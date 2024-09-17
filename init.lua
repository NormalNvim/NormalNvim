-- HELLO, welcome to NormalNvim!
-- ---------------------------------------
-- This is the entry point of your config.
-- ---------------------------------------

-- LOAD SOURCE FILES BY ORDER:
vim.loader.enable()
for _, source in ipairs {
  "base.1-options",
  "base.2-lazy",
  "base.3-autocmds",
  "base.4-mappings",
} do
  local status_ok, error = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. error) end
end

-- ONCE ALL SOURCE FILES HAVE LOADED:
-- Load the color scheme defined in ./lua/1-options.lua
if vim.g.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, vim.g.default_colorscheme) then
    require("base.utils").notify(
      "Error setting up colorscheme: " .. vim.g.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end