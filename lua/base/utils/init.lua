--- ### General utils.

--  DESCRIPTION:
--  General utility functions to use within Nvim.

--    Functions:
--      -> run_cmd                    → Run a shell command and return true/false.
--      -> add_autocmds_to_buffer     → Add autocmds to a bufnr.
--      -> apply_default_lsp_settings → Apply Default LSP settings.
--      -> apply_user_lsp_mappings    → Apply user lsp mappings to a lsp client.
--      -> del_autocmds_from_buffer   → Delete autocmds from a bufnr.
--      -> get_icon                   → Return an icon from the icons directory.
--      -> get_mappings_template      → Return a empty mappings table.
--      -> is_available               → Return true if the plugin exist.
--      -> is_big_file                → Return true if the file is too big.
--      -> notify                     → Send a notification with a default title.
--      -> os_path                    → Converts a path to the current OS.
--      -> get_plugin_opts            → Return a plugin opts table.
--      -> set_mappings               → Set a list of mappings in a clean way.
--      -> set_url_effect             → Show an effect for urls.
--      -> open_with_program          → Open the file or URL under the cursor.
--      -> trigger_event              → Manually trigger an event.
--      -> which_key_register         → When setting a mapping, add it to whichkey.


local M = {}

--- Run a shell command and capture the output and whether the command
--- succeeded or failed.
--- @param cmd string|string[] The terminal command to execute.
--- @param show_error? boolean If true, print errors if the command fails.
--- @return string|nil # The result of a successfully executed command, or nil if it failed.
function M.run_cmd(cmd, show_error)
  -- Split cmd string into a list, if needed.
  if type(cmd) == "string" then
    cmd = vim.split(cmd, " ")
  end

  -- If windows, and prepend cmd.exe
  if vim.fn.has("win32") == 1 then
    cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd)
  end

  -- Execute cmd and store result (output or error message)
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar("shell_error") == 0

  -- If the command failed and show_error is true or not provided, print error.
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_echo({{
      ("Error running command %s\nError message:\n%s"):format(
        table.concat(cmd, " "), -- Convert the cmd back to string.
        result                  -- Show the error result
      )}}, true, { err = true }
    )
  end

  -- strip out terminal escape sequences and control characters.
  local cleaned_result = result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")

  -- Return the cleaned result if the command succeeded, or nil if it failed
  return (success and cleaned_result) or nil
end

--- Adds autocmds to a specific buffer if they don't already exist.
---
--- @param augroup string       The name of the autocmd group to which the autocmds belong.
--- @param bufnr number         The buffer number to which the autocmds should be applied.
--- @param autocmds table|any  A table or a single autocmd definition containing the autocmds to add.
function M.add_autocmds_to_buffer(augroup, bufnr, autocmds)
  -- Check if autocmds is a list, if not convert it to a list
  if not vim.islist(autocmds) then autocmds = { autocmds } end

  -- Attempt to retrieve existing autocmds associated with the specified augroup and bufnr
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })

  -- If no existing autocmds are found or the cmds_found call fails
  if not cmds_found or vim.tbl_isempty(cmds) then
    -- Create a new augroup if it doesn't already exist
    vim.api.nvim_create_augroup(augroup, { clear = false })

    -- Iterate over each autocmd provided
    for _, autocmd in ipairs(autocmds) do
      -- Extract the events from the autocmd and remove the events key
      local events = autocmd.events
      autocmd.events = nil

      -- Set the group and buffer keys for the autocmd
      autocmd.group = augroup
      autocmd.buffer = bufnr

      -- Create the autocmd
      vim.api.nvim_create_autocmd(events, autocmd)
    end
  end
end

--- Apply default settings for diagnostics, formatting, and lsp capabilities.
--- It only need to be executed once, normally on mason-lspconfig.
--- @return nil
M.apply_default_lsp_settings = function()
  -- Icons
  -- Apply the icons defined in ../icons/icons.lua
  local signs = {
    { name = "DiagnosticSignError",    text = M.get_icon("DiagnosticError"),        texthl = "DiagnosticSignError" },
    { name = "DiagnosticSignWarn",     text = M.get_icon("DiagnosticWarn"),         texthl = "DiagnosticSignWarn" },
    { name = "DiagnosticSignHint",     text = M.get_icon("DiagnosticHint"),         texthl = "DiagnosticSignHint" },
    { name = "DiagnosticSignInfo",     text = M.get_icon("DiagnosticInfo"),         texthl = "DiagnosticSignInfo" },
    { name = "DapStopped",             text = M.get_icon("DapStopped"),             texthl = "DiagnosticWarn" },
    { name = "DapBreakpoint",          text = M.get_icon("DapBreakpoint"),          texthl = "DiagnosticInfo" },
    { name = "DapBreakpointRejected",  text = M.get_icon("DapBreakpointRejected"),  texthl = "DiagnosticError" },
    { name = "DapBreakpointCondition", text = M.get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" },
    { name = "DapLogPoint",            text = M.get_icon("DapLogPoint"),            texthl = "DiagnosticInfo" }
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, sign)
  end

  -- Apply default lsp hover borders
  -- Applies the option lsp_round_borders_enabled from ../1-options.lua
  M.lsp_hover_opts = vim.g.lsp_round_borders_enabled and { border = "rounded", silent = true } or {}

  -- Set default diagnostics
  local default_diagnostics = {
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = M.get_icon("DiagnosticError"),
        [vim.diagnostic.severity.HINT] = M.get_icon("DiagnosticHint"),
        [vim.diagnostic.severity.WARN] = M.get_icon("DiagnosticWarn"),
        [vim.diagnostic.severity.INFO] = M.get_icon("DiagnosticInfo"),
      },
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focused = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  -- Apply default diagnostics
  -- Applies the option diagnostics_mode from ../1-options.lua
  M.diagnostics = {
    -- diagnostics off
    [0] = vim.tbl_deep_extend(
      "force",
      default_diagnostics,
      { underline = false, virtual_text = false, signs = false, update_in_insert = false }
    ),
    -- status only
    vim.tbl_deep_extend("force", default_diagnostics, { virtual_text = false, signs = false }),
    -- virtual text off, signs on
    vim.tbl_deep_extend("force", default_diagnostics, { virtual_text = false }),
    -- all diagnostics on
    default_diagnostics,
  }
  vim.diagnostic.config(M.diagnostics[vim.g.diagnostics_mode])

  -- Apply formatting settings
  M.lsp_formatting = { format_on_save = { enabled = true }, disabled = {} }
  if type(M.formatting.format_on_save) == "boolean" then
    M.lsp_formatting.format_on_save = { enabled = M.lsp_formatting.format_on_save }
  end
  M.lsp_format_opts = vim.deepcopy(M.lsp_formatting)
  M.lsp_format_opts.disabled = nil
  M.lsp_format_opts.format_on_save = nil
  M.lsp_format_opts.filter = function(client)
    local filter = M.lsp_formatting.filter
    local disabled = M.lsp_formatting.disabled or {}
    -- check if client is fully disabled or filtered by function
    return not (vim.tbl_contains(disabled, client.name) or (type(filter) == "function" and not filter(client)))
  end
end

--- Applies the user lsp mappings to the lsp client.
--- This function must be called every time a lsp client is attached.
--- (currently on the config of the plugins `lspconfig` and none-ls)
--- @param client string The client where the lsp mappings will load.
--- @param bufnr number The bufnr where the lsp mappings will load.
function M.apply_user_lsp_mappings(client, bufnr)
  local lsp_mappings = require("base.4-mappings").lsp_mappings(client, bufnr)
  if not vim.tbl_isempty(lsp_mappings.v) then
    lsp_mappings.v["<leader>l"] = { desc = M.get_icon("ActiveLSP", true) .. "LSP" }
  end
  M.set_mappings(lsp_mappings, { buffer = bufnr })
end

--- Deletes autocmds associated with a specific buffer and autocmd group.
--- @param augroup string The name of the autocmd group from which the autocmds should be removed.
--- @param bufnr number The buffer number from which the autocmds should be removed.
function M.del_autocmds_from_buffer(augroup, bufnr)
  -- Attempt to retrieve existing autocmds associated with the specified augroup and bufnr
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })

  -- If retrieval was successful
  if cmds_found then
    -- Map over each retrieved autocmd and delete it
    vim.tbl_map(function(cmd) vim.api.nvim_del_autocmd(cmd.id) end, cmds)
  end
end

--- Get an icon from given its icon name.
--- if vim.g.fallback_icons_enabled = true, it will return a fallback icon
--- unless specified otherwise.
--- @param icon_name string Name of the icon to retrieve.
--- @param fallback_to_empty_string boolean|nil If this parameter is true, when `vim.g.fallback_icons_enabled = true` then `get_icon()` will return empty string.
--- @return string icon.
function M.get_icon(icon_name, fallback_to_empty_string)
  -- guard clause
  if fallback_to_empty_string and vim.g.fallback_icons_enabled then return "" end

  -- get icon_pack
  local icon_pack = (vim.g.fallback_icons_enabled and "fallback_icons") or "icons"

  -- cache icon_pack into M
  if not M[icon_pack] then -- only if not cached already.
    if icon_pack == "icons" then
      M.icons = require("base.icons.icons")
    elseif icon_pack =="fallback_icons" then
      M.fallback_icons = require("base.icons.fallback_icons")
    end
  end

  -- return specified icon
  local icon = M[icon_pack] and M[icon_pack][icon_name]
  return icon
end

--- Get an empty table of mappings with a key for each map mode.
--- @return table<string,table> # a table with entries for each map mode.
function M.get_mappings_template()
  local maps = {}
  for _, mode in ipairs {
    "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t", "ia", "ca", "!a"
  } do maps[mode] = {} end
  return maps
end

--- Check if a plugin is defined in lazy. Useful with lazy loading
--- when a plugin is not necessarily loaded yet.
--- @param plugin string The plugin to search for.
--- @return boolean available # Whether the plugin is available.
function M.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Returns true if the file is considered a big file,
--- according to the criteria defined in `vim.g.big_file`.
--- @param bufnr number|nil buffer number. 0 by default, which means current buf.
--- @return boolean is_big_file true or false.
function M.is_big_file(bufnr)
  if bufnr == nil then bufnr = 0 end
  local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  local is_big_file = (filesize > vim.g.big_file.size)
      or (nlines > vim.g.big_file.lines)
  return is_big_file
end

--- Sends a notification with 'Neovim' as default title.
--- Same as using vim.notify, but it saves us typing the title every time.
--- @param msg string The notification body.
--- @param type number|nil The type of the notification (:help vim.log.levels).
--- @param opts? table The nvim-notify options to use (:help notify-options).
function M.notify(msg, type, opts)
  vim.schedule(function()
    vim.notify(
      msg, type, vim.tbl_deep_extend("force", { title = "Neovim" }, opts or {}))
  end)
end

--- Convert a path to the path format of the current operative system.
--- It converts 'slash' to 'inverted slash' if on windows, and vice versa on UNIX.
--- @param path string A path string.
--- @return string|nil,nil path A path string formatted for the current OS.
function M.os_path(path)
  if path == nil then return nil end
  -- Get the platform-specific path separator
  local separator = string.sub(package.config, 1, 1)
  return string.gsub(path, '[/\\]', separator)
end

--- Get the options of a plugin managed by lazy.
--- @param plugin string The plugin to get options from
--- @return table opts # The plugin options, or empty table if no plugin.
function M.get_plugin_opts(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugin")
  local opts = {}
  if lazy_config_avail and lazy_plugin_avail then
    local spec = lazy_config.spec.plugins[plugin]
    if spec then opts = lazy_plugin.values(spec, "opts") end
  end
  return opts
end

--- Set a table of mappings.
--- This wrapper prevents boilerplate code, and takes care of `whichkey.nvim`.
--- @param map_table table A nested table where the first key is the vim mode,
---                        the second key is the key to map, and the value is
---                        the function to set the mapping to.
--- @param base? table A base set of options to set on every keybinding.
function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd
        local keymap_opts = base or {}
        if type(options) == "string" or type(options) == "function" then
          cmd = options
        else
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd then -- if which-key mapping, queue it
          keymap_opts[1], keymap_opts.mode = keymap, mode
          if not keymap_opts.group then keymap_opts.group = keymap_opts.desc end
          if not M.which_key_queue then M.which_key_queue = {} end
          table.insert(M.which_key_queue, keymap_opts)
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  -- if which-key is loaded already, register
  if package.loaded["which-key"] then M.which_key_register() end
end


--- Add syntax matching rules for highlighting URLs/URIs.
function M.set_url_effect()
  --- regex used for matching a valid URL/URI string
  local url_matcher =
      "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)" ..
      "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)" ..
      "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|" ..
      "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)" ..
      "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*" ..
      "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

  M.delete_url_effect()
  if vim.g.url_effect_enabled then
    vim.fn.matchadd("HighlightURL", url_matcher, 15)
  end
end

--- Delete the syntax matching rules for URLs/URIs if set.
function M.delete_url_effect()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then vim.fn.matchdelete(match.id) end
  end
end

--- Open the file or url under the cursor.
--- @param path string The path of the file to open with the system opener.
function M.open_with_program(path)
  -- guard clause: If a opener already exists, use it.
  if vim.ui.open then return vim.ui.open(path) end

  -- command to run
  local cmd

  -- cmd is different depending the OS
  if vim.fn.has("mac") == 1 then
    cmd = { "open" }
  elseif vim.fn.has("win32") == 1 then
    if vim.fn.executable "rundll32" then
      cmd = { "rundll32", "url.dll,FileProtocolHandler" }
    else
      cmd = { "cmd.exe", "/K", "explorer" }
    end
  elseif vim.fn.has("unix") == 1 then
    if vim.fn.executable("explorer.exe") == 1 then -- available in WSL
      cmd = { "explorer.exe" }
    elseif vim.fn.executable("xdg-open") == 1 then
      cmd = { "xdg-open" }
    end
  end
  if not cmd then M.notify("Available system opening tool not found!", vim.log.levels.ERROR) end

  -- No path provided? use the file under the cursor; else, expand the path.
  if not path then
    path = vim.fn.expand("<cfile>")
  elseif not path:match "%w+:" then
    path = vim.fn.expand(path)
  end

  -- start job (detached)
  vim.fn.jobstart(vim.list_extend(cmd, { path }), { detach = true })
end

--- Convenient wapper to save code when we Trigger events.
--- To listen for an event triggered by this function you can use `autocmd`.
--- @param event string Name of the event.
--- @param is_urgent boolean|nil If true, trigger directly instead of scheduling. Useful for startup events.
-- @usage To run a User event:   `trigger_event("User MyUserEvent")`
-- @usage To run a Neovim event: `trigger_event("BufEnter")
function M.trigger_event(event, is_urgent)
  -- define behavior
  local function trigger()
    local is_user_event = string.match(event, "^User ") ~= nil
    if is_user_event then
      event = event:gsub("^User ", "")
      vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false })
    else
      vim.api.nvim_exec_autocmds(event, { modeline = false })
    end
  end

  -- execute
  if is_urgent then
    trigger()
  else
    vim.schedule(trigger)
  end
end

--- Register queued which-key mappings.
function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    if wk_avail then
      wk.add(M.which_key_queue)
      M.which_key_queue = nil
    end
  end
end

return M
