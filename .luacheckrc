-- Global objects
globals = {
  "base",
  "vim",
}

-- Rerun tests only if their modification time changed
cache = true

-- Don't report unused self arguments of methods
self = false

-- You can find a list with all the warnings you can ignore here:
-- https://luacheck.readthedocs.io/en/stable/warnings.html
-- Accepted values are integer, string, and regular expression.
ignore = {
  "212/_.*", -- unused argument, for vars with "_" prefix
}
