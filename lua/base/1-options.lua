-- NVim option variables

-- HELLO, welcome to NormalNVim!
-- -------------------------------------
-- Here you can define your nvim options.
--
-- You can update this nvim distro with :NvimUpdateConfig
-- you can easily revert to the previous version with :NvimRollbackRestore
--
-- For plugin updates
-- Check ./2-lazy.lua to know more about "stable" and "nightly" channels.
-- And how to lock your package versions.

local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Global that will contain this Nvim distro options (updater... etc)
_G.base = {}

-- Theme
--base.default_colorscheme = "astrotheme"
base.default_colorscheme = "tokyonight-night"

-- append/remove
vim.opt.viewoptions:remove "curdir" -- disable saving current directory with views
vim.opt.shortmess:append { s = true, I = true } -- disable startup message
vim.opt.backspace:append { "nostop" } -- Don't stop backspace at insert
if vim.fn.has "nvim-0.9" == 1 then
  vim.opt.diffopt:append "linematch:60" -- enable linematch diff algorithm
end
if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true --Scroll by screen line rather than by line when wrap is set. nvim 0.10 only
end

-- Set
vim.cmd "set autochdir" -- By default, use current file dir as working dir.

-- define variables
local options = {
  opt = {
    -- AstroNvim Defaults
    clipboard = "unnamedplus", -- Connection to the system clipboard
    breakindent = true, -- Wrap indent to match  line start
    cmdheight = 0, -- hide command line unless needed
    completeopt = { "menu", "menuone", "noselect" }, -- Options for insert mode completion
    copyindent = true, -- Copy the previous indentation on autoindenting
    cursorline = true, -- Highlight the text line of the cursor
    expandtab = true, -- Enable the use of space in tab
    fileencoding = "utf-8", -- File content encoding for the buffer
    fillchars = { eob = " " }, -- Disable `~` on nonexistent lines
    foldenable = true, -- enable fold for nvim-ufo
    foldlevel = 99, -- set high foldlevel for nvim-ufo
    foldlevelstart = 99, -- start with all code unfolded
    foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil, -- show foldcolumn in nvim 0.9
    ignorecase = true, -- Case insensitive searching
    infercase = true, -- Infer cases in keyword completion
    laststatus = 3, -- globalstatus
    linebreak = true, -- Wrap lines at 'breakat'
    number = true, -- Show numberline
    preserveindent = true, -- Preserve indent structure as much as possible
    pumheight = 10, -- Height of the pop up menu
    relativenumber = false, -- Show relative numberline
    shiftwidth = 2, -- Number of space inserted for indentation
    showmode = false, -- Disable showing modes in command line
    showtabline = 2, -- always display tabline
    signcolumn = "yes", -- Always show the sign column
    smartcase = true, -- Case sensitivie searching
    smartindent = true, -- Smarter autoindentation
    splitbelow = true, -- Splitting a new window below the current one
    splitright = true, -- Splitting a new window at the right of the current one
    tabstop = 2, -- Number of space in a tab
    termguicolors = true, -- Enable 24-bit RGB color in the TUI
    timeoutlen = 500, -- Shorten key timeout length a little bit for which-key
    undofile = true, -- Enable persistent undo between session and reboots
    updatetime = 300, -- Length of time to wait before triggering the plugin
    virtualedit = "block", -- allow going past end of line in visual block mode
    writebackup = false, -- Disable making a backup before overwriting a file

    -- Aditions
    undodir = vim.fn.stdpath "data" .. "/undodir", -- Chooses where to store the undodir
    history = 1000, -- Number of commands to remember in a history table (per buffer).
    swapfile = false, -- Ask what state to recover when opening a file that was not saved.
    wrap = true, -- Disable wrapping of lines longer than the width of window.
    colorcolumn = "80", -- PEP8 like character limit vertical bar.
    mouse = "a", -- Enable mouse support.
    mousescroll = "ver:1,hor:0", -- Disables hozirontal scroll in neovim.
    guicursor = "a:blinkon200", -- Enable cursor blink.
    autochdir = true, -- Use current file dir as working dir (See project.nvim)
    scrolloff = 1000, -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cusros centered.
    sidescrolloff = 8, -- Same but for side scrolling.
    selection = "old", -- Don't select the newline symbol when using <End> on visual mode
  },
  g = {
    mapleader = " ", -- set leader key
    maplocalleader = ",", -- set default local leader key
    autoformat_enabled = false, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    autopairs_enabled = false, -- enable autopairs at start
    cmp_enabled = true, -- enable completion at start
    codelens_enabled = true, -- enable or disable automatic codelens refreshing for lsp that support it
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    highlighturl_enabled = true, -- highlight URLs by default
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available)
    lsp_handlers_enabled = true, -- enable or disable default vim.lsp.handlers (hover and signatureHelp)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
  },
  t = vim.t.bufs and vim.t.bufs or { bufs = vim.api.nvim_list_bufs() }, -- initialize buffers for the current tab
}

-- set variables
for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end
