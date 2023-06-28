-- On neovim you can run
-- :healthcheck base
-- to know possible causes in case NormalNvim is not working correctly.

local M = {}

local health = {
  start = vim.health.start or vim.health.report_start,
  ok = vim.health.ok or vim.health.report_ok,
  warn = vim.health.warn or vim.health.report_warn,
  error = vim.health.error or vim.health.report_error,
  info = vim.health.info or vim.health.report_info,
}

function M.check()
  health.start "NormalNvim"

  health.info(
    "NormalNvim Version: " .. require("base.utils.updater").version(true)
  )
  health.info(
    "Neovim Version: v"
      .. vim.fn.matchstr(vim.fn.execute "version", "NVIM v\\zs[^\n]*")
  )

  if vim.version().prerelease then
    health.warn "Neovim nightly is not officially supported and may have breaking changes"
  elseif vim.fn.has "nvim-0.8" == 1 then
    health.ok "Using stable Neovim >= 0.8.0"
  else
    health.error "Neovim >= 0.8.0 is required"
  end

  -- Checks to perform.
  local programs = {
    {
      cmd = { "git" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management",
    },
    {
      cmd = { "node" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management",
    },
    {
      cmd = { "yarn" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management.",
    },
    {
      cmd = { "lazygit" },
      type = "warn",
      msg = "Used for mappings to pull up git TUI (Optional)",
    },
    {
      cmd = { "gitui" },
      type = "warn",
      msg = "Used for mappings to pull up git TUI (Optional)",
    },
    {
      cmd = { "pynvim", "ranger" },
      type = "warn",
      msg = "Used to enable ranger file browser (Optional)",
    },
    {
      cmd = { "delta" },
      type = "warn",
      msg = "Used by undotree to show a diff (Optional)",
    },
  }

  -- Actually perform the checks we defined above.
  for _, program in ipairs(programs) do
    if type(program.cmd) == "string" then program.cmd = { program.cmd } end
    local name = table.concat(program.cmd, "/")
    local found = false
    for _, cmd in ipairs(program.cmd) do
      if vim.fn.executable(cmd) == 1 then
        name = cmd
        found = true
        break
      end
    end

    if found then
      health.ok(("`%s` is installed: %s"):format(name, program.msg))
    else
      health[program.type](
        ("`%s` is not installed: %s"):format(name, program.msg)
      )
    end
  end
  health.info("")
  health.info("Write `:bw` to close `:checkhealth` gracefuly.")
end

return M
