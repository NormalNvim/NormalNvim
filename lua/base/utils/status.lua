--- ### Heirline config modules
--
--  DESCRIPTION:
--  We use this file to configure the plugin "Heirline".
--  By having this file, we don't have to require every file separately.

return {
  component = require "base.utils.status.component",
  condition = require "base.utils.status.condition",
  env = require "base.utils.status.env",
  heirline = require "base.utils.status.heirline",
  hl = require "base.utils.status.hl",
  init = require "base.utils.status.init",
  provider = require "base.utils.status.provider",
  utils = require "base.utils.status.utils",
}
