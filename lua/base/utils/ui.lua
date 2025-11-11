--- ### UI toggle functions.

--  DESCRIPTION:
--  While you could technically delete this file, we encourage you
--  to keep it as it takes a lot of complexity out of `../4-mappings.lua`.

--    Functions:
--      -> set_tabulation
--      -> toggle_animations
--      -> toggle_autoformat
--      -> toggle_autopairs
--      -> toggle_background
--      -> toggle_buffer_inlay_hints
--      -> toggle_buffer_syntax
--      -> toggle_codelens
--      -> toggle_coverage_signs
--      -> toggle_css_colors
--      -> toggle_cmp
--      -> toggle_conceal
--      -> toggle_diagnostics
--      -> toggle_foldcolumn
--      -> toggle_inlay_hints
--      -> toggle_buffer_semantic_tokens
--      -> toggle_line_numbers
--      -> toggle_lsp_signature
--      -> toggle_paste
--      -> toggle_signcolumn
--      -> toggle_spell
--      -> toggle_statusline
--      -> toggle_tabline
--      -> toggle_ui_notifications
--      -> toggle_url_hl
--      -> toggle_wrap
--      -> toggle_zen_mode


local M = {}
local utils = require("base.utils")
local function bool2str(bool) return bool and "ON" or "OFF" end

--- Set tabulation value for the current buffer.
--- Enter a positive number to set tabulation to n spaces.
--- Or enter a negative number to set tabulation to n tabs.
---
--- NOTE: It will also be used when you autoformat your code.
function M.set_tabulation()
  local input_avail, input = pcall(vim.fn.input, "[Tabulation] \n\n- Enter a possitive number to use spaces.\nOr\n- Enter a negative number to use tabs.\n\nThe value will be used when you press TAB for the current buffer, and also when you format your code.\n\nValue: ")
  if input_avail then
    local indent = tonumber(input)
    if not indent or indent == 0 then return end
    vim.bo.expandtab = (indent > 0) -- local to buffer
    indent = math.abs(indent)
    vim.bo.tabstop = indent         -- local to buffer
    vim.bo.softtabstop = indent     -- local to buffer
    vim.bo.shiftwidth = indent      -- local to buffer
    utils.notify(string.format("Buffer [Indent]: `%d`, [Expand tab]`%s`", indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
  end
end

--- Toggle animations
function M.toggle_animations()
  if vim.g.minianimate_disable then
    vim.g.minianimate_disable = false
  else
    vim.g.minianimate_disable = true
  end

  local state = vim.g.minianimate_disable
  utils.notify(string.format("Global [Animations]: `%s`", bool2str(not state)))
end

--- Toggle auto format
function M.toggle_autoformat()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  utils.notify(string.format("Global [Autoformat]: `%s`", bool2str(vim.g.autoformat_enabled)))
end

--- Toggle autopairs
function M.toggle_autopairs()
  if not utils.is_available("nvim-autopairs") then -- guard clause
    utils.notify("Plugin 'autopairs.nvim' not available")
    return
  end
  local autopairs = require("nvim-autopairs")

  if autopairs.state.disabled then
    autopairs.enable()
  else
    autopairs.disable()
  end
  vim.g.autopairs_enabled = not autopairs.state.disabled
  utils.notify(string.format("Global [Autopairs]: `%s`", bool2str(not autopairs.state.disabled)))

end

--- Toggle background="dark"|"light"
--- It will only work if your colorscheme implements this feature.
function M.toggle_background()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  utils.notify(string.format("Global [background]: `%s`", vim.go.background))
end

--- Toggle buffer local auto format
--- @param bufnr? number the buffer to toggle `autoformat` on.
function M.toggle_buffer_autoformat(bufnr)
  bufnr = bufnr or 0
  local old_val = vim.b[bufnr].autoformat_enabled
  if old_val == nil then old_val = vim.g.autoformat_enabled end
  vim.b[bufnr].autoformat_enabled = not old_val
  utils.notify(string.format("Buffer [Autoformat]: `%s`", bool2str(vim.b[bufnr].autoformat_enabled)))
end

--- Toggle LSP inlay hints (buffer)
--- @param bufnr? number the buffer to toggle the `inlay hints` on.
function M.toggle_buffer_inlay_hints(bufnr)
  bufnr = bufnr or 0
  vim.b[bufnr].inlay_hints_enabled = not vim.b[bufnr].inlay_hints_enabled
  vim.lsp.inlay_hint.enable(vim.b[bufnr].inlay_hints_enabled, { bufnr = bufnr })
  utils.notify(string.format("Buffer [Inlay hints]: `%s`", bool2str(vim.b[bufnr].inlay_hints_enabled)))
end

--- Toggle buffer semantic token highlighting for all language servers that support it
--- @param bufnr? number the buffer to toggle `semantic tokens` on.
function M.toggle_buffer_semantic_tokens(bufnr)
  bufnr = bufnr or 0
  vim.b[bufnr].semantic_tokens_enabled = not vim.b[bufnr].semantic_tokens_enabled
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b[bufnr].semantic_tokens_enabled and "start" or "stop"](bufnr, client.id)
      utils.notify(string.format("Buffer [LSP semantic highlighting]: `%s`", bool2str(vim.b[bufnr].semantic_tokens_enabled)))
    end
  end
end

--- Toggle syntax highlighting and treesitter
--- @param bufnr? number the buffer to toggle `treesitter` on.
function M.toggle_buffer_syntax(bufnr)
  -- HACK: this should just be `bufnr = bufnr or 0` but it looks like
  --       `vim.treesitter.stop` has a bug with `0` being current.
  bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_win_get_buf(0)
  local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
  if vim.bo[bufnr].syntax == "OFF" then
    if ts_avail and parsers.has_parser() then vim.treesitter.start(bufnr) end
    vim.bo[bufnr].syntax = "ON"
    if not vim.b.semantic_tokens_enabled then M.toggle_buffer_semantic_tokens(bufnr) end
  else
    if ts_avail and parsers.has_parser() then vim.treesitter.stop(bufnr) end
    vim.bo[bufnr].syntax = "off"
    if vim.b.semantic_tokens_enabled then M.toggle_buffer_semantic_tokens(bufnr) end
  end
  utils.notify(string.format("Buffer [Syntax]: `%s`", bool2str(vim.bo[bufnr].syntax)))
end

--- Toggle codelens
--- @param bufnr? number the buffer to toggle `codelens` on.
function M.toggle_codelens(bufnr)
  bufnr = bufnr or 0
  vim.g.codelens_enabled = not vim.g.codelens_enabled
  if vim.g.codelens_enabled then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  else
    vim.lsp.codelens.clear()
  end
  utils.notify(string.format("Buffer [CodeLens]: `%s`", bool2str(vim.g.codelens_enabled)))
end

--- Toggle coverage signs
function M.toggle_coverage_signs()
  vim.g.coverage_signs_enabled = not vim.g.coverage_signs_enabled
  if vim.g.coverage_signs_enabled then
    utils.notify("Global [Coverage signs]: `ON`" ..
                 "\n\n- Git signs will be temporary disabled." ..
                 "\n- Diagnostic signs won't be automatically disabled.")
    vim.cmd("Gitsigns toggle_signs")
    require("coverage").load(true)
  else
    utils.notify("Global [Coverage signs]: `OFF`  \n\n- Git signs re-enabled.")
    require("coverage").hide()
    vim.cmd("Gitsigns toggle_signs")
  end
end

--- Toggle CSS #colors
function M.toggle_css_colors()
  if not utils.is_available("nvim-highlight-colors") then -- guard clause
    utils.notify("Plugin 'nvim-highlight-colors' not available")
    return
  end

  vim.cmd("HighlightColors toggle")
  local state = require("nvim-highlight-colors").is_active()
  utils.notify(string.format("Global [CSS #colors]: `%s`", bool2str(state)))
end

--- Toggle cmp entrirely
function M.toggle_cmp()
  if not utils.is_available("nvim-cmp") then -- guard clause
    utils.notify("Plugin 'nvim-cmp' not available")
    return
  end

  vim.g.cmp_enabled = not vim.g.cmp_enabled
  utils.notify(
    string.format("Global [AutoCompletion]: `%s`", bool2str(vim.g.cmp_enabled))
  )
end

--- Toggle conceal=2|0
function M.toggle_conceal()
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0 -- global
  utils.notify(string.format("Buffer [Conceal]: `%s`", bool2str(vim.opt.conceallevel:get() == 2)))
end

--- Toggle diagnostics
function M.toggle_diagnostics()
  vim.g.diagnostics_mode = (vim.g.diagnostics_mode - 1) % 4
  vim.diagnostic.config(require("base.utils").diagnostics_enum[vim.g.diagnostics_mode])
  if vim.g.diagnostics_mode == 0 then
    utils.notify("Global [LSP diagnostics mode]: `OFF`")
  elseif vim.g.diagnostics_mode == 1 then
    utils.notify("Global [LSP diagnostics mode]: `Statusbar only`")
  elseif vim.g.diagnostics_mode == 2 then
    utils.notify("Global [LSP diagnostics mode]: `Virtual text only`")
  else
    utils.notify("Global [LSP diagnostics mode]: `All diagnostics ON`")
  end
end

local last_active_foldcolumn
--- Toggle foldcolumn=0|1
function M.toggle_foldcolumn()
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= "0" then last_active_foldcolumn = curr_foldcolumn end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  utils.notify(string.format("Window [Fold column]: `%s`", vim.wo.foldcolumn))
end

--- Toggle LSP inlay hints (global)
--- @param bufnr? number the buffer to toggle the `inlay_hints` on.
function M.toggle_inlay_hints(bufnr)
  bufnr = bufnr or 0
  vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled -- flip global state
  vim.b.inlay_hints_enabled = not vim.g.inlay_hints_enabled -- sync buffer state
  vim.lsp.buf.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = bufnr }) -- apply state
  utils.notify(string.format("Global [Inlay hints]: %s", bool2str(vim.g.inlay_hints_enabled)))
end

--- Toggle line numbers
function M.toggle_line_numbers()
  local number = vim.wo.number
  local relativenumber = vim.wo.relativenumber
  if not number and not relativenumber then    -- mode 1
    vim.wo.number = true
  elseif number and not relativenumber then    -- mode 2
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false                      -- mode 3
  else -- not number and relativenumber
    vim.wo.relativenumber = false              -- mode 4
  end
  utils.notify(string.format("Window [Line number] `%s`, [Relative Number] `%s`", bool2str(vim.wo.number), bool2str(vim.wo.relativenumber)))
end

--- Toggle lsp signature
function M.toggle_lsp_signature()
  if not utils.is_available("lsp_signature.nvim") then -- guard clause
    utils.notify("Plugin 'lsp_signature.nvim' not available")
    return
  end

  local state = require('lsp_signature').toggle_float_win() -- global
  utils.notify(string.format("Global [LSP signature]: `%s`", bool2str(state)))
end

--- Toggle paste
function M.toggle_paste()
  vim.opt.paste = not vim.opt.paste:get()
  utils.notify(string.format("Global [Paste mode]: `%s`", bool2str(vim.opt.paste:get())))
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
  utils.notify(string.format("Window [Sign column]: `%s`", vim.wo.signcolumn))
end

--- Toggle spell
function M.toggle_spell()
  vim.wo.spell = not vim.wo.spell
  utils.notify(string.format("Window [Spell check]: `%s`", bool2str(vim.wo.spell)))
end

--- Toggle laststatus=3|2|0
function M.toggle_statusline()
  local laststatus = vim.opt.laststatus:get()
  local status
  if laststatus == 0 then
    vim.opt.laststatus = 2
    status = "LOCAL"
  elseif laststatus == 2 then
    vim.opt.laststatus = 3
    status = "GLOBAL"
  elseif laststatus == 3 then
    vim.opt.laststatus = 0
    status = "OFF"
  end
  utils.notify(string.format("toggle [Status line]: `%s`", status))
end

--- Toggle showtabline=2|0
function M.toggle_tabline()
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
  utils.notify(string.format("Global [vim.opt.showtabline]: `%s`", bool2str(vim.opt.showtabline:get() == 2)))
end


local notify_state
--- Toggle notifications
function M.toggle_notifications()
  vim.g.notifications_enabled = not vim.g.notifications_enabled
  if vim.g.notifications_enabled then
    vim.notify = notify_state
  else
    notify_state = vim.notify
  end
  utils.notify(string.format("Global [vim.g.notifications_enabled]: `%s`", bool2str(vim.g.notifications_enabled)))
end

--- Toggle URL highlight
function M.toggle_url_hl()
  vim.g.url_hl_enabled = not vim.g.url_hl_enabled
  require("base.utils").set_url_hl()
  utils.notify(string.format("Global [URL highlight]: `%s`", bool2str(vim.g.url_hl_enabled)))
end

--- Toggle line wrap
function M.toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
  utils.notify(string.format("Window [Line Wrap]: `%s`", bool2str(vim.wo.wrap)))
end

--- Toggle zen mode
--- @param bufnr? number the buffer to toggle `zen mode` on.
function M.toggle_zen_mode(bufnr)
  if not utils.is_available("zen-mode.nvim") then -- guard clause
    utils.notify("Plugin 'zen-mode.nvim' not available")
    return
  end

  bufnr = bufnr or 0
  if not vim.g.zen_mode then
    vim.g.zen_mode = true
  else
    vim.g.zen_mode = false
  end
  utils.notify(string.format("Global [Zen mode]: `%s`", bool2str(vim.g.zen_mode)))
  vim.cmd("ZenMode")
end

return M
