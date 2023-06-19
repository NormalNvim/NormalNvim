-- Core behaviors
-- Things that add new behaviors.

--    Sections:
--       -> ranger file browser    [ranger]
--       -> project.nvim           [project search + auto cd]
--       -> trim.nvim              [auto trim spaces]
--       -> stickybuf.nvim         [lock special buffers]
--       -> telescope-undo.nvim    [undo history]
--       -> nvim-window-picker     [select buffer with a letter]
--       -> smart-splits           [move and resize buffers]
--       -> better-scape.nvim      [esc]
--       -> toggleterm.nvim        [term]
--       -> session-manager        [session]
--       -> spectre.nvim           [search and replace in project]
--       -> neotree file browser   [neotree]
--       -> nvim-ufo               [folding mod]
--       -> nvim-neoclip           [nvim clipboard]
--       -> suda.vim               [write as sudo]
--       -> vim-matchup            [Imprived % motion]

-- import custom icons
local get_icon = require("base.utils").get_icon

-- configures plugins
return {
  -- [ranger] file browser
  -- https://github.com/kevinhwang91/rnvimr
  {
    "kevinhwang91/rnvimr",
    cmd = { "RnvimrToggle" },
    init = function()
      -- vim.g.rnvimr_vanilla = 1 → Often solves many issues
      vim.g.rnvimr_enable_picker = 1 -- if 1, will close rnvimr after choosing a file.
      vim.g.rnvimr_ranger_cmd = { "ranger" } -- by using a shell script like TERM=foot ranger "$@" we can open terminals inside ranger.
    end,
  },

  -- project.nvim [project search + auto cd]
  -- https://github.com/ahmedkhalf/project.nvim
  {
    "ahmedkhalf/project.nvim",
    cmd = "ProjectRoot",
    opts = {
      -- How to find root directory
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
      },
      silent_chdir = true,
      manual_mode = false,
      --ignore_lsp = { "lua_ls" },
    },
    config = function(_, opts) require("project_nvim").setup(opts) end,
  },
  -- Telescope integration (:Telescope projects)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {"ahmedkhalf/project.nvim"},
    cmd = {"ProjectRoot", "Telescope projects"},
    opts = function() require("telescope").load_extension "projects" end,
  },

  -- trim.nvim [auto trim spaces]
  -- https://github.com/cappyzawa/trim.nvim
  {
    "cappyzawa/trim.nvim",
    event = "BufWrite",
    opts = {
      -- ft_blocklist = {"typescript"},
      trim_on_write = true,
      trim_trailing = true,
      trim_last_line = false,
      trim_first_line = false,
      -- patterns = {[[%s/\(\n\n\)\n\+/\1/]]}, -- Only one consecutive bl
    },
  },

  -- stickybuf.nvim [lock special buffers]
  -- https://github.com/arnamak/stay-centered.nvim
  -- By default it support neovim/aerial and others.
  {
    "stevearc/stickybuf.nvim",
  },

  -- telescope-undo.nvim [undo history]
  -- https://github.com/debugloop/telescope-undo.nvim
  -- BUG: We are using a fork because of a bug where options are ignored.
  --      You can use the original repo once this is fixed.
  -- https://github.com/debugloop/telescope-undo.nvim/issues/30#issuecomment-1575753897
  {
    "Zeioth/telescope-undo.nvim",
    cmd = { "Telescope undo" },
  },
  -- Telescope integration (:Telescope undo)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {"Zeioth/telescope-undo.nvim"},
    cmd = { "Telescope undo" },
    opts = function() require("telescope").load_extension "undo" end,
  },

  -- nvim-window-picker  [select buffer with a letter]
  -- https://github.com/s1n7ax/nvim-window-picker
  -- Warning: currently no keybinding assigned for this plugin.
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    opts = {
      picker_config = {
        statusline_winbar_picker = {
          use_winbar = "smart",
        },
      },
    },
  },

  --  smart-splits [move and resize buffers]
  --  https://github.com/mrjones2014/smart-splits.nvim
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
    },
  },

  -- Improved [esc]
  -- https://github.com/max397574/better-escape.nvim
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      mapping = {},
      timeout = 300,
    },
  },

  -- Toggle floating terminal on <F7> [term]
  -- https://github.com/akinsho/toggleterm.nvim
  -- neovim bug → https://github.com/neovim/neovim/issues/21106
  -- workarounds → https://github.com/akinsho/toggleterm.nvim/wiki/Mouse-support
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
  -- Check: https://github.com/gennaro-tedesco/nvim-possession
  --
  -- BUG: Swap disabled on options because of this bug
  -- https://github.com/Shatur/neovim-session-manager/issues/72
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
      buf_filter = function(bufnr)
        return require("base.utils.buffer").is_valid(bufnr)
      end,
      tab_buf_filter = function(tabpage, bufnr)
        return vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
      end,
      extensions = { base = {} },
    },
  },

  -- spectre.nvim [search and replace in project]
  -- https://github.com/nvim-pack/nvim-spectre
  -- INSTRUCTIONS:
  -- To see the instructions press '?'
  -- To start the search press <ESC>.
  -- It doesn't have ctrl-z so please always commit before using it.
  {
    "zeioth/nvim-spectre",
    cmd = "Spectre",
    opts = {
      find_engine = {
        default = {
         find = {
            --pick one of item in find_engine [ag, rg ]
            cmd = "ag",
            options = { "ignore-case" },
          },
          replace = {
            -- If you install oxi with cargo you can use it instead.
            cmd = "sed",
          },
        },
      },
      is_insert_mode = true,  -- start open panel on is_insert_mode
      line_sep_start = '┌──────────────────────────────────────────────────────',
      result_padding = '│  ',
      line_sep       = '└──────────────────────────────────────────────────────',
      mapping = {
        ['toggle_line'] = {
            map = "d",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle item."
        },
        ['enter_file'] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "open file."
        },
        ['send_to_qf'] = {
            map = "sqf",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix."
        },
        ['replace_cmd'] = {
            map = "src",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "replace command."
        },
        ['show_option_menu'] = {
            map = "so",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "show options."
        },
        ['run_current_replace'] = {
          map = "c",
          cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          desc = "confirm item."
        },
        ['run_replace'] = {
            map = "R",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "replace all."
        },
        ['change_view_mode'] = {
            map = "sv",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "results view mode."
        },
        ['change_replace_sed'] = {
          map = "srs",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "use sed to replace."
        },
        ['change_replace_oxi'] = {
          map = "sro",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "use oxi to replace."
        },
        ['toggle_live_update']={
          map = "sar",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "auto refresh changes when nvim writes a file."
        },
        ['resume_last_search'] = {
          map = "sl",
          cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          desc = "repeat last search."
        },
        ['insert_qwerty'] = {
          map = "i",
          cmd = "<cmd>startinsert<CR>",
          desc = "insert (qwerty)."
        },
        ['insert_colemak'] = {
          map = "o",
          cmd = "<cmd>startinsert<CR>",
          desc = "insert (colemak)."
        },
        ['quit'] = {
            map = "q",
            cmd = "<cmd>lua require('spectre').close()<CR>",
            desc = "quit."
        },
      },
    },
  },

  --neotree
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    init = function() vim.g.neo_tree_remove_legacy_commands = true end,
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          {
            source = "filesystem",
            display_name = get_icon "FolderClosed" .. " File",
          },
          {
            source = "buffers",
            display_name = get_icon "DefaultFile" .. " Bufs",
          },
          { source = "git_status", display_name = get_icon "Git" .. " Git" },
          {
            source = "diagnostics",
            display_name = get_icon "Diagnostic" .. " Diagnostic",
          },
        },
      },
      default_component_configs = {
        indent = { padding = 0 },
        icon = {
          folder_closed = get_icon "FolderClosed",
          folder_open = get_icon "FolderOpen",
          folder_empty = get_icon "FolderEmpty",
          folder_empty_open = get_icon "FolderEmpty",
          default = get_icon "DefaultFile",
        },
        modified = { symbol = get_icon "FileModified" },
        git_status = {
          symbols = {
            added = get_icon "GitAdd",
            deleted = get_icon "GitDelete",
            modified = get_icon "GitChange",
            renamed = get_icon "GitRenamed",
            untracked = get_icon "GitUntracked",
            ignored = get_icon "GitIgnored",
            unstaged = get_icon "GitUnstaged",
            staged = get_icon "GitStaged",
            conflict = get_icon "GitConflict",
          },
        },
      },
      commands = {
        system_open = function(state)
          require("base.utils").system_open(state.tree:get_node():get_id())
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if
            (node.type == "directory" or node:has_children())
            and node:is_expanded()
          then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(
              state,
              node:get_parent_id()
            )
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(
                state,
                node:get_child_ids()[1]
              )
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            e = { val = modify(filename, ":e"), msg = "Extension only" },
            f = { val = filename, msg = "Filename" },
            F = {
              val = modify(filename, ":r"),
              msg = "Filename w/o extension",
            },
            h = { val = modify(filepath, ":~"), msg = "Path relative to Home" },
            p = { val = modify(filepath, ":."), msg = "Path relative to CWD" },
            P = { val = filepath, msg = "Absolute path" },
          }

          local messages = {
            { "\nChoose to copy to clipboard:\n", "Normal" },
          }
          for i, result in pairs(results) do
            if result.val and result.val ~= "" then
              vim.list_extend(messages, {
                { ("%s."):format(i), "Identifier" },
                { (" %s: "):format(result.msg) },
                { result.val, "String" },
                { "\n" },
              })
            end
          end
          vim.api.nvim_echo(messages, false, {})
          local result = results[vim.fn.getcharstr()]
          if result and result.val and result.val ~= "" then
            vim.notify("Copied: " .. result.val)
            vim.fn.setreg("+", result.val)
          end
        end,
        run_command = function(state) vim.api.nvim_input ":" end,
        diff_files = function(state)
          local node = state.tree:get_node()
          local log = require "neo-tree.log"
          state.clipboard = state.clipboard or {}
          if diff_Node and diff_Node ~= tostring(node.id) then
            local current_Diff = node.id
            require("neo-tree.utils").open_file(state, diff_Node, open)
            vim.cmd("vert diffs " .. current_Diff)
            log.info("Diffing " .. diff_Name .. " against " .. node.name)
            diff_Node = nil
            current_Diff = nil
            state.clipboard = {}
            require("neo-tree.ui.renderer").redraw(state)
          else
            local existing = state.clipboard[node.id]
            if existing and existing.action == "diff" then
              state.clipboard[node.id] = nil
              diff_Node = nil
              require("neo-tree.ui.renderer").redraw(state)
            else
              state.clipboard[node.id] = { action = "diff", node = node }
              diff_Name = state.clipboard[node.id].node.name
              diff_Node = tostring(state.clipboard[node.id].node.id)
              log.info("Diff source file " .. diff_Name)
              require("neo-tree.ui.renderer").redraw(state)
            end
          end
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = false, -- disable space until we figure out which-key disabling
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          ["e"] = function()
            vim.api.nvim_exec("Neotree focus filesystem left", true)
          end,
          ["b"] = function()
            vim.api.nvim_exec("Neotree focus buffers left", true)
          end,
          ["g"] = function()
            vim.api.nvim_exec("Neotree focus git_status left", true)
          end,
          o = "open",
          O = "system_open",
          h = "parent_or_close",
          l = "child_or_open",
          Y = "copy_selector",
          ["s"] = "run_command",
          ["D"] = "diff_files", -- This replaces filter directories
        },
      },
      filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false, -- By default, hide hidden files, but show them dimmed when enabled.
          hide_dotfiles = true,
          hide_gitignored = true,
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_) vim.opt_local.signcolumn = "auto" end,
        },
        --{
        --  event = "file_opened",
        --  handler = function(file_path)
        --    --auto close
        --    require("neo-tree").close_all()
        --  end
        --},
      },
    },
  },

  --  code [folding mod] + [promise-asyn] dependency
  --  https://github.com/kevinhwang91/nvim-ufo
  --  https://github.com/kevinhwang91/promise-async
  {
    "kevinhwang91/nvim-ufo",
    event = { "User BaseFile", "InsertEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      preview = {
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == "string" and err:match "UfoFallbackException" then
            return require("ufo").getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or function(bufnr)
            return require("ufo")
              .getFolds(bufnr, "lsp")
              :catch(
                function(err)
                  return handleFallbackException(bufnr, err, "treesitter")
                end
              )
              :catch(
                function(err)
                  return handleFallbackException(bufnr, err, "indent")
                end
              )
          end
      end,
    },
  },

  --  [zen mode]
  --  https://github.com/folke/zen-mode.nvim
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  --  nvim-neoclip [nvim clipboard]
  --  https://github.com/AckslD/nvim-neoclip.lua
  --  Registers are deleted between sessions
  {
    "AckslD/nvim-neoclip.lua",
    cmd = { "Telescope neoclip", "Telescope macroscope" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() require("neoclip").setup() end,
  },
  -- Telescope integration (:Telescope neoclip amd :Telescope macroscope)
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope neoclip", "Telescope macroscope" },
    dependencies = {"AckslD/nvim-neoclip.lua"},
    opts = function()
      require("telescope").load_extension "neoclip"
      require("telescope").load_extension "macroscope"
    end,
  },

  --  suda.nvim [write as sudo]
  --  https://github.com/lambdalisue/suda.vim
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },

  --  vim-matchup [improved % motion]
  --  https://github.com/andymass/vim-matchup
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_deferred = 1 -- work async
      vim.g.matchup_matchparen_offscreen = {} -- disable status bar icon
    end,
  },

  --  hop.nvim [go to word visually]
  --  https://github.com/phaazon/hop.nvim
  {
    "phaazon/hop.nvim",
    cmd = { "HopWord" },
    opts = { keys = "etovxqpdygfblzhckisuran" },
    config = function(_, opts)
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup(opts)
    end,
  },
}
