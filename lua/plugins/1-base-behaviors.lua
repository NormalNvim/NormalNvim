-- Core behaviors
-- Things that add new behaviors.

--    Sections:
--       -> ranger file browser    [ranger]
--       -> project.nvim           [project search + auto cd]
--       -> trim.nvim              [auto trim spaces]
--       -> stay-centered.nvim     [cursor centered]
--       -> stickybuf.nvim         [lock special buffers]
--       -> nvim-window-picker     [windows]
--       -> better-scape.nvim      [esc]
--       -> toggleterm.nvim        [term]
--       -> session-manager        [session]
--       -> spectre.nvim           [search and replace in project]
--       -> neotree file browser   [neotree]
--       -> nvim-ufo               [folding mod]
--       -> nvim-neoclip           [nvim clipboard]

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
      vim.g.rnvimr_enable_picker = 1 -- if 1, will replace the current buffer
      vim.g.rnvimr_ranger_cmd = { "ranger" }

      -- Known bug: We cannot set a custom terminal for rnvimr.
      --            (now even through a wrapper)
      --            Doing so will provoke rnvimr RPC to not close correctly.
      --            If you need that feature, use ranger.vim instead.
      --
      -- Check: https://github.com/kevinhwang91/rnvimr/issues/149
      -- vim.g.rnvimr_ranger_cmd = { "ranger-custom" } -- Currently broken
    end,
    config = function() -- FIX: Adds mouse support to rnvimr
      -- TODO: You can delete this after the author merges it:
      -- https://github.com/kevinhwang91/rnvimr/issues/58
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      local rnvimr_mouse_group =
        augroup("RnvimrMouseSupport", { clear = true })

      -- Enables mouse support for rnvimr
      local function set_mouse_with_rnvimr()
        local n_mouse = vim.o.mouse

        -- Disable nvim mouse support while we are on the rnvimr buffer
        if string.match(n_mouse, "[a|h|n]") then
          autocmd({ "TermEnter", "WinEnter <buffer>" }, {
            desc = "Disable nvim mouse support while we are on the rnvimr buffer",
            group = rnvimr_mouse_group,
            callback = function() vim.api.nvim_set_option("mouse", "") end,
          })
          -- Restore mouse mode on exiting rnvimr
          autocmd({ "TermLeave", "WinLeave <buffer>" }, {
            desc = "Disable nvim mouse support while we are on the rnvimr buffer",
            group = rnvimr_mouse_group,
            callback = function() vim.api.nvim_set_option("mouse", n_mouse) end,
          })
        end

        -- Extra mouse fix for tmux
        -- If tmux mouse mode is enabled
        local output = vim.fn.system 'tmux display -p "#{mouse}"'
        if output:sub(1, 1) == "1" then
          -- Disable tmux mouse while using rnvimr
          autocmd({ "TermEnter", "WinEnter <buffer>" }, {
            desc = "Disable tmux mouse while using rnvimr",
            group = rnvimr_mouse_group,
            callback = function() vim.fn.system "tmux set mouse off" end,
          })

          -- Enable tmux mouse when mouse leaves rnvimr
          autocmd({ "WinLeave <buffer>" }, {
            desc = "Enable tmux mouse when mouse leaves rnvimr",
            group = rnvimr_mouse_group,
            callback = function() vim.fn.system "tmux set mouse on" end,
          })
        end
      end

      -- Entry point
      autocmd({ "FileType rnvimr" }, {
        desc = "If we are on the rnvimr buffer, execute the callback",
        group = rnvimr_mouse_group,
        callback = function()
          -- Apply only to rnvimr
          if vim.bo.filetype == "rnvimr" then set_mouse_with_rnvimr() end
        end,
      })
    end,
  },

  -- project.nvim [project search + auto cd]
  -- https://github.com/ahmedkhalf/project.nvim
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
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

  -- telescope-undo.nvim
  -- https://github.com/debugloop/telescope-undo.nvim
  {
    "debugloop/telescope-undo.nvim",
    -- opts = { -- currently this plugin doesn't support opts.
    --   use_delta = false,
    --   side_by_side = true,
    --   layout_strategy = "vertical",
    --   layout_config = {
    --     preview_height = 0.8,
    --   },
    -- }
  },
  -- Telescope integration (:Telescope projects)
  {
    "nvim-telescope/telescope.nvim",
    opts = function() require("telescope").load_extension "undo" end,
  },

  -- easier window selection  [windows]
  -- https://github.com/s1n7ax/nvim-window-picker
  {
    "s1n7ax/nvim-window-picker",
    opts = { use_winbar = "smart" },
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
    init = function()
      -- PATCH: Enable mouse support for ToggleTerm.
      -- TODO: Remove this once the patch is merged into main.
      -- https://github.com/akinsho/toggleterm.nvim/pull/441
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      local toggleterm_mouse_group =
        augroup("ToggleTermMouseSupport", { clear = true })

      -- Enables mouse support for toggleterm
      local function set_mouse_with_toggleterm()
        local n_mouse = vim.o.mouse

        -- Disable nvim mouse support while we are on the toggleterm buffer
        if string.match(n_mouse, "[a|h|n]") then
          autocmd({ "TermEnter", "WinEnter <buffer>" }, {
            desc = "Disable nvim mouse support while we are on the toggleterm buffer",
            group = toggleterm_mouse_group,
            callback = function() vim.api.nvim_set_option("mouse", "") end,
          })
          -- Restore mouse mode on exiting toggleterm
          autocmd({ "TermLeave", "WinLeave <buffer>" }, {
            desc = "Disable nvim mouse support while we are on the toggleterm buffer",
            group = toggleterm_mouse_group,
            callback = function() vim.api.nvim_set_option("mouse", n_mouse) end,
          })
        end

        -- Extra mouse fix for tmux
        -- If tmux mouse mode is enabled
        local output = vim.fn.system 'tmux display -p "#{mouse}"'
        if output:sub(1, 1) == "1" then
          -- Disable tmux mouse while using toggleterm
          autocmd({ "TermEnter", "WinEnter <buffer>" }, {
            desc = "Disable tmux mouse while using toggleterm",
            group = toggleterm_mouse_group,
            callback = function() vim.fn.system "tmux set mouse off" end,
          })

          -- Enable tmux mouse when mouse leaves toggleterm
          autocmd({ "WinLeave <buffer>" }, {
            desc = "Enable tmux mouse when mouse leaves toggleterm",
            group = toggleterm_mouse_group,
            callback = function() vim.fn.system "tmux set mouse on" end,
          })
        end
      end

      -- Entry point
      autocmd({ "FileType rnvimr" }, {
        desc = "If we are on the rnvimr buffer, execute the callback",
        group = toggleterm_mouse_group,
        callback = function()
          -- Apply only to toggleterm
          if vim.bo.filetype == "toggleterm" then
            set_mouse_with_toggleterm()
          end
        end,
      })
    end,
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
  -- It doesn't have ctrl-z so please always commit before using it.
  {
    "nvim-pack/nvim-spectre",
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
      mapping = {
        -- The mappings only appear while spectre is active
        ["toggle_line"] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "toggle current item",
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "goto current file",
        },
        ["send_to_qf"] = {
          map = "<leader>q",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all item to quickfix",
        },
        ["replace_cmd"] = {
          map = "<leader>c",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "input replace vim command",
        },
        ["show_option_menu"] = {
          map = "<leader>o",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show option",
        },
        ["run_current_replace"] = {
          map = "<leader>rc",
          cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          desc = "replace current line",
        },
        ["run_replace"] = {
          map = "<leader>T",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "replace all",
        },
        ["change_view_mode"] = {
          map = "<leader>v",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "change result view mode",
        },
        ["change_replace_sed"] = {
          map = "trs",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "use sed to replace",
        },
        ["change_replace_oxi"] = {
          map = "tro",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "use oxi to replace",
        },
        ["toggle_live_update"] = {
          map = "tu",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "update change when vim write file.",
        },
        ["toggle_ignore_case"] = {
          map = "ti",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "toggle ignore case",
        },
        ["toggle_ignore_hidden"] = {
          map = "th",
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = "toggle search hidden",
        },
        ["resume_last_search"] = {
          map = "<leader>l",
          cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          desc = "resume last search before close",
        },
        -- you can put your mapping here it only use normal mode
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
        indent = { padding = 0, indent_size = 1 },
        icon = {
          folder_closed = get_icon "FolderClosed",
          folder_open = get_icon "FolderOpen",
          folder_empty = get_icon "FolderEmpty",
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
    opts = {},
    config = function() require("neoclip").setup() end,
  },
  -- Telescope integration (:Telescope neoclip amd :Telescope macroscope)
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      require("telescope").load_extension "neoclip"
      require("telescope").load_extension "macroscope"
    end,
  },
}
