--- ### Nvim UI toggle functions
--
--  DESCRIPTION:
--  We use this for easy UI toggles.
--  We call these functions in ../4-mappings.lua and ./lsp.lua
--
--  While you could technically delete this file, we encourage you
--  to keep it as it takes a lot of complexity out of
--  ../4-mappings.lua and ./lsp.lua

--    Functions:
--      -> toggle_ui_notifications
--      -> toggle_autopairs
--      -> toggle_diagnostics
--      -> toggle_background
--      -> toggle_cmp
--      -> toggle_autoformat
--      -> toggle_buffer_autoformat
--      -> toggle_buffer_semantic_tokens
--      -> toggle_semantic_tokens
--      -> toggle_buffer_inlay_hints
--      -> toggle_inlay_hints
--      -> toggle_codelens
--      -> toggle_tabline
--      -> toggle_conceal
--      -> toggle_statusline
--      -> change_number
--      -> toggle_spell
--      -> toggle_paste
--      -> toggle_wrap
--      -> toggle_syntax
--      -> toggle_url_effect
--      -> toggle_zen_mode
--      -> toggle_foldcolumn
--      -> toggle_signcolumn
--      -> set_indent

local M = {}
local utils = require("base.utils")

local function bool2str(bool) return bool and "on" or "off" end

--- Toggle notifications for UI toggles
function M.toggle_ui_notifications()
  vim.g.notifications_enabled = not vim.g.notifications_enabled
  utils.notify(string.format("Notifications %s", bool2str(vim.g.notifications_enabled)))
end

--- Toggle autopairs
function M.toggle_autopairs()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
    else
      autopairs.disable()
    end
    vim.g.autopairs_enabled = autopairs.state.disabled
    utils.notify(string.format("autopairs %s", bool2str(not autopairs.state.disabled)))
  else
    utils.notify "autopairs not available"
  end
end

--- Toggle diagnostics
function M.toggle_diagnostics()
  vim.g.diagnostics_mode = (vim.g.diagnostics_mode - 1) % 4
  vim.diagnostic.config(require("base.utils.lsp").diagnostics[vim.g.diagnostics_mode])
  if vim.g.diagnostics_mode == 0 then
    utils.notify "diagnostics off"
  elseif vim.g.diagnostics_mode == 1 then
    utils.notify "only status diagnostics"
  elseif vim.g.diagnostics_mode == 2 then
    utils.notify "virtual text off"
  else
    utils.notify "all diagnostics on"
  end
end

--- Toggle background="dark"|"light"
function M.toggle_background()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  utils.notify(string.format("background=%s", vim.go.background))
end

--- Toggle cmp entrirely
function M.toggle_cmp()
  vim.g.cmp_enabled = not vim.g.cmp_enabled
  local ok, _ = pcall(require, "cmp")
  utils.notify(ok and string.format("completion %s", bool2str(vim.g.cmp_enabled)) or "completion not available")
end

--- Toggle auto format
function M.toggle_autoformat()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  utils.notify(string.format("Global autoformatting %s", bool2str(vim.g.autoformat_enabled)))
end

--- Toggle buffer local auto format
function M.toggle_buffer_autoformat(bufnr)
  bufnr = bufnr or 0
  local old_val = vim.b[bufnr].autoformat_enabled
  if old_val == nil then old_val = vim.g.autoformat_enabled end
  vim.b[bufnr].autoformat_enabled = not old_val
  utils.notify(string.format("Buffer autoformatting %s", bool2str(vim.b[bufnr].autoformat_enabled)))
end

--- Toggle buffer semantic token highlighting for all language servers that support it
--@param bufnr? number the buffer to toggle the clients on
function M.toggle_buffer_semantic_tokens(bufnr)
  bufnr = bufnr or 0
  vim.b[bufnr].semantic_tokens_enabled = not vim.b[bufnr].semantic_tokens_enabled
  for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b[bufnr].semantic_tokens_enabled and "start" or "stop"](bufnr, client.id)
      utils.notify(string.format("Buffer lsp semantic highlighting %s", bool2str(vim.b[bufnr].semantic_tokens_enabled)))
    end
  end
end

--- Toggle LSP inlay hints (buffer)
-- @param bufnr? number the buffer to toggle the clients on
function M.toggle_buffer_inlay_hints(bufnr)
  bufnr = bufnr or 0
  vim.b[bufnr].inlay_hints_enabled = not vim.b[bufnr].inlay_hints_enabled
  vim.lsp.inlay_hint(bufnr, vim.b[bufnr].inlay_hints_enabled)
  utils.notify(string.format("Inlay hints %s", bool2str(vim.b[bufnr].inlay_hints_enabled)))
end

--- Toggle LSP inlay hints (global)
-- @param bufnr? number the buffer to toggle the clients on
function M.toggle_inlay_hints(bufnr)
  vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled     -- flip global state
  vim.b.inlay_hints_enabled = not vim.g.inlay_hints_enabled     -- sync buffer state
  vim.lsp.buf.inlay_hint(bufnr or 0, vim.g.inlay_hints_enabled) -- apply state
  utils.notify(string.format("Global inlay hints %s", bool2str(vim.g.inlay_hints_enabled)))
end

--- Toggle codelens
function M.toggle_codelens()
  vim.g.codelens_enabled = not vim.g.codelens_enabled
  if not vim.g.codelens_enabled then vim.lsp.codelens.clear() end
  utils.notify(string.format("CodeLens %s", bool2str(vim.g.codelens_enabled)))
end

--- Toggle showtabline=2|0
function M.toggle_tabline()
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
  utils.notify(string.format("tabline %s", bool2str(vim.opt.showtabline:get() == 2)))
end

--- Toggle conceal=2|0
function M.toggle_conceal()
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0
  utils.notify(string.format("conceal %s", bool2str(vim.opt.conceallevel:get() == 2)))
end

--- Toggle laststatus=3|2|0
function M.toggle_statusline()
  local laststatus = vim.opt.laststatus:get()
  local status
  if laststatus == 0 then
    vim.opt.laststatus = 2
    status = "local"
  elseif laststatus == 2 then
    vim.opt.laststatus = 3
    status = "global"
  elseif laststatus == 3 then
    vim.opt.laststatus = 0
    status = "off"
  end
  utils.notify(string.format("statusline %s", status))
end

--- Toggle signcolumn="auto"|"no"
function M.toggle_signcolumn()
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "auto"
  else
    vim.wo.signcolumn = "no"
  end
  utils.notify(string.format("signcolumn=%s", vim.wo.signcolumn))
end

--- Toggle spell
function M.toggle_spell()
  vim.wo.spell = not vim.wo.spell -- local to window
  utils.notify(string.format("spell %s", bool2str(vim.wo.spell)))
end

--- Toggle paste
function M.toggle_paste()
  vim.opt.paste = not vim.opt.paste:get() -- local to window
  utils.notify(string.format("paste %s", bool2str(vim.opt.paste:get())))
end

--- Toggle wrap
function M.toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap -- local to window
  utils.notify(string.format("wrap %s", bool2str(vim.wo.wrap)))
end

--- Toggle syntax highlighting and treesitter
function M.toggle_buffer_syntax(bufnr)
  -- HACK: this should just be `bufnr = bufnr or 0` but it looks like `vim.treesitter.stop` has a bug with `0` being current
  bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_win_get_buf(0)
  local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
  if vim.bo[bufnr].syntax == "off" then
    if ts_avail and parsers.has_parser() then vim.treesitter.start(bufnr) end
    vim.bo[bufnr].syntax = "on"
    if not vim.b.semantic_tokens_enabled then M.toggle_buffer_semantic_tokens(bufnr, true) end
  else
    if ts_avail and parsers.has_parser() then vim.treesitter.stop(bufnr) end
    vim.bo[bufnr].syntax = "off"
    if vim.b.semantic_tokens_enabled then M.toggle_buffer_semantic_tokens(bufnr, true) end
  end
  utils.notify(string.format("syntax %s", bool2str(vim.bo[bufnr].syntax)))
end

--- Toggle URL/URI syntax highlighting rules
function M.toggle_url_effect()
  vim.g.url_effect_enabled = not vim.g.url_effect_enabled
  require("base.utils").set_url_effect()
  utils.notify(string.format("URL effect %s", bool2str(vim.g.url_effect_enabled)))
end

local last_active_foldcolumn
--- Toggle foldcolumn=0|1
function M.toggle_foldcolumn()
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= "0" then last_active_foldcolumn = curr_foldcolumn end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  utils.notify(string.format("foldcolumn=%s", vim.wo.foldcolumn))
end

--- Toggle zen mode
function M.toggle_zen_mode(bufnr)
  bufnr = bufnr or 0
  if not vim.b[bufnr].zen_mode then
    vim.b[bufnr].zen_mode = true
  else
    vim.b[bufnr].zen_mode = false
  end
  utils.notify(string.format("zen mode %s", bool2str(vim.b[bufnr].zen_mode)))
  vim.cmd "ZenMode"
end

--- Set the indent and tab related numbers
function M.set_indent()
  local input_avail, input = pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if input_avail then
    local indent = tonumber(input)
    if not indent or indent == 0 then return end
    vim.bo.expandtab = (indent > 0) -- local to buffer
    indent = math.abs(indent)
    vim.bo.tabstop = indent -- local to buffer
    vim.bo.softtabstop = indent -- local to buffer
    vim.bo.shiftwidth = indent -- local to buffer
    utils.notify(string.format("indent=%d %s", indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
  end
end

--- Change the number display modes
function M.change_number()
  local number = vim.wo.number -- local to window
  local relativenumber = vim.wo.relativenumber -- local to window
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else -- not number and relativenumber
    vim.wo.relativenumber = false
  end
  utils.notify(string.format("number %s, relativenumber %s", bool2str(vim.wo.number), bool2str(vim.wo.relativenumber)))
end

return M
