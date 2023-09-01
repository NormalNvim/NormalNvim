-- Autocmds file.
--
-- DESCRIPTION:
-- All autocmds are defined here.

--    Sections:
--
--       ## EXTRA LOGIC
--       -> 1. Events to load plugins faster.
--       -> 2. Save/restore window layout when possible.
--       -> 3. Launch alpha greeter on startup.
--       -> 4. Hot reload on config change.
--       -> 5. Update neotree when closing the git client.
--       -> 6. Java debugger.
--
--       ## COOL HACKS
--       -> 7. Effect: URL underline.
--       -> 8. Effect: Flash on yank.
--       -> 9. Customize right click contextual menu.
--       -> 10. Unlist quickfix buffers if the filetype changes.
--
--       ## COMMANDS
--       -> 11. Nvim updater commands.
--       -> 12. Neotest commands.
--       ->     Extra commands.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local utils = require "base.utils"
local is_available = utils.is_available

-- ## EXTRA LOGIC -----------------------------------------------------------
-- 1. Events to load plugins faster → 'BaseFile'/'BaseGitFile':
--    this is pretty much the same thing as the event 'BufEnter',
--    but without increasing the startup time displayed in the greeter.
autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  desc = "Nvim user events for file detection (BaseFile and BaseGitFile)",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    local empty_buffer = vim.fn.resolve(vim.fn.expand "%") == ""
    local greeter = vim.api.nvim_get_option_value("filetype", { buf = args.buf }) == "alpha"
    local git_repo = utils.cmd({ "git", "-C", vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand "%"), ":p:h"), "rev-parse" }, false)

    -- For any file exept empty buffer, or the greeter (alpha)
    if not (empty_buffer or greeter) then
      utils.event "File" -- Emit event 'BaseFile'

      -- Is the buffer part of a git repo?
      if git_repo then
        utils.event "GitFile" -- Emit event 'BaseGitFile'
        vim.api.nvim_del_augroup_by_name "file_user_events"
      end

    end
  end,
})

-- 2. Save/restore window layout when possible.
local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(args)
    if vim.b[args.buf].view_activated then
      vim.cmd.mkview { mods = { emsg_silent = true } }
    end
  end,
})
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype =
        vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      local buftype =
        vim.api.nvim_get_option_value("buftype", { buf = args.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if
        buftype == ""
        and filetype
        and filetype ~= ""
        and not vim.tbl_contains(ignore_filetypes, filetype)
      then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})

-- 3. Launch alpha greeter on startup
if is_available "alpha-nvim" then
  local alpha_group = augroup("alpha_settings", { clear = true })
  autocmd({ "User", "BufEnter" }, {
    desc = "Disable status and tablines for alpha",
    group = alpha_group,
    callback = function(args)
      local is_filetype_alpha = vim.api.nvim_get_option_value(
        "filetype", { buf = 0 }) == "alpha"
      local is_empty_file = vim.api.nvim_get_option_value(
        "buftype", { buf = 0 }) == "nofile"
      if((args.event == "User" and args.file == "AlphaReady") or
         (args.event == "BufEnter" and is_filetype_alpha)) and
        not vim.g.before_alpha
      then
        vim.g.before_alpha = {
          showtabline = vim.opt.showtabline:get(),
          laststatus = vim.opt.laststatus:get()
        }
        vim.opt.showtabline, vim.opt.laststatus = 0, 0
      elseif
        vim.g.before_alpha
        and args.event == "BufEnter"
        and not is_empty_file
      then
        vim.opt.laststatus = vim.g.before_alpha.laststatus
        vim.opt.showtabline = vim.g.before_alpha.showtabline
        vim.g.before_alpha = nil
      end
    end,
  })
  autocmd("VimEnter", {
    desc = "Start Alpha only when nvim is opened with no arguments",
    group = alpha_group,
    callback = function()
      local should_skip = false
      if
        vim.fn.argc() > 0
        or vim.fn.line2byte(vim.fn.line "$") ~= -1
        or not vim.o.modifiable
      then
        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if
            arg == "-b"
            or arg == "-c"
            or vim.startswith(arg, "+")
            or arg == "-S"
          then
            should_skip = true
            break
          end
        end
      end
      if not should_skip then
        require("alpha").start(true, require("alpha").default_config)
        vim.schedule(function() vim.cmd.doautocmd "FileType" end)
      end
    end,
  })
end

-- 4. Hot reload on config change.
autocmd({ "BufWritePost" }, {
  desc = "When writing a buffer, :NvimReload if the buffer is a config file.",
  group = augroup("reload_if_buffer_is_config_file", { clear = true }),
  callback = function()
    local filesThatTriggerReload = {
      vim.fn.stdpath "config" .. "lua/base/1-options.lua",
      vim.fn.stdpath "config" .. "lua/base/4-mappings.lua",
    }

    local bufPath = vim.fn.expand "%:p"
    for _, filePath in ipairs(filesThatTriggerReload) do
      if filePath == bufPath then vim.cmd "NvimReload" end
    end
  end,
})

-- 5. Update neotree when closin the git client.
if is_available "neo-tree.nvim" then
  autocmd("TermClose", {
    pattern = { "*lazygit", "*gitui" },
    desc = "Refresh Neo-Tree git when closing lazygit/gitui",
    group = augroup("neotree_git_refresh", { clear = true }),
    callback = function()
      local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
      if manager_avail then
        for _, source in ipairs {
          "filesystem",
          "git_status",
          "document_symbols",
        } do
          local module = "neo-tree.sources." .. source
          if package.loaded[module] then
            manager.refresh(require(module).name)
          end
        end
      end
    end,
  })
end

-- 6. Java debugger.
if is_available "nvim-dap" then
  autocmd("BufRead", {
    desc = "On java files, start jdtls",
    group = augroup("nvim_dap_java_jdtls", { clear = true }),
    callback = function()
      if vim.bo.filetype == "java" then
        local config = {
          cmd = { vim.fn.stdpath "data" .. "/mason/packages/jdtls/jdtls" },
          root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
          init_options = {
            bundles = {
              vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/java-test/extension/server/*.jar", true),
              vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
            },
          },
        }
        require("jdtls").start_or_attach(config)

        -- Give enough time for jdt to fully load the project, or it will fail with
        -- "No LSP client found"
        local timer = 2500
        for i = 0, 12, 1 do
          vim.defer_fn(
            function()
              test = require("jdtls.dap").setup_dap_main_class_configs()
            end,
            timer
          )
          timer = timer + 2500
        end
      end
    end,
  })
end

-- ## COOL HACKS ------------------------------------------------------------
-- 7. Effect: URL underline.
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("HighlightUrl", { clear = true }),
  callback = function() utils.set_url_effect() end,
})

-- 8. Effect: Flash on yank.
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- 9. Customize right click contextual menu.
autocmd("VimEnter", {
  desc = "Disable right contextual menu warning message",
  group = augroup("contextual_menu", { clear = true }),
  callback = function()
    -- Disable right click message
    vim.api.nvim_command [[aunmenu PopUp.How-to\ disable\ mouse]]
    -- vim.api.nvim_command [[aunmenu PopUp.-1-]] -- You can remode a separator like this.
    vim.api.nvim_command [[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]]
    vim.api.nvim_command [[menu PopUp.-2- <Nop>]]
    vim.api.nvim_command [[menu PopUp.Start\ \Compiler <cmd>:CompilerOpen<CR>]]
    vim.api.nvim_command [[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]]
    vim.api.nvim_command [[menu PopUp.Run\ \Test <cmd>:TestRunBlock<CR>]]

  end,
})

-- 10. Unlist quickfix buffers if the filetype changes.
autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function() vim.opt_local.buflisted = false end,
})



-- ## COMMANDS --------------------------------------------------------------
-- 11. Nvim updater commands
cmd(
  "NvimChangelog",
  function() require("base.utils.updater").changelog() end,
  { desc = "Check Nvim Changelog" }
)
cmd(
  "NvimUpdatePlugins",
  function() require("base.utils.updater").update_packages() end,
  { desc = "Update Plugins and Mason" }
)
cmd(
  "NvimRollbackCreate",
  function() require("base.utils.updater").create_rollback(true) end,
  { desc = "Create a rollback of '~/.config/nvim'." }
)
cmd(
  "NvimRollbackRestore",
  function() require("base.utils.updater").rollback() end,
  { desc = "Restores '~/.config/nvim' to the last rollbacked state." }
)
cmd(
  "NvimFreezePluginVersions",
  function() require("base.utils.updater").generate_snapshot(true) end,
  { desc = "Lock package versions (only lazy, not mason)." }
)
cmd(
  "NvimUpdateConfig", function() require("base.utils.updater").update() end,
  { desc = "Update Nvim distro" }
)
cmd(
  "NvimVersion",
  function() require("base.utils.updater").version() end,
  { desc = "Check Nvim distro Version" }
)
cmd(
  "NvimReload",
  function() require("base.utils").reload() end,
  { desc = "Reload Nvim without closing it (Experimental)" }
)

-- 12. Neotest commands
-- Neotest doesn't implement commands by default, so we do it here.
-------------------------------------------------------------------
cmd(
  "TestRunBlock",
  function() require("neotest").run.run() end,
  { desc = "Run the nearest test under the cursor" }
)

cmd(
  "TestStopBlock",
  function() require("neotest").run.stop() end,
  { desc = "Stopts the nearest test under the cursor" }
)

cmd(
  "TestRunFile",
  function() require("neotest").run.run(vim.fn.expand "%") end,
  { desc = "Run all tests in the test file" }
)

cmd(
  "TestDebugBlock",
  function() require("neotest").run.run { strategy = "dap" } end,
  { desc = "Debug the nearest test under the cursor using dap" }
)

-- Customize this command to work as you like
cmd("TestNodejs", function()
  vim.cmd ":ProjectRoot" -- cd the project root (requires project.nvim)
  vim.cmd ":TermExec cmd='npm run tests'" -- convention to run tests on nodejs
  -- You can generate code coverage by add this to your project's packages.json
  -- "tests": "jest --coverage"
end, { desc = "Run all unit tests for the current nodejs project" })

-- Customize this command to work as you like
cmd("TestNodejsE2e", function()
  vim.cmd ":ProjectRoot" -- cd the project root (requires project.nvim)
  vim.cmd ":TermExec cmd='npm run e2e'" -- Conventional way to call e2e in nodejs (requires ToggleTerm)
end, { desc = "Run e2e tests for the current nodejs project" })

-- Extra commands
----------------------------------------------

-- Change working directory
cmd("Cwd", function()
  vim.cmd ":cd %:p:h"
  vim.cmd ":pwd"
end, { desc = "cd current file's directory" })

-- Set working directory (alias)
cmd("Swd", function()
  vim.cmd ":cd %:p:h"
  vim.cmd ":pwd"
end, { desc = "cd current file's directory" })

-- Run a termimal command with ':Term ls' / ':T ls'
function TermExecAlias(...)
  local command = table.concat({...}, ' ')
  vim.cmd('TermExec cmd="' .. command .. '"')
end
vim.cmd('command! -nargs=* Term call v:lua.TermExecAlias(<q-args>)')
vim.cmd('command! -nargs=* T call v:lua.TermExecAlias(<q-args>)')
