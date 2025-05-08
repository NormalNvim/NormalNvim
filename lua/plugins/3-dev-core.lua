-- Dev core
-- Plugins that are just there.

--    Sections:
--       ## TREE SITTER
--       -> nvim-treesitter                [syntax highlight]
--       -> render-markdown.nvim           [normal mode markdown]
--       -> nvim-highlight-colors          [hex colors]

--       ## LSP
--       -> nvim-java                      [java support]
--       -> mason-lspconfig                [auto start lsp]
--       -> nvim-lspconfig                 [lsp configs]
--       -> mason.nvim                     [lsp package manager]
--       -> SchemaStore.nvim               [mason extra schemas]
--       -> none-ls-autoload.nvim          [mason package loader]
--       -> none-ls                        [lsp code formatting]
--       -> garbage-day                    [lsp garbage collector]
--       -> lazydev                        [lua lsp for nvim plugins]

--       ## AUTO COMPLETION
--       -> nvim-cmp                       [auto completion engine]
--       -> cmp-nvim-buffer                [auto completion buffer]
--       -> cmp-nvim-path                  [auto completion path]
--       -> cmp-nvim-lsp                   [auto completion lsp]
--       -> cmp-luasnip                    [auto completion snippets]

local utils = require("base.utils")
local utils_lsp = require("base.utils.lsp")

return {
  --  TREE SITTER ---------------------------------------------------------
  --  [syntax highlight]
  --  https://github.com/nvim-treesitter/nvim-treesitter
  --  https://github.com/windwp/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = "User BaseDefered",
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    opts = {
      auto_install = false, -- Currently bugged. Use [:TSInstall all] and [:TSUpdate all]

      highlight = {
        enable = true,
        disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
      },
      matchup = {
        enable = true,
        enable_quotes = true,
        disable = function(_, bufnr) return utils.is_big_file(bufnr) end,
      },
      incremental_selection = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["al"] = { query = "@loop.outer", desc = "around loop" },
            ["il"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous parameter end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next parameter" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
          },
        },
      },
    },
    config = function(_, opts)
      -- calling setup() here is necessary to enable conceal and some features.
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  --  render-markdown.nvim [normal mode markdown]
  --  https://github.com/MeanderingProgrammer/render-markdown.nvim
  --  While on normal mode, markdown files will display highlights.
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown" },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      heading = {
        sign = false,
        icons = require("base.utils").get_icon("RenderMarkdown"),
        width = "block",
      },
      code = {
        sign = false,
        width = 'block', -- use 'language' if colorcolumn is important for you.
        right_pad = 1,
      },
      dash = {
        width = 79
      },
      pipe_table = {
        style = 'full', -- use 'normal' if colorcolumn is important for you.
      },
    },
  },

  --  [hex colors]
  --  https://github.com/brenoprata10/nvim-highlight-colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "User BaseFile",
    cmd = { "HighlightColors" }, -- followed by 'On' / 'Off' / 'Toggle'
    opts = { enabled_named_colors = false },
  },

  --  LSP -------------------------------------------------------------------

  -- nvim-java [java support]
  -- https://github.com/nvim-java/nvim-java
  -- Reliable jdtls support. Must go before mason-lspconfig and lsp-config.
  -- NOTE: Let's use our fork until they merge pull request
  --       https://github.com/nvim-java/nvim-java/pull/376
  {
    "zeioth/nvim-java",
    ft = { "java" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mason-org/mason.nvim",
    },
    opts = {
      notifications = {
        dap = false,
      },
      -- NOTE: One of these files must be in your project root directory.
      --       Otherwise the debugger will end in the wrong directory and fail.
      root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle',
        'build.gradle.kts',
        '.git',
      },
    },
  },

  --  nvim-lspconfig [lsp configs]
  --  https://github.com/neovim/nvim-lspconfig
  --  This plugin provide default configs for the lsp servers available on mason.
  {
    "neovim/nvim-lspconfig",
    event = "User BaseFile",
    dependencies = "zeioth/nvim-java",
  },

  -- mason-lspconfig [auto start lsp]
  -- https://github.com/mason-org/mason-lspconfig.nvim
  -- This plugin auto starts the lsp servers installed by Mason
  -- every time Neovim trigger the event FileType.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "User BaseFile",
    opts = function(_, opts)
      if not opts.handlers then opts.handlers = {} end
      opts.handlers[1] = function(server) utils_lsp.setup(server) end
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      utils_lsp.apply_default_lsp_settings() -- Apply our default lsp settings.
      utils.trigger_event("FileType")        -- This line starts this plugin.
    end,
  },

  --  mason [lsp package manager]
  --  https://github.com/mason-org/mason.nvim
  --  https://github.com/zeioth/mason-extra-cmds
  {
    "mason-org/mason.nvim",
    dependencies = { "zeioth/mason-extra-cmds", opts = {} },
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll", -- this cmd is provided by mason-extra-cmds
    },
    opts = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
      ui = {
        icons = {
          package_installed = require("base.utils").get_icon("MasonInstalled"),
          package_uninstalled = require("base.utils").get_icon("MasonUninstalled"),
          package_pending = require("base.utils").get_icon("MasonPending"),
        },
      },
    }
  },

  --  Schema Store [mason extra schemas]
  --  https://github.com/b0o/SchemaStore.nvim
  --  We use this plugin in ../base/utils/lsp.lua
  "b0o/SchemaStore.nvim",

  -- none-ls-autoload.nvim [mason package loader]
  -- https://github.com/zeioth/mason-none-ls.nvim
  -- This plugin auto starts the packages installed by Mason
  -- every time Neovim trigger the event FileType ().
  -- By default it will use none-ls builtin sources.
  -- But you can add external sources if a mason package has no builtin support.
  {
    "zeioth/none-ls-autoload.nvim",
    event = "User BaseFile",
    dependencies = {
      "mason-org/mason.nvim",
      "zeioth/none-ls-external-sources.nvim"
    },
    opts = {
      -- Here you can add support for sources not oficially suppored by none-ls.
      external_sources = {
        -- diagnostics
        'none-ls-external-sources.diagnostics.cpplint',
        'none-ls-external-sources.diagnostics.eslint',
        'none-ls-external-sources.diagnostics.eslint_d',
        'none-ls-external-sources.diagnostics.flake8',
        'none-ls-external-sources.diagnostics.luacheck',
        'none-ls-external-sources.diagnostics.psalm',
        'none-ls-external-sources.diagnostics.yamllint',

        -- formatting
        'none-ls-external-sources.formatting.autopep8',
        'none-ls-external-sources.formatting.beautysh',
        'none-ls-external-sources.formatting.easy-coding-standard',
        'none-ls-external-sources.formatting.eslint',
        'none-ls-external-sources.formatting.eslint_d',
        'none-ls-external-sources.formatting.jq',
        'none-ls-external-sources.formatting.latexindent',
        'none-ls-external-sources.formatting.reformat_gherkin',
        'none-ls-external-sources.formatting.rustfmt',
        'none-ls-external-sources.formatting.standardrb',
        'none-ls-external-sources.formatting.yq',
      },
    },
  },

  -- none-ls [lsp code formatting]
  -- https://github.com/nvimtools/none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    event = "User BaseFile",
    opts = function()
      local builtin_sources = require("null-ls").builtins

      -- You can customize your 'builtin sources' and 'external sources' here.
      builtin_sources.formatting.shfmt.with({
        command = "shfmt",
        args = { "-i", "2", "-filename", "$FILENAME" },
      })

      -- Attach the user lsp mappings to every none-ls client.
      return { on_attach = utils_lsp.apply_user_lsp_mappings }
    end
  },

  --  garbage-day.nvim [lsp garbage collector]
  --  https://github.com/zeioth/garbage-day.nvim
  {
    "zeioth/garbage-day.nvim",
    event = "User BaseFile",
    opts = {
      aggressive_mode = false,
      excluded_lsp_clients = {
        "null-ls", "jdtls", "marksman", "lua_ls"
      },
      grace_period = (60 * 15),
      wakeup_delay = 3000,
      notifications = false,
      retries = 3,
      timeout = 1000,
    }
  },

  --  lazy.nvim [lua lsp for nvim plugins]
  --  https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = function(_, opts)
      opts.library = {
        -- Any plugin you wanna have LSP autocompletion for, add it here.
        -- in 'path', write the name of the plugin directory.
        -- in 'mods', write the word you use to require the module.
        -- in 'words' write words that trigger loading a lazydev path (optionally).
        { path = "lazy.nvim", mods = { "lazy" } },
        { path = "yazi.nvim", mods = { "yazi" } },
        { path = "project.nvim", mods = { "project_nvim", "telescope" } },
        { path = "trim.nvim", mods = { "trim" } },
        { path = "stickybuf.nvim", mods = { "stickybuf" } },
        { path = "mini.bufremove", mods = { "mini.bufremove" } },
        { path = "smart-splits.nvim", mods = { "smart-splits" } },
        { path = "toggleterm.nvim", mods = { "toggleterm" } },
        { path = "neovim-session-manager.nvim", mods = { "session_manager" } },
        { path = "nvim-spectre", mods = { "spectre" } },
        { path = "neo-tree.nvim", mods = { "neo-tree" } },
        { path = "nui.nvim", mods = { "nui" } },
        { path = "nvim-ufo", mods = { "ufo" } },
        { path = "promise-async", mods = { "promise-async" } },
        { path = "nvim-neoclip.lua", mods = { "neoclip", "telescope" } },
        { path = "zen-mode.nvim", mods = { "zen-mode" } },
        { path = "vim-suda", mods = { "suda" } }, -- has vimscript
        { path = "vim-matchup", mods = { "matchup", "match-up", "treesitter-matchup" } }, -- has vimscript
        { path = "hop.nvim", mods = { "hop", "hop-treesitter", "hop-yank" } },
        { path = "nvim-autopairs", mods = { "nvim-autopairs" } },
        { path = "lsp_signature", mods = { "lsp_signature" } },
        { path = "nvim-lightbulb", mods = { "nvim-lightbulb" } },
        { path = "hot-reload.nvim", mods = { "hot-reload" } },
        { path = "distroupdate.nvim", mods = { "distroupdate" } },

        { path = "tokyonight.nvim", mods = { "tokyonight" } },
        { path = "astrotheme", mods = { "astrotheme" } },
        { path = "alpha-nvim", mods = { "alpha" } },
        { path = "nvim-notify", mods = { "notify" } },
        { path = "mini.indentscope", mods = { "mini.indentscope" } },
        { path = "heirline-components.nvim", mods = { "heirline-components" } },
        { path = "telescope.nvim", mods = { "telescope" } },
        { path = "telescope-undo.nvim", mods = { "telescope", "telescope-undo" } },
        { path = "telescope-fzf-native.nvim", mods = { "telescope", "fzf_lib"  } },
        { path = "dressing.nvim", mods = { "dressing" } },
        { path = "noice.nvim", mods = { "noice", "telescope" } },
        { path = "nvim-web-devicons", mods = { "nvim-web-devicons" } },
        { path = "lspkind.nvim", mods = { "lspkind" } },
        { path = "nvim-scrollbar", mods = { "scrollbar" } },
        { path = "mini.animate", mods = { "mini.animate" } },
        { path = "highlight-undo.nvim", mods = { "highlight-undo" } },
        { path = "which-key.nvim", mods = { "which-key" } },

        { path = "nvim-treesitter", mods = { "nvim-treesitter" } },
        { path = "nvim-ts-autotag", mods = { "nvim-ts-autotag" } },
        { path = "nvim-treesitter-textobjects", mods = { "nvim-treesitter", "nvim-treesitter-textobjects" } },
        { path = "markdown.nvim", mods = { "render-markdown" } },
        { path = "nvim-highlight-colors", mods = { "nvim-highlight-colors" } },
        { path = "nvim-java", mods = { "java" } },
        { path = "nvim-lspconfig", mods = { "lspconfig" } },
        { path = "mason-lspconfig.nvim", mods = { "mason-lspconfig" } },
        { path = "mason.nvim", mods = { "mason", "mason-core", "mason-registry", "mason-vendor" } },
        { path = "mason-extra-cmds", mods = { "masonextracmds" } },
        { path = "SchemaStore.nvim", mods = { "schemastore" } },
        { path = "none-ls-autoload.nvim", mods = { "none-ls-autoload" } },
        { path = "none-ls.nvim", mods = { "null-ls" } },
        { path = "lazydev.nvim", mods = { "" } },
        { path = "garbage-day.nvim", mods = { "garbage-day" } },
        { path = "nvim-cmp", mods = { "cmp" } },
        { path = "cmp_luasnip", mods = { "cmp_luasnip" } },
        { path = "cmp-buffer", mods = { "cmp_buffer" } },
        { path = "cmp-path", mods = { "cmp_path" } },
        { path = "cmp-nvim-lsp", mods = { "cmp_nvim_lsp" } },

        { path = "LuaSnip", mods = { "luasnip" } },
        { path = "friendly-snippets", mods = { "snippets" } }, -- has vimscript
        { path = "NormalSnippets", mods = { "snippets" } }, -- has vimscript
        { path = "telescope-luasnip.nvim", mods = { "telescop" } },
        { path = "gitsigns.nvim", mods = { "gitsigns" } },
        { path = "vim-fugitive", mods = { "fugitive" } }, -- has vimscript
        { path = "aerial.nvim", mods = { "aerial", "telescope", "lualine", "resession" } },
        { path = "litee.nvim", mods = { "litee" } },
        { path = "litee-calltree.nvim", mods = { "litee" } },
        { path = "dooku.nvim", mods = { "dooku" } },
        { path = "markdown-preview.nvim", mods = { "mkdp" } }, -- has vimscript
        { path = "markmap.nvim", mods = { "markmap" } },
        { path = "neural", mods = { "neural" } },
        { path = "guess-indent.nvim", mods = { "guess-indent" } },
        { path = "compiler.nvim", mods = { "compiler" } },
        { path = "overseer.nvim", mods = { "overseer", "lualine", "neotest", "resession", "cmp_overseer" } },
        { path = "nvim-dap", mods = { "dap" } },
        { path = "nvim-nio", mods = { "nio" } },
        { path = "nvim-dap-ui", mods = { "dapui" } },
        { path = "cmp-dap", mods = { "cmp_dap" } },
        { path = "mason-nvim-dap.nvim", mods = { "mason-nvim-dap" } },

        { path = "one-small-step-for-vimkind", mods = { "osv" } },
        { path = "neotest-dart", mods = { "neotest-dart" } },
        { path = "neotest-dotnet", mods = { "neotest-dotnet" } },
        { path = "neotest-elixir", mods = { "neotest-elixir" } },
        { path = "neotest-golang", mods = { "neotest-golang" } },
        { path = "neotest-java", mods = { "neotest-java" } },
        { path = "neotest-jest", mods = { "neotest-jest" } },
        { path = "neotest-phpunit", mods = { "neotest-phpunit" } },
        { path = "neotest-python", mods = { "neotest-python" } },
        { path = "neotest-rust", mods = { "neotest-rust" } },
        { path = "neotest-zig", mods = { "neotest-zig" } },
        { path = "nvim-coverage.nvim", mods = { "coverage" } },
        { path = "gutentags_plus", mods = { "gutentags_plus" } }, -- has vimscript
        { path = "vim-gutentags", mods = { "vim-gutentags" } }, -- has vimscript

        -- To make it work exactly like neodev, you can add all plugins
        -- without conditions instead like this but it will load slower
        -- on startup and consume ~1 Gb RAM:
        -- vim.fn.stdpath "data" .. "/lazy",

        -- You can also add libs.
        { path = "luvit-meta/library", mods = { "vim%.uv" } },
      }
    end,
    specs = { { "Bilal2453/luvit-meta", lazy = true } },
  },

  --  AUTO COMPLETION --------------------------------------------------------
  --  Auto completion engine [autocompletion engine]
  --  https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim"
    },
    event = "InsertEnter",
    opts = function()
      -- ensure dependencies exist
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind_loaded, lspkind = pcall(require, "lspkind")

      -- border opts
      local border_opts = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }
      local cmp_config_window = (
        vim.g.lsp_round_borders_enabled and cmp.config.window.bordered(border_opts)
      ) or cmp.config.window

      -- helper
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      return {
        enabled = function() -- disable in certain cases on dap.
          local is_prompt = vim.bo.buftype == "prompt"
          local is_dap_prompt = utils.is_available("cmp-dap")
              and vim.tbl_contains(
                { "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype)
          if is_prompt and not is_dap_prompt then
            return false
          else
            return vim.g.cmp_enabled
          end
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = (lspkind_loaded and lspkind.cmp_format(utils.get_plugin_opts("lspkind.nvim"))) or nil
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        duplicates = {
          nvim_lsp = 1,
          lazydev = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp_config_window,
          documentation = cmp_config_window,
        },
        mapping = {
          ["<PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          },
          ["<PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          },
          ["<C-PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<C-PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<S-PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<S-PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<Up>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ["<Down>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ["<C-p>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-n>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-k>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-j>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 1000 },
          { name = "lazydev",  priority = 850 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        },
      }
    end,
  },

}

