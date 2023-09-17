-- Lazy.nvim config file.

-- DESCRIPTION:
-- Use this file to configure the way you get updates.

--    Sections:
--
--      -> nvim updater options  → choose your updates channel here.
--      -> extra behaviors       → extra stuff we add to lazy for better UX.
--      -> assign spec           → if channel==stable, uses lazy_snatshot.lua
--      -> setup using spec      → actual setup.


-- This collection is used to lock plugin versions.
--  To do so run ':NvimFreezePluginVersions'.
--  Please don't manually delete ../lazy_snapshot.lua or you will get errors.
base.updater = {
  options = { remote = "origin", channel = "stable" }, -- 'nightly', or 'stable'
  snapshot = { module = "lazy_snapshot", path = vim.fn.stdpath "config" .. "/lua/lazy_snapshot.lua" },
  rollback_file = vim.fn.stdpath "cache" .. "/rollback.lua",

  -- You can update your nvim config from your repo by using ':NvimUpdateConfig'.
  -- This comes handy if you use nivm in more than one device.
  -- You can use 'stable_version_release' to specify the version to install.
  -- If nil, :NvimUpdateConfig will use the latest available tag release of your
  -- git repository, starting by 'v', for example, "v1.0"
  stable_version_release = nil,
}

-- lazyload extra behavior
--  * If plugins need to be installed → auto lanch lazy at startup.
--  * When lazy finithes updating     → check for mason updates too.
--  * Then show notifications and stuff.
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local luv = vim.uv or vim.loop
if not luv.fs_stat(lazypath) then
  local output = vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
  if vim.api.nvim_get_vvar "shell_error" ~= 0 then
    vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" .. output)
  end
  local oldcmdheight = vim.opt.cmdheight:get()
  vim.opt.cmdheight = 1
  vim.notify "Please wait while plugins are installed..."
  vim.api.nvim_create_autocmd("User", {
    desc = "Load Mason and Treesitter after Lazy installs plugins",
    once = true,
    pattern = "LazyInstall",
    callback = function()
      vim.cmd.bw()
      vim.opt.cmdheight = oldcmdheight
      vim.tbl_map(function(module) pcall(require, module) end, { "nvim-treesitter", "mason" })
      require("base.utils").notify "Mason is installing packages if configured, check status with `:Mason`"
    end,
  })
end
vim.opt.rtp:prepend(lazypath)

 -- true if channel is 'stable'
local pin_plugins = base.updater.options.channel == "stable"

-- assign spec (if pin_plugins is true, load ./lua/lazy_snapshot.lua)
local spec = pin_plugins and {{ import = base.updater.snapshot.module }} or {}
vim.list_extend(spec, { { import = "plugins" } })


-- the actual setup
require("lazy").setup({
  spec = spec,
  defaults = { lazy = true },
  performance = {
    rtp = { -- Use deflate to download faster from the plugin repos.
      disabled_plugins = {
        "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin"
      },
    },
  },
  -- We don't use this, so create it in a disposable place.
  lockfile = vim.fn.stdpath "cache" .. "/lazy-lock.json",
})
