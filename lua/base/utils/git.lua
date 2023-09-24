--- ### Git api
--
--  DESCRIPTION:
--  Helpers to easily perform the git operations we need.
--
--  We use this on ./updater.lua
--  to search for the latest version on your git repository
--  when using the command :NvimUpdateConfig
--
--  So if you you decide to delete the updater, feel free to delete this too.

--    Helpers:
--      -> git.cmd              → Used to run git commands.
--      -> git.pretty_changelog → Used by 'git.current_version'.

--    Functions:
--      -> git.available
--      -> git.is_repo
--      -> git.fetch
--      -> git.pull
--      -> git.checkout
--      -> git.hard_reset
--      -> git.branch_contains
--      -> git.branch_remote
--      -> git.remote_add
--      -> git.remote_update
--      -> git.current_version
--      -> git.verify
--      -> git.local_head
--      -> git.remote_head
--      -> git.tag_commit
--      -> git.get_commit_range
--      -> git.get_versions
--      -> git.latest_version
--      -> git.is_breaking
--      -> git.breaking_changes

local git = { url = "https://github.com/" }

local function trim_or_nil(str)
  return type(str) == "string" and vim.trim(str) or nil
end

--- Run a git command from the Nvim installation directory.
---@param args string|string[] the git arguments.
---@return string|nil # The result of the command or nil if unsuccessful.
function git.cmd(args, ...)
  local utils = require "base.utils"
  local config_dir = vim.fn.stdpath "config"
  if type(args) == "string" then args = { args } end
  return utils.cmd(vim.list_extend({ "git", "-C", config_dir }, args), ...)
end

--- Check if the Nvim is able to reach the `git` command.
---@return boolean # The result of running `git --help`.
function git.available() return vim.fn.executable "git" == 1 end

--- Check if the Nvim home is a git repo.
---@return string|nil # ~he result of the command.
function git.is_repo()
  return git.cmd({ "rev-parse", "--is-inside-work-tree" }, false)
end

--- Fetch git remote.
---@param remote string the remote to fetch.
---@return string|nil # The result of the command.
function git.fetch(remote, ...) return git.cmd({ "fetch", remote }, ...) end

--- Pull the git repo.
---@return string|nil # The result of the command.
function git.pull(...) return git.cmd({ "pull", "--rebase" }, ...) end

--- Checkout git target.
---@param dest string the target to checkout.
---@return string|nil # The result of the command.
function git.checkout(dest, ...) return git.cmd({ "checkout", dest }, ...) end

--- Hard reset to a git target.
-- @param dest the target to hard reset to.
---@return string|nil # The result of the command.
function git.hard_reset(dest, ...)
  return git.cmd({ "reset", "--hard", dest }, ...)
end

--- Check if a branch contains a commit.
---@param remote string the git remote to check.
---@param branch string the git branch to check.
---@param commit string the git commit to check for.
---@return boolean # The result of the command.
function git.branch_contains(remote, branch, commit, ...)
  return git.cmd(
    { "merge-base", "--is-ancestor", commit, remote .. "/" .. branch }, ...
  ) ~= nil
end

--- Get the remote name for a given branch.
---@param branch string the git branch to check.
---@return string|nil # The name of the remote for the given branch.
function git.branch_remote(branch, ...)
  return trim_or_nil(
    git.cmd({ "config", "branch." .. branch .. ".remote" }, ...)
  )
end

--- Add a git remote.
---@param remote string the remote to add.
---@param url string the url of the remote.
---@return string|nil # The result of the command.
function git.remote_add(remote, url, ...)
  return git.cmd({ "remote", "add", remote, url }, ...)
end

--- Update a git remote URL.
---@param remote string the remote to update.
---@param url string the new URL of the remote.
---@return string|nil # The result of the command.
function git.remote_update(remote, url, ...)
  return git.cmd({ "remote", "set-url", remote, url }, ...)
end

--- Get the URL of a given git remote.
---@param remote string the remote to get the URL of.
---@return string|nil # The url of the remote.
function git.remote_url(remote, ...)
  return trim_or_nil(git.cmd({ "remote", "get-url", remote }, ...))
end

--- Get branches from a git remote.
---@param remote string the remote to setup branches for.
---@param branch string the branch to setup.
---@return string|nil # The result of the command.
function git.remote_set_branches(remote, branch, ...)
  return git.cmd({ "remote", "set-branches", remote, branch }, ...)
end

--- Get the current version with git describe including tags.
---@return string|nil # The current git describe string.
function git.current_version(...)
  return trim_or_nil(git.cmd({ "describe", "--tags" }, ...))
end

--- Get the current branch.
---@return string|nil # The branch of the Nvim installation.
function git.current_branch(...)
  return trim_or_nil(git.cmd({ "rev-parse", "--abbrev-ref", "HEAD" }, ...))
end

--- Verify a reference.
---@return string|nil # The referenced commit.
function git.ref_verify(ref, ...)
  return trim_or_nil(git.cmd({ "rev-parse", "--verify", ref }, ...))
end

--- Get the current head of the git repo.
---@return string|nil # the head string.
function git.local_head(...)
  return trim_or_nil(git.cmd({ "rev-parse", "HEAD" }, ...))
end

--- Get the current head of a git remote.
---@param remote string the remote to check.
---@param branch string the branch to check.
---@return string|nil # The head string of the remote branch.
function git.remote_head(remote, branch, ...)
  return trim_or_nil(
    git.cmd({ "rev-list", "-n", "1", remote .. "/" .. branch }, ...)
  )
end

--- Get the commit hash of a given tag.
---@param tag string the tag to resolve.
---@return string|nil # The commit hash of a git tag.
function git.tag_commit(tag, ...)
  return trim_or_nil(git.cmd({ "rev-list", "-n", "1", tag }, ...))
end

--- Get the commit log between two commit hashes.
---@param start_hash? string the start commit hash.
---@param end_hash? string the end commit hash.
---@return string[] # An array like table of commit messages.
function git.get_commit_range(start_hash, end_hash, ...)
  local range = start_hash
                and end_hash
                and start_hash .. ".." .. end_hash
                or nil
  local log = git.cmd(
    { "log", "--no-merges", '--pretty="format:[%h] %s"', range }, ...
  )
  return log and vim.fn.split(log, "\n") or {}
end

--- Get a list of all tags with a regex filter.
---@param search? string a regex to search the tags with.
---                     (default: to "v*" for version tags).
---@return string[] # An array like table of tags that match the search.
function git.get_versions(search, ...)
  local tags = git.cmd(
    {
      "tag",
      "-l",
      "--sort=version:refname",
      search == "latest" and "v*" or search,
    },
    ...
  )
  return tags and vim.fn.split(tags, "\n") or {}
end

--- Get the latest version of a list of versions.
---@param versions? table a list of versions to search.
---                      (default: to all versions available).
---@return string|nil # The latest version from the array.
function git.latest_version(versions, ...)
  if not versions then versions = git.get_versions(...) end
  return versions[#versions]
end

--- Check if a Conventional Commit commit message is breaking or not.
---@param commit string a commit message.
---@return boolean # true if the message is breaking,
---                  false if the commit message is not breaking.
function git.is_breaking(commit)
  return vim.fn.match(commit, "\\[.*\\]\\s\\+\\w\\+\\((\\w\\+)\\)\\?!:") ~= -1
end

--- Get a list of breaking commits from commit messages using
--- conventional commit standard.
---@param commits string[] an array like table of commit messages.
---@return string[] # An array like table of commits that are breaking.
function git.breaking_changes(commits)
  return vim.tbl_filter(git.is_breaking, commits)
end

--- Generate a table of commit messages for neovim's echo API with highlighting.
---@param commits string[] an array like table of commit messages.
---@return string[][] # An array like table of echo messages to provide to
---                     nvim_echo or 'base.echo'.
function git.pretty_changelog(commits)
  local changelog = {}
  for _, commit in ipairs(commits) do
    local hash, type, msg = commit:match "(%[.*%])(.*:)(.*)"
    if hash and type and msg then
      vim.list_extend(changelog, {
        { hash, "DiffText" },
        { type, git.is_breaking(commit) and "DiffDelete" or "DiffChange" },
        { msg },
        { "\n" },
      })
    end
  end
  return changelog
end

return git
