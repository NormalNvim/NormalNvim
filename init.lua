-- Source config files (Plugins are loaded in the file ./lua/base/2-lazy)

-- Compile lua to bytecode if the nvim version supports it.
if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

-- Source config files
for _, source in ipairs {
  "base.1-options",
  "base.2-lazy",
  "base.3-autocmds",
  "base.4-mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

-- Apply color scheme defined in ./lua/1-options.lua after all modules loaded
if base.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, base.default_colorscheme) then
    require("base.utils").notify(
      "Error setting up colorscheme: " .. base.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end
