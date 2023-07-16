-- Autocmds file.
--
-- DESCRIPTION:
-- All autocmds are defined here.

--    Sections:
--
--       ## EXTRA LOGIC
--       -> 1. Events to load plugins faster.
--       -> 2. Save/restore window layout when possible.
--       -> 3. Launch alpha greeter on startup.
--       -> 4. Hot reload on config change.
--       -> 5. Update neotree when closing the git client.
--
--       ## COOL HACKS
--       -> 6. Effect: URL underline.
--       -> 7. Effect: Flash on yank.
--       -> 8. Disable right click contextual menu warning message.
--       -> 9. Unlist quickfix buffers if the filetype changes.
--
--       ## COMMANDS
--       -> 9. Nvim updater commands.
--       -> 10. Neotest commands.
--       ->     Extra commands.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local utils = require "base.utils"
local is_available = utils.is_available

-- ## EXTRA LOGIC -----------------------------------------------------------
-- 1. Events to load plugins faster → 'BaseFile'/'BaseGitFile':
--    this is pretty much the same thing as the event 'BufEnter',
--    but without increasing the startup time displayed in the greeter.
autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  desc = "Nvim user events for file detection (BaseFile and BaseGitFile)",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    local empty_buffer = vim.fn.expand "%" == ""
    local greeter = vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha"
    local git_repo = utils.cmd({ "git", "-C", vim.fn.expand "%:p:h", "rev-parse" }, false)

    -- For any file exept empty buffer, or the greeter (alpha)
    if not (empty_buffer or greeter) then
      utils.event "File" -- Emit event 'BaseFile'

      -- Is the buffer part of a git repo?
      if git_repo then
        utils.event "GitFile" -- Emit event 'BaseGitFile'
        vim.api.nvim_del_augroup_by_name "file_user_events"
      end

    end
  end,
})

-- 2. Save/restore window layout when possible.
local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(event)
    if vim.b[event.buf].view_activated then
      vim.cmd.mkview { mods = { emsg_silent = true } }
    end
  end,
})
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(event)
    if not vim.b[event.buf].view_activated then
      local filetype =
        vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      local buftype =
        vim.api.nvim_get_option_value("buftype", { buf = event.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if
        buftype == ""
        and filetype
        and filetype ~= ""
        and not vim.tbl_contains(ignore_filetypes, filetype)
      then
        vim.b[event.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})

-- 3. Launch alpha greeter on startup
if is_available "alpha-nvim" then
  local alpha_group = augroup("alpha_settings", { clear = true })
  autocmd({ "User", "BufEnter" }, {
    desc = "Disable status and tablines for alpha",
    group = alpha_group,
    callback = function(event)
      local is_filetype_alpha = vim.api.nvim_get_option_value(
        "filetype", { buf = event.buf }) == "alpha"
      local is_empty_file = vim.api.nvim_get_option_value(
        "buftype", { buf = event.buf }) == "nofile"
      if((event.event == "User" and event.file == "AlphaReady") or
         (event.event == "BufEnter" and is_filetype_alpha)) and
        not vim.g.before_alpha
      then
        vim.g.before_alpha = {
          showtabline = vim.opt.showtabline:get(),
          laststatus = vim.opt.laststatus:get()
        }
        vim.opt.showtabline, vim.opt.laststatus = 0, 0
      elseif
        vim.g.before_alpha
        and event.event == "BufEnter"
        and not is_empty_file
      then
        vim.opt.laststatus = vim.g.before_alpha.laststatus
        vim.opt.showtabline = vim.g.before_alpha.showtabline
        vim.g.before_alpha = nil
      end
    end,
  })
  autocmd("VimEnter", {
    desc = "Start Alpha only when nvim is opened with no arguments",
    group = alpha_group,
    callback = function()
      local should_skip = false
      if
        vim.fn.argc() > 0
        or vim.fn.line2byte(vim.fn.line "$") ~= -1
        or not vim.o.modifiable
      then
        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if
            arg == "-b"
            or arg == "-c"
            or vim.startswith(arg, "+")
            or arg == "-S"
          then
            should_skip = true
            break
          end
        end
      end
      if not should_skip then
        require("alpha").start(true, require("alpha").default_config)
        vim.schedule(function() vim.cmd.doautocmd "FileType" end)
      end
    end,
  })
end



-- 4. Hot reload on config change.
autocmd({ "BufWritePost" }, {
  desc = "When writing a buffer, :NvimReload if the buffer is a config file.",
  group = augroup("reload_if_buffer_is_config_file", { clear = true }),
  callback = function()
    local filesThatTriggerReload = {
      vim.fn.stdpath "config" .. "lua/base/1-options.lua",
      vim.fn.stdpath "config" .. "lua/base/4-mappings.lua",
    }

    local bufPath = vim.fn.expand "%:p"
    for _, filePath in ipairs(filesThatTriggerReload) do
      if filePath == bufPath then vim.cmd "NvimReload" end
    end
  end,
})

-- 5. Update neotree when closin the git client.
if is_available "neo-tree.nvim" then
  autocmd("TermClose", {
    pattern = { "*lazygit", "*gitui" },
    desc = "Refresh Neo-Tree git when closing lazygit/gitui",
    group = augroup("neotree_git_refresh", { clear = true }),
    callback = function()
      if package.loaded["neo-tree.sources.git_status"] then
        require("neo-tree.sources.git_status").refresh()
      end
    end,
  })
end

-- ## COOL HACKS ------------------------------------------------------------
-- 6. Effect: URL underline.
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("HighlightUrl", { clear = true }),
  callback = function() utils.set_url_effect() end,
})

-- 6. Effect: Flash on yank.
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- 7. Disable right click contextual menu warning message.
autocmd("VimEnter", {
  desc = "Disable right contextual menu warning message",
  group = augroup("contextual_menu", { clear = true }),
  callback = function()
    -- Disable right click message
    vim.api.nvim_command [[aunmenu PopUp.How-to\ disable\ mouse]]
    vim.api.nvim_command [[aunmenu PopUp.-1-]]
  end,
})

-- 8. Unlist quickfix buffers if the filetype changes.
autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function() vim.opt_local.buflisted = false end,
})



-- ## COMMANDS --------------------------------------------------------------
-- 10. Nvim updater commands
cmd(
  "NvimChangelog",
  function() require("base.utils.updater").changelog() end,
  { desc = "Check Nvim Changelog" }
)
cmd(
  "NvimUpdatePlugins",
  function() require("base.utils.updater").update_packages() end,
  { desc = "Update Plugins and Mason" }
)
cmd(
  "NvimRollbackCreate",
  function() require("base.utils.updater").create_rollback(true) end,
  { desc = "Create a rollback of '~/.config/nvim'." }
)
cmd(
  "NvimRollbackRestore",
  function() require("base.utils.updater").rollback() end,
  { desc = "Restores '~/.config/nvim' to the last rollbacked state." }
)
cmd(
  "NvimFreezePluginVersions",
  function() require("base.utils.updater").generate_snapshot(true) end,
  { desc = "Lock package versions (only lazy, not mason)." }
)
cmd(
  "NvimUpdateConfig", function() require("base.utils.updater").update() end,
  { desc = "Update Nvim distro" }
)
cmd(
  "NvimVersion",
  function() require("base.utils.updater").version() end,
  { desc = "Check Nvim distro Version" }
)
cmd(
  "NvimReload",
  function() require("base.utils").reload() end,
  { desc = "Reload Nvim without closing it (Experimental)" }
)

-- 11. Neotest commands
-- Neotest doesn't implement commands by default, so we do it here.
-------------------------------------------------------------------
cmd(
  "TestRunBlock",
  function() require("neotest").run.run() end,
  { desc = "Run the nearest test under the cursor" }
)

cmd(
  "TestStopBlock",
  function() require("neotest").run.stop() end,
  { desc = "Stopts the nearest test under the cursor" }
)

cmd(
  "TestRunFile",
  function() require("neotest").run.run(vim.fn.expand "%") end,
  { desc = "Run all tests in the test file" }
)

cmd(
  "TestDebugBlock",
  function() require("neotest").run.run { strategy = "dap" } end,
  { desc = "Debug the nearest test under the cursor using dap" }
)

-- Customize this command to work as you like
cmd("TestNodejs", function()
  vim.cmd ":ProjectRoot" -- cd the project root (requires project.nvim)
  vim.cmd ":TermExec cmd='npm run tests'" -- convention to run tests on nodejs
  -- You can generate code coverage by add this to your project's packages.json
  -- "tests": "jest --coverage"
end, { desc = "Run all unit tests for the current nodejs project" })

-- Customize this command to work as you like
cmd("TestNodejsE2e", function()

  vim.cmd ":ProjectRoot" -- cd the project root (requires project.nvim)
  vim.cmd ":TermExec cmd='npm run e2e'" -- Conventional way to call e2e in nodejs (requires ToggleTerm)
end, { desc = "Run e2e tests for the current nodejs project" })

-- Extra commands
----------------------------------------------

-- Change working directory
cmd("Cwd", function()
  vim.cmd ":cd %:p:h"
  vim.cmd ":pwd"
end, { desc = "cd current file's directory" })

-- Set working directory (alias)
cmd("Swd", function()
  vim.cmd ":cd %:p:h"
  vim.cmd ":pwd"
end, { desc = "cd current file's directory" })



