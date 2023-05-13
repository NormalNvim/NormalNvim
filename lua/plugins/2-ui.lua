-- User interface
-- Things that make the GUI better.


--    Sections:
--       -> astrotheme                  [theme] 
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
--       -> which-key                   [on-screen keybinding]




return {
  --  Astrotheme [theme]
  --  https://github.com/AstroNvim/astrotheme
  {
    "AstroNvim/astrotheme",
    opts = { plugins = { ["dashboard-nvim"] = true } } 
  },




  --  Alpha-nvim [greeter]
  --  https://github.com/goolord/alpha-nvim
  {
    "goolord/alpha-nvim",
    cmd = "Alpha",
    opts = function()
      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = {

        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      dashboard.section.header.opts.hl = "DashboardHeader"

      local button = require("base.utils").alpha_button
      dashboard.section.buttons.val = {
        button("LDR n  ", "  New File  "),
        button("LDR f f", "  Find File  "),
        button("LDR f o", "󰈙  Recents  "),
        button("LDR f w", "󰈭  Find Word  "),
        button("LDR f '", "  Bookmarks  "),
        button("LDR S l", "  Last Session  "),
      }

      dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
      dashboard.config.layout[3].val = 5
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = function(_, opts)
      require("alpha").setup(opts.config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        desc = "Add Alpha dashboard footer",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          opts.section.footer.val =
            { " ", " ", " ", "Nvim loaded " .. stats.count .. " plugins  in " .. ms .. "ms" }
          opts.section.footer.opts.hl = "DashboardFooter"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },




  --  [notifications]
  --  https://github.com/rcarriga/nvim-notify
  {
    "rcarriga/nvim-notify",
    init = function() require("base.utils").load_plugin_with_func("nvim-notify", vim, "notify") end,
    opts = { on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 1000 }) end },
    config = function(_, opts)
      local notify = require "notify"
      notify.setup(opts)
      vim.notify = notify
    end,
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
          disable_winbar_cb = function(args)
            return status.condition.buffer_matches({
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
          status.component.treesitter(),
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
                { filetype = { "aerial", "dapui_.", "neo%-tree", "NvimTree" } },
                vim.api.nvim_win_get_buf(self.winid)
              )
            end,
            provider = function(self) return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1) end,
            hl = { bg = "tabline_bg" },
          },
          status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
          status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
          { -- tab list
            condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
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
      local status = require "base.utils.status"
      local C = status.env.fallback_colors
      local get_hlgroup = require("base.utils").get_hlgroup

      local function setup_colors()
        local Normal = get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
        local Comment = get_hlgroup("Comment", { fg = C.bright_grey, bg = C.bg })
        local Error = get_hlgroup("Error", { fg = C.red, bg = C.bg })
        local StatusLine = get_hlgroup("StatusLine", { fg = C.fg, bg = C.dark_bg })
        local TabLine = get_hlgroup("TabLine", { fg = C.grey, bg = C.none })
        local TabLineSel = get_hlgroup("TabLineSel", { fg = C.fg, bg = C.none })
        local WinBar = get_hlgroup("WinBar", { fg = C.bright_grey, bg = C.bg })
        local WinBarNC = get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
        local Conditional = get_hlgroup("Conditional", { fg = C.bright_purple, bg = C.dark_bg })
        local String = get_hlgroup("String", { fg = C.green, bg = C.dark_bg })
        local TypeDef = get_hlgroup("TypeDef", { fg = C.yellow, bg = C.dark_bg })
        local GitSignsAdd = get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.dark_bg })
        local GitSignsChange = get_hlgroup("GitSignsChange", { fg = C.orange, bg = C.dark_bg })
        local GitSignsDelete = get_hlgroup("GitSignsDelete", { fg = C.bright_red, bg = C.dark_bg })
        local DiagnosticError = get_hlgroup("DiagnosticError", { fg = C.bright_red, bg = C.dark_bg })
        local DiagnosticWarn = get_hlgroup("DiagnosticWarn", { fg = C.orange, bg = C.dark_bg })
        local DiagnosticInfo = get_hlgroup("DiagnosticInfo", { fg = C.white, bg = C.dark_bg })
        local DiagnosticHint = get_hlgroup("DiagnosticHint", { fg = C.bright_yellow, bg = C.dark_bg })
        local HeirlineInactive = get_hlgroup("HeirlineInactive", { bg = nil }).bg
          or status.hl.lualine_mode("inactive", C.dark_grey)
        local HeirlineNormal = get_hlgroup("HeirlineNormal", { bg = nil }).bg or status.hl.lualine_mode("normal", C.blue)
        local HeirlineInsert = get_hlgroup("HeirlineInsert", { bg = nil }).bg or status.hl.lualine_mode("insert", C.green)
        local HeirlineVisual = get_hlgroup("HeirlineVisual", { bg = nil }).bg or status.hl.lualine_mode("visual", C.purple)
        local HeirlineReplace = get_hlgroup("HeirlineReplace", { bg = nil }).bg
          or status.hl.lualine_mode("replace", C.bright_red)
        local HeirlineCommand = get_hlgroup("HeirlineCommand", { bg = nil }).bg
          or status.hl.lualine_mode("command", C.bright_yellow)
        local HeirlineTerminal = get_hlgroup("HeirlineTerminal", { bg = nil }).bg
          or status.hl.lualine_mode("insert", HeirlineInsert)

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
          tabline_bg = StatusLine.bg,
          tabline_fg = StatusLine.bg,
          buffer_fg = Comment.fg,
          buffer_path_fg = WinBarNC.fg,
          buffer_close_fg = Comment.fg,
          buffer_bg = StatusLine.bg,
          buffer_active_fg = Normal.fg,
          buffer_active_path_fg = WinBarNC.fg,
          buffer_active_close_fg = Error.fg,
          buffer_active_bg = Normal.bg,
          buffer_visible_fg = Normal.fg,
          buffer_visible_path_fg = WinBarNC.fg,
          buffer_visible_close_fg = Error.fg,
          buffer_visible_bg = Normal.bg,
          buffer_overflow_fg = Comment.fg,
          buffer_overflow_bg = StatusLine.bg,
          buffer_picker_fg = Error.fg,
          tab_close_fg = Error.fg,
          tab_close_bg = StatusLine.bg,
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
          if not colors[section .. "_bg"] then colors[section .. "_bg"] = colors["section_bg"] end
          if not colors[section .. "_fg"] then colors[section .. "_fg"] = colors["section_fg"] end
        end
        return colors
      end

      heirline.load_colors(setup_colors())
      heirline.setup(opts)

      local augroup = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "AstroColorScheme",
        group = augroup,
        desc = "Refresh heirline colors",
        callback = function() require("heirline.utils").on_colorscheme(setup_colors()) end,
      })
    end,
  },




  --  Telescope [search] + [search backend] dependency
  --  https://github.com/nvim-telescope/telescope.nvim
  --  https://github.com/nvim-telescope/telescope-fzf-native.nvim
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require "telescope.actions"
      local get_icon = require("base.utils").get_icon
      return {
        defaults = {
          prompt_prefix = string.format("%s ", get_icon "Search"),
          selection_caret = string.format("%s ", get_icon "Selected"),
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

          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = { ["q"] = actions.close },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      local utils = require "base.utils"
      local conditional_func = utils.conditional_func
      conditional_func(telescope.load_extension, pcall(require, "notify"), "notify")
      conditional_func(telescope.load_extension, pcall(require, "aerial"), "aerial")
      conditional_func(telescope.load_extension, utils.is_available "telescope-fzf-native.nvim", "fzf")
    end
  },




  --  [window-dimming]
  --  https://github.com/mrjones2014/smart-splits.nvim
  {
    "mrjones2014/smart-splits.nvim",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },




  --  [better ui elements]
  --  https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    init = function() require("base.utils").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" }) end,
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
      select = {
        backend = { "telescope", "builtin" },
        builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
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
