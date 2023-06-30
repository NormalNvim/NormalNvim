-- Dependencies
-- Widely used by other plugins.
-- It would be ideal using only the ones we need.

--    Sections:
--       -> plenary.nvim     [plenary]
--       -> mini.bufdelete   [required window logic]

return {
  -- plenary.nvim  [plenary]
  -- https://github.com/nvim-lua/plenary.nvim
  --
  -- General methods used by other plugins. (500kb) [plenary]
  -- Enables async and other common functions in pure lua,
  -- which runs faster than vimscript. So it is quite necessary.
  -- We use it for our utils. None of our plugins use it.
  --
  -- There are plans on Telescope to remove this dependency so you may be able
  -- to delete in the future.
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

  --  mini.bufremove [required window logic]
  --  https://github.com/echasnovski/mini.bufremove
  --
  -- WARNING:
  -- This plugin is a hard dependency for the current wintab implementation.
  -- If this plugin is deleted, <leader>c and <leader>C will thow error.
  --
  -- It is used by the functions "delete" and "wipe" in
  -- ../base/utils/buffer.lua
  --
  { "echasnovski/mini.bufremove", event = "User BaseFile" },
}
