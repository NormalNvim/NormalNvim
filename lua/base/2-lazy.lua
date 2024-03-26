-- Lazy.nvim config file.

-- DESCRIPTION:
-- Use this file to configure the way you get updates.

--    Sections:
--
--      -> lazy updater options  → choose your lazy updates channel here.
--      -> extra behaviors       → extra stuff we add to lazy for better UX.
--      -> assign spec           → if channel==stable, uses lazy_snatshot.lua
--      -> setup using spec      → actual setup.


-- lazy updater options
-- Use the same values you have in the plugin `distroupdate.nvim`
local updater = {
  channel = "stable",               -- 'nightly', or 'stable'
  snapshot_module = "lazy_snapshot" -- snapshot file name without extension.
}

-- lazyload extra behavior
--  * If plugins need to be installed         → auto launch lazy at startup.
--  * When lazy finishes installing plugins   → check for mason updates too.
--    (but not when updating them)
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
      -- Note: This event will also trigger a Mason update in distroupdate.nvim
    end,
  })
end
vim.opt.rtp:prepend(lazypath)

-- assign spec (if pin_plugins is true, load ./lua/lazy_snapshot.lua).
local pin_plugins = updater.channel == "stable"
local spec = pin_plugins and { { import = updater.snapshot_module } } or {}
vim.list_extend(spec, { { import = "plugins" } })

-- Require lazy and pass the spec.
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
