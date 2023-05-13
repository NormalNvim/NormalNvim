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




--- Updater setup
base.updater = {
  options = { remote = "origin", channel = "stable" },
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




--- table of user created terminals
--base.user_terminals = {}
--- table of language servers to ignore the setup of, configured through lsp.skip_setup in the user configuration
base.lsp = { skip_setup = {} }

