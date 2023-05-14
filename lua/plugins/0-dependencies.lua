-- Dependencies
-- Widely used by other plugins.
-- It would be ideal using only the ones we need.

--    Sections:
--       -> plenary.nvim     [plenary]


return {
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
  --
  --  URL
  --  https://github.com/nvim-lua/plenary.nvim
  "nvim-lua/plenary.nvim"
}
