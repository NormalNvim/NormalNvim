-- Disabled plugins
-- In case we want to re-enable them in the future.

--    Sections:
--       -> ranger.vim

return {

  -- [ranger] file browser (fork with mouse scroll support)
  -- https://github.com/Zeioth/ranger.vim
  -- {
  --   -- This one is a backup ranger in case rnvimr breaks for some reason.
  --   -- It supports invoking terminals from inside ranger, which Rnvimr doesn't atm.
  --   "zeioth/ranger.vim",
  --   dependencies = { "rbgrouleff/bclose.vim" },
  --   cmd = { "Ranger" },
  --   init = function() -- For this plugin has to be init
  --     vim.g.ranger_terminal = "foot"
  --     vim.g.ranger_command_override = 'LC_ALL=es_ES.UTF8 TERMCMD="foot -a "scratchpad"" ranger'
  --     vim.g.ranger_map_keys = 0
  --   end,
  -- },

}
