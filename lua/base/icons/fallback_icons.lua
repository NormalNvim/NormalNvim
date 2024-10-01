-- ### Fallback icons

-- DESCRIPTION:
-- Fallback icons that will be displayed
-- if you set `vim.g.fallback_icons = true` on `../1-options.lua`.
-- Use it in cases when it's not possible for you to install nerd fonts.

return {
  -- Which-key (we use which-key defaults)
  -- Debugger = "+",
  -- Run = "+",
  -- Search = "+",
  -- Session = "+",
  -- Sort = "+",
  -- Buffer = "+",
  -- Terminal = "+",
  -- UI = "+",
  -- Test = "+",
  -- Package = "+",
  -- Docs = "+",
  -- Git = "+",

  -- Heirline-components - tabline components
  TabClose = "X",
  BufferClose = "x",
  ArrowLeft = "<",
  ArrowRight = ">",
  FileModified = "*",
  FileReadOnly = "[lock]",

  -- Heirline components - Winbar components
  CompilerPlay = "[PLAY]",
  CompilerStop = "[STOP]",
  CompilerRedo = "[REDO]",
  NeoTree = "[TREE]",
  Aerial = "[AERIAL]" ,
  ZenMode = "[ZEN]",
  BufWrite = "[WRITE]",
  BufWriteAll = "[WRITE_ALL]",
  Ellipsis = "...",
  BreadcrumbSeparator = ">",

  -- Heirline-components - statuscolumn
  FoldClosed = "+",
  FoldOpened = "-",
  FoldSeparator = " ",

  -- Heirline-components - statusline components
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

  -- DAP
  DapBreakpoint = "B",
  DapBreakpointCondition = "C",
  DapBreakpointRejected = "R",
  DapLogPoint = "L",
  DapStopped = ">",

  -- Git
  GitAdd = "[+]",
  GitBranch = "[BRANCH]",
  GitChange = "[/]",
  GitConflict = "[!]",
  GitDelete = "[-]",
  GitIgnored = "[I]",
  GitRenamed = "[R]",
  GitSign = "|",
  GitStaged = "[S]",
  GitUnstaged = "[U]",
  GitUntracked = "[?]",

  -- Telescope
  PromptPrefix = ">",
}
