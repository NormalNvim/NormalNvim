-- Disabled plugins
-- In case we want to re-enable them in the future.

return {

  -- leetcode.nvim
  -- https://github.com/kawre/leetcode.nvim
  -- You found an easter egg!
  -- To use it, uncomment this, exit nvim and write "nvim leetcode.nvim"
  -- {
  --   "kawre/leetcode.nvim",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     "rcarriga/nvim-notify",
  --   },
  --   init = function(_, opts)
  --     -- Require only when needed
  --     if vim.tbl_contains(vim.fn.argv(), 'leetcode.nvim') then
  --       require("leetcode").setup(opts)
  --     end
  --   end,
  --   opts = {
  --     -- HOW TO ENABLE TYPESCRIPT/JAVASCRIPT LINTING FOR THIS PLUGIN
  --     -- -----------------------------------------------------------
  --     -- * Install the eslint packages:
  --     -- npm install @typescript-eslint/eslint-plugin @typescript-eslint/parser
  --     -- * Then copy paste this into ~/.local/share/nvim/leetcode/.eslintrc.json
  --     -- https://pastebin.com/raw/aQXjpLuE
  --     lang = "typescript",
  --   },
  -- },

}
