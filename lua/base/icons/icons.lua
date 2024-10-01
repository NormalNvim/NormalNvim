-- ### icons

-- DESCRIPTION:
-- Here you can edit the icons displayed in NormalNvim.

-- If you can't see the default icons:
-- Install nerd fonts and set it as your terminal font:
-- https://www.nerdfonts.com/

return {
  -- Which-key
  Debugger = "",
  Run = "󰑮",
  Search = "",
  Session = "󱂬",
  Sort = "󰒺",
  Buffer = "󰓩",
  Terminal = "",
  UI = "",
  Test = "󰙨",
  Package = "󰏖",
  Docs = "",
  Git = "󰊢",

  -- Heirline-components - tabline
  TabClose = "󰅙",
  BufferClose = "󰅖",
  ArrowLeft = "",
  ArrowRight = "",
  FileModified = "",
  FileReadOnly = "",

  -- Heirline-components - winbar
  -- TODO: These icons are currently hardcoded in heirline-components.
  CompilerPlay = "",
  CompilerStop = "",
  CompilerRedo = "",
  NeoTree = "",
  Aerial = "" ,
  ZenMode = "󰰶",
  BufWrite = "",
  BufWriteAll = "",
  Ellipsis = "…",
  BreadcrumbSeparator = "",

  -- Heirline-components - statuscolumn
  FoldClosed = "",
  FoldOpened = "",
  FoldSeparator = " ",

  -- Heirline-components - statusline components
  ActiveLSP = "",
  ActiveTS = "",
  Environment = "",
  DiagnosticError = "",
  DiagnosticHint = "󰌵",
  DiagnosticInfo = "󰋼",
  DiagnosticWarn = "",
  LSPLoading1 = "",
  LSPLoading2 = "󰀚",
  LSPLoading3 = "",
  MacroRecording = "",
  ToggleResults = "󰑮",

  -- Heirline-components - misc
  Paste = "󰅌",
  PathSeparator = "",

  -- Neotree
  FolderClosed = "",
  FolderEmpty = "",
  FolderOpen = "",
  Diagnostic = "󰒡",
  DefaultFile = "󰈙",

  -- Git
  GitAdd = "",
  GitBranch = "",
  GitChange = "",
  GitConflict = "",
  GitDelete = "",
  GitIgnored = "◌",
  GitRenamed = "➜",
  GitSign = "▎",
  GitStaged = "✓",
  GitUnstaged = "✗",
  GitUntracked = "★",

  -- DAP
  DapBreakpoint = "",
  DapBreakpointCondition = "",
  DapBreakpointRejected = "",
  DapLogPoint = ".>",
  DapStopped = "󰁕",

  -- Telescope
  PromptPrefix = "❯",
}
