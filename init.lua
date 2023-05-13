
-- Source config files
-- Plugins are on lazy
for _, source in ipairs {
  "base.1-bootstrap",
  "base.2-options",
  "base.3-lazy",
  "base.4-autocmds",
  "base.5-mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if base.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, base.default_colorscheme) then
    require("base.utils").notify(
      "Error setting up colorscheme: " .. base.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end

require("base.utils").conditional_func(base.user_opts("polish", nil, false), true)
