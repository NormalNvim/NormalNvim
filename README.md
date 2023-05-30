# NormalNvim
A normal NeoVim config

![screenshot_2023-05-27_16-41-26_120206834](https://github.com/Zeioth/NormalNvim/assets/3357792/8f3b76c8-3ceb-4b8d-a0e1-50f73c94eb00)


## Install

```sh
# Strongly recommended: 
# Fork the project, and clone the fork instead of this.
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
* 🔋 **Batteries included:** Most plugins you will ever need are included and debugged by default. Get the best user experience out of the box and forget about nasty bugs in your Neovim config.
* 🔒 **Plugin version lock:** You can choose "stable" or "nightly" update channels. Or if you prefer, use :NvimFreezePluginVersions to create your own stable versions!
* 🔙 **Rollbacks:** You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 **Hot reload:** Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* 📱 **Phone friendly:** Good usability even on smalll screens.
* ❤️ **We don't treat you like you are stupid:** Code comments guide you to easily customize everything. We will never hide or abstract stuff from you.

## Philosophy and design decissions
__You are expected to fork the project before cloning it. So you are the only one in control. It is also recommended to use [neovim's appimage](https://github.com/neovim/neovim/releases).__

NormalNvim updates don't have a user space. This is by design. It makes the code considerably more simple. And it also gives you the keys of the house to change anything you desire. This is not a distro you are expected to update often from upstream. It is meant to be used as a base to create your own distro.

[NormalNvim](https://github.com/Zeioth/NormalNvim) won't be the next [/r/UnixPorn](https://www.reddit.com/r/unixporn/) sensation. It is a normal nvim config you can trust to work without unexpected breakage. Nothing flashy. Nothing brightful. Just bread and butter.

## Commands

|  Command            | Description                             |
|---------------------|-----------------------------------------|
| **:healthcheck base**   | Look for errors in NormalNvim. |
| **:NvimFreezePluginVersions** | Creates `lazy_versions`.lua in your config directory containing the current pugin versions. If you are using the stable updates channel, this file willl be used to decide what plugin versions will be instlaed. If you are using the nighty channel, the file will be ignored. |
| **:NvimReload** | Hot reloads nvim without leaving nvim. I can cause unexpected issues sometimes. | 
| **:NvimRollbackCreate** | Creates a recovery point. It is triggered automatically when uptading running `:NvimUpdateConfig`. | 
| **:NvimRollbackRestore** | Uses git to bring your config to the state it had when `:NvimRollbackCreate` was called. | 
| **:NvimUpdateConfig** | Pull the latest changes from the current git repository of the distro. Useful when you have your distro installed in more than one machine. |
| **:NvimUpdatePlugins** | Uses lazy to update the plugins. |
| **:NvimVersion** | Prints the commit number of the current NormalNvim version. |

## FAQ
Please before opening an issue, check [the AstroVim manual](https://astronvim.com/) and the [AstroVim Community](https://github.com/AstroNvim/astrocommunity) repos where you can find help about how to install and configure most plugins.

* **NormalNvim is not working ok. How can I know why?**

    :healthcheck base

* **How do I disable the tabline?** On the options file, set showtabline=0. If you wanna remove the functionality completely from nvim check the plugin heirline. Here is where we implement the tab logic. Also check the ./lua/base/3-autocmds.lua and ./lua/base/utils/status.lua.

* **What scenarios are not covered by this distro?**
  * **Kubernetes**: We do not provide a kubernetes plugin. There is not much neovim can do for you if you work with Kubernetes apart from the features provided by Mason (LSP, Hightighing, autocompletion..).
  * **e2e testing**: We to not provide a e2e plugin. But we do provide the :TestNodejsE2e command you can customize on [/lua/base/3-autocmds.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/3-autocmds.lua) along with all the other testing commands. You can also rename the command to anything you want in case you don't use nodejs.
  * **Compiling and running tasks**: This is planned for the future. In the meantime we recommend [overseer.nvim](https://github.com/stevearc/overseer.nvim).

## Credits
Originally it took AstroVim as base. But implements [this VIM config](https://github.com/amix/vimrc). Code has been simplified while retaining its core features.

## TODOS
* The plugins [vim-doxygen](https://github.com/Zeioth/vim-doxygen) and [vim-typedoc](https://github.com/Zeioth/vim-typedoc) are not compatible with windows yet. Is it planned to re-write them on lua with windows support, but in the meantime if you are on windows, please don't use them.
