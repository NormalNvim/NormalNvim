--- ### Nvim LSP utils
--
--  DESCRIPTION:
--  Functions we use to configure the plugin mason-lspconfig.nvim
--
--  NOTE:
--  Most options defined here can be tweaked on ../1-options.lua
--  so avoid touching here when possible. High risk of breaking important stuff.

--    Helpers:
--      -> M.has_capability      → Returns true if the client has the capability.

--    Functions:
--      -> M.setup_defaults      → Default settings for diagnostics and formatting.
--      -> M.on_attach           → Called from M.config().
--      -> M.config              → Called from M.setup().
--      -> M.setup               → Function responsible of starting a lsp server.

local M = {}
local utils = require "base.utils"
local stored_handlers = {}


--- Helper function to check if any active LSP clients given a filter provide a specific capability
---@param capability string The server capability to check for (example: "documentFormattingProvider")
---@param filter vim.lsp.get_active_clients.filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
function M.has_capability(capability, filter)
  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    if client.supports_method(capability) then return true end
  end
  return false
end

--- Apply default settings for diagnostics and formatting.
--- It only need to be executed once, normally on mason-lspconfig.
M.apply_defaults = function()
  -- Icons
  -- Apply the icons defined in ../icons/nerd_font.lua
  local get_icon = utils.get_icon
  local signs = {
    { name = "DiagnosticSignError", text = get_icon "DiagnosticError", texthl = "DiagnosticSignError" },
    { name = "DiagnosticSignWarn", text = get_icon "DiagnosticWarn", texthl = "DiagnosticSignWarn" },
    { name = "DiagnosticSignHint", text = get_icon "DiagnosticHint", texthl = "DiagnosticSignHint" },
    { name = "DiagnosticSignInfo", text = get_icon "DiagnosticInfo", texthl = "DiagnosticSignInfo" },
    { name = "DapStopped", text = get_icon "DapStopped", texthl = "DiagnosticWarn" },
    { name = "DapBreakpoint", text = get_icon "DapBreakpoint", texthl = "DiagnosticInfo" },
    { name = "DapBreakpointRejected", text = get_icon "DapBreakpointRejected", texthl = "DiagnosticError" },
    { name = "DapBreakpointCondition", text = get_icon "DapBreakpointCondition", texthl = "DiagnosticInfo" },
    { name = "DapLogPoint", text = get_icon "DapLogPoint", texthl = "DiagnosticInfo" },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, sign)
  end

  -- Borders
  -- Apply the option lsp_round_borders_enabled from ../1-options.lua
  if vim.g.lsp_round_borders_enabled then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", silent = true })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", silent = true })
  end

  -- Set default diagnostics
  local default_diagnostics = {
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = utils.get_icon "DiagnosticError",
        [vim.diagnostic.severity.HINT] = utils.get_icon "DiagnosticHint",
        [vim.diagnostic.severity.WARN] = utils.get_icon "DiagnosticWarn",
        [vim.diagnostic.severity.INFO] = utils.get_icon "DiagnosticInfo",
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
  -- Apply the opiton diagnostics_mode from ../1-options.lua
  M.diagnostics = {
    -- diagnostics off
    [0] = utils.extend_tbl(
      default_diagnostics,
      { underline = false, virtual_text = false, signs = false, update_in_insert = false }
    ),
    -- status only
    utils.extend_tbl(default_diagnostics, { virtual_text = false, signs = false }),
    -- virtual text off, signs on
    utils.extend_tbl(default_diagnostics, { virtual_text = false }),
    -- all diagnostics on
    default_diagnostics,
  }
  vim.diagnostic.config(M.diagnostics[vim.g.diagnostics_mode])


  -- Apply formatting settings
  M.formatting = { format_on_save = { enabled = true }, disabled = {} }
  if type(M.formatting.format_on_save) == "boolean" then
    M.formatting.format_on_save = { enabled = M.formatting.format_on_save }
  end
  M.format_opts = vim.deepcopy(M.formatting)
  M.format_opts.disabled = nil
  M.format_opts.format_on_save = nil
  M.format_opts.filter = function(client)
    local filter = M.formatting.filter
    local disabled = M.formatting.disabled or {}
    -- check if client is fully disabled or filtered by function
    return not (vim.tbl_contains(disabled, client.name) or (type(filter) == "function" and not filter(client)))
  end

  --- Apply the default LSP capabilities
  M.capabilities = vim.lsp.protocol.make_client_capabilities()
  M.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
  M.capabilities.textDocument.completion.completionItem.preselectSupport = true
  M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  M.capabilities.textDocument.completion.completionItem.resolveSupport =
    { properties = { "documentation", "detail", "additionalTextEdits" } }
  M.capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
  M.flags = {}

end

--- Things we do when a lsp client is attached to a buffer.
---@param client table The LSP client details when attaching
---@param bufnr number The buffer that the LSP client is attaching to
M.on_attach = function(client, bufnr)
  local lsp_mappings = require("base.git-ignored.mappings-colemak-dh").lsp_mappings(client, bufnr)

  -- Add mappings
  if not vim.tbl_isempty(lsp_mappings.v) then
    lsp_mappings.v["<leader>l"] = { desc = utils.get_icon("ActiveLSP", 1, true) .. "LSP" }
  end
  utils.set_mappings(lsp_mappings, { buffer = bufnr })

end


--- Get the server configuration for a given language server to be provided to the server's `setup()` call
---@param server_name string The name of the server
---@return table # The table of LSP options used when setting up the given language server
function M.config(server_name)
  local server = require("lspconfig")[server_name]
  local lsp_opts = utils.extend_tbl(server, { capabilities = M.capabilities, flags = M.flags })
  if server_name == "jsonls" then -- by default add json schemas
    local schemastore_avail, schemastore = pcall(require, "schemastore")
    if schemastore_avail then
      lsp_opts.settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } }
    end
  end
  if server_name == "yamlls" then -- by default add yaml schemas
    local schemastore_avail, schemastore = pcall(require, "schemastore")
    if schemastore_avail then lsp_opts.settings = { yaml = { schemas = schemastore.yaml.schemas() } } end
  end
  if server_name == "lua_ls" then -- by default initialize neodev and disable third party checking
    pcall(require, "neodev")
    lsp_opts.settings = { Lua = { workspace = { checkThirdParty = false } } }
  end
  if server_name == "bashls" then -- by default use mason shellcheck path
    lsp_opts.settings = { bashIde = { shellcheckPath = vim.fn.stdpath "data" .. "/mason/bin/shellcheck" } }
  end
  local opts = lsp_opts
  local old_on_attach = server.on_attach
  opts.on_attach = function(client, bufnr)
    utils.conditional_func(old_on_attach, true, client, bufnr)
    M.on_attach(client, bufnr)
  end
  return opts
end


--- Function to set up a given server with the LSP client.
--- You normally call this function from the plugin `mason-lspconfig.nvim`.
---
-- NOTE: This function call M.config() which call M.on_attach() for us.
---@param server string The name of the server to be setup.
M.setup = function(server)
  -- Apply our settings to the the server.
  local opts = M.config(server)

  -- Apply the lspconfig settings to the server.
  local setup_handler = stored_handlers[server] or require("lspconfig")[server].setup(opts)

  -- Start the server
  if setup_handler then setup_handler(server, opts) end
end

return M
