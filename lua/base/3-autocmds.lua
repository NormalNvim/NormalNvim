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
--       -> 13. Open Ranger on startup with directory.
--       -> 14. Cursor always centered
--       -> 15. Nvim user events for file detection (BaseFile and BaseGitFile).
--       -> 16. NVin updater commands.




-- 1. auto-hlsearch.nvim
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  end
end, namespace "auto_hlsearch")




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
    vim.t.bufs = vim.tbl_filter(require("base.utils.buffer").is_valid, vim.t.bufs)
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
    vim.t.bufs = vim.tbl_filter(require("base.utils.buffer").is_valid, vim.t.bufs)
    baseevent "BufsUpdated"
    vim.cmd.redrawtabline()
  end,
})




-- 4. URL highlighting
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  group = augroup("highlighturl", { clear = true }),
  pattern = "*",
  callback = function() utils.set_url_match() end,
})




-- 5. Save view with mkview for real files
local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(event)
    if vim.b[event.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
  end,
})




-- 6. Load file view if available. Enable view saving for real files.
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(event)
    if not vim.b[event.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
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
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
    if buftype == "nofile" or filetype == "help" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, nowait = true })
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
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
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
  local group_name = augroup("alpha_settings", { clear = true })
  autocmd({ "User", "BufEnter" }, {
    desc = "Disable status and tablines for alpha",
    group = group_name,
    callback = function(event)
      if
        (
          (event.event == "User" and event.file == "AlphaReady")
          or (event.event == "BufEnter" and vim.api.nvim_get_option_value("filetype", { buf = event.buf }) == "alpha")
        ) and not vim.g.before_alpha
      then
        vim.g.before_alpha = { showtabline = vim.opt.showtabline:get(), laststatus = vim.opt.laststatus:get() }
        vim.opt.showtabline, vim.opt.laststatus = 0, 0
      elseif
        vim.g.before_alpha
        and event.event == "BufEnter"
        and vim.api.nvim_get_option_value("buftype", { buf = event.buf }) ~= "nofile"
      then
        vim.opt.laststatus, vim.opt.showtabline = vim.g.before_alpha.laststatus, vim.g.before_alpha.showtabline
        vim.g.before_alpha = nil
      end
    end,
  })
  autocmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = group_name,
    callback = function()
      local should_skip = false
      if vim.fn.argc() > 0 or vim.fn.line2byte(vim.fn.line "$") ~= -1 or not vim.o.modifiable then
        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
            should_skip = true
            break
          end
        end
      end
      if not should_skip then require("alpha").start(true, require("alpha").default_config) end
    end,
  })
end




-- 12. Save session on close
if is_available "resession.nvim" then
  autocmd("VimLeavePre", {
    desc = "Save session on close",
    group = augroup("resession_auto_save", { clear = true }),
    callback = function(event)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      if not vim.tbl_contains({ "gitcommit", "gitrebase" }, filetype) then
        local save = require("resession").save
        save "Last Session"
        save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
      end
    end,
  })
end




-- Open Neo-Tree on startup with directory
-- if is_available "neo-tree.nvim" then
--   autocmd("BufEnter", {
--     desc = "Open Neo-Tree on startup with directory",
--     group = augroup("neotree_start", { clear = true }),
--     callback = function()
--       if package.loaded["neo-tree"] then
--         vim.api.nvim_del_augroup_by_name "neotree_start"
--       else
--         local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
--         if stats and stats.type == "directory" then
--           vim.api.nvim_del_augroup_by_name "neotree_start"
--           require "neo-tree"
--         end
--       end
--     end,
--   })
-- end




-- 13. Open Ranger on startup with directory
-- if is_available "neo-tree.nvim" then
--   autocmd("BufEnter", {
--     desc = "Open Neo-Tree on startup with directory",
--     group = augroup("neotree_start", { clear = true }),
--     callback = function()
--       if package.loaded["neo-tree"] then
--         vim.api.nvim_del_augroup_by_name "neotree_start"
--       else
--         local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
--         if stats and stats.type == "directory" then
--           vim.api.nvim_del_augroup_by_name "neotree_start"
--           require "neo-tree"
--         end
--       end
--     end,
--   })
-- end




-- 14. Cursor always centered
-- Warning: Using CursorMovedI
local cursor_group = augroup("cursor", { clear = true })
autocmd({ "CursorMoved", "BufEnter"}, {
  desc = "Keep cursor always centered",
  group = cursor_group,
  callback = function()
    vim.api.nvim_exec("norm zz", false)
    baseevent "CursorCentered"
  end,
})




-- 15. Nvim user events for file detection (BaseFile and BaseGitFile)
autocmd({ "BufReadPost", "BufNewFile" }, {
  desc = "Nvim user events for file detection (BaseFile and BaseGitFile)",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    if not (vim.fn.expand "%" == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      utils.event "File"
      if utils.cmd('git -C "' .. vim.fn.expand "%:p:h" .. '" rev-parse', false) then utils.event "GitFile" end
    end
  end,
})



-- 16. NVin updater commands
cmd(
  "NvimChangelog",
  function() require("base.utils.updater").changelog() end,
  { desc = "Check Nvim Changelog" }
)
cmd(
  "NVimUpdatePackages",
  function() require("base.utils.updater").update_packages() end,
  { desc = "Update Plugins and Mason" }
)
cmd("NVimRollback", function() require("base.utils.updater").rollback() end, { desc = "Rollback Nvim" })
cmd("NVimUpdate", function() require("base.utils.updater").update() end, { desc = "Update Nvim" })
cmd("NVimVersion", function() require("base.utils.updater").version() end, { desc = "Check Nvim Version" })
cmd("NVimReload", function() require("base.utils").reload() end, { desc = "Reload Nvim (Experimental)" })
