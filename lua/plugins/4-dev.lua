-- Dev
-- Things you actively use for coding.

--    Sections:
--       ## COMMENTS
--       -> comment.nvim                   [comment with a key]

--       ## SNIPPETS
--       -> luasnip                        [snippet engine]
--       -> friendly-snippets              [snippet templates]

--       ## GIT
--       -> gitsigns.nvim                  [git hunks]
--       -> fugitive.vim                   [git commands]

--       ## ANALYZER
--       -> aerial.nvim                    [symbols tree]

--       ## CODE DOCUMENTATION
--       -> dooku.nivm                     [html doc generator]
--       -> markdown-preview.nvim          [markdown previewer]
--       -> markmap.nvim                   [markdown mindmap]

--       ## ARTIFICIAL INTELLIGENCE
--       -> neural                         [chatgpt code generator]
--       -> copilot                        [github code suggestions]
--       -> guess-indent                   [guess-indent]

--       ## COMPILER
--       -> compiler.nvim                  [compiler]
--       -> overseer.nvim                  [task runner]

--       ## DEBUGGER
--       -> nvim-dap                       [debugger]

--       ## TESTING
--       -> neotest.nvim                   [unit testing]
--       -> nvim-coverage                  [code coverage]

--       ## NOT INSTALLED
--       -> distant.nvim                   [ssh to edit in a remote machine]

local get_icon = require("base.utils").get_icon
local windows = vim.fn.has('win32') == 1 -- true if on windows
return {
  --  COMMENTS ----------------------------------------------------------------
  --  Advanced comment features [comment with a key]
  --  https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    opts = function()
      local commentstring_avail, commentstring =
        pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail
          and commentstring
          and { pre_hook = commentstring.create_pre_hook() }
        or {}
    end,
  },

  --  SNIPPETS ----------------------------------------------------------------
  --  Vim Snippets engine  [snippet engine] + [snippet templates]
  --  https://github.com/L3MON4D3/LuaSnip
  --  https://github.com/rafamadriz/friendly-snippets
  {
    "L3MON4D3/LuaSnip",
    build = not windows
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = {
      "zeioth/friendly-snippets",
      "benfowler/telescope-luasnip.nvim",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(
        function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
        { "vscode", "snipmate", "lua" }
      )
      -- friendly-snippets - enable standardized comments snippets
      require("luasnip").filetype_extend("typescript", { "tsdoc" })
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require("luasnip").filetype_extend("lua", { "luadoc" })
      require("luasnip").filetype_extend("python", { "pydoc" })
      require("luasnip").filetype_extend("rust", { "rustdoc" })
      require("luasnip").filetype_extend("cs", { "csharpdoc" })
      require("luasnip").filetype_extend("java", { "javadoc" })
      require("luasnip").filetype_extend("c", { "cdoc" })
      require("luasnip").filetype_extend("cpp", { "cppdoc" })
      require("luasnip").filetype_extend("php", { "phpdoc" })
      require("luasnip").filetype_extend("kotlin", { "kdoc" })
      require("luasnip").filetype_extend("ruby", { "rdoc" })
      require("luasnip").filetype_extend("sh", { "shelldoc" })
      --require("luasnip").filetype_extend("shell", { "doxygen" })
    end,
  },

  --  GIT ---------------------------------------------------------------------
  --  Git signs [git hunks]
  --  https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    event = "User BaseGitFile",
    opts = {
      signs = {
        add = { text = get_icon "GitSign" },
        change = { text = get_icon "GitSign" },
        delete = { text = get_icon "GitSign" },
        topdelete = { text = get_icon "GitSign" },
        changedelete = { text = get_icon "GitSign" },
        untracked = { text = get_icon "GitSign" },
      },
    },
  },

  --  Git fugitive mergetool + [git commands]
  --  https://github.com/lewis6991/gitsigns.nvim
  --  PR needed: Setup keymappings to move quickly when using this feature.
  --
  --  We only want this plugin to use it as mergetool like "git mergetool".
  --  To enable this feature, add this  to your global .gitconfig:
  --
  --  [mergetool "fugitive"]
  --  	cmd = nvim -c \"Gvdiffsplit!\" \"$MERGED\"
  --  [merge]
  --  	tool = fugitive
  --  [mergetool]
  --  	keepBackup = false
  {
    "https://github.com/tpope/vim-fugitive",
    enabled = vim.fn.executable "git" == 1,
    dependencies = { "tpope/vim-rhubarb" },
    cmd = {
      "Gvdiffsplit",
      "Gdiffsplit",
      "Gedit",
      "Gsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GRename",
      "GDelete",
      "GRemove",
      "GBrowse",
      "Git",
      "Gstatus",
    },
    init = function() vim.g.fugitive_no_maps = 1 end,
  },



  --  ANALYZER ----------------------------------------------------------------
  --  [symbols tree]
  --  https://github.com/stevearc/aerial.nvim
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    cmd = {
      "AerialToggle",
      "AerialOpen",
      "AerialNavOpen",
      "AerialInfo",
      "AerialClose",
    },
    opts = {
      open_automatic = false, -- Open if the buffer is compatible
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      disable_max_lines = vim.g.big_file.lines,
      disable_max_size = vim.g.big_file.size,
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

  --  CODE DOCUMENTATION ------------------------------------------------------
  --  dooku.nvim [html doc generator]
  --  https://github.com/Zeioth/dooku.nvim
  {
    "Zeioth/dooku.nvim",
    cmd = {
      "DookuGenerate",
      "DookuOpen",
      "DookuAutoSetup"
    },
    opts = {},
  },

  --  [markdown previewer]
  --  https://github.com/iamcco/markdown-preview.nvim
  --  Note: If you change the build command, wipe ~/.local/data/nvim/lazy
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    build = "cd app && yarn install",
  },

  --  [markdown markmap]
  --  https://github.com/Zeioth/markmap.nvim
  --  Note: If you change the build command, wipe ~/.local/data/nvim/lazy
  {
    "Zeioth/markmap.nvim",
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    config = function(_, opts) require("markmap").setup(opts) end,
  },

  --  ARTIFICIAL INTELIGENCE  -------------------------------------------------
  --  neural [chatgpt code generator]
  --  https://github.com/dense-analysis/neural
  {
    "dense-analysis/neural",
    cmd = { "Neural" },
    config = function()
      require("neural").setup {
        source = {
          openai = {
            api_key = vim.env.OPENAI_API_KEY,
          },
        },
        ui = {
          prompt_icon = ">",
        },
      }
    end,
  },

  --  copilot [github code suggestions]
  --  https://github.com/github/copilot.vim
  --  As alternative to chatgpt, you can use copilot uncommenting this.
  --  Then you must run :Copilot setup
  -- {
  --   "github/copilot.vim",
  --   event = "User BaseFile"
  -- },

  -- [guess-indent]
  -- https://github.com/NMAC427/guess-indent.nvim
  -- Note that this plugin won't autoformat the code.
  -- It just set the buffer options to tabuate in a certain way.
  {
    "NMAC427/guess-indent.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("guess-indent").setup(opts)
      vim.cmd.lua {
        args = { "require('guess-indent').set_from_buffer('auto_cmd')" },
        mods = { silent = true },
      }
    end,
  },

  --  COMPILER ----------------------------------------------------------------
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    config = function(_, opts) require("compiler").setup(opts) end,
  },
  {
    "stevearc/overseer.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults" },
    opts = {
      -- Tasks are disposed 5 minutes after running to free resources.
      -- If you need to close a task inmediatelly:
      -- press ENTER in the outut menu on the task you wanna close.
      task_list = { -- this refers to the window that shows the result
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["q"] = function() vim.cmd("OverseerClose") end ,
        }
      },
      -- component_aliases = { -- uncomment this to disable notifications
      --   -- Components included in default will apply to all tasks
      --   default = {
      --     { "display_duration", detail_level = 2 },
      --     "on_output_summarize",
      --     "on_exit_set_status",
      --     "on_complete_notify",
      --     "on_complete_dispose",
      --   },
      -- },
    },
  },

  --  DEBUGGER ----------------------------------------------------------------
  --  Debugger alternative to vim-inspector [debugger]
  --  https://github.com/mfussenegger/nvim-dap
  --  Here we configure the adapter+config of every debugger.
  --  Debuggers don't have system dependencies, you just install them with mason.
  --  We currently ship most of them with nvim.
  {
    "mfussenegger/nvim-dap",
    enabled = vim.fn.has "win32" == 0,
    event = "User BaseFile",
    config = function(_, opts)
      local dap = require("dap")

      -- C#
      dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.stdpath('data')..'/mason/bin/netcoredbg',
        args = {'--interpreter=vscode'}
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function() -- Ask the user what executable wants to debug
              return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Program.exe', 'file')
          end,
        },
      }

      -- Java
      -- WARNING:
      -- * The java debugger config is system specific.
      -- * You HAVE to manually modify this file as specified inside:
      -- ../../ftplugin/java.lua

      -- Python
      dap.adapters.python = {
          type = 'executable',
          command = vim.fn.stdpath('data')..'/mason/packages/debugpy/venv/bin/python',
          args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}", -- This configuration will launch the current file if used.
        },
      }

      -- Lua
      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end
      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
          program = function() pcall(require"osv".launch({port = 8086})) end,
        }
      }

      -- C
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath('data')..'/mason/bin/codelldb',
          args = {"--port", "${port}"},
           detached = function() if windows then return false else return true end end,
        }
      }
      dap.configurations.c = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function() -- Ask the user what executable wants to debug
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/bin/program', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      -- C++
      dap.configurations.cpp = dap.configurations.c

      -- Rust
      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function() -- Ask the user what executable wants to debug
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/bin/program', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          initCommands = function() -- add rust types support (optional)
            -- Find out where to look for the pretty printer Python module
            local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

            local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
            local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

            local commands = {}
            local file = io.open(commands_file, 'r')
            if file then
              for line in file:lines() do
                table.insert(commands, line)
              end
              file:close()
            end
            table.insert(commands, 1, script_import)

            return commands
          end,
        }
      }

      -- Go
      -- Requires:
      -- * You have the system dependency 'dlv'.
      -- * You have initialized your module with 'go mod init module_name'.
      -- * You :cd your project before running DAP.
      -- note that no mason package or nvim plugin is required.
      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = '/usr/bin/dlv', -- Ensure this is correct
          args = {'dap', '-l', '127.0.0.1:${port}'},
        }
      }
      dap.configurations.go = {
        {
          type = "delve",
          name = "Compile module and debug this file",
          request = "launch",
          program = "./${relativeFileDirname}",
        },
        {
          type = "delve",
          name = "Compile module and debug this file (test)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}"
        },
      }

      -- Dart (untested)
      dap.adapters.dart = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath('data')..'/mason/bin/dart-debug-adapter', "flutter"}
      }
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch flutter",
          dartSdkPath = os.getenv('HOME').."/flutter/bin/cache/dart-sdk/",
          flutterSdkPath = os.getenv('HOME').."/flutter",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        }
      }

      -- Kotlin (untested)
      dap.adapters.kotlin = {
          type = 'executable';
        command = vim.fn.stdpath('data')..'/mason/bin/kotlin-debug-adapter',
      }
      dap.configurations.kotlin = {
          {
              type = 'kotlin';
              request = 'launch';
              name = 'Launch kotlin program';
              projectRoot = "${workspaceFolder}/app";
              mainClass = "AppKt";
          };
      }

      -- Javascript / Typescript (firefox)
      dap.adapters.firefox = {
        type = 'executable',
        command = vim.fn.stdpath('data')..'/mason/bin/firefox-debug-adapter',
      }
      dap.configurations.typescript = {
        {
        name = 'Debug with Firefox',
        type = 'firefox',
        request = 'launch',
        reAttach = true,
        url = 'http://localhost:3000', -- Write the actual URL of your project.
        webRoot = '${workspaceFolder}',
        firefoxExecutable = '/usr/bin/firefox'
        }
      }

      -- Shell
      dap.adapters.bashdb = {
        type = 'executable';
        command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
        name = 'bashdb';
      }
      dap.configurations.sh = {
        {
          type = 'bashdb';
          request = 'launch';
          name = "Launch file";
          showDebugOutput = true;
          pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb';
          pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir';
          trace = true;
          file = "${file}";
          program = "${file}";
          cwd = '${workspaceFolder}';
          pathCat = "cat";
          pathBash = "/bin/bash";
          pathMkfifo = "mkfifo";
          pathPkill = "pkill";
          args = {};
          env = {};
          terminalKind = "integrated";
        }
      }

    end, -- of dap config
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        "jbyuki/one-small-step-for-vimkind",
        "https://github.com/mfussenegger/nvim-jdtls",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { handlers = {} },
      },
      {
        "rcarriga/nvim-dap-ui",
        opts = { floating = { border = "rounded" } },
        config = function(_, opts)
          local dap, dapui = require "dap", require "dapui"
          dap.listeners.after.event_initialized["dapui_config"] = function(
          )
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function(
          )
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
          dapui.setup(opts)
        end,
      },
      {
        "rcarriga/cmp-dap",
        dependencies = { "nvim-cmp" },
        config = function()
          require("cmp").setup.filetype(
            { "dap-repl", "dapui_watches", "dapui_hover" },
            {
              sources = {
                { name = "dap" },
              },
            }
          )
        end,
      },
    },
  },

  --  TESTING ----------------------------------------------------------------
  --  Run tests inside of nvim [unit testing]
  --  https://github.com/nvim-neotest/neotest
  --
  --
  --  MANUAL:
  --  -- Unit testing:
  --  To tun an unit test you can run any of these commands:
  --
  --    :TestRunBlock   -- Runs the nearest test to the cursor.
  --    :TestStopBlock  -- Stop the nearest test to the cursor.
  --    :TestRunFile    -- Run all tests in the file.
  --    :TestDebugBlock -- Debug the nearest test under the cursor using dap
  --
  --  All this commands are meant to be executed in a test file.
  --  You can find them on ../base/3-autocmds.lua
  --
  --  -- E2e and Test Suite
  --  Normally you will prefer to open your e2e framework GUI outside of nvim.
  --  But you have the next commands in ../base/3-autocmds.lua:
  --
  --    :TestNodejs    -- Run all tests for this nodejs project.
  --    :TestNodejsE2e -- Run the e2e tests/suite for this nodejs project.
  {
    "nvim-neotest/neotest",
    cmd = {             -- All commands are meant to run in a test file
      "TestRunBlock",   -- Run the nearest test to the cursor.
      "TestStopBlock",  -- Stop the test to the cursor.
      "TestDebugBlock", -- Debug the nearest test under the cursor using dap.
      "TestRunFile",    -- Run all tests in the file.
    },
    dependencies = {
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "Issafalcon/neotest-dotnet",
      "rouge8/neotest-rust",
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require "neotest-go",
          require "neotest-python",
          require "neotest-jest",
          require "neotest-dotnet",
          require "neotest-rust",
        },
      }
    end,
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },

  --  Shows a float panel with the [code coverage]
  --  https://github.com/andythigpen/nvim-coverage
  --
  --  Your project must generate coverage/lcov.info for this to work.
  --
  --  On jest, make sure your packages.json file has this:
  --  "tests": "jest --coverage"
  --
  --  If you use other framework or language, refer to nvim-coverage docs:
  --  https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
  {
    "andythigpen/nvim-coverage",
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageLoadLcov",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    config = function() require("coverage").setup() end,
    requires = { "nvim-lua/plenary.nvim" },
  },
}
