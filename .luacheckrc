-- Global objects
globals = {
  "base",
  "vim",
  "bit",
  "C",
}

-- Rerun tests only if their modification time changed
cache = true

-- Don't report unused self arguments of methods
self = false

ignore = {
  "79",      -- max_line_length
  "212/_.*", -- unused argument, for vars with "_" prefix
}
