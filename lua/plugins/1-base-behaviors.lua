-- Core behaviors
-- Things that add new behaviors.


--    Sections:
--       -> nvim-window-picker     [windows]
--       -> better-scape.nvim      [esc]
--       -> toggleterm.nvim        [term]
--       -> session-manager        [session]




return {
  -- easier window selection  [windows]
  -- https://github.com/s1n7ax/nvim-window-picker
  { 
    "s1n7ax/nvim-window-picker", opts = { use_winbar = "smart" } 
  },




  -- Improved [esc]
  -- https://github.com/max397574/better-escape.nvim
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = { timeout = 300 } 
  },



  
  -- Toggle floating terminal on <F7> [term]
  -- https://github.com/akinsho/toggleterm.nvim 
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      size = 10,
      open_mapping = [[<F7>]],
      shading_factor = 2,
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = { border = "Normal", background = "Normal" },
      },
    },
  },




  -- Session management [session]
  -- TODO: Replace both for procession or similar.
  -- Check: https://github.com/gennaro-tedesco/nvim-possession
  {
    "Shatur/neovim-session-manager",
    event = "BufWritePost",
    cmd = "SessionManager",
    enabled = vim.g.resession_enabled ~= true,
  },
  {
    "stevearc/resession.nvim",
    enabled = vim.g.resession_enabled == true,
    opts = {
      buf_filter = function(bufnr) return require("base.utils.buffer").is_valid(bufnr) end,
      tab_buf_filter = function(tabpage, bufnr) return vim.tbl_contains(vim.t[tabpage].bufs, bufnr) end,
      extensions = { base = {} },
    },
  },




}
