-- Lazy config file (nvim package manager)


--- NVim updater options
base.updater = {
  options = { remote = "origin", channel = "stable" },
  snapshot = {
    module = "lazy_snapshot",
    path = vim.fn.stdpath "config" .. "/lua/lazy_snapshot.lua" 
  },
  rollback_file = vim.fn.stdpath "cache" .. "/nvim_rollback.lua",
}



--- Lazy options
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


-- Assign spec
local spec = base.updater.options.pin_plugins and { { import = base.updater.snapshot.module } } or {}
vim.list_extend(spec, { { import = "plugins" } })


-- The actual setup
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
