-- Dev
-- Things you actively use for coding.


--    Sections:
--       ## COMMENTS
--       -> comment.nvim                   [adv. comments]

--       ## SNIPPETS
--       -> luasnip                        [snippet engine]
--       -> friendly-snippets              [snippet templates]

--       ## GIT
--       -> gitsigns.nvim                  [git]

--       ## DEBUGGER
--       -> nvim-dap                       [debugger]

--       ## ANALYZER
--       -> aerial.nvim                    [code analyzer]

--       ## EXTRA
--       -> guess-indent                   [guess-indent]




return {
  --  COMMENTS ----------------------------------------------------------------
  --  Advanced comment features [adv. comments]
  --  https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    opts = function()
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
    end,
  },


  --  SNIPPETS ----------------------------------------------------------------
  --  Vim Snippets engine  [snippet engine] + [snippet templates]
  --  https://github.com/L3MON4D3/LuaSnip
  --  https://github.com/rafamadriz/friendly-snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function(_, opts)
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(function(type) require("luasnip.loaders.from_" .. type).lazy_load() end, { "vscode", "snipmate", "lua" })
    end,
  },




  --  GIT ---------------------------------------------------------------------
  --  Git commands inside vim [git]
  --  https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    event = "User BaseGitFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "󰐊" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },




  --  DEBUGGER ----------------------------------------------------------------
  --  Debugger alternative to vim-inspector [debugger]
  --  https://github.com/mfussenegger/nvim-dap
  {
    "mfussenegger/nvim-dap",
    enabled = vim.fn.has "win32" == 0,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { handlers = {} },
      },
      {
        "rcarriga/nvim-dap-ui",
        opts = { floating = { border = "rounded" } },
        config = function(_, opts)
          local dap, dapui = require "dap", require "dapui"
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
          dapui.setup(opts)
        end,
      },
    },
    event = "User BaseFile",
  },




  --  ANALYZER ----------------------------------------------------------------
  --  [code analyzer]
  --  https://github.com/stevearc/aerial.nvim
  {
  "stevearc/aerial.nvim",
  event = "User BaseFile",
  cmd = {"AerialToggle", "AerialOpen", "AerialNavOpen", "AerialInfo", "AerialClose"},
  opts = {
    open_automatic = false, -- Open if the buffer is compatible
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = { min_width = 28 },
    show_guides = true,
    filter_kind = false,
    guides = {
      mid_item = "├ ",
      last_item = "└ ",
      nested_top = "│ ",
      whitespace = "  ",
    },
    keymaps = {
      ["[y"] = "actions.prev",
      ["]y"] = "actions.next",
      ["[Y"] = "actions.prev_up",
      ["]Y"] = "actions.next_up",
      ["{"] = false,
      ["}"] = false,
      ["[["] = false,
      ["]]"] = false,
    },
  },
},
-- Telescope integration (:Telescope aerial)
{ "nvim-telescope/telescope.nvim", opts = function() require("telescope").load_extension "aerial" end },




  --  EXTRA ----------------------------------------------------------------
  --  [guess-indent]
  --  https://github.com/NMAC427/guess-indent.nvim
  {
    "NMAC427/guess-indent.nvim",
    event = "User BaseFile",
    config = function(_, opts)
      require("guess-indent").setup(opts)
      vim.cmd.lua { args = { "require('guess-indent').set_from_buffer('auto_cmd')" }, mods = { silent = true } }
    end,
  },





}
