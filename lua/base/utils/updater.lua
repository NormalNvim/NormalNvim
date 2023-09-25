--- ### Nvim Updater functions
--
--  DESCRIPTION:
--  Functions for the nvim updater commands in ../3-autocmds.lua
--
--  While you could technically delete this file, and the update commands
--  in the autocmds file, we encourage you to keep it, as it is a great way to:
--  * Freeze your plugins versions.
--  * Download the latest version of your config, assuming you use nvim in more
--    than one device.
--
--    Functions:
--      -> generate_snapshot   → used by :NvimFreezePluginVersions.
--      -> version             → used by :NvimVersion.
--      -> changelog           → used by :NvimChangeLog.
--      -> update_packages     → used by :NvimUpdatePlugins.
--      -> create_rollback     → ured by :NvimRollbackCreate.
--      -> rollback            → used by :NvimRollbackRestore.
--      -> attempt_update      → helper for update.
--      -> update              → used by :NvimUpdateConfig.

local utils = require "base.utils"
local git = require "base.utils.git"

local M = {}

local function echo(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
end

local function confirm_prompt(messages, type)
  return vim.fn.confirm(
    messages,
    "&Yes\n&No",
    (type == "Error" or type == "Warning") and 2 or 1,
    type or "Question"
  ) == 1
end

--- Helper function to generate Nvim snapshots (For internal use only)
---@param write? boolean Whether or not to write to the snapshot file (default: false)
---@return table # The plugin specification table of the snapshot
function M.generate_snapshot(write)
  local file
  local prev_snapshot = require(base.updater.snapshot.module)
  for _, plugin in ipairs(prev_snapshot) do
    prev_snapshot[plugin[1]] = plugin
  end
  local plugins = assert(require("lazy").plugins())
  table.sort(plugins, function(l, r) return l[1] < r[1] end)
  local function git_commit(dir)
    local commit =
        assert(utils.cmd("git -C " .. dir .. " rev-parse HEAD", false))
    if commit then return vim.trim(commit) end
  end
  if write == true then
    file = assert(io.open(base.updater.snapshot.path, "w"))
    file:write "return {\n"
  end
  local snapshot = vim.tbl_map(function(plugin)
    plugin =
    { plugin[1], commit = git_commit(plugin.dir), version = plugin.version }
    if prev_snapshot[plugin[1]] and prev_snapshot[plugin[1]].version then
      plugin.version = prev_snapshot[plugin[1]].version
    end
    if file then
      file:write(("  { %q, "):format(plugin[1]))
      if plugin.version then
        file:write(("version = %q "):format(plugin.version))
      else
        file:write(("commit = %q "):format(plugin.commit))
      end
      file:write "},\n"
    end
    return plugin
  end, plugins)
  if file then
    file:write "}\n"
    file:close()
  end
  utils.notify("Lazy packages locked to their current version.")
  return snapshot
end

--- Get the current Nvim version
--- @param quiet? boolean Whether to quietly execute or send a notification
--- @return string # The current Nvim version string
function M.version(quiet)
  local version = git.current_version(false) or "unknown"
  if base.updater.options.channel ~= "stable" then
    version = ("nightly (%s)"):format(version)
  end
  if version and not quiet then utils.notify("Version: " .. version) end
  return version
end

--- Get the full Nvim changelog
--- @param quiet? boolean Whether to quietly execute or display the changelog
--- @return table # The current Nvim changelog table of commit messages
function M.changelog(quiet)
  local summary = {}
  vim.list_extend(summary, git.pretty_changelog(git.get_commit_range()))
  if not quiet then echo(summary) end
  return summary
end

--- Cancelled update message
local cancelled_message = { { "Update cancelled", "WarningMsg" } }

--- Sync Packer and then update Mason
function M.update_packages()
  require("lazy").sync { wait = true }
  require("base.utils.mason").update_all()
end

--- Create a table of options for the currently installed Nvim version
--- @param write? boolean Whether or not to write to the rollback file (default: false)
--- @return table # The table of updater options
function M.create_rollback(write)
  local snapshot = { branch = git.current_branch(), commit = git.local_head() }
  if snapshot.branch == "HEAD" then snapshot.branch = "main" end
  snapshot.remote = git.branch_remote(snapshot.branch, false) or "origin"
  snapshot.remotes = { [snapshot.remote] = git.remote_url(snapshot.remote) }

  if write == true then
    local file = assert(io.open(base.updater.rollback_file, "w"))
    file:write(
      "return " .. vim.inspect(snapshot, { newline = " ", indent = "" })
    )
    file:close()
  end
  -- Rollback file created
  utils.notify(
    "Rollback file created in ~/.cache/nvim\n\npointing to commit:\n"
    .. snapshot.commit
    .. "  \n\nYou can use :NvimRollbackRestore to revert ~/.config to this state."
  )
  return snapshot
end

--- Nvim's rollback to saved previous version function
function M.rollback()
  local rollback_avail, rollback_opts =
      pcall(dofile, base.updater.rollback_file)
  if not rollback_avail then
    utils.notify("No rollback file available", vim.log.levels.ERROR)
    return
  end
  M.update(rollback_opts)
end


--- Attempt an update of Nvim
--- @param target string The target if checking out a specific tag or commit or nil if just pulling
local function attempt_update(target, opts)
  -- if updating to a new stable version or a specific commit checkout the provided target
  if opts.channel == "stable" or opts.commit then
    return git.checkout(target, false)
    -- if no target, pull the latest
  else
    return git.pull(false)
  end
end

--- Nvim's updater function
--- @param opts? table the settings to use for the update
function M.update(opts)
  if not opts then opts = base.updater.options end
  opts = require("base.utils").extend_tbl(
    { remote = "origin", show_changelog = true, auto_quit = false },
    opts
  )
  -- if the git command is not available, then throw an error
  if not git.available() then
    utils.notify(
      "git command is not available, please verify it is accessible in a command line. This may be an issue with your PATH",
      vim.log.levels.ERROR
    )
    return
  end

  -- if installed with an external package manager, disable the internal updater
  if not git.is_repo() then
    utils.notify(
      "Updater not available for non-git installations",
      vim.log.levels.ERROR
    )
    return
  end
  -- set up any remotes defined by the user if they do not exist
  for remote in pairs(opts.remotes and opts.remotes or {}) do
    local url = git.remote_url(remote, false)
    -- Show remote we are using
    echo {
      { "Checking remote " },
      { remote,                       "Title" },
      { " which is currently set to " },
      { url,                          "WarningMsg" },
      { "..." },
    }
  end
  local is_stable = opts.channel == "stable"
  if is_stable then
    opts.branch = "main"
  elseif not opts.branch then
    opts.branch = "nightly"
  end
  -- setup branch if missing
  if not git.ref_verify(opts.remote .. "/" .. opts.branch, false) then
    git.remote_set_branches(opts.remote, opts.branch, false)
  end
  -- fetch the latest remote
  if not git.fetch(opts.remote) then
    vim.api.nvim_err_writeln("Error fetching remote: " .. opts.remote)
    return
  end
  -- switch to the necessary branch only if not on the stable channel
  if not is_stable then
    local local_branch = (
      opts.remote == "origin" and "" or (opts.remote .. "_")
    ) .. opts.branch
    if git.current_branch() ~= local_branch then
      echo {
        { "Switching to branch: " },
        { opts.remote .. "/" .. opts.branch .. "\n\n", "String" },
      }
      if not git.checkout(local_branch, false) then
        git.checkout(
          "-b " .. local_branch .. " " .. opts.remote .. "/" .. opts.branch,
          false
        )
      end
    end
    -- check if the branch was switched to successfully
    if git.current_branch() ~= local_branch then
      vim.api.nvim_err_writeln(
        "Error checking out branch: " .. opts.remote .. "/" .. opts.branch
      )
      return
    end
  end
  local source = git.local_head() -- calculate current commit
  local target                    -- calculate target commit
  if is_stable then               -- if stable get tag commit
    local version_search = base.updater.stable_version_release or "latest"
    opts.version = git.latest_version(git.get_versions(version_search))
    if not opts.version then -- continue only if stable version is found
      vim.api.nvim_err_writeln("Error finding version: " .. version_search)
      return
    end
    target = git.tag_commit(opts.version)
  elseif opts.commit then -- if commit specified use it
    target = git.branch_contains(opts.remote, opts.branch, opts.commit)
        and opts.commit
        or nil
  else -- get most recent commit
    target = git.remote_head(opts.remote, opts.branch)
  end
  if not source or not target then -- continue if current and target commits were found
    vim.api.nvim_err_writeln "Error checking for updates"
    return
  elseif source == target then
    echo { { "No changes available", "String" } }
    return
  elseif -- prompt user if they want to accept update
      not opts.skip_prompts
      and not confirm_prompt(
        ("Update avavilable to %s\nUpdating requires a restart, continue?"):format(
          is_stable and opts.version or target
        )
      )
  then
    echo(cancelled_message)
    return
  else                      -- perform update
    M.create_rollback(true) -- create rollback file before updating

    -- calculate and print the changelog
    local changelog = git.get_commit_range(source, target)
    local breaking = git.breaking_changes(changelog)
    if
        #breaking > 0
        and not opts.skip_prompts
        and not confirm_prompt(
          ("Update contains the following breaking changes:\n%s\nWould you like to continue?"):format(
            table.concat(breaking, "\n")
          ),
          "Warning"
        )
    then
      echo(cancelled_message)
      return
    end -- attempt an update
    local updated = attempt_update(target, opts)
    -- check for local file conflicts and prompt user to continue or abort
    if
        not updated
        and not opts.skip_prompts
        and not confirm_prompt {
          {
            "Unable to pull due to local modifications to base files.\nReset local files and continue?",
            "Error",
          },
          { "Reset local files and continue?" },
        }
    then
      echo(cancelled_message)
      return
      -- if continued and there were errors reset the base config and attempt another update
    elseif not updated then
      git.hard_reset(source)
      updated = attempt_update(target, opts)
    end
    -- if update was unsuccessful throw an error
    if not updated then
      vim.api.nvim_err_writeln "Error occurred performing update"
      return
    end
    -- print a summary of the update with the changelog
    local summary = {
      { "Nvim updated successfully to ", "Title" },
      { git.current_version(),           "String" },
      { "!\n",                           "Title" },
      {
        opts.auto_quit and "Nvim will now update plugins and quit.\n\n"
        or "After plugins update, please restart.\n\n",
        "WarningMsg",
      },
    }
    if opts.show_changelog and #changelog > 0 then
      vim.list_extend(summary, { { "Changelog:\n", "Title" } })
      vim.list_extend(summary, git.pretty_changelog(changelog))
    end
    echo(summary)

    -- if the user wants to auto quit, create an autocommand to quit Nvim on the update completing
    if opts.auto_quit then
      vim.api.nvim_create_autocmd("User", {
        desc = "Auto quit Nvim after update completes",
        pattern = "NVimUpdateComplete",
        command = "quitall",
      })
    end

    require("lazy.core.plugin").load()   -- force immediate reload of lazy
    require("lazy").sync { wait = true } -- sync new plugin spec changes
    utils.event "UpdateComplete"
  end
end

return M
