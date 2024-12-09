-- Command to check if you have the required dependencies to use NormalNvim.

-- DESCRIPTION:
-- To use it run the command :checkhealth base

local M = {}

function M.check()
  -- Get normalnvim_version from the plugin distroupdate, if present.
  local success, git_utils = pcall(require, "distroupdate.utils.git")
  success = success and vim.fn.executable("git") == 1
  local normalnvim_version = success and git_utils.current_version(false) or "unknown"
  local distroupdate_config = vim.g.distroupdate_config or {}

  if distroupdate_config.branch == "nightly" then
    normalnvim_version = ("nightly (%s)"):format(normalnvim_version)
  end

  -- Title
  vim.health.start("NormalNvim health stats:")

  -- Print NormalNvim version
  vim.health.info("NormalNvim Version: " .. normalnvim_version)
  vim.health.info(
    "Neovim Version: v"
      .. vim.fn.matchstr(vim.fn.execute("version"), "NVIM v\\zs[^\n]*")
  )

  -- Print Neovim version
  if vim.version().prerelease then
    vim.health.warn(
      "Neovim nightly is not officially supported and may have breaking changes"
    )
  elseif vim.fn.has("nvim-0.10") == 1 then
    vim.health.ok("Using stable Neovim >= 0.10.0")
  else
    vim.health.error("Neovim >= 0.10.0 is required")
  end

  -- Checks to perform.
  local programs = {
    {
      cmd = { "git" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management.",
    },
    {
      cmd = { "luarocks" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management.",
    },
    {
      cmd = { "node" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management.",
    },
    {
      cmd = { "yarn" },
      type = "error",
      msg = "Used for core functionality such as updater and plugin management.",
    },
    {
      cmd = { "cargo" },
      type = "error",
      msg = "Used by nvim-spectre to install oxi. Also by dooku.nvim to generate rust html docs.",
    },
    {
      cmd = { "yazi" },
      type = "error",
      msg = "Used to enable yazi file browser.",
    },
    {
      cmd = { "markmap" },
      type = "warn",
      msg = "Used by markmap.nvim. Make sure yarn is in your PATH. To learn how check markmap.nvim github page.",
    },
    {
      cmd = { "fd" },
      type = "error",
      msg = "Used for nvim-spectre to find using fd.",
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
      cmd = { "delta" },
      type = "warn",
      msg = "Used by undotree to show a diff (Optional)",
    },
    {
      cmd = { "grcov" },
      type = "warn",
      msg = "Used to show code coverage (Optional)",
    },
    {
      cmd = { "grcov" },
      type = "warn",
      msg = "Used to show code coverage (Optional)",
    },
    {
      cmd = { "jest" },
      type = "warn",
      msg = "Used to run typescript and javascript tests (Optional)",
    },
    {
      cmd = { "pytest" },
      type = "warn",
      msg = "Used to run python tests (Optional)",
    },
    {
      cmd = { "cargo nextest" },
      type = "warn",
      msg = "Used to run rust tests (optional)\nNOTE: checkhealth won't detect this correctly, but you can confirm it works correctly with 'cargo nextest'.",
    },
    {
      cmd = { "nunit" },
      type = "warn",
      msg = "Used to run C# tests (optional)\nNOTE: There is no way to install this system wide. To use it you must add it to your dotnet C# project: 'dotnet add package NUnit NUnit3TestAdapter'.",
    },
    {
      cmd = { "csc" },
      type = "warn",
      msg = "Used by compiler.nvim to compile non dotnet C# files (Optional)",
    },
    {
      cmd = { "mono" },
      type = "warn",
      msg = "Used by compiler.nvim to run non dotnet C# files. (Optional)",
    },
    {
      cmd = { "dotnet" },
      type = "warn",
      msg = "Used by compiler.nvim and DAP to operate with dotnet projects (optional)\nNOTE: Make sure you also have the system package dotnet-sdk installed.",
    },
    {
      cmd = { "java" },
      type = "warn",
      msg = "Used by compiler.nvim and dap to operate with java (Optional)",
    },
    {
      cmd = { "javac" },
      type = "warn",
      msg = "Used by compiler.nvim to compile java (Optional)",
    },
    {
      cmd = { "nasm" },
      type = "warn",
      msg = "Used by compiler.nvim to compile assembly x86_64 (Optional)",
    },

    {
      cmd = { "gcc" },
      type = "warn",
      msg = "Used by compiler.nvim to compile C (Optional)",
    },
    {
      cmd = { "g++" },
      type = "warn",
      msg = "Used by compiler.nvim to compile C++ (Optional)",
    },
    {
      cmd = { "elixir" },
      type = "warn",
      msg = "Used by compiler.nvim to compile elixir (optional)",
    },
    {
      cmd = { "Rscript" },
      type = "warn",
      msg = "Used by compiler.nvim to interpretate R (Optional)",
    },
    {
      cmd = { "python" },
      type = "warn",
      msg = "Used by compiler.nvim to interpretate python (Optional)",
    },
    {
      cmd = { "nuitka" },
      type = "warn",
      msg = "Used by compiler.nvim to compile python to machine code (Optional)",
    },
    {
      cmd = { "pyinstaller" },
      type = "warn",
      msg = "Used by compiler.nvim to compile python to bytecode (Optional)",
    },
    {
      cmd = { "ruby" },
      type = "warn",
      msg = "Used by compiler.nvim to interpretate ruby (optional)",
    },
    {
      cmd = { "perl" },
      type = "warn",
      msg = "Used by compiler.nvim to interpretate perl (optional)",
    },
    {
      cmd = { "swiftc" },
      type = "warn",
      msg = "Used by compiler.nvim to compile swift (optional)",
    },
    {
      cmd = { "swift" },
      type = "warn",
      msg = "Used by compiler.nvim to compile swift (optional)",
    },
    {
      cmd = { "gfortran" },
      type = "warn",
      msg = "Used by compiler.nvim to compile fortran (optional)",
    },
    {
      cmd = { "fpm" },
      type = "warn",
      msg = "Used by compiler.nvim to compile fortran (optional)",
    },
    {
      cmd = { "go" },
      type = "warn",
      msg = "Used by compiler.nvim to compile go (optional)",
    },
    {
      cmd = { "godoc" },
      type = "warn",
      msg = "Used by dooku.nvim to generate go html docs\nNOTE: If you have it installed but you can't run it on the terminal, ensure you have added 'go' to your OS path (optional)",
    },
    {
      cmd = { "doxygen" },
      type = "warn",
      msg = "Used by dooku.nvim to generate c/c++/python/java html docs (optional)",
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
      vim.health.ok(("`%s` is installed: %s"):format(name, program.msg))
    else
      vim.health[program.type](
        ("`%s` is not installed: %s"):format(name, program.msg)
      )
    end
  end
  vim.health.info("")
  vim.health.info("Write `:bw` to close `:checkhealth` gracefully.")
end

return M
