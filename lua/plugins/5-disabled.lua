-- Disabled plugins
-- In case we want to re-enable them in the future.

--    Sections:
--       -> lsp_signature.nvim

return {

  -- Show help when writing parameters [auto params help]
  -- https://github.com/ray-x/lsp_signature.nvim
  -- It's disabled by default, you can enable it by setting 'enabled' to true.
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "User BaseFile",
  --   opts = {
  --     -- Window mode
  --     floating_window = true,     -- Dislay it as floating window.
  --     hi_parameter = "IncSearch", -- Color to highlight floating window.
  --
  --     -- Hint mode
  --     hint_enable = false,        -- Display it as hint.
  --     hint_prefix = "👈 "
  --
  --     -- Aditionally, you can use <space>ui to toggle inlay hints.
  --   },
  --   config = function(_, opts) require'lsp_signature'.setup(opts) end
  -- },

}
