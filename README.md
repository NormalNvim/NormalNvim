# NormalNvim
A normal NeoVim config

## Install

```sh
git clone --depth 1 git@github.com:Zeioth/NormalNVim.git ~/.config/nvim
nvim
```

## System dependencies
```sh
pynvim       # Necessary for Rnvimr.
yarn npm     # Necessary for most formatters and parsers.
```


## Distro features

* ⚡ **Lazy:** Plugins are loaded lazily, providing super fast performance.
* 😎 **Plugins are self-contained:** Allowing you to easily delete what you don't want.
* 🔋 **Batteries included:** Most plugins you will ever need are inclued and debugged by default. Get the best user experience out of the box and forget about nasty bugs in your Neovim config.
* 🔒 **Plugin version lock:** You can choose "stable" or "nightly" update channels. Or if you prefer, use :NvimFreezePluginVersions to create your own stable versions!
* 🔙 **Rollbacks:** You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 **Hot reload:** Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* 📱 **Phone friendly:** Good usability even on smalll screens.
* ❤️ **We don't treat you like you are stupid:** Code comments guide you to easily customize everything. We will never hide or abstract stuff from you.

## Plugins included

01-behaviors.lua
``` lua
--       -> ranger file browser    [ranger]
--       -> project.nvim           [project search + auto cd]
--       -> trim.nvim              [auto trim spaces]
--       -> stickybuf.nvim         [lock special buffers]
--       -> nvim-window-picker     [windows]
--       -> telescope-undo.nvim    [internal clipboard history]
--       -> better-scape.nvim      [esc]
--       -> toggleterm.nvim        [term]
--       -> session-manager        [session]
--       -> spectre.nvim           [search and replace in project]
--       -> neotree file browser   [neotree]
--       -> nvim-ufo               [folding mod]
--       -> nvim-neoclip           [nvim clipboard] 

```

02-ui.lua
``` lua
--    Sections:
--       -> astrotheme                  [theme]
--       -> alpha-nvim                  [greeter]
--       -> nvim-notify                 [notifications]
--       -> indent-blankline.nvim       [guides]
--       -> heirline                    [statusbar]
--       -> telescope                   [search]
--       -> telescope-fzf-native.nvim   [search backend]
--       -> smart-splits                [window-dimming]
--       -> dressing.nvim               [better ui elements]
--       -> nvim-web-devicons           [icons | ui]
--       -> lspkind.nvim                [icons | lsp]
--       -> nvim-scrollbar              [scrollbar]
--       -> mini.animate                [animations]
--       -> which-key                   [on-screen keybinding]
```

3-dev-core.lua
``` lua
--    Sections:
--       ## TREE SITTER
--       -> nvim-treesitter                [syntax highlight]
--       -> nvim-ts-autotag                [treesitter understand html tags]
--       -> nvim-ts-context-commentstring  [treesitter comments]
--       -> nvim-colorizer                 [hex colors]

--       ## LSP
--       -> SchemaStore.nvim               [lsp schema manager]
--       -> mason.nvim                     [lsp package manager]
--       -> nvim-lspconfig                 [lsp config]
--       -> null-ls                        [code formatting]
--       -> luasnip                        [snippet-engine]

--       ## AUTO COMPLETON
--       -> nvim-cmp                       [auto completion engine]
--       -> cmp-nvim-buffer                [auto completion buffer]
--       -> cmp-nvim-path                  [auto completion path]
--       -> cmp-nvim-lsp                   [auto completion lsp]
--       -> cmp-luasnip                    [auto completion snippets]
```

4-dev.lua
``` lua
--    Sections:
--       ## COMMENTS
--       -> comment.nvim                   [adv. comments]

--       ## SNIPPETS
--       -> luasnip                        [snippet engine]
--       -> friendly-snippets              [snippet templates]

--       ## GIT
--       -> gitsigns.nvim                  [git hunks]
--       -> fugitive.vim                   [git commands]

--       ## DEBUGGER
--       -> nvim-dap                       [debugger]

--       ## TESTING
--       -> neotest.nvim                   [unit testing]

--       ## ANALYZER
--       -> aerial.nvim                    [code analyzer]

--       ## CODE DOCUMENTATION
--       -> vim-doxigen                    [general    doc generator]
--       -> vim-typedoc                    [typescript doc generator]

--       ## EXTRA
--       -> guess-indent                   [guess-indent]
--       -> neural                         [chatgpt code generator]
--       -> markdown-preview.nvim          [markdown previewer]
--       -> markmap                        [markdown mindmap]
```

## Base
This is the core part of the config. (WIP, make this a table)

* **1-options.lua:** let and set variables.
* **2-lazy.lua:** Here you can select the channed for updates. "Stable" by default.
* **3-autocmds.lua:** Hacks to make your life better.
* **4-mappings.lua:** All keybindings are defined here in one single place with the only exception of LSP, which can be found in [/lua/base/utils/lsp](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/utils/lsp.lua). This is necessary for us to enable/disable lsp features on the fly.

## FAQ
Please before opening an issue, check [the AstroVim manual](https://astronvim.com/) and the [AstroVim Community](https://github.com/AstroNvim/astrocommunity) repos where you can find help about how to install and configure most plugins.

* **NormalNvim is not working ok. How can I know why?**

    :healthcheck base

* **How do I disable the tabline?** On the options file, set showtabline=0. If you wanna remove the functionality completely from nvim check the plugin heirline. Here is where we implement the tab logic. Also check the ./lua/base/3-autocmds.lua and ./lua/base/utils/status.lua.

* **What scenarios are not covered by this distro?**
  * **Kubernetes**: We do not provide a kubernetes plugin. There is not much neovim can do for you if you work with Kubernetes apart from the features provided by Mason (LSP, Hightighing, autocompletion..).
  * **e2e testing**: We to not provide a e2e plugin. But we do provide the :TestNodejsE2e command you can customize on [/lua/base/3-autocmds.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/3-autocmds.lua) along with all the other testing commands. You can also rename the command to anything you want in case you don't use nodejs.

## Credits
Originally it took AstroVim as base. But implements [this VIM config](https://github.com/Zeioth/vim-zeioth-config). Code has been simplified while retaining its core features.

## TODOS
* The plugins [vim-doxygen](https://github.com/Zeioth/vim-doxygen) and [vim-typedoc](https://github.com/Zeioth/vim-typedoc) are not compatible with windows yet. Is it planned to re-write them on lua with windows support, but in the meantime if you are on windows, please don't use them.
