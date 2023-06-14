# NormalNvim
A normal NeoVim config

![screenshot_2023-06-06_00-29-48_707187891](https://github.com/Zeioth/NormalNvim/assets/3357792/84255589-0afe-49ff-b3a2-38f2ffad459b)

Tokyo Night (Night) theme by default
![screenshot_2023-05-27_16-41-26_120206834](https://github.com/Zeioth/NormalNvim/assets/3357792/8f3b76c8-3ceb-4b8d-a0e1-50f73c94eb00)

Space shows [all you can do](https://github.com/Zeioth/NormalNvim/wiki/basic-mappings)
![screenshot_2023-06-07_02-50-51_081140888](https://github.com/Zeioth/NormalNvim/assets/3357792/284fb47a-a056-44e0-b4fd-0872d35df77d)


## Install

```sh
# Strongly recommended: 
# Fork the project, and clone the fork instead of this.
git clone --depth 1 git@github.com:Zeioth/NormalNVim.git ~/.config/nvim
nvim
```

## System dependencies
```sh
ranger       # Necessary for Rnvimr.
pynvim       # Necessary for Rnvimr.
yarn         # Necessary for Markmap.
```


## Distro features

* ⚡ **Lazy:** Plugins are loaded lazily, providing super fast performance.
* 😎 **Plugins are self-contained:** Allowing you to easily delete what you don't want.
* 🔋 **Batteries included:** Most plugins you will ever need are included and debugged by default. Get the best user experience out of the box and forget about nasty bugs in your Neovim config.
* 🔒 **Plugin version lock:** You can choose "stable" or "nightly" update channels. Or if you prefer, use :NvimFreezePluginVersions to create your own stable versions!
* 🔙 **Rollbacks:** You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 **Hot reload:** Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* 📱 **Phone friendly:** Good usability even on smalll screens.
* ⌨️ **Alternative mappings:** By default the distro uses qwerty, but colemak-dh can be found [here](https://github.com/Zeioth/NormalNvim/wiki/colemak-dh).
* ❤️ **We don't treat you like you are stupid:** Code comments guide you to easily customize everything. We will never hide or abstract stuff from you.

## Philosophy and design decissions
__You are expected to fork the project before cloning it. So you are the only one in control. It is also recommended to use [neovim's appimage](https://github.com/neovim/neovim/releases).__

> This is not a distro you are expected to update often from upstream. It is meant to be used as a base to create your own distro.

[NormalNvim](https://github.com/Zeioth/NormalNvim) won't be the next [/r/UnixPorn](https://www.reddit.com/r/unixporn/) sensation. It is a normal nvim config you can trust 100% will never break unexpectedly while you are working. Nothing flashy. Nothing brightful. Just bread and butter.

## Commands

|  Command            | Description                             |
|---------------------|-----------------------------------------|
| **:healthcheck base**   | Look for errors in NormalNvim. |
| **:NvimFreezePluginVersions** | Creates `lazy_versions.lua` in your config directory, containing your current plugin versions. If you are using the `stable` updates channel, this file willl be used to decide what plugin versions will be installed, and even if you manually try to update your plugins using lazy package manager, the versions file will be respected. If you are using the `nighty` channel, the first time you open nvim, the versions from `lazy_versions.lua` will be installed, but it will be possible to download the latests versions by manually updating your plugins with lazy. Note that after running this command, you can manually modify `lazy_versions.lua` in case you only want to freeze some plugins. |
| **:NvimReload** | Hot reloads nvim without leaving nvim. It can cause unexpected issues sometimes. | 
| **:NvimRollbackCreate** | Creates a recovery point. It is triggered automatically when running `:NvimUpdateConfig`. | 
| **:NvimRollbackRestore** | Uses git to bring your config to the state it had when `:NvimRollbackCreate` was called. | 
| **:NvimUpdateConfig** | Pulls the latest changes from the current git repository of your nvim config. Useful to keep your config fresh when you use it in more than one machine. If the updates channel is `stable` this command will pull from the latest available tag release in your github repository. Only tag releases starting by 'v', such v1.0.0 are recognized. It is also possible to define an specific stable version in `2-lazy.lua` by setting the option `nvim_config_stable_vesion`. If the channel is `nightly` it will pull from the nightly branch. Note that uncommited local changes in your config will be lost after an update, so it's important you commit before updating your distro config. |
| **:NvimUpdatePlugins** | Uses lazy to update the plugins. |
| **:NvimVersion** | Prints the commit number of the current NormalNvim version. |

For more info, [read the wiki](https://github.com/Zeioth/NormalNvim/wiki).

## FAQ
Please before opening an issue, check [the AstroVim manual](https://astronvim.com/) and the [AstroVim Community](https://github.com/AstroNvim/astrocommunity) repos where you can find help about how to install and configure most plugins.

* **NormalNvim is not working. How can I know why?**

    `:healthcheck base`

* **How can I disable the tabline?** On the options file, search for `showtabline` and set it to 0. If instead you want to remove the functionality completely from nvim, then check the plugin heirline. Here is where we implement the tabline logic. Also check the [./lua/base/3-autocmds.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/3-autocmds.lua) and [./lua/base/utils/status.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/utils/status.lua).

* **How can I disable the animations?** You can delete the plugin [mini.animate](https://github.com/echasnovski/mini.animate). In case you only want to disable some animations look into the plugin docs.

* **How can I use `Ask chatgpt`?** On your operative system, set the next env var. You can get an API key from chatgpt's website.

```sh
CHATGPT_API_KEY="my_key_here"
```

* **What scenarios are not covered by this distro?**
  * **Kubernetes**: We do not provide a kubernetes plugin. There is not much neovim can do for you if you work with Kubernetes apart from the features provided by Mason (LSP, Hightighing, autocompletion..).
  * **e2e testing**: We do not provide a e2e plugin. But we do provide the :TestNodejsE2e command you can customize on [/lua/base/3-autocmds.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/3-autocmds.lua) along with all the other testing commands. You can also rename the commands to anything you want in case you don't use nodejs.
  * **Compiling and running tasks**: This is planned for the future. In the meantime we recommend [overseer.nvim](https://github.com/stevearc/overseer.nvim).


## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/NormalNvim/NormalNvim.svg)](https://starchart.cc/NormalNvim/NormalNvim)

## Credits
Originally it took AstroVim as base. But implements [this VIM config](https://github.com/amix/vimrc) with some extras. Code has been simplified while retaining its core features. NormalNvim has also contributed to the code of many of the plugins included, on order to debug them and make them better.
