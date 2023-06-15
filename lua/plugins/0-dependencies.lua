-- Dependencies
-- Widely used by other plugins.
-- It would be ideal using only the ones we need.

--    Sections:
--       -> plenary.nvim     [plenary]
--       -> bufdelete.nvim   [required window logic]

return {
  -- bufdelete.nvim   [required window logic]
  -- https://github.com/nvim-lua/plenary.nvim
  --
  -- General methods used by other plugins. (500kb) [plenary]
  -- Enables async and other common functions in pure lua,
  -- which runs faster than vimscript. So it is quite necessary.
  -- We use it for our utils. None of our plugins use it.
  --
  --  METHODS
  --  plenary.async
  --  plenary.async_lib
  --  plenary.job
  --  plenary.path
  --  plenary.scandir
  --  plenary.context_manager
  --  plenary.test_harness
  --  plenary.filetype
  --  plenary.strings
  --
  --  REQUIRED BY
  --  telescope
  --  many others
  "nvim-lua/plenary.nvim",

  --  bufdelete.nvim   [required window logic]
  --  https://github.com/famiu/bufdelete.nvim
  --
  -- WARNING:
  -- This plugin is a hard dependency for the current window implementation.
  -- If this plugin is deleted, windows will malfunction.
  --
  -- If you want to disable the current window system, you can do it by
  -- removing/modifying the plugin heirline in:
  -- ../plugins/2-ui.lua
  --
  { "famiu/bufdelete.nvim", cmd = { "Bdelete", "Bwipeout" } },
}
