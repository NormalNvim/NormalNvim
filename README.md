# NormalNvim
A normal NeoVim config

![screenshot_2023-05-27_16-41-26_120206834](https://github.com/Zeioth/NormalNvim/assets/3357792/8f3b76c8-3ceb-4b8d-a0e1-50f73c94eb00)


## Install

```sh
# Fork the project first, then clone from there.
git clone --depth 1 git@github.com:Zeioth/NormalNVim.git ~/.config/nvim
nvim
```

## System dependencies
```sh
pynvim       # Necessary for Rnvimr.
lcov         # Necessary for code coverage.
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

## Design decissions
You are expected to fork the project before cloning it. So you are the only one in control.

NormalNvim updates don't have a user space. This is by design. It makes the code considerably more simple. And it also gives you the keys of the house to change anything you desire. The downside is, if you update from this repo, your settings will be overrided, so don't do it unless you know what you ae doing; This is not a distro you are expected to update often from upstream. It is meant to be used as a base to create your own distro. This makes this distro rock solid and reliable.

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
