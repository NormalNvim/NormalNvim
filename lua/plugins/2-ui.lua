-- User interface
-- Things that make the GUI better.

--    Sections:
--       -> astrotheme                  [theme]
--       -> tokyonight                  [theme]
--       -> alpha-nvim                  [greeter]
--       -> nvim-notify                 [notifications]
--       -> indent-blankline.nvim       [guides]
--       -> heirline                    [statusbar]
--       -> telescope                   [search]
--       -> telescope-fzf-native.nvim   [search backend]
--       -> smart-splits                [window-dimming]
--       -> dressing.nvim               [better ui elements]
--       -> nvim-web-devicons           [icons | ui]
--       -> lspkind.nvim                [icons | lsp]
--       -> nvim-scrollbar              [scrollbar]
--       -> mini.animate                [animations]
--       -> highlight-undo              [highlights]
--       -> which-key                   [on-screen keybinding]

local utils = require "base.utils"

return {
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

  -- tokyonight [theme]
  -- https://github.com/folke/tokyonight.nvim
  {
    "folke/tokyonight.nvim",
    event = "User LoadColorSchemes",
    opts = {
      plugins = { ["dashboard-nvim"] = true },
      dim_inactive = true, -- dims inactive windows

      -- Colors can be overrided
      on_colors = function(colors)
        -- colors.bg_dark = "#16161e" -- Other backgrounds
        -- colors.bg = "#1a1b26" -- Main background color
        -- colors.bg_highlight = "#2f334d" -- Active line background color
        -- colors.terminal_black = "#444a73" -- No idea really
        -- colors.fg = "#c8d3f5" -- UI regular text color (including greeter)
        -- colors.fg_dark = "#828bb8" -- Parentesis and status echo text
        -- colors.fg_gutter = "#3b4261" -- Versical line separators
        -- colors.dark3 = "#545c7e"
        -- colors.comment = "#7a88cf"
        -- colors.dark5 = "#737aa2"
        -- colors.blue0 = "#3e68d7"
        -- colors.blue = "#82aaff"
        -- colors.cyan = "#86e1fc"
        -- colors.blue1 = "#65bcff"
        -- colors.blue2 = "#0db9d7"
        -- colors.blue5 = "#89ddff"
        -- colors.blue6 = "#b4f9f8"
        -- colors.blue7 = "#394b70"
        -- colors.purple = "#fca7ea"
        -- colors.magenta2 = "#ff007c"
        -- colors.magenta = "#c099ff"
        -- colors.orange = "#ff966c"
        -- colors.yellow = "#ffc777"
        -- colors.green = "#c3e88d"
        -- colors.green1 = "#4fd6be"
        -- colors.green2 = "#41a6b5"
        -- colors.teal = "#4fd6be"
        -- colors.red = "#ff757f"
        -- colors.red1 = "#c53b53"

        -- colorcolumn (80 col separator)
        --vim.cmd "hi colorcolumn guibg='#000000'"

        -- -- GIT + GITSIGN
        -- colors.git =
        --   { change = "#6183bb", add = "#449dab", delete = "#914c54" }
        -- colors.gitSigns = {
        --   add = "#266d6a",
        --   change = "#536c9e",
        --   delete = "#b2555b",
        -- }
        --
        -- -- DIFF
        -- colors.diff = {
        --   add = util.darken(colors.green2, 0.15),
        --   delete = util.darken(colors.red1, 0.15),
        --   change = util.darken(colors.blue7, 0.15),
        --   text = colors.blue7,
        -- }
        --
        -- -- POPUP AND STPOPUP AND STATUS BG
        -- colors.bg_popup = colors.bg_dark
        -- colors.bg_statusline = colors.bg_dark
        --
        -- -- SEARCH AND VISUAL SELECTION FROM A LIST BG
        -- -- colors.bg_visual = util.darken(colors.blue0, 0.4) -- bg when you select stuff from a list of elements
        -- colors.bg_search = colors.blue0
        --
        -- -- SIDEBAR
        -- colors.fg_sidebar = colors.fg_dark -- Sidebar and status bar text color
        -- colors.bg_sidebar = config.options.styles.sidebars == "transparent"
        --     and colors.none
        --   or config.options.styles.sidebars == "dark" and colors.bg_dark
        --   or colors.bg
        --
        -- -- FLOAT
        -- colors.fg_float = colors.fg
        -- colors.bg_float = config.options.styles.floats == "transparent"
        --     and colors.none
        --   or config.options.styles.floats == "dark" and colors.bg_dark
        --   or colors.bg

        -- ERRORS
        -- colors.error = colors.red1
        -- colors.warning = colors.yellow
        -- colors.info = colors.blue2
        -- colors.hint = colors.teal

        -- DELTA
        -- Colors when delta is enablet
        -- colors.delta = {
        --   add = util.darken(colors.green2, 0.45),
        --   delete = util.darken(colors.red1, 0.45),
        -- }
      end,
    },
  },

  --  alpha-nvim [greeter]
  --  https://github.com/goolord/alpha-nvim
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    -- setup header and buttonts
    opts = function()
      local dashboard = require "alpha.themes.dashboard"

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
      -- dashboard.section.header.val = {
      --   [[                __                ]],
      --   [[  ___   __  __ /\_\    ___ ___    ]],
      --   [[/' _ `\/\ \/\ \\/\ \ /' __` __`\  ]],
      --   [[/\ \/\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
      --   [[\ \_\ \_\ \___/  \ \_\ \_\ \_\ \_\]],
      --   [[ \/_/\/_/\/__/    \/_/\/_/\/_/\/_/]],
      -- }
      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }

      dashboard.section.header.opts.hl = "DashboardHeader"
      vim.cmd "highlight DashboardHeader guifg=#F7778F"

      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("n", "📄 New     ", "<cmd>ene<CR>"),
        dashboard.button("e", "🌺 Recent  ", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("r", "🐍 Ranger  ", "<cmd>RnvimrToggle<CR>"),
        dashboard.button(
          "s",
          "🔎 Sessions",
          "<cmd>SessionManager! load_session<CR>"
        ),
        dashboard.button("p", "💼 Projects", "<cmd>Telescope projects<CR>"),
        dashboard.button("", ""),
        dashboard.button("q", "   Quit", "<cmd>exit<CR>"),
        --  --button("LDR f '", "  Bookmarks  "),
      }

      ---- Vertical margins
      dashboard.config.layout[1].val =
          vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above header
      dashboard.config.layout[3].val =
          vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above buttons

      -- Disablel autocmd and return
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
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          opts.section.footer.val = {
            " ",
            " ",
            " ",
            "Loaded " .. stats.count .. " plugins  in " .. ms .. "ms",
            "..............................",
          }
          opts.section.footer.opts.hl = "DashboardFooter"
          vim.cmd "highlight DashboardFooter guifg=#D29B68"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  --  [notifications]
  --  https://github.com/rcarriga/nvim-notify
  {
    "rcarriga/nvim-notify",
    init = function()
      require("base.utils").load_plugin_with_func("nvim-notify", vim, "notify")
    end,
    opts = {
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 1000 })
      end,
    },
    config = function(_, opts)
      local notify = require "notify"
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  -- Telescope integration (:Telescope notify)
  {
    "nvim-telescope/telescope.nvim",
    dependency = { "rcarriga/nvim-notify" },
    cmd = "Telescope notify",
    opts = function() require("telescope").load_extension "notify" end,
  },

  --  Code identation [guides]
  --  https://github.com/lukas-reineke/indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User BaseFile",
    opts = {
      buftype_exclude = {
        "nofile",
        "terminal",
      },
      filetype_exclude = {
        "help",
        "startify",
        "aerial",
        "alpha",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
        "ranger",
        "rnvimr",
      },
      context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      },
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      char = "▏",
      context_char = "▏",
      show_current_context = true,
    },
  },

  --  [statusbar]
  --  https://github.com/rebelot/heirline.nvim
  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    opts = function()
      local status = require "base.utils.status"
      return {
        opts = {
          -- Disable the winbar for the next special buffers
          disable_winbar_cb = function(args)
            return not require("base.utils.buffer").is_valid(args.buf)
                or status.condition.buffer_matches({
                  buftype = {
                    "terminal",
                    "prompt",
                    "nofile",
                    "help",
                    "quickfix",
                  },
                  filetype = {
                    "NvimTree",
                    "neo%-tree",
                    "dashboard",
                    "Outline",
                    "aerial",
                  },
                }, args.buf)
          end,
        },
        statusline = {
                       -- statusline
          hl = { fg = "fg", bg = "bg" },
          status.component.mode(),
          status.component.git_branch(),
          status.component.file_info {
            filetype = {},
            filename = false,
            file_modified = false,
          },
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          status.component.treesitter(),
          status.component.nav(),
          status.component.mode { surround = { separator = "right" } },
        },
        winbar = {
                   -- winbar
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          {
            condition = function()
              return not status.condition.is_active() -- Condition to show breadcrumrs
            end,
            status.component.separated_path(),
            -- Comment the block below to hide the breadcrumbs while unfocused.
            -- But you won't know the buffer name then while unfocused.
            -- This is specially important as we currently use a single status bar.
            status.component.file_info {
              file_icon = {
                hl = status.hl.file_icon "winbar",
                padding = { left = 0 },
              },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbarnc", true),
              surround = false,
              update = "BufEnter",
            },
          },
          status.component.breadcrumbs {
            hl = status.hl.get_attributes("winbar", true),
          },
        },
        tabline = { -- bufferline
          {
                    -- file tree padding
            condition = function(self)
              self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
              return status.condition.buffer_matches(
                { filetype = { "aerial", "dapui_.", "neo%-tree", "NvimTree" } },
                vim.api.nvim_win_get_buf(self.winid)
              )
            end,
            provider = function(self)
              return string.rep(
                " ",
                vim.api.nvim_win_get_width(self.winid) + 1
              )
            end,
            hl = { bg = "tabline_bg" },
          },
          -- component for each buffer tab
          status.heirline.make_buflist(status.component.tabline_file_info()),
          -- fill the rest of the tabline with background color
          status.component.fill { hl = { bg = "tabline_bg" } },
          {
            -- tab list
            -- only show tabs if there are more than one
            condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
            status.heirline.make_tablist { -- component for each tab
              provider = status.provider.tabnr(),
              hl = function(self)
                return status.hl.get_attributes(
                  status.heirline.tab_type(self, "tab"),
                  true
                )
              end,
            },
            {
              -- close button for current tab
              provider = status.provider.close_button {
                kind = "TabClose",
                padding = { left = 1, right = 1 },
              },
              hl = status.hl.get_attributes("tab_close", true),
              on_click = {
                callback = function() require("base.utils.buffer").close_tab() end,
                name = "heirline_tabline_close_tab_callback",
              },
            },
          },
        },
        statuscolumn = vim.fn.has "nvim-0.9" == 1 and {
          status.component.foldcolumn(),
          status.component.fill(),
          status.component.numbercolumn(),
          status.component.signcolumn(),
        } or nil,
      }
    end,
    config = function(_, opts)
      local heirline = require "heirline"
      local hl = require "base.utils.status.hl"
      local C = require("base.utils.status.env").fallback_colors
      local get_hlgroup = require("base.utils").get_hlgroup

      local function setup_colors()
        local Normal = get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
        local Comment =
            get_hlgroup("Comment", { fg = C.bright_grey, bg = C.bg })
        local Error = get_hlgroup("Error", { fg = C.red, bg = C.bg })
        local StatusLine =
            get_hlgroup("StatusLine", { fg = C.fg, bg = C.dark_bg })
        local TabLine = get_hlgroup("TabLine", { fg = C.grey, bg = C.none })
        local TabLineFill =
            get_hlgroup("TabLineFill", { fg = C.fg, bg = C.dark_bg })
        local TabLineSel =
            get_hlgroup("TabLineSel", { fg = C.fg, bg = C.none })
        local WinBar = get_hlgroup("WinBar", { fg = C.bright_grey, bg = C.bg })
        local WinBarNC = get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
        local Conditional =
            get_hlgroup("Conditional", { fg = C.bright_purple, bg = C.dark_bg })
        local String = get_hlgroup("String", { fg = C.green, bg = C.dark_bg })
        local TypeDef =
            get_hlgroup("TypeDef", { fg = C.yellow, bg = C.dark_bg })
        local GitSignsAdd =
            get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.dark_bg })
        local GitSignsChange =
            get_hlgroup("GitSignsChange", { fg = C.orange, bg = C.dark_bg })
        local GitSignsDelete =
            get_hlgroup("GitSignsDelete", { fg = C.bright_red, bg = C.dark_bg })
        local DiagnosticError =
            get_hlgroup("DiagnosticError", { fg = C.bright_red, bg = C.dark_bg })
        local DiagnosticWarn =
            get_hlgroup("DiagnosticWarn", { fg = C.orange, bg = C.dark_bg })
        local DiagnosticInfo =
            get_hlgroup("DiagnosticInfo", { fg = C.white, bg = C.dark_bg })
        local DiagnosticHint = get_hlgroup(
          "DiagnosticHint",
          { fg = C.bright_yellow, bg = C.dark_bg }
        )
        local HeirlineInactive = get_hlgroup("HeirlineInactive", { bg = nil }).bg
            or hl.lualine_mode("inactive", C.dark_grey)
        local HeirlineNormal = get_hlgroup("HeirlineNormal", { bg = nil }).bg
            or hl.lualine_mode("normal", C.blue)
        local HeirlineInsert = get_hlgroup("HeirlineInsert", { bg = nil }).bg
            or hl.lualine_mode("insert", C.green)
        local HeirlineVisual = get_hlgroup("HeirlineVisual", { bg = nil }).bg
            or hl.lualine_mode("visual", C.purple)
        local HeirlineReplace = get_hlgroup("HeirlineReplace", { bg = nil }).bg
            or hl.lualine_mode("replace", C.bright_red)
        local HeirlineCommand = get_hlgroup("HeirlineCommand", { bg = nil }).bg
            or hl.lualine_mode("command", C.bright_yellow)
        local HeirlineTerminal = get_hlgroup("HeirlineTerminal", { bg = nil }).bg
            or hl.lualine_mode("insert", HeirlineInsert)

        local colors = {
          close_fg = Error.fg,
          fg = StatusLine.fg,
          bg = StatusLine.bg,
          section_fg = StatusLine.fg,
          section_bg = StatusLine.bg,
          git_branch_fg = Conditional.fg,
          mode_fg = StatusLine.bg,
          treesitter_fg = String.fg,
          scrollbar = TypeDef.fg,
          git_added = GitSignsAdd.fg,
          git_changed = GitSignsChange.fg,
          git_removed = GitSignsDelete.fg,
          diag_ERROR = DiagnosticError.fg,
          diag_WARN = DiagnosticWarn.fg,
          diag_INFO = DiagnosticInfo.fg,
          diag_HINT = DiagnosticHint.fg,
          winbar_fg = WinBar.fg,
          winbar_bg = WinBar.bg,
          winbarnc_fg = WinBarNC.fg,
          winbarnc_bg = WinBarNC.bg,
          tabline_bg = TabLineFill.bg,
          tabline_fg = TabLineFill.bg,
          buffer_fg = Comment.fg,
          buffer_path_fg = WinBarNC.fg,
          buffer_close_fg = Comment.fg,
          buffer_bg = TabLineFill.bg,
          buffer_active_fg = Normal.fg,
          buffer_active_path_fg = WinBarNC.fg,
          buffer_active_close_fg = Error.fg,
          buffer_active_bg = Normal.bg,
          buffer_visible_fg = Normal.fg,
          buffer_visible_path_fg = WinBarNC.fg,
          buffer_visible_close_fg = Error.fg,
          buffer_visible_bg = Normal.bg,
          buffer_overflow_fg = Comment.fg,
          buffer_overflow_bg = TabLineFill.bg,
          buffer_picker_fg = Error.fg,
          tab_close_fg = Error.fg,
          tab_close_bg = TabLineFill.bg,
          tab_fg = TabLine.fg,
          tab_bg = TabLine.bg,
          tab_active_fg = TabLineSel.fg,
          tab_active_bg = TabLineSel.bg,
          inactive = HeirlineInactive,
          normal = HeirlineNormal,
          insert = HeirlineInsert,
          visual = HeirlineVisual,
          replace = HeirlineReplace,
          command = HeirlineCommand,
          terminal = HeirlineTerminal,
        }

        for _, section in ipairs {
          "git_branch",
          "file_info",
          "git_diff",
          "diagnostics",
          "lsp",
          "macro_recording",
          "mode",
          "cmd_info",
          "treesitter",
          "nav",
        } do
          if not colors[section .. "_bg"] then
            colors[section .. "_bg"] = colors["section_bg"]
          end
          if not colors[section .. "_fg"] then
            colors[section .. "_fg"] = colors["section_fg"]
          end
        end
        return colors
      end

      heirline.load_colors(setup_colors())
      heirline.setup(opts)

      local augroup = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = augroup,
        desc = "Refresh heirline colors",
        callback = function()
          require("heirline.utils").on_colorscheme(setup_colors())
        end,
      })
    end,
  },

  --  Telescope [search] + [search backend] dependency
  --  https://github.com/nvim-telescope/telescope.nvim
  --  https://github.com/nvim-telescope/telescope-fzf-native.nvim
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = vim.fn.executable "make" == 1,
        build = "make",
      },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require "telescope.actions"
      local get_icon = require("base.utils").get_icon
      local mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<ESC>"] = actions.close,
          ["<C-c>"] = false,
        },
        n = { ["q"] = actions.close },
      }
      return {
        defaults = {
          prompt_prefix = get_icon("Selected", 1),
          selection_caret = get_icon("Selected", 1),
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
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
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      local utils = require "base.utils"
      local conditional_func = utils.conditional_func
      conditional_func(
        telescope.load_extension,
        utils.is_available "telescope-fzf-native.nvim",
        "fzf"
      )
    end,
  },

  --  [better ui elements]
  --  https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    init = function()
      require("base.utils").load_plugin_with_func(
        "dressing.nvim",
        vim.ui,
        { "input", "select" }
      )
    end,
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
      select = {
        backend = { "telescope", "builtin" },
        builtin = {
          win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
        },
      },
    },
  },

  --  UI icons [icons]
  --  https://github.com/nvim-tree/nvim-web-devicons
  {
    "nvim-tree/nvim-web-devicons",
    enabled = vim.g.icons_enabled,
    opts = {
      override = {
        default_icon = { icon = require("base.utils").get_icon "DefaultFile" },
        deb = { icon = "", name = "Deb" },
        lock = { icon = "󰌾", name = "Lock" },
        mp3 = { icon = "󰎆", name = "Mp3" },
        mp4 = { icon = "", name = "Mp4" },
        out = { icon = "", name = "Out" },
        ["robots.txt"] = { icon = "󰚩", name = "Robots" },
        ttf = { icon = "", name = "TrueTypeFont" },
        rpm = { icon = "", name = "Rpm" },
        woff = { icon = "", name = "WebOpenFontFormat" },
        woff2 = { icon = "", name = "WebOpenFontFormat2" },
        xz = { icon = "", name = "Xz" },
        zip = { icon = "", name = "Zip" },
      },
    },
  },

  --  LSP icons [icons]
  --  https://github.com/onsails/lspkind.nvim
  {
    "onsails/lspkind.nvim",
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
    },
    enabled = vim.g.icons_enabled,
    config = function(_, opts)
      base.lspkind = opts
      require("lspkind").init(opts)
    end,
  },

  --  nvim-scrollbar [scrollbar]
  --  https://github.com/petertriho/nvim-scrollbar
  {
    "petertriho/nvim-scrollbar",
    opts = {
      handlers = {
        gitsigns = true, -- gitsigns integration (display hunks)
        ale = true,      -- lsp integration (display errors/warnings)
        search = false,  -- hlslens integration (display search result)
      },
    },
    event = "User BaseFile",
  },

  --  mini.animate [animations]
  --  https://github.com/echasnovski/mini.animate
  --  HINT: if one of your personal keymappings fail due to mini.animate, try to
  --        disable it during the keybinding using vim.g.minianimate_disable = true
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    -- enabled = false,
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

      local animate = require "mini.animate"
      return {
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
  --  BUG: Currently only works for redo.
  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    opts = {
      hlgroup = "CurSearch",
      duration = 150,
      keymaps = {
        { "n", "u",     "undo", {} }, -- If you remap undo/redo, change this
        { "n", "<C-r>", "redo", {} },
      },
    },
    config = function(_, opts) require("highlight-undo").setup(opts) end,
  },

  --  [on-screen keybindings]
  --  https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
      disable = { filetypes = { "TelescopePrompt" } },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
      require("base.utils").which_key_register()
    end,
  },
}
