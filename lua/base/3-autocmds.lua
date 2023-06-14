-- Actions performed automatically

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local namespace = vim.api.nvim_create_namespace
local utils = require "base.utils"
local is_available = utils.is_available
local baseevent = utils.event

--    Sections:
--       -> 1. Auto-hlsearch.nvim.
--       -> 2. Update buffers when adding new buffers.
--       -> 3. Update buffers when deleting buffers.
--       -> 4. URL highlighting.
--       -> 5. Save view with mkview for real files.
--       -> 6. Load file view if available. Enable view saving for real files.
--       -> 7. Make q close help, man, quickfix, dap floats.
--       -> 8. Effect: Briefly flash on yank.
--       -> 9. Unlist quickfist buffers.
--       -> 10. Quit Nvim if >=1 window open and only sidebar windows are list.
--       -> 11. Open the greeter on opening vim.
--       -> 12. Save session on close.
--       -> 13. Open neotree in the current working directory
--       -> 14. At startup, open neotree and aerial.
--       -> 15. Auto reload.
--       -> 16. Disable right click contextual menu.
--       -> 17. Nvim user events for file detection (BaseFile and BaseGitFile).
--       -> 18. NVim updater commands.
--       -> 19. Neotest commands
--       ->     Extra commands

-- 1. hlsearch (serch highlighting)
-- vim.on_key(function(char)
--   if vim.fn.mode() == "n" then
--     local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
--     if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
--   end
-- end, namespace "auto_hlsearch")

-- 2. Update buffers when adding new buffers
local bufferline_group = augroup("bufferline", { clear = true })
autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
  desc = "Update buffers when adding new buffers",
  group = bufferline_group,
  callback = function(args)
    if not vim.t.bufs then vim.t.bufs = {} end
    local bufs = vim.t.bufs
    if not vim.tbl_contains(bufs, args.buf) then
      table.insert(bufs, args.buf)
      vim.t.bufs = bufs
    end
    vim.t.bufs =
      vim.tbl_filter(require("base.utils.buffer").is_valid, vim.t.bufs)
    baseevent "BufsUpdated"
  end,
})

-- 3. Update buffers when deleting buffers
autocmd("BufDelete", {
  desc = "Update buffers when deleting buffers",
  group = bufferline_group,
  callback = function(args)
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local bufs = vim.t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            table.remove(bufs, i)
            vim.t[tab].bufs = bufs
            break
          end
        end
      end
    end
    vim.t.bufs =
      vim.tbl_filter(require("base.utils.buffer").is_valid, vim.t.bufs)
    baseevent "BufsUpdated"
    vim.cmd.redrawtabline()
  end,
})

-- 4. URL highlighting
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("HighlightUrl", { clear = true }),
  callback = function() utils.set_url_match() end,
})

-- 5. Save view with mkview for real files
local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(event)
    if vim.b[event.buf].view_activated then
      vim.cmd.mkview { mods = { emsg_silent = true } }
    end
  end,
})

-- 6. Load file view if available. Enable view saving for real files.
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(event)
    if not vim.b[event.buf].view_activated then
      local filetype =
        vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      local buftype =
        vim.api.nvim_get_option_value("buftype", { buf = event.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if
        buftype == ""
        and filetype
        and filetype ~= ""
        and not vim.tbl_contains(ignore_filetypes, filetype)
      then
        vim.b[event.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})

-- 7. Make q close help, man, quickfix, dap floats
autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  group = augroup("q_close_windows", { clear = true }),
  callback = function(event)
    local filetype =
      vim.api.nvim_get_option_value("filetype", { buf = event.buf })
    local buftype =
      vim.api.nvim_get_option_value("buftype", { buf = event.buf })
    if buftype == "nofile" or filetype == "help" then
      vim.keymap.set(
        "n",
        "q",
        "<cmd>close<cr>",
        { buffer = event.buf, silent = true, nowait = true }
      )
    end
  end,
})

-- 8. Effect: Briefly flash on yank
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- 9. Unlist quickfist buffers
autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function() vim.opt_local.buflisted = false end,
})

-- 10. Quit Nvim if >=1 window open and only sidebar windows are list
autocmd("BufEnter", {
  desc = "Quit Nvim if more than one window is open and only sidebar windows are list",
  group = augroup("auto_quit", { clear = true }),
  callback = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    -- Both neo-tree and aerial will auto-quit if there is only a single window left
    if #wins <= 1 then return end
    local sidebar_fts = { aerial = true, ["neo-tree"] = true }
    for _, winid in ipairs(wins) do
      if vim.api.nvim_win_is_valid(winid) then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local filetype =
          vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        -- If any visible windows are not sidebars, early return
        if not sidebar_fts[filetype] then
          return
          -- If the visible window is a sidebar
        else
          -- only count filetypes once, so remove a found sidebar from the detection
          sidebar_fts[filetype] = nil
        end
      end
    end
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    else
      vim.cmd.qall()
    end
  end,
})

-- 11. Open the greeter on opening vim
if is_available "alpha-nvim" then
  autocmd({ "User", "BufEnter" }, {
    desc = "Disable status and tablines for alpha",
    group = augroup("alpha_settings", { clear = true }),
    callback = function(event)
      if
        (
          (event.event == "User" and event.file == "AlphaReady")
          or (
            event.event == "BufEnter"
            and vim.api.nvim_get_option_value(
                "filetype",
                { buf = event.buf }
              )
              == "alpha"
          )
        ) and not vim.g.before_alpha
      then
        vim.g.before_alpha = {
          showtabline = vim.opt.showtabline:get(),
          laststatus = vim.opt.laststatus:get(),
        }
        vim.opt.showtabline, vim.opt.laststatus = 0, 0
      elseif
        vim.g.before_alpha
        and event.event == "BufEnter"
        and vim.api.nvim_get_option_value("buftype", { buf = event.buf })
          ~= "nofile"
      then
        vim.opt.laststatus, vim.opt.showtabline =
          vim.g.before_alpha.laststatus, vim.g.before_alpha.showtabline
        vim.g.before_alpha = nil
      end
    end,
  })
  autocmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = augroup("alpha_autostart", { clear = true }),
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
      end
    end,
  })
end

-- 12. Save session on close
if is_available "resession.nvim" then
  autocmd("VimLeavePre", {
    desc = "Save session on close",
    group = augroup("resession_auto_save", { clear = true }),
    callback = function(event)
      local filetype =
        vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      if not vim.tbl_contains({ "gitcommit", "gitrebase" }, filetype) then
        local save = require("resession").save
        save "Last Session"
        save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
      end
    end,
  })
end

-- 13. Open Neo-Tree on startup with directory
if is_available "neo-tree.nvim" then
  autocmd("BufEnter", {
    desc = "Open Neo-Tree on startup with directory",
    group = augroup("neotree_start", { clear = true }),
    once = true,
    callback = function()
      if package.loaded["neo-tree"] then
        vim.api.nvim_del_augroup_by_name "neotree_start"
      else
        local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
        if stats and stats.type == "directory" then
          vim.api.nvim_del_augroup_by_name "neotree_start"
          require "neo-tree"
        end
      end
    end,
  })
  autocmd("TermClose", {
    pattern = { "*lazygit", "*gitui" },
    desc = "Refresh Neo-Tree git when closing lazygit/gitui",
    group = augroup("neotree_git_refresh", { clear = true }),
    callback = function()
      if package.loaded["neo-tree.sources.git_status"] then
        require("neo-tree.sources.git_status").refresh()
      end
    end,
  })
end

-- 15.  Auto reload.
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

-- 16.  Disable right click contextual menu warning message
autocmd("VimEnter", {
  desc = "Disable right contextual menu warning message",
  group = augroup("contextual_menu", { clear = true }),
  callback = function()
    vim.api.nvim_command [[aunmenu PopUp.How-to\ disable\ mouse]] -- Disable right click message
    vim.api.nvim_command [[aunmenu PopUp.-1-]] -- Disable right click message
  end,
})

-- 17. Nvim user events for file detection (BaseFile and BaseGitFile)
autocmd({ "BufReadPost", "BufNewFile" }, {
  desc = "Nvim user events for file detection (BaseFile and BaseGitFile)",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    if
      not (
        vim.fn.expand "%" == ""
        or vim.api.nvim_get_option_value("buftype", { buf = args.buf })
          == "nofile"
      )
    then
      utils.event "File"
      if
        utils.cmd('git -C "' .. vim.fn.expand "%:p:h" .. '" rev-parse', false)
      then
        utils.event "GitFile"
      end
    end
  end,
})

-- 18. Nvim updater commands
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

-- 19. Neotest commands
-- Neotest doesn't implement commands, so we do it here.
----------------------------------------------
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
