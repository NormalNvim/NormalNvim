-- Lazy config file (nvim package manager)


--    Functions:
--       -> nvim updater options      → used to lock package version.
--       -> lazyload extra behaviors  → notifications and stuff.
--       -> assign spec               → if channel==stable, uses lazy_snatshot.lua
--       -> setup using spec          → actual setup.


-- lazy.nvim packager options
-- Here you can lock/unlock your package versions.
--
-- When setting channel to "stable", package versions will taken from:
-- ~/.config/nvim/lua/lazy_snapshot.lua
-- This snapshot can be updated by manually running :NvimFreezePluginVersions
-- This operation is never performed automatically.
--
-- When setting channel to "nightly", the snapshot will be ignored.
-- And you will get always the latest available versions.
-- But this can be unstable!!

--- This collection is used  to lock package versions.
--  Please don't manually delete lazy_snapshop.lua or you will get errors.
--  Instead just run :NvimFreezePluginVersions
base.updater = {
  options = { remote = "origin", channel = "nightly" },
  snapshot = { module = "lazy_snapshot", path = vim.fn.stdpath "config" .. "/lua/lazy_snapshot.lua" },
  rollback_file = vim.fn.stdpath "cache" .. "/rollback.lua",


  -- if nil, :NvimConfigUpdate wil use the latest available tag release of your
  -- git repository, starting by 'v', for example, "v1.0"
  nvim_config_stable_version = nil,
}


--- lazyload extra behavior (notifications and stuff)
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local output = vim.fn.system { "git", "clone", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }
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
      require("base.utils").notify "Mason is installing packages if configured, check status with :Mason"
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
    rtp = {
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
    },
  },
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
})
