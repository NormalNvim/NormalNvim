-- ### Fallback icons

-- DESCRIPTION:
-- Use this when it's not possible for you to install nerd fonts.
--
-- Fallback icons will be displayed
-- if you set `vim.g.fallback_icons_enabled = true` on `../1-options.lua`.

--    Sections:
--      -> which-key
--      -> heirline-components (tabline)
--      -> heirline-components (winbar)
--      -> heirline-components (statuscolumn)
--      -> heirline-components (statusline)
--      -> heirline-components (misc)
--      -> Neotree
--      -> Git
--      -> DAP
--      -> Telescope
--      -> Nvim-lightbulb
--      -> Alpha
--      -> Mason
--      -> Render-markdown

return {
  -- Which-key
  -- Auto managed

  -- Heirline-components - tabline components
  BufferClose = "x",
  FileModified = "*",
  FileReadOnly = "[lock]",
  TabClose = "X",
  ArrowLeft = "<",
  ArrowRight = ">",

  -- Heirline components - Winbar components
  CompilerPlay = "[PLAY]",
  CompilerStop = "[STOP]",
  CompilerRedo = "[REDO]",
  NeoTree = "[TREE]",
  Aerial = "[AERIAL]",
  ZenMode = "[ZEN]",
  BufWrite = "[WRITE]",
  BufWriteAll = "[WRITE_ALL]",
  Ellipsis = "...",
  BreadcrumbSeparator = ">",

  -- Heirline-components - statuscolumn
  FoldClosed = "+",
  FoldOpened = "-",
  FoldSeparator = " ",

  -- Heirline-components - statusline
  ActiveLSP = "[LSP]",
  ActiveTS = " ",
  Environment = "Env:",
  DiagnosticError = "X",
  DiagnosticHint = "?",
  DiagnosticInfo = "i",
  DiagnosticWarn = "!",
  LSPLoading1 = "/",
  LSPLoading2 = "-",
  LSPLoading3 = "\\",
  SearchCount = "FIND:",
  MacroRecording = "REC:",
  ToggleResults = "[RESULTS]",

  -- Heirline-components - misc
  Paste = "[PASTE]",
  PathSeparator = ">",

  -- Neotree
  FolderClosed = "[C]",
  FolderEmpty = "[E]",
  FolderOpen = "[O]",
  Diagnostic = "[!]",
  DefaultFile = " ",

  -- Git
  GitBranch = "[BRANCH]",
  GitAdd = "[+]",
  GitChange = "[/]",
  GitConflict = "[!]",
  GitDelete = "[-]",
  GitIgnored = "[I]",
  GitRenamed = "[R]",
  GitSign = "|",
  GitStaged = "[S]",
  GitUnstaged = "[U]",
  GitUntracked = "[?]",

  -- DAP
  DapBreakpoint = "B",
  DapBreakpointCondition = "C",
  DapBreakpointRejected = "R",
  DapLogPoint = "L",
  DapStopped = ">",

  -- Telescope
  PromptPrefix = ">",

  -- nvim-lightbulb
  Lightbulb = "[ACTION]",

  -- alpha
  GreeterNew = "  ",
  GreeterRecent = "  ",
  GreeterYazi = "  ",
  GreeterSessions = "  ",
  GreeterProjects = "  ",
  GreeterPlug = "|",

  -- Mason
  MasonInstalled = "[I]",
  MasonUninstalled = "[U]",
  MasonPending = "[P]",

  -- Render-markdown
  RenderMarkdown = { '# ', '## ', '### ', '#### ', '##### ', '###### ' }
}
