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

local user_plugins = base.user_opts "plugins"
for _, config_dir in ipairs(base.supported_configs) do
  if vim.fn.isdirectory(config_dir .. "/lua/user/plugins") == 1 then user_plugins = { import = "user.plugins" } end
end

local spec = base.updater.options.pin_plugins and { { import = base.updater.snapshot.module } } or {}
vim.list_extend(spec, { { import = "plugins" }, user_plugins })

local colorscheme = base.default_colorscheme and { base.default_colorscheme } or nil

require("lazy").setup(base.user_opts("lazy", {
  spec = spec,
  defaults = { lazy = true },
  install = { colorscheme = colorscheme },
  performance = {
    rtp = {
      paths = base.supported_configs,
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
    },
  },
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
}))
