-- User interface
-- Plugins that make the user interface better.

--    Sections:
--       -> tokyonight                  [theme]
--       -> astrotheme                  [theme]
--       -> alpha-nvim                  [greeter]
--       -> nvim-notify                 [notifications]
--       -> mini.indentscope            [guides]
--       -> heirline-components.nvim    [ui components]
--       -> heirline                    [ui components]
--       -> telescope                   [search]
--       -> telescope-fzf-native.nvim   [search backend]
--       -> dressing.nvim               [better ui elements]
--       -> noice.nvim                  [better cmd/search line]
--       -> nvim-web-devicons           [icons | ui]
--       -> lspkind.nvim                [icons | lsp]
--       -> nvim-scrollbar              [scrollbar]
--       -> mini.animate                [animations]
--       -> highlight-undo              [highlights]
--       -> which-key                   [on-screen keybinding]

local utils = require("base.utils")
local is_windows = vim.fn.has('win32') == 1         -- true if on windows
local is_android = vim.fn.isdirectory('/data') == 1 -- true if on android

return {

  --  tokyonight [theme]
  --  https://github.com/folke/tokyonight.nvim
  {
    "folke/tokyonight.nvim",
    event = "User LoadColorSchemes",
    opts = {
      dim_inactive = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    }
  },

  --  astrotheme [theme]
  --  https://github.com/AstroNvim/astrotheme
  {
    "AstroNvim/astrotheme",
    event = "User LoadColorSchemes",
    opts = {
      palette = "astrodark",
      plugins = { ["dashboard-nvim"] = true },
    },
  },

  --  alpha-nvim [greeter]
  --  https://github.com/goolord/alpha-nvim
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    -- setup header and buttonts
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      -- Header
      -- dashboard.section.header.val = {
      --   "                                                                     ",
      --   "       ████ ██████           █████      ██                     ",
      --   "      ███████████             █████                             ",
      --   "      █████████ ███████████████████ ███   ███████████   ",
      --   "     █████████  ███    █████████████ █████ ██████████████   ",
      --   "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
      --   "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
      --   " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
      -- }
      -- dashboard.section.header.val = {
      --   '                                        ▟▙            ',
      --   '                                        ▝▘            ',
      --   '██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
      --   '██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██',
      --   '██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██',
      --   '██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██',
      --   '▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
      -- }
      -- dashboard.section.header.val = {
      --   '                    ▟▙            ',
      --   '                    ▝▘            ',
      --   '██▃▅▇█▆▖  ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
      --   '██▛▔ ▝██  ▝██  ██▘  ██  ██▛▜██▛▜██',
      --   '██    ██   ▜█▙▟█▛   ██  ██  ██  ██',
      --   '██    ██   ▝████▘   ██  ██  ██  ██',
      --   '▀▀    ▀▀     ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
      -- }
      -- Generated with https://www.fancytextpro.com/BigTextGenerator/Larry3D
      -- dashboard.section.header.val = {
      --   [[ __  __                  __  __                     ]],
      --   [[/\ \/\ \                /\ \/\ \  __                ]],
      --   [[\ \ `\\ \     __    ___ \ \ \ \ \/\_\    ___ ___    ]],
      --   [[ \ \ , ` \  /'__`\ / __`\\ \ \ \ \/\ \ /' __` __`\  ]],
      --   [[  \ \ \`\ \/\  __//\ \L\ \\ \ \_/ \ \ \/\ \/\ \/\ \ ]],
      --   [[   \ \_\ \_\ \____\ \____/ \ `\___/\ \_\ \_\ \_\ \_\]],
      --   [[    \/_/\/_/\/____/\/___/   `\/__/  \/_/\/_/\/_/\/_/]],
      -- }
      --  dashboard.section.header.val = {
      --   '                                                     ',
      --   '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      --   '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      --   '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      --   '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      --   '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      --   '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      --   '                                                     ',
      -- }
      -- dashboard.section.header.val = {
      --   [[                __                ]],
      --   [[  ___   __  __ /\_\    ___ ___    ]],
      --   [[/' _ `\/\ \/\ \\/\ \ /' __` __`\  ]],
      --   [[/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
      --   [[\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
      --   [[ \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
      -- }

      if is_android then
        dashboard.section.header.val = {
          [[         __                ]],
          [[ __  __ /\_\    ___ ___    ]],
          [[/\ \/\ \\/\ \ /' __` __`\  ]],
          [[\ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
          [[ \ \___/  \ \_\ \_\ \_\ \_\]],
          [[  \/__/    \/_/\/_/\/_/\/_/]],
        }
      else
        dashboard.section.header.val = {
          [[888b      88                                                           88]],
          [[8888b     88                                                           88]],
          [[88 `8b    88                                                           88]],
          [[88  `8b   88   ,adPPYba,   8b,dPPYba,  88,dPYba,,adPYba,   ,adPPYYba,  88]],
          [[88   `8b  88  a8"     "8a  88P'   "Y8  88P'   "88"    "8a  ""     `Y8  88]],
          [[88    `8b 88  8b       d8  88          88      88      88  ,adPPPPP88  88]],
          [[88     `8888  "8a,   ,a8"  88          88      88      88  88,    ,88  88]],
          [[88      `888   `"YbbdP"'   88          88      88      88  `"8bbdP"Y8  88]],
          [[                                    __                ]],
          [[                      ___   __  __ /\_\    ___ ___    ]],
          [[                    /' _ `\/\ \/\ \\/\ \ /' __` __`\  ]],
          [[                    /\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
          [[                    \ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
          [[                     \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
        }
      end


      local get_icon = require("base.utils").get_icon

      dashboard.section.header.opts.hl = "DashboardHeader"
      vim.cmd("highlight DashboardHeader guifg=#F7778F")

      -- If yazi is not installed, don't show the button.
      local is_yazi_installed = vim.fn.executable("ya") == 1
      local yazi_button = dashboard.button("r", get_icon("GreeterYazi") .. " Yazi", "<cmd>Yazi<CR>")
      if not is_yazi_installed then yazi_button = nil end

      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("n",
          get_icon("GreeterNew") .. " New",
          "<cmd>ene<CR>"),
        dashboard.button("e",
          get_icon("GreeterRecent") .. " Recent  ",
          "<cmd>Telescope oldfiles<CR>"),
        yazi_button,
        dashboard.button("s",
          get_icon("GreeterSessions") .. " Sessions",
          "<cmd>SessionManager! load_session<CR>"
        ),
        dashboard.button("p",
          get_icon("GreeterProjects") .. " Projects",
          "<cmd>Telescope projects<CR>"),
        dashboard.button("", ""),
        dashboard.button("q", "   Quit", "<cmd>exit<CR>"),
      }

      -- Vertical margins
      dashboard.config.layout[1].val =
          vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above header
      dashboard.config.layout[3].val =
          vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above buttons

      -- Disable autocmd and return
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = function(_, opts)
      -- Footer
      require("alpha").setup(opts.config)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        desc = "Add Alpha dashboard footer",
        once = true,
        callback = function()
          local  footer_icon = require("base.utils").get_icon("GreeterPlug")
          local stats = require("lazy").stats()
          stats.real_cputime = not is_windows
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          opts.section.footer.val = {
            " ",
            " ",
            " ",
            "Loaded " .. stats.loaded .. " plugins " .. footer_icon .. " in " .. ms .. "ms",
            ".............................",
          }
          opts.section.footer.opts.hl = "DashboardFooter"
          vim.cmd("highlight DashboardFooter guifg=#D29B68")
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  --  [notifications]
  --  https://github.com/rcarriga/nvim-notify
  {
    "rcarriga/nvim-notify",
    event = "User BaseDefered",
    opts = function()
      local fps
      if is_android then fps = 30 else fps = 144 end

      return {
        timeout = 2500,
        fps = fps,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.75) end,
        on_open = function(win)
          -- enable markdown support on notifications
          vim.api.nvim_win_set_config(win, { zindex = 175 })
          if not vim.g.notifications_enabled then
            vim.api.nvim_win_close(win, true)
          end
          if not package.loaded["nvim-treesitter"] then
            pcall(require, "nvim-treesitter")
          end
          vim.wo[win].conceallevel = 3
          local buf = vim.api.nvim_win_get_buf(win)
          if not pcall(vim.treesitter.start, buf, "markdown") then
            vim.bo[buf].syntax = "markdown"
          end
          vim.wo[win].spell = false
        end,
      }
    end,
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  --  mini.indentscope [guides]
  --  https://github.com/echasnovski/mini.indentscope
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      draw = { delay = 0, animation = function() return 0 end },
      options = { border = "top", try_as_border = true },
      symbol = "▏",
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)

      -- Disable for certain filetypes
      vim.api.nvim_create_autocmd({ "FileType" }, {
        desc = "Disable indentscope for certain filetypes",
        callback = function()
          local ignored_filetypes = {
            "aerial",
            "dashboard",
            "help",
            "lazy",
            "leetcode.nvim",
            "mason",
            "neo-tree",
            "NvimTree",
            "neogitstatus",
            "notify",
            "startify",
            "toggleterm",
            "Trouble",
            "calltree",
            "coverage"
          }
          if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end
  },

  -- heirline-components.nvim [ui components]
  -- https://github.com/zeioth/heirline-components.nvim
  -- Collection of components to use on your heirline config.
  {
    "zeioth/heirline-components.nvim",
    opts = function()
      -- return different items depending of the value of `vim.g.fallback_icons_enabled`
      local function get_icons()
        if vim.g.fallback_icons_enabled then
          return require("base.icons.fallback_icons")
        else
          return require("base.icons.icons")
        end
      end

      -- opts
      return {
        icons = get_icons(),
      }
    end
  },

  --  heirline [ui components]
  --  https://github.com/rebelot/heirline.nvim
  --  Use it to customize the components of your user interface,
  --  Including tabline, winbar, statuscolumn, statusline.
  --  Be aware some components are positional. Read heirline documentation.
  {
    "rebelot/heirline.nvim",
    dependencies = { "zeioth/heirline-components.nvim" },
    event = "User BaseDefered",
    opts = function()
      local lib = require("heirline-components.all")
      return {
        opts = {
          disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
            local is_disabled = not require("heirline-components.buffer").is_valid(args.buf) or
                lib.condition.buffer_matches({
                  buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                  filetype = {
                    "NvimTree",
                    "neo%-tree",
                    "dashboard",
                    "Outline",
                    "aerial",
                    "rnvimr",
                    "yazi"
                  },
                }, args.buf)
            return is_disabled
          end,
        },
        tabline = { -- UI upper bar
          lib.component.tabline_conditional_padding(),
          lib.component.tabline_buffers(),
          lib.component.fill { hl = { bg = "tabline_bg" } },
          lib.component.tabline_tabpages()
        },
        winbar = { -- UI breadcrumbs bar
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          -- Winbar for terminal, neotree, and aerial.
          {
            condition = function() return not lib.condition.is_active() end,
            {
              lib.component.neotree(),
              lib.component.compiler_play(),
              lib.component.fill(),
              lib.component.compiler_redo(),
              lib.component.aerial(),
            },
          },
          -- Regular winbar
          {
            lib.component.neotree(),
            lib.component.compiler_play(),
            lib.component.fill(),
            lib.component.breadcrumbs(),
            lib.component.fill(),
            lib.component.compiler_redo(),
            lib.component.aerial(),
          }
        },
        statuscolumn = { -- UI left column
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        } or nil,
        statusline = { -- UI statusbar
          hl = { fg = "fg", bg = "bg" },
          lib.component.mode(),
          lib.component.git_branch(),
          lib.component.file_info(),
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          lib.component.lsp(),
          lib.component.compiler_state(),
          lib.component.virtual_env(),
          lib.component.nav(),
          lib.component.mode { surround = { separator = "right" } },
        },
      }
    end,
    config = function(_, opts)
      local heirline = require("heirline")
      local heirline_components = require "heirline-components.all"

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },

  --  Telescope [search] + [search backend] dependency
  --  https://github.com/nvim-telescope/telescope.nvim
  --  https://github.com/nvim-telescope/telescope-fzf-native.nvim
  --  https://github.com/debugloop/telescope-undo.nvim
  --  NOTE: Normally, plugins that depend on Telescope are defined separately.
  --  But its Telescope extension is added in the Telescope 'config' section.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "debugloop/telescope-undo.nvim",
        cmd = "Telescope",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = vim.fn.executable("make") == 1,
        build = "make",
      },
    },
    cmd = "Telescope",
    opts = function()
      local get_icon = require("base.utils").get_icon
      local actions = require("telescope.actions")
      local mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<ESC>"] = actions.close,
          ["<C-c>"] = false,
        },
        n = { ["q"] = actions.close },
      }
      return {
        defaults = {
          prompt_prefix = get_icon("PromptPrefix") .. " ",
          selection_caret = get_icon("PromptPrefix") .. " ",
          multi_icon = get_icon("PromptPrefix") .. " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.50,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = mappings,
        },
        extensions = {
          undo = {
            use_delta = true,
            side_by_side = true,
            vim_diff_opts = { ctxlen = 0 },
            entry_format = "󰣜 #$ID, $STAT, $TIME",
            layout_strategy = "horizontal",
            layout_config = {
              preview_width = 0.65,
            },
            mappings = {
              i = {
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<C-cr>"] = require("telescope-undo.actions").restore,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- Here we define the Telescope extension for all plugins.
      -- If you delete a plugin, you can also delete its Telescope extension.
      if utils.is_available("nvim-notify") then telescope.load_extension("notify") end
      if utils.is_available("telescope-fzf-native.nvim") then telescope.load_extension("fzf") end
      if utils.is_available("telescope-undo.nvim") then telescope.load_extension("undo") end
      if utils.is_available("project.nvim") then telescope.load_extension("projects") end
      if utils.is_available("LuaSnip") then telescope.load_extension("luasnip") end
      if utils.is_available("aerial.nvim") then telescope.load_extension("aerial") end
      if utils.is_available("nvim-neoclip.lua") then
        telescope.load_extension("neoclip")
        telescope.load_extension("macroscope")
      end
    end,
  },

  --  [better ui elements]
  --  https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    event = "User BaseDefered",
    opts = {
      input = { default_prompt = "➤ " },
      select = { backend = { "telescope", "builtin" } },
    }
  },

  --  Noice.nvim [better cmd/search line]
  --  https://github.com/folke/noice.nvim
  --  We use it for:
  --  * cmdline: Display treesitter for :
  --  * search: Display a magnifier instead of /
  --
  --  We don't use it for:
  --  * LSP status: We use a heirline component for this.
  --  * Search results: We use a heirline component for this.
  {
    "folke/noice.nvim",
    event = "User BaseDefered",
    opts = function()
      local enable_conceal = false          -- Hide command text if true
      return {
        presets = { bottom_search = true }, -- The kind of popup used for /
        cmdline = {
          view = "cmdline",                 -- The kind of popup used for :
          format = {
            cmdline = { conceal = enable_conceal },
            search_down = { conceal = enable_conceal },
            search_up = { conceal = enable_conceal },
            filter = { conceal = enable_conceal },
            lua = { conceal = enable_conceal },
            help = { conceal = enable_conceal },
            input = { conceal = enable_conceal },
          }
        },

        -- Disable every other noice feature
        messages = { enabled = false },
        lsp = {
          hover = { enabled = false },
          signature = { enabled = false },
          progress = { enabled = false },
          message = { enabled = false },
          smart_move = { enabled = false },
        },
      }
    end
  },

  --  UI icons [icons]
  --  https://github.com/nvim-tree/nvim-web-devicons
  {
    "nvim-tree/nvim-web-devicons",
    enabled = not vim.g.fallback_icons_enabled,
    event = "User BaseDefered",
    opts = {
      override = {
        default_icon = {
          icon = require("base.utils").get_icon("DefaultFile")
        },
      },
    },
  },

  --  LSP icons [icons]
  --  https://github.com/onsails/lspkind.nvim
  {
    "onsails/lspkind.nvim",
    enabled = not vim.g.fallback_icons_enabled,
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
      },
      menu = {},
    },
    config = function(_, opts)
      require("lspkind").init(opts)
    end,
  },

  --  nvim-scrollbar [scrollbar]
  --  https://github.com/petertriho/nvim-scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "User BaseFile",
    opts = {
      handlers = {
        gitsigns = true, -- gitsigns integration (display hunks)
        ale = true,      -- lsp integration (display errors/warnings)
        search = false,  -- hlslens integration (display search result)
      },
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "alpha"
      },
    },
  },

  --  mini.animate [animations]
  --  https://github.com/echasnovski/mini.animate
  --  HINT: if one of your personal keymappings fail due to mini.animate, try to
  --        disable it during the keybinding using vim.g.minianimate_disable = true
  {
    "echasnovski/mini.animate",
    event = "User BaseFile",
    enabled = not is_android,
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { "Up", "Down" } do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        open = { enable = false }, -- true causes issues on nvim-spectre
        resize = {
          timing = animate.gen_timing.linear { duration = 33, unit = "total" },
        },
        scroll = {
          timing = animate.gen_timing.linear { duration = 50, unit = "total" },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          },
        },
        cursor = {
          enable = false, -- We don't want cursor ghosting
          timing = animate.gen_timing.linear { duration = 26, unit = "total" },
        },
      }
    end,
  },

  --  highlight-undo
  --  https://github.com/tzachar/highlight-undo.nvim
  --  This plugin only flases on undo/redo.
  --  But we also have a autocmd to flash on yank.
  {
    "tzachar/highlight-undo.nvim",
    event = "User BaseDefered",
    opts = {
      duration = 150,
      hlgroup = "IncSearch",
    },
    config = function(_, opts)
      require("highlight-undo").setup(opts)

      -- Also flash on yank.
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight yanked text",
        pattern = "*",
        callback = function()
          (vim.hl or vim.highlight).on_yank()
        end,
      })
    end,
  },

  --  which-key.nvim [on-screen keybindings]
  --  https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "User BaseDefered",

    opts_extend = { "disable.ft", "disable.bt" },
    opts = {
      preset = "classic", -- "classic", "modern", or "helix"
      icons = {
        group = (vim.g.fallback_icons_enabled and "+") or "",
        rules = false,
        separator = "-",
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
      require("base.utils").which_key_register()
    end,
  },


} -- end of return
