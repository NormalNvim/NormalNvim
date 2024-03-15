-- HELLO, welcome to NormalNvim!
-- ---------------------------------------
-- This is the entry point of your config.
-- ---------------------------------------

-- EVERY TIME NEOVIM OPENS:
-- Compile lua to bytecode if the nvim version supports it.
if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

-- THEN:
-- Source config files by order.
for _, source in ipairs {
  "base.1-options",
  "base.2-lazy",
  "base.3-autocmds",
  "base.4-mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

-- ONCE ALL SOURCE FILES HAVE LOADED:
-- Load the color scheme defined in ./lua/1-options.lua
if base.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, base.default_colorscheme) then
    require("base.utils").notify(
      "Error setting up colorscheme: " .. base.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end
