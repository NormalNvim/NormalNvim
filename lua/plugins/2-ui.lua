-- User interface
-- Things that make the GUI better.

--    Sections:
--       -> tokyonight                  [theme]
--       -> astrotheme                  [theme]
--       -> alpha-nvim                  [greeter]
--       -> nvim-notify                 [notifications]
--       -> mini.indentscope            [guides]
--       -> heirline                    [statusbar]
--       -> telescope                   [search]
--       -> telescope-fzf-native.nvim   [search backend]
--       -> smart-splits                [window-dimming]
--       -> dressing.nvim               [better ui elements]
--       -> noice.nvim                  [better cmd/search line]
--       -> nvim-web-devicons           [icons | ui]
--       -> lspkind.nvim                [icons | lsp]
--       -> nvim-scrollbar              [scrollbar]
--       -> mini.animate                [animations]
--       -> highlight-undo              [highlights]
--       -> which-key                   [on-screen keybinding]

local utils = require "base.utils"
local windows = vim.fn.has('win32') == 1             -- true if on windows
local android = vim.fn.isdirectory('/system') == 1   -- true if on android

return {

  -- tokyonight [theme]
  -- https://github.com/folke/tokyonight.nvim
  {
    "Zeioth/tokyonight.nvim",
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

      if android then dashboard.section.header.val = {
        [[         __                ]],
        [[ __  __ /\_\    ___ ___    ]],
        [[/\ \/\ \\/\ \ /' __` __`\  ]],
        [[\ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[ \ \___/  \ \_\ \_\ \_\ \_\]],
        [[  \/__/    \/_/\/_/\/_/\/_/]],
       }
      else dashboard.section.header.val = {
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

      dashboard.section.header.opts.hl = "DashboardHeader"
      vim.cmd "highlight DashboardHeader guifg=#F7778F"

      -- If on windows, don't show the 'ranger' button
      local ranger_button = dashboard.button("r", "🐍 Ranger  ", "<cmd>RnvimrToggle<CR>")
      if windows then ranger_button = nil end

      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("n", "📄 New     ", "<cmd>ene<CR>"),
        dashboard.button("e", "🌺 Recent  ", "<cmd>Telescope oldfiles<CR>"),
        ranger_button,
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
    },
    config = function(_, opts)
      local notify = require "notify"
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
      vim.api.nvim_create_autocmd({ "User AlphaReady", "BufEnter" }, {
        desc = "Disable indentscope for certain filetypes",
        callback = function()
          if vim.bo.filetype == "alpha"
            or vim.bo.filetype == "neo-tree"
            or vim.bo.filetype == "mason"
            or vim.bo.filetype == "notify"
          then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end
  },

  --  heirline [statusbar]
  --  https://github.com/rebelot/heirline.nvim
  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    opts = function()
      local status = require "base.utils.status"
      return {
        opts = {
          disable_winbar_cb = function(args)
            return not require("base.utils.buffer").is_valid(args.buf)
              or status.condition.buffer_matches({
                buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
              }, args.buf)
          end,
        },
        statusline = { -- statusline
          hl = { fg = "fg", bg = "bg" },
          status.component.mode(),
          status.component.git_branch(),
          status.component.file_info { filetype = {}, filename = false, file_modified = false },
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          --status.component.treesitter(),    -- uncomment to enable
          status.component.compiler_state(),
          --status.component.file_encoding(), -- uncomment to enable
          status.component.nav(),
          status.component.mode { surround = { separator = "right" } },
        },
        winbar = { -- winbar
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          {
            condition = function() return not status.condition.is_active() end,
            status.component.separated_path(),
            status.component.file_info {
              file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbarnc", true),
              surround = false,
              update = "BufEnter",
            },
          },
          status.component.breadcrumbs { hl = status.hl.get_attributes("winbar", true) },
        },
        tabline = { -- bufferline
          { -- file tree padding
            condition = function(self)
              self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
              return status.condition.buffer_matches(
                {
                  filetype = {
                  "aerial", "dapui_.", "dap-repl", "neo%-tree", "NvimTree", "edgy"
                  }
                },
                vim.api.nvim_win_get_buf(self.winid)
              )
            end,
            provider = function(self) return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1) end,
            hl = { bg = "tabline_bg" },
          },
          status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
          status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
          { -- tab list
            condition = function()
              -- only show tabs if there are more than one
              return #vim.api.nvim_list_tabpages() >= 2
            end,
            status.heirline.make_tablist { -- component for each tab
              provider = status.provider.tabnr(),
              hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
            },
            { -- close button for current tab
              provider = status.provider.close_button { kind = "TabClose", padding = { left = 1, right = 1 } },
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

      -- Autocmds --

      -- 0. Apply colors defined above to heirline after applying a theme
      vim.api.nvim_create_autocmd("ColorScheme", {
        desc = "Refresh heirline colors",
        callback = function()
          require("heirline.utils").on_colorscheme(setup_colors())
        end,
      })

      -- 1. Update tabs when adding new buffers
      vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
        desc = "Update buffers when adding new buffers",
        callback = function(args)
          local buf_utils = require "base.utils.buffer"
          if not vim.t.bufs then vim.t.bufs = {} end
          if not buf_utils.is_valid(args.buf) then return end
          if args.buf ~= buf_utils.current_buf then
            buf_utils.last_buf = buf_utils.current_buf
            buf_utils.current_buf = args.buf
          end
          local bufs = vim.t.bufs
          if not vim.tbl_contains(bufs, args.buf) then
            table.insert(bufs, args.buf)
            vim.t.bufs = bufs
          end
          vim.t.bufs = vim.tbl_filter(buf_utils.is_valid, vim.t.bufs)
          utils.event "BufsUpdated"
        end,
      })

      -- 2. Update tabs when deleting buffers
      vim.api.nvim_create_autocmd("BufDelete", {
        desc = "Update buffers when deleting buffers",
        callback = function(args)
          local removed
          for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            local bufs = vim.t[tab].bufs
            if bufs then
              for i, bufnr in ipairs(bufs) do
                if bufnr == args.buf then
                  removed = true
                  table.remove(bufs, i)
                  vim.t[tab].bufs = bufs
                  break
                end
              end
            end
          end
          vim.t.bufs = vim.tbl_filter(require("base.utils.buffer").is_valid, vim.t.bufs)
          if removed then utils.event "BufsUpdated" end
          vim.cmd.redrawtabline()
        end,
      })
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
        enabled = vim.fn.executable "make" == 1,
        build = "make",
      },
    },
    cmd = "Telescope",
    opts = function()
      local get_icon = require("base.utils").get_icon
      local actions = require "telescope.actions"
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
            diff_context_lines = 0,
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
      local telescope = require "telescope"
      telescope.setup(opts)
      -- Here we define the Telescope extension for all plugins.
      -- If you delete a plugin, you can also delete its Telescope extension.
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "nvim-notify",
        "notify"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "telescope-fzf-native.nvim",
        "fzf"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "telescope-undo.nvim",
        "undo"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "nvim-neoclip.lua",
        "neoclip"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "nvim-neoclip.lua",
        "macroscope"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "project.nvim",
        "projects"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "LuaSnip",
        "luasnip"
      )
      utils.conditional_func(
        telescope.load_extension,
        utils.is_available "aerial.nvim",
        "aerial"
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
      input = { default_prompt = "➤ "},
      select = { backend = { "telescope", "builtin" } },
    },
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
    event = "VeryLazy",
    opts = function()
      local enable_conceal = false          -- Hide command text if true
      return {
        presets = { bottom_search = true }, -- The kind of popup used for /
        cmdline = {
          view = "cmdline",                 -- The kind of popup used for :
          format= {
            cmdline =     { conceal = enable_conceal },
            search_down = { conceal = enable_conceal },
            search_up =   { conceal = enable_conceal },
            filter =      { conceal = enable_conceal },
            lua =         { conceal = enable_conceal },
            help =        { conceal = enable_conceal },
            input =       { conceal = enable_conceal },
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
      menu = {},
    },
    enabled = vim.g.icons_enabled,
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
        "alpha",
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
    enabled = not android,
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
        open = { enable = false }, -- causes issues on spectre toggle.
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
  --  This plugin only flases on redo.
  --  But we also have a autocmd to flash on undo.
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
    config = function(_, opts)
      require("highlight-undo").setup(opts)

      -- Also flash on undo.
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight yanked text",
        pattern = "*",
        callback = function() vim.highlight.on_yank() end,
      })
    end,
  },

  --  which-key.nvim [on-screen keybindings]
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
