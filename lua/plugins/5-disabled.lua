-- Disabled plugins
-- In case we want to re-enable them in the future.


--    Sections:
--       -> autopairs




return {
  --  [autopairs] auto closes (), "", '', [], {}
  --  https://github.com/windwp/nvim-autopairs
  -- {
  --   "windwp/nvim-autopairs",
  --   event = "InsertEnter",
  --   opts = {
  --     check_ts = true,
  --     ts_config = { java = false },
  --     fast_wrap = {
  --       map = "<M-e>",
  --       chars = { "{", "[", "(", '"', "'" },
  --       pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
  --       offset = 0,
  --       end_key = "$",
  --       keys = "qwertyuiopzxcvbnmasdfghjkl",
  --       check_comma = true,
  --       highlight = "PmenuSel",
  --       highlight_grey = "LineNr",
  --     },
  --   },
  --   config = function(_, opts)
  --     local npairs = require "nvim-autopairs"
  --     npairs.setup(opts)

  --     if not vim.g.autopairs_enabled then npairs.disable() end
  --     local cmp_status_ok, cmp = pcall(require, "cmp")
  --     if cmp_status_ok then
  --       cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done { tex = false })
  --     end
  --   end
  -- },




  }

