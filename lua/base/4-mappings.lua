-- nvim keybindings (qwerty).
-- note that "../utils/lsp.lua" will always prevail over "mappings.lua".

--    Sections:
--
--       ## Base bindings
--       -> icons displayed on which-key.nvim
--       -> standard operations
--       -> clipboard
--       -> search highlighting
--       -> improved tabulation
--       -> improved gg
--       -> packages
--       -> buffers/tabs                       [buffers]
--       -> ui toggles                         [ui]
--       -> shifted movement keys
--
--       ## Plugin bindings
--       -> alpha-nvim
--       -> comments.nvim
--       -> git                                [git]
--       -> file browsers
--       -> session manager
--       -> smart-splits.nvim
--       -> aerial.nvim
--       -> telescope.nivm                     [find]
--       -> toggleterm.nvim
--       -> dap.nvim                           [debugger]
--       -> tests                              [tests]
--       -> nvim-ufo
--       -> code documentation                 [docs]
--       -> ask chatgpt                        [neural]
--       -> hop.nvim

--
--   KEYBINDINGS REFERENCE
--   -------------------------------------------------------------------
--   |        Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
--   Command        +------+-----+-----+-----+-----+-----+------+------+
--   [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
--   n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
--   [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
--   i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
--   c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
--   v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
--   x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
--   s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
--   o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
--   t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
--   l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
--   -------------------------------------------------------------------

local utils = require "base.utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local ui = require "base.utils.ui"

local maps = { i = {}, n = {}, v = {}, t = {} }

-- -------------------------------------------------------------------------
--
-- ## Base bindings ########################################################
--
-- -------------------------------------------------------------------------

-- icons displayed on which-key.nvim ---------------------------------------
local icons = {
  f = { desc = get_icon("Search", 1, true) .. "Find" },
  p = { desc = get_icon("Package", 1, true) .. "Packages" },
  l = { desc = get_icon("ActiveLSP", 1, true) .. "LSP" },
  u = { desc = get_icon("Window", 1, true) .. "UI" },
  b = { desc = get_icon("Tab", 1, true) .. "Buffers" },
  bs = { desc = get_icon("Sort", 1, true) .. "Sort Buffers" },
  d = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
  tt = { desc = get_icon("Test", 1, true) .. "Test" },
  dc = { desc = get_icon("Docs", 1, true) .. "Docs" },
  g = { desc = get_icon("Git", 1, true) .. "Git" },
  S = { desc = get_icon("Session", 1, true) .. "Session" },
  t = { desc = get_icon("Terminal", 1, true) .. "Terminal" },
  Q = { desc = get_icon("Terminal", 1, true) .. "Quarto" },
}

-- standard Operations -----------------------------------------------------
maps.n["j"] =
  { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] =
  { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>W"] =
  { function() vim.cmd "SudaWrite" end, desc = "Save as sudo" }
maps.n["<leader>n"] = { "<cmd>enew<cr>", desc = "New file" }
maps.n["gx"] =
  { utils.system_open, desc = "Open the file under cursor with system app" }
maps.n["<C-s>"] = { "<cmd>w!<cr>", desc = "Force write" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" }
maps.i["<C-BS>"] = { "<C-W>", desc = "Enable CTRL+backsace to delete." }
maps.n["0"] = { "^", desc = "Go to the fist character of the line (aliases 0 to ^)" }
maps.n["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["<leader>q"] = {
  function() require("base.utils").confirm_quit() end,
  desc = "Quit"
}
maps.n["<Tab>"] = {
  "<Tab>",
  noremap = true, silent = true, expr = false,
  desc = "FIX: Prevent TAB from behaving like <C-i>, as they share the same internal code"
}

-- clipboard ---------------------------------------------------------------
-- only useful when the option 'clipboard' is commented on ./1-options.lua
maps.n["<C-y>"] = { '"+y<esc>', desc = "Copy to cliboard" }
maps.v["<C-y>"] = { '"+y<esc>', desc = "Copy to cliboard" }
maps.n["<C-d>"] = { '"+y<esc>dd', desc = "Copy to clipboard and delete line" }
maps.v["<C-d>"] = { '"+y<esc>dd', desc = "Copy to clipboard and delete line" }
maps.n["<C-p>"] = { '"+p<esc>', desc = "Paste from cliboard" }

-- Make 'x' key not copy to clipboard when depeting a character.
maps.n["x"] = {
  -- Also let's allow 'x' key to delete blank lines in normal mode.
  function()
    if vim.fn.col "." == 1 then
      local line = vim.fn.getline "."
      if line:match "^%s*$" then
        vim.api.nvim_feedkeys("dd", "n", false)
        vim.api.nvim_feedkeys("$", "n", false)
      else
        vim.api.nvim_feedkeys('"_x', "n", false)
      end
    else
      vim.api.nvim_feedkeys('"_x', "n", false)
    end
  end,
  desc = "Delete character without yanking it.",
}
maps.v["x"] = { '"_x', desc = "Delete character without yanking it." }

-- Override nvim default behavior so it doesn't auto-yank when pasting on visual mode.
maps.v["p"] = { "P", desc = "Paste content you've previourly yanked" }
maps.v["P"] = { "p", desc = "Yank what you are going to override, then paste" }

-- search highlighing ------------------------------------------------------
-- use ESC to clear hlsearch, while preserving its original functionality.
--
-- TIP: If you prefer,  use <leader>ENTER instead of <ESC>
--      to avoid triggering it by accident.
maps.n["<ESC>"] = {
  function()
    if vim.fn.hlexists "Search" then
      vim.cmd "nohlsearch"
    else
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<ESC>", true, true, true),
        "n",
        true
      )
    end
  end,
}

-- Improved tabulation ------------------------------------------------------
maps.v["<S-Tab>"] = { "<gv", desc = "unindent line" }
maps.v["<Tab>"] = { ">gv", desc = "indent line" }
maps.v["<"] = { "<gv", desc = "unindent line" }
maps.v[">"] = { ">gv", desc = "indent line" }

-- improved gg --------------------------------------------------------------
maps.n["gg"] = {
  function()
    vim.g.minianimate_disable = true
    if vim.v.count > 0 then vim.cmd("normal! " .. vim.v.count .. "gg")
    else vim.cmd("normal! gg0") end
    vim.g.minianimate_disable = false
  end,
  desc = "gg and go to the first position"
}
maps.n["G"] = {
  function()
    vim.g.minianimate_disable = true
    vim.cmd("normal! G$")
    vim.g.minianimate_disable = false
  end,
  desc = "G and go to the last position" }
maps.v["gg"] = {
  function()
    vim.g.minianimate_disable = true
    if vim.v.count > 0 then vim.cmd("normal! " .. vim.v.count .. "gg")
    else vim.cmd("normal! gg0") end
    vim.g.minianimate_disable = false
  end,
  desc = "gg and go to the first position (visual)"
}
maps.v["G"] = {
  function()
    vim.g.minianimate_disable = true
    vim.cmd("normal! G$")
    vim.g.minianimate_disable = false
  end,
  desc = "G and go to the last position (visual)"
}
maps.n["<C-a>"] = { -- to move to the previous position press ctrl + oo
  function()
    vim.g.minianimate_disable = true
    vim.cmd("normal! gg0vG$")
    vim.g.minianimate_disable = false
  end,
  desc = "Visually select all"
}

-- packages -----------------------------------------------------------------
-- lazy
maps.n["<leader>p"] = icons.p
maps.n["<leader>pi"] =
  { function() require("lazy").install() end, desc = "Plugins Install" }
maps.n["<leader>ps"] =
  { function() require("lazy").home() end, desc = "Plugins Status" }
maps.n["<leader>pS"] =
  { function() require("lazy").sync() end, desc = "Plugins Sync" }
maps.n["<leader>pu"] =
  { function() require("lazy").check() end, desc = "Plugins Check Updates" }
maps.n["<leader>pU"] =
  { function() require("lazy").update() end, desc = "Plugins Update" }

-- mason
if is_available "mason.nvim" then
  maps.n["<leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
  maps.n["<leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }
end

-- nvim updater
maps.n["<leader>pa"] =
  { "<cmd>NvimUpdatePackages<cr>", desc = "Update Plugins and Mason" }
maps.n["<leader>pA"] = { "<cmd>NvimUpdate<cr>", desc = "Nvim Update" }
maps.n["<leader>pv"] = { "<cmd>NvimVersion<cr>", desc = "Nvim Version" }
maps.n["<leader>pl"] = { "<cmd>NvimChangelog<cr>", desc = "Nvim Changelog" }

-- buffers/tabs [buffers ]--------------------------------------------------
maps.n["<leader>bc"] = { -- Close buffer keeping the window.
  function() require("base.utils.buffer").close() end,
  desc = "Close buffer",
}
 -- Close buffer keeping the window → Without confirmation.
-- maps.n["<leader>X"] = {
--   function() require("base.utils.buffer").close(0, true) end,
--   desc = "Force close buffer",
-- }
maps.n["]b"] = {
  function()
    require("base.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Next buffer",
}
maps.n["[b"] = {
  function()
    require("base.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Previous buffer",
}
maps.n[">b"] = {
  function()
    require("base.utils.buffer").move(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Move buffer tab right",
}
maps.n["<b"] = {
  function()
    require("base.utils.buffer").move(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Move buffer tab left",
}

maps.n["<leader>b"] = icons.b
maps.n["<leader>ba"] = {
  function() require("base.utils.buffer").close_all(true) end,
  desc = "Close all buffers except current",
}
maps.n["<leader>bC"] = {
  function() require("base.utils.buffer").close_all() end,
  desc = "Close all buffers",
}
maps.n["<leader>bb"] = {
  function()
    require("base.utils.status").heirline.buffer_picker(
      function(bufnr) vim.api.nvim_win_set_buf(0, bufnr) end
    )
  end,
  desc = "Select buffer from tabline",
}
maps.n["<leader>bd"] = {
  function()
    require("base.utils.status").heirline.buffer_picker(
      function(bufnr) require("base.utils.buffer").close(bufnr) end
    )
  end,
  desc = "Delete buffer from tabline",
}
maps.n["<leader>bl"] = {
  function() require("base.utils.buffer").close_left() end,
  desc = "Close all buffers to the left",
}
maps.n["<leader>br"] = {
  function() require("base.utils.buffer").close_right() end,
  desc = "Close all buffers to the right",
}
maps.n["<leader>bs"] = icons.bs
maps.n["<leader>bse"] = {
  function() require("base.utils.buffer").sort "extension" end,
  desc = "Sort by extension (buffers)",
}
maps.n["<leader>bsr"] = {
  function() require("base.utils.buffer").sort "unique_path" end,
  desc = "Sort by relative path (buffers)",
}
maps.n["<leader>bsp"] = {
  function() require("base.utils.buffer").sort "full_path" end,
  desc = "Sort by full path (buffers)",
}
maps.n["<leader>bsi"] = {
  function() require("base.utils.buffer").sort "bufnr" end,
  desc = "Sort by buffer number (buffers)",
}
maps.n["<leader>bsm"] = {
  function() require("base.utils.buffer").sort "modified" end,
  desc = "Sort by modification (buffers)",
}
maps.n["<leader>b\\"] = {
  function()
    require("base.utils.status").heirline.buffer_picker(function(bufnr)
      vim.cmd.split()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Horizontal split buffer from tabline",
}
maps.n["<leader>b|"] = {
  function()
    require("base.utils.status").heirline.buffer_picker(function(bufnr)
      vim.cmd.vsplit()
      vim.api.nvim_win_set_buf(0, bufnr)
    end)
  end,
  desc = "Vertical split buffer from tabline",
}

-- quick movement aliases
maps.n["<C-k>"] = {
  function()
    require("base.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
  end,
  desc = "Next buffer",
}
maps.n["<C-j>"] = {
  function()
    require("base.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
  end,
  desc = "Previous buffer",
}

-- tabs
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }

-- zen mode
if is_available "zen-mode.nvim" then
  maps.n["<leader>bz"] =
    { function() vim.cmd "ZenMode" end, desc = "Zen mode" }
end

-- ui toggles [ui ]---------------------------------------------------------
maps.n["<leader>u"] = icons.u
if is_available "nvim-autopairs" then
  maps.n["<leader>ua"] = { ui.toggle_autopairs, desc = "Toggle autopairs" }
end
maps.n["<leader>ub"] = { ui.toggle_background, desc = "Toggle background" }
if is_available "nvim-cmp" then
  maps.n["<leader>uc"] = { ui.toggle_cmp, desc = "Toggle autocompletion" }
end
if is_available "nvim-colorizer.lua" then
  maps.n["<leader>uC"] =
    { "<cmd>ColorizerToggle<cr>", desc = "Toggle color highlight" }
end
maps.n["<leader>ud"] = { ui.toggle_diagnostics, desc = "Toggle diagnostics" }
maps.n["<leader>ug"] = { ui.toggle_signcolumn, desc = "Toggle signcolumn" }
maps.n["<leader>ui"] = { ui.set_indent, desc = "Change indent setting" }
maps.n["<leader>ul"] = { ui.toggle_statusline, desc = "Toggle statusline" }
maps.n["<leader>uL"] = { ui.toggle_codelens, desc = "Toggle CodeLens" }
maps.n["<leader>un"] = { ui.change_number, desc = "Change line numbering" }
maps.n["<leader>uN"] =
  { ui.toggle_ui_notifications, desc = "Toggle UI notifications" }
maps.n["<leader>up"] = { ui.toggle_paste, desc = "Toggle paste mode" }
maps.n["<leader>us"] = { ui.toggle_spell, desc = "Toggle spellcheck" }
maps.n["<leader>uS"] = { ui.toggle_conceal, desc = "Toggle conceal" }
maps.n["<leader>ut"] = { ui.toggle_tabline, desc = "Toggle tabline" }
maps.n["<leader>uu"] = { ui.toggle_url_match, desc = "Toggle URL highlight" }
maps.n["<leader>uw"] = { ui.toggle_wrap, desc = "Toggle wrap" }
maps.n["<leader>uy"] = { ui.toggle_syntax, desc = "Toggle syntax highlight" }
maps.n["<leader>uh"] = { ui.toggle_foldcolumn, desc = "Toggle foldcolumn" }
maps.n["<leader>ua"] = {
  function()
    if vim.g.minianimate_disable then
      vim.g.minianimate_disable = false
    else
      vim.g.minianimate_disable = true
    end
  end,
  desc = "Toggle animations",
}

-- fast movement (shifted) -------------------------------------------------
maps.n["<S-Down>"] = {
  function() vim.api.nvim_feedkeys("7j", "n", true) end,
  desc = "Fast move down",
}
maps.n["<S-Up>"] = {
  function() vim.api.nvim_feedkeys("7k", "n", true) end,
  desc = "Fast move up",
}
maps.n["<S-PageDown>"] = {
  function()
    local current_line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
    local target_line = current_line + 1 + math.floor(total_lines * 0.20)
    if target_line > total_lines then target_line = total_lines end
    vim.api.nvim_win_set_cursor(0, {target_line, 0})
    vim.cmd('normal! zz')  end,
  desc = "Page down exactly a 20% of the total size of the buffer",
}
maps.n["<S-PageUp>"] = {
  function()
    local current_line = vim.fn.line('.')
    local target_line = current_line - 1 - math.floor(vim.fn.line('$') * 0.20)
    if target_line < 1 then target_line = 1 end
    vim.api.nvim_win_set_cursor(0, {target_line, 0})
    vim.cmd('normal! zz')
  end,
  desc = "Page up exactly 20% of the total size of the buffer",
}


-- -------------------------------------------------------------------------
--
-- ## Plugin bindings
--
-- -------------------------------------------------------------------------

-- alpha-nvim --------------------------------------------------------------
if is_available "alpha-nvim" then
  maps.n["<leader>h"] = {
    function()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      if
        #wins > 1
        and vim.api.nvim_get_option_value("filetype", { win = wins[1] })
          == "neo-tree"
      then
        vim.fn.win_gotoid(wins[2]) -- go to non-neo-tree window to toggle alpha
      end
      require("alpha").start(false, require("alpha").default_config)
    end,
    desc = "Home screen",
  }
end

-- comment.nvim -------------------------------------------------------------
if is_available "Comment.nvim" then
  maps.n["<leader>/"] = {
    function()
      require("Comment.api").toggle.linewise.count(
        vim.v.count > 0 and vim.v.count or 1
      )
    end,
    desc = "Comment line",
  }
  maps.v["<leader>/"] = {
    "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<cr>",
    desc = "Toggle comment line",
  }
end

-- [git] -----------------------------------------------------------
-- gitsigns.nvim
maps.n["<leader>g"] = icons.g
if is_available "gitsigns.nvim" then
  maps.n["<leader>g"] = icons.g
  maps.n["]g"] =
    { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
  maps.n["[g"] = {
    function() require("gitsigns").prev_hunk() end,
    desc = "Previous Git hunk",
  }
  maps.n["<leader>gl"] = {
    function() require("gitsigns").blame_line() end,
    desc = "View Git blame",
  }
  maps.n["<leader>gL"] = {
    function() require("gitsigns").blame_line { full = true } end,
    desc = "View full Git blame",
  }
  maps.n["<leader>gp"] = {
    function() require("gitsigns").preview_hunk() end,
    desc = "Preview Git hunk",
  }
  maps.n["<leader>gh"] = {
    function() require("gitsigns").reset_hunk() end,
    desc = "Reset Git hunk",
  }
  maps.n["<leader>gr"] = {
    function() require("gitsigns").reset_buffer() end,
    desc = "Reset Git buffer",
  }
  maps.n["<leader>gs"] = {
    function() require("gitsigns").stage_hunk() end,
    desc = "Stage Git hunk",
  }
  maps.n["<leader>gS"] = {
    function() require("gitsigns").stage_buffer() end,
    desc = "Stage Git buffer",
  }
  maps.n["<leader>gu"] = {
    function() require("gitsigns").undo_stage_hunk() end,
    desc = "Unstage Git hunk",
  }
  maps.n["<leader>gd"] = {
    function() require("gitsigns").diffthis() end,
    desc = "View Git diff",
  }
end
-- git fugitive
if is_available "vim-fugitive" then
  maps.n["<leader>gP"] = {
    function() vim.cmd ":GBrowse" end,
    desc = "Open in github ",
  }
end
-- git client
if vim.fn.executable "lazygit" == 1 then -- if lazygit exists, show it
  maps.n["<leader>gg"] = {
    function()
      local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
      if git_dir ~= "" then
        utils.toggle_term_cmd "lazygit"
      else
        utils.notify("Not a git repository", 4)
      end
    end,
    desc = "ToggleTerm lazygit",
  }
end
if vim.fn.executable "gitui" == 1 then -- if gitui exists, show it
  maps.n["<leader>gg"] = {
    function()
      local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
      if git_dir ~= "" then
        if vim.fn.executable "keychain" == 1 then
          vim.cmd 'TermExec cmd="eval `keychain --eval ~/.ssh/github.key` && gitui && exit"'
        else
          vim.cmd "TermExec cmd='gitui && exit'"
        end
      else
        utils.notify("Not a git repository", 4)
      end
    end,
    desc = "ToggleTerm gitui",
  }
end

-- file browsers ------------------------------------
-- ranger
if is_available "rnvimr" then
  maps.n["<leader>r"] = { "<cmd>RnvimrToggle<cr>", desc = "Ranger" }
end

-- neotree
if is_available "neo-tree.nvim" then
  maps.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle neotree" }
  maps.n["<leader>o"] = {
    function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd "p"
      else
        vim.cmd.Neotree "focus"
      end
    end,
    desc = "Toggle Neotree Focus",
  }
end

-- session manager ---------------------------------------------------------
if is_available "neovim-session-manager" then
  maps.n["<leader>S"] = icons.S
  maps.n["<leader>Sl"] = {
    "<cmd>SessionManager! load_last_session<cr>",
    desc = "Load last session",
  }
  maps.n["<leader>Ss"] = {
    "<cmd>SessionManager! save_current_session<cr>",
    desc = "Save this session",
  }
  maps.n["<leader>Sd"] =
    { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
  maps.n["<leader>Sf"] =
    { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
  maps.n["<leader>S."] = {
    "<cmd>SessionManager! load_current_dir_session<cr>",
    desc = "Load current directory session",
  }
end
if is_available "resession.nvim" then
  maps.n["<leader>S"] = icons.S
  maps.n["<leader>Sl"] = {
    function() require("resession").load "Last Session" end,
    desc = "Load last session",
  }
  maps.n["<leader>Ss"] =
    { function() require("resession").save() end, desc = "Save this session" }
  maps.n["<leader>St"] = {
    function() require("resession").save_tab() end,
    desc = "Save this tab's session",
  }
  maps.n["<leader>Sd"] =
    { function() require("resession").delete() end, desc = "Delete a session" }
  maps.n["<leader>Sf"] =
    { function() require("resession").load() end, desc = "Load a session" }
  maps.n["<leader>S."] = {
    function()
      require("resession").load(vim.fn.getcwd(), { dir = "dirsession" })
    end,
    desc = "Load current directory session",
  }
end

-- smart-splits.nivm
if is_available "smart-splits.nvim" then
  maps.n["<S-h>"] = {
    function() require("smart-splits").move_cursor_left() end,
    desc = "Move to left split",
  }
  maps.n["<S-j>"] = {
    function() require("smart-splits").move_cursor_down() end,
    desc = "Move to below split",
  }
  maps.n["<S-k>"] = {
    function() require("smart-splits").move_cursor_up() end,
    desc = "Move to above split",
  }
  maps.n["<S-l>"] = {
    function() require("smart-splits").move_cursor_right() end,
    desc = "Move to right split",
  }
  maps.n["<S-Up>"] = {
    function() require("smart-splits").resize_up() end,
    desc = "Resize split up",
  }
  maps.n["<S-Down>"] = {
    function() require("smart-splits").resize_down() end,
    desc = "Resize split down",
  }
  maps.n["<S-Left>"] = {
    function() require("smart-splits").resize_left() end,
    desc = "Resize split left",
  }
  maps.n["<S-Right>"] = {
    function() require("smart-splits").resize_right() end,
    desc = "Resize split right",
  }
else
  maps.n["<S-h>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<S-j>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<S-k>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<S-l>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<S-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<S-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<S-Left>"] =
    { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<S-Right>"] =
    { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
end

-- aerial.nvimm ------------------------------------------------------------
if is_available "aerial.nvim" then
  maps.n["<leader>l"] = icons.l
  maps.n["<leader>lS"] =
    { function() require("aerial").toggle() end, desc = "Toggle symbols tree" }
end

-- telescope.nvim [find] ----------------------------------------------------
if is_available "telescope.nvim" then
  maps.n["<leader>f"] = icons.f
  maps.n["<leader>gb"] = {
    function() require("telescope.builtin").git_branches() end,
    desc = "Git branches",
  }
  maps.n["<leader>gc"] = {
    function() require("telescope.builtin").git_commits() end,
    desc = "Git commits",
  }
  maps.n["<leader>gt"] = {
    function() require("telescope.builtin").git_status() end,
    desc = "Git status",
  }
  maps.n["<leader>f<CR>"] = {
    function() require("telescope.builtin").resume() end,
    desc = "Resume previous search",
  }
  maps.n["<leader>f'"] = {
    function() require("telescope.builtin").marks() end,
    desc = "Find marks",
  }
  maps.n["<leader>fa"] = {
    function()
      local cwd = vim.fn.stdpath "config" .. "/.."
      local search_dirs = { vim.fn.stdpath "config" }
      if #search_dirs == 1 then cwd = search_dirs[1] end -- if only one directory, focus cwd
      require("telescope.builtin").find_files {
        prompt_title = "Config Files",
        search_dirs = search_dirs,
        cwd = cwd,
      } -- call telescope
    end,
    desc = "Find nvim config files",
  }
  maps.n["<leader>fB"] = {
    function() require("telescope.builtin").buffers() end,
    desc = "Find buffers",
  }
  maps.n["<leader>fw"] = {
    function() require("telescope.builtin").grep_string() end,
    desc = "Find word under cursor in project",
  }
  maps.n["<leader>fC"] = {
    function() require("telescope.builtin").commands() end,
    desc = "Find commands",
  }
  -- Let's disable this. It is way too imprecise. Use rnvimr instead.
  -- maps.n["<leader>ff"] = {
  --   function()
  --     require("telescope.builtin").find_files { hidden = true, no_ignore = true }
  --   end,
  --   desc = "Find all files",
  -- }
  -- maps.n["<leader>fF"] = {
  --   function() require("telescope.builtin").find_files() end,
  --   desc = "Find files (no hidden)",
  -- }
  maps.n["<leader>fh"] = {
    function() require("telescope.builtin").help_tags() end,
    desc = "Find help",
  }
  maps.n["<leader>fk"] = {
    function() require("telescope.builtin").keymaps() end,
    desc = "Find keymaps",
  }
  maps.n["<leader>fm"] = {
    function() require("telescope.builtin").man_pages() end,
    desc = "Find man",
  }
  if is_available "nvim-notify" then
    maps.n["<leader>fn"] = {
      function() require("telescope").extensions.notify.notify() end,
      desc = "Find notifications",
    }
  end
  maps.n["<leader>fo"] = {
    function() require("telescope.builtin").oldfiles() end,
    desc = "Find recent",
  }
  maps.n["<leader>fv"] = {
    function() require("telescope.builtin").registers() end,
    desc = "Find vim registers",
  }
  maps.n["<leader>ft"] = {
    function()
      -- load color schemes before listing them
      pcall(vim.api.nvim_command, "doautocmd User LoadColorSchemes")

      -- Open telescope
      pcall(require("telescope.builtin").colorscheme, { enable_preview = true })

      -- Refresh heirline by manually triggeing its autocmd group.
      pcall(vim.api.nvim_command, "doautocmd Heirline")
    end,
    desc = "Find themes",
  }
  maps.n["<leader>ff"] = {
    function()
      require("telescope.builtin").live_grep {
        additional_args = function(args)
          return vim.list_extend(args, { "--hidden", "--no-ignore" })
        end,
      }
    end,
    desc = "Find words in project",
  }
  maps.n["<leader>fF"] = {
    function() require("telescope.builtin").live_grep() end,
    desc = "Find words in project (no hidden)",
  }

  -- Some lsp keymappings are here because they depend on telescope
  maps.n["<leader>l"] = icons.l
  maps.n["<leader>lt"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end

    end,
    desc = "Search symbols",
  }

  -- extra - project.nvim
  if is_available "project.nvim" then
    maps.n["<leader>fp"] = {
      function() vim.cmd "Telescope projects" end,
      desc = "Find project",
    }
  end

  -- extra - spectre.nvim (search and replace in project)
  if is_available "nvim-spectre" then
    maps.n["<leader>fr"] = {
      function() require("spectre").toggle() end,
      desc = "Toggle find and replace word in project",
    }
    maps.n["<leader>fb"] = {
      function() require("spectre").toggle({path=vim.fn.expand('%:t:p')}) end,
      desc = "Toggle find and replace word in buffer",
    }
  end

  -- extra - luasnip
  if is_available "LuaSnip" and is_available "telescope-luasnip.nvim" then
    maps.n["<leader>fs"] = {
      function() require("telescope").extensions.luasnip.luasnip {} end,
      desc = "Find snippets",
    }
  end

  -- extra - nvim-neoclip (neovim internal clipboard)
  --         Specially useful if you disable the shared clipboard in options.
  if is_available "nvim-neoclip.lua" then
    maps.n["<leader>fc"] = {
      function() require("telescope").extensions.neoclip.default() end,
      desc = "Find recorded macros",
    }
    maps.n["<leader>fq"] = {
      function() require("telescope").extensions.macroscope.default() end,
      desc = "Find recorded macros",
    }
  end

  -- extra - undotree
  if is_available "telescope-undo.nvim" then
    maps.n["<leader>fu"] = {
      function() require("telescope").extensions.undo.undo() end,
      desc = "Find in undo tree",
    }
  end
end

-- toggleterm.nvim ----------------------------------------------------------
if is_available "toggleterm.nvim" then
  maps.n["<leader>t"] = icons.t
  maps.n["<leader>tt"] =
    { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
  maps.n["<leader>th"] = {
    "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
    desc = "Toggleterm horizontal split",
  }
  maps.n["<leader>tv"] = {
    "<cmd>ToggleTerm size=80 direction=vertical<cr>",
    desc = "Toggleterm vertical split",
  }
  maps.n["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
  maps.t["<F7>"] = maps.n["<F7>"]
  maps.n["<C-'>"] = maps.n["<F7>"] -- requires terminal that supports binding <C-'>
  maps.t["<C-'>"] = maps.n["<F7>"] -- requires terminal that supports binding <C-'>
end

-- extra - improved terminal navigation
maps.t["<C-h>"] =
  { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
maps.t["<C-j>"] =
  { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
maps.t["<C-k>"] =
  { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
maps.t["<C-l>"] =
  { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

-- dap.nvim [debugger] -----------------------------------------------------
if is_available "nvim-dap" then
  maps.n["<leader>d"] = icons.d
  maps.v["<leader>d"] = icons.d
  -- modified function keys found with `showkey -a` in the terminal to get key code
  -- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
  maps.n["<F5>"] =
    { function() require("dap").continue() end, desc = "Debugger: Start" }
  maps.n["<F17>"] =
    { function() require("dap").terminate() end, desc = "Debugger: Stop" } -- Shift+F5
  maps.n["<F21>"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Debugger: Conditional Breakpoint",
  }
  maps.n["<F29>"] = {
    function() require("dap").restart_frame() end,
    desc = "Debugger: Restart",
  } -- Control+F5
  maps.n["<F6>"] =
    { function() require("dap").pause() end, desc = "Debugger: Pause" }
  maps.n["<F9>"] = {
    function() require("dap").toggle_breakpoint() end,
    desc = "Debugger: Toggle Breakpoint",
  }
  maps.n["<F10>"] =
    { function() require("dap").step_over() end, desc = "Debugger: Step Over" }
  maps.n["<F11>"] =
    { function() require("dap").step_into() end, desc = "Debugger: Step Into" }
  maps.n["<F23>"] =
    { function() require("dap").step_out() end, desc = "Debugger: Step Out" } -- Shift+F11
  maps.n["<leader>db"] = {
    function() require("dap").toggle_breakpoint() end,
    desc = "Toggle Breakpoint (F9)",
  }
  maps.n["<leader>dB"] = {
    function() require("dap").clear_breakpoints() end,
    desc = "Clear Breakpoints",
  }
  maps.n["<leader>dc"] =
    { function() require("dap").continue() end, desc = "Start/Continue (F5)" }
  maps.n["<leader>dC"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Conditional Breakpoint (S-F9)",
  }
  maps.n["<leader>di"] =
    { function() require("dap").step_into() end, desc = "Step Into (F11)" }
  maps.n["<leader>do"] =
    { function() require("dap").step_over() end, desc = "Step Over (F10)" }
  maps.n["<leader>dO"] =
    { function() require("dap").step_out() end, desc = "Step Out (S-F11)" }
  maps.n["<leader>dq"] =
    { function() require("dap").close() end, desc = "Close Session" }
  maps.n["<leader>dQ"] = {
    function() require("dap").terminate() end,
    desc = "Terminate Session (S-F5)",
  }
  maps.n["<leader>dp"] =
    { function() require("dap").pause() end, desc = "Pause (F6)" }
  maps.n["<leader>dr"] =
    { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" }
  maps.n["<leader>dR"] =
    { function() require("dap").repl.toggle() end, desc = "Toggle REPL" }
  maps.n["<leader>ds"] =
    { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" }

  if is_available "nvim-dap-ui" then
    maps.n["<leader>dE"] = {
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then require("dapui").eval(expr) end
        end)
      end,
      desc = "Evaluate Input",
    }
    maps.v["<leader>dE"] =
      { function() require("dapui").eval() end, desc = "Evaluate Input" }
    maps.n["<leader>du"] =
      { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" }
    maps.n["<leader>dh"] = {
      function() require("dap.ui.widgets").hover() end,
      desc = "Debugger Hover",
    }
  end
end

-- testing [tests] -------------------------------------------------
-- neotest
maps.n["<leader>T"] = icons.tt
maps.v["<leader>T"] = icons.tt
if is_available "neotest" then
  maps.n["<leader>Tu"] = {
    function() require("neotest").run.run() end,
    desc = "Unit",
  }
  maps.n["<leader>Ts"] = {
    function() require("neotest").run.stop() end,
    desc = "Stop unit",
  }
  maps.n["<leader>Tf"] = {
    function() require("neotest").run.run(vim.fn.expand "%") end,
    desc = "File",
  }
  maps.n["<leader>Td"] = {
    function() require("neotest").run.run { strategy = "dap" } end,
    desc = "Unit in debugger",
  }
end

-- Extra - nvim-coverage
--         Your project must generate coverage/lcov.info for this to work.
--
--         On jest, make sure your packages.json file has this:
--         "test": "jest --coverage"
--
--         If you use other framework or language, refer to nvim-coverage docs:
--         https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
if is_available "nvim-coverage" then
  maps.n["<leader>Tc"] = {
    function()
      utils.notify(
        "Attemping to find coverage/lcov.info in project root...",
        3
      )
      require("coverage").load(false)
      require("coverage").summary()
    end,
    desc = "Toggle Coverage",
  }
end

-- Extra - nodejs testing commands
maps.n["<leader>Ta"] = {
  function() vim.cmd "TestNodejs" end,
  desc = "All",
}
maps.n["<leader>Te"] = {
  function() vim.cmd "TestNodejsE2e" end,
  desc = "E2e",
}

-- nvim-ufo [code folding] --------------------------------------------------
if is_available "nvim-ufo" then
  maps.n["zR"] =
    { function() require("ufo").openAllFolds() end, desc = "Open all folds" }
  maps.n["zM"] =
    { function() require("ufo").closeAllFolds() end, desc = "Close all folds" }
  maps.n["zr"] = {
    function() require("ufo").openFoldsExceptKinds() end,
    desc = "Fold less",
  }
  maps.n["zm"] =
    { function() require("ufo").closeFoldsWith() end, desc = "Fold more" }
  maps.n["zp"] = {
    function() require("ufo").peekFoldedLinesUnderCursor() end,
    desc = "Peek fold",
  }
end

-- code docmentation [docs] -------------------------------------------------

if is_available "markdown-preview.nivm" or is_available "markmap.nvim" then
  maps.n["<leader>D"] = icons.dc

  -- Markdown preview
  if is_available "markdown-preview.nvim" then
    maps.n["<leader>Dp"] = {
      function() vim.cmd "MarkdownPreview" end,
      desc = "Markdown preview",
    }
  end

  -- Markdown Mindmap
  if is_available "markmap.nvim" then
    maps.n["<leader>Dm"] = {
      function() vim.cmd "MarkmapOpen" end,
      desc = "Markmap",
    }
  end
end

-- dooku.nvim → Enable it once ported to lua
-- if is_available "markmap.nvim" then
--   maps.n["<leader>Dm"] = {
--     function() vim.cmd ":MarkmapOpen" end,
--     desc = "Markdown mental map",
--   }
-- end

--- [quarto] ------------
maps.n["<leader>Q"] = icons.Q
maps.n["<leader>Qa"] = {
  "<cmd>QuartoActivate<cr>",
  desc = "Activate Quarto"
}
if is_available("quarto-nvim") then
  maps.n["<leader>Qp"] = {
    "<cmd>QuartoPreview<cr>",
    desc = "Preview Quarto"
  }
  maps.n["<leader>Qq"] = {
    "<cmd>QuartoClosePreview<cr>",
    desc = "Close Quarto"
  }
  maps.n["<leader>Qh"] = {
    "<cmd>QuartoHelp<cr>",
    desc = "Quarto Help"
  }
  maps.n["<leader>Qe"] = {
    function () require('otter').export(false) end,
    desc = "Quarto Export"
  }
  maps.n["<leader>QE"] = {
    function () require('otter').export(true) end,
    desc = "Quarto Export Overwrite"
  }
  maps.n["<leader>Qra"] = {
    "<cmd>QuartoSendAbove<cr>",
    desc = "quarto run to cursor"
  }
  maps.n["<leader>Qrr"] = {
    "<cmd>QuartoSendAll<cr>",
    desc = "Quarto run all"
  }
end

----[[Slime]]
if is_available("vim-slime") then
  maps.n["<leader>Qs"] = {
    "<cmd>SlimeSend<cr>",
    desc = "Send Code Chunk"
  }
  maps.i["<c-cr>"] = {
    "<cmd>SlimeSend<cr>i",
    desc = "Send Code Chunk"
  }
  maps.v["<c-cr>"] = {
    "<cmd>SlimeRegionSend<cr>",
    desc = "Send Code Chunk"
  }
  maps.v["<cr>"] = {
    "<cmd>SlimeRegionSend<cr>",
    desc = "Send Code Chunk"
  }
end
maps.n["<leader>tg"] = {
  "<cmd>vsplit terminal://ghci<cr>",
  desc = "Terminal: haskell"
}
maps.n["<leader>tp"] = {
  "<cmd>vsplit terminal://python<cr>",
  desc = "Terminal: python"
}

utils.set_mappings(maps)
