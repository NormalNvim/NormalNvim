-- HELLO, welcome to NormalNvim!
-- -------------------------------------
-- Here you can define your nvim globals.
--
-- For plugin updates:
-- Check ./2-lazy.lua to know more about "stable" and "nightly" channels.
-- And how to lock your package versions.


-- NormalNvin lua globals
_G.base = {}

-- Theme
base.default_colorscheme = "tokyonight-night"

-- define variables -----------------------------------------------------------
local options = {
  opt = {
    breakindent = true, -- Wrap indent to match  line start.
    clipboard = "unnamedplus", -- Connection to the system clipboard.
    cmdheight = 0, -- hide command line unless needed.
    completeopt = { "menu", "menuone", "noselect" }, -- Options for insert mode completion.
    copyindent = true, -- Copy the previous indentation on autoindenting.
    cursorline = true, -- Highlight the text line of the cursor.
    expandtab = true, -- Enable the use of space in tab.
    fileencoding = "utf-8", -- File content encoding for the buffer.
    fillchars = { eob = " " }, -- Disable `~` on nonexistent lines.
    foldenable = true, -- enable fold for nvim-ufo.
    foldlevel = 99, -- set highest foldlevel for nvim-ufo.
    foldlevelstart = 99, -- start with all code unfolded.
    foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil, -- show foldcolumn in nvim 0.9+.
    ignorecase = true, -- Case insensitive searching.
    infercase = true, -- Infer cases in keyword completion.
    laststatus = 3, -- globalstatus.
    linebreak = true, -- Wrap lines at'breakat'.
    number = true, -- Show numberline.
    preserveindent = true, -- Preserve indent structure as much as possible.
    pumheight = 10, -- Height of the pop up menu.
    relativenumber = false, -- Show relative numberline.
    shiftwidth = 2, -- Number of space inserted for indentation.
    showmode = false, -- Disable showing modes in command line.
    showtabline = 2, -- always display tabline.
    signcolumn = "yes", -- Always show the sign column.
    smartcase = true, -- Case sensitivie searching.
    smartindent = false, -- Smarter autoindentation.
    splitbelow = true, -- Splitting a new window below the current one.
    splitright = true, -- Splitting a new window at the right of the current one.
    tabstop = 2, -- Number of space in a tab.
    termguicolors = true, -- Enable 24-bit RGB color in the TUI.
    timeoutlen = 500, -- Shorten key timeout length a little bit for which-key.
    undofile = true, -- Enable persistent undo between session and reboots.
    updatetime = 300, -- Length of time to wait before triggering the plugin.
    virtualedit = "block", -- allow going past end of line in visual block mode.
    writebackup = false, -- Disable making a backup before overwriting a file.

    -- Aditions
    shada = "!,'1000,<50,s10,h", -- Remember the last 1000 opened files
    undodir = vim.fn.stdpath "data" .. "/undodir", -- Chooses where to store the undodir.
    history = 1000, -- Number of commands to remember in a history table (per buffer).
    swapfile = false, -- Ask what state to recover when opening a file that was not saved.
    wrap = true, -- Disable wrapping of lines longer than the width of window.
    colorcolumn = "80", -- PEP8 like character limit vertical bar.
    mousescroll = "ver:1,hor:0", -- Disables hozirontal scroll in neovim.
    guicursor = "n:blinkon200,i-ci-ve:ver25", -- Enable cursor blink.
    autochdir = true, -- Use current file dir as working dir (See project.nvim).
    scrolloff = 1000, -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
    sidescrolloff = 8, -- Same but for side scrolling.
    selection = "old", -- Don't select the newline symbol when using <End> on visual mode.
  },
  g = {
    mapleader = " ", -- Set leader key.
    maplocalleader = ",", -- Set default local leader key.
    big_file = { size = 1024 * 100, lines = 10000 }, -- For files bigger than this, disable 'treesitter'.

    -- All these options are toggleable with <space + l + u>
    autoformat_enabled = false, -- Enable auto formatting at start.
    autopairs_enabled = false, -- Enable autopairs at start.
    cmp_enabled = true, -- Enable completion at start.
    codelens_enabled = true, -- Enable automatic codelens refreshing for lsp that support it.
    diagnostics_mode = 3, -- Set code linting (0=off, 1=only show in status line, 2=virtual text off, 3=all on).
    icons_enabled = true, -- Enable icons in the UI (disable if no nerd font is available).
    inlay_hints_enabled = false, -- Enable ayways show function parameter names.
    lsp_round_borders_enabled = true, -- Enable round borders for lsp hover and signatureHelp.
    lsp_signature_enabled = true, -- Enable automatically showing lsp help as you write function parameters.
    notifications_enabled = true, -- Enable notifications.
    semantic_tokens_enabled = true, -- Enable lsp semantic tokens at start.
    url_effect_enabled = true, -- Highlight URLs with an underline effect.
  },
  t = vim.t.bufs and vim.t.bufs or { bufs = vim.api.nvim_list_bufs() }, -- initialize buffers for the current tab.
}

-- extra logic ----------------------------------------------------------------
local android = vim.fn.isdirectory('/system') == 1   -- true if on android

-- mouse mode
if android then
  vim.opt.mouse = "v"
else
  vim.opt.mouse = "a"
end

-- append/remove
vim.opt.viewoptions:remove "curdir" -- Disable saving current directory with views.
vim.opt.shortmess:append { s = true, I = true } -- disable startup message.
vim.opt.backspace:append { "nostop" } -- Don't stop backspace at insert.
vim.opt.diffopt:append "linematch:60" -- Enable linematch diff algorithm.

-- apply variables ------------------------------------------------------------
for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end
