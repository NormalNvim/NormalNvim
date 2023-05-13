--- ### NVim core Bootstrap
-- This module simply sets up the global `base` module.
-- This is automatically loaded and should not be resourced. 
-- everything is accessible through the global `base` variable.
-- @module base.bootstrap


_G.base = {}




--- Setup paths
base.install = _G["nvim_installation"] or { home = vim.fn.stdpath "config" }
base.supported_configs = { base.install.home }
--- external base configuration folder
base.install.config = vim.fn.stdpath("config"):gsub("[^/\\]+$", "base")
-- check if they are the same, protects against NVIM_APPNAME use for isolated install
if base.install.home ~= base.install.config then
  vim.opt.rtp:append(base.install.config)
  --- supported base user conifg folders
  table.insert(base.supported_configs, base.install.config)
end




--- If a module path references a lua file in a configuration 
--- folder try to load it. If there is an error loading the file, 
--- write an error and continue.
--- @param module string The module path to try and load.
--- @return table|nil # The loaded module if successful or nil.
local function load_module_file(module)
  -- placeholder for final return value
  local found_module = nil
  -- search through each of the supported configuration locations
  for _, config_path in ipairs(base.supported_configs) do
    -- convert the module path to a file path (example user.init -> user/init.lua)
    local module_path = config_path .. "/lua/" .. module:gsub("%.", "/") .. ".lua"
    -- check if there is a readable file, if so, set it as found
    if vim.fn.filereadable(module_path) == 1 then found_module = module_path end
  end
  -- if we found a readable lua file, try to load it
  if found_module then
    -- try to load the file
    local status_ok, loaded_module = pcall(require, module)
    -- if successful at loading, set the return variable
    if status_ok then
      found_module = loaded_module
    -- if unsuccessful, throw an error
    else
      vim.api.nvim_err_writeln(
        "Error loading file: " .. found_module .. "\n\n" .. loaded_module
      )
    end
  end
  -- return the loaded module or nil if no file found
  return found_module
end




--- User configuration entry point to override the default options of a
--- configuration table with a user configuration file or table in the
--- user/init.lua user settings.
--- @param module string The module path of the override setting.
--- @param default? table The default settings that will be overridden.
--- @param extend? boolean # Whether extend the default settings or overwrite 
--- them with the user settings entirely (default: true).
--@return any # The new configuration settings with the user overrides applied.
function base.user_opts(module, default, extend)
  -- default to extend = true
  if extend == nil then extend = true end
  -- if no default table is provided set it to an empty table
  if default == nil then default = {} end
  -- try to load a module file if it exists
  local user_module_settings = load_module_file("user." .. module)
  -- return the final configuration table with any overrides applied
  return default
end




--- Updater setup
base.updater = {
  options = base.user_opts("updater", { remote = "origin", channel = "stable" }),
  snapshot = {
    module = "lazy_snapshot",
    path = vim.fn.stdpath "config" .. "/lua/lazy_snapshot.lua" 
  },
  rollback_file = vim.fn.stdpath "cache" .. "/nvim_rollback.lua",
}
local options = base.updater.options
if base.install.is_stable ~= nil then 
  options.channel = base.install.is_stable and "stable" or "nightly" 
end
if options.pin_plugins == nil then 
  options.pin_plugins = options.channel == "stable" 
end





