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

* 😴 Lazy: Plugins are loaded lazily, providing super fast startup times.
* 😎 Plugins are self-contained: Allowing you to easily delete what you don't want.
* 🔒 Plugin version lock: Options to choose "stable" or "nightly" channels to choose between locking your plugin versions, or go bleeding edge and have the latest updates.
* 🔙 Rollbacks: You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 Hot reload: Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* 📱 Phone friendly: Good usability even on smalll screens.
* ❤️ We don't treat you like you stupid: Code comments guide you to easily customize everything. We will never hide or abstract stuff from you.

## Plugins

WIP

## FAQ
Please before opening an issue, check [the AstroVim manual](https://neovim.io/doc/user/pi_health.html).

* **NormalNvim is not working ok. How can I know why?**

    :healthcheck base

* **How do I disable the tabline?** On the options file, set showtabline=0. If you wanna remove the functionality completely from nvim check the plugin heirline. Here is where we implement the tab logic. Also check the ./lua/base/3-autocmds.lua and ./lua/base/utils/status.lua.

* **What scenarios are not covered by this distro?**
  * **Kubernetes**: We do not provide a kubernetes plugin. There is not much neovim can do for you if you work with Kubernetes apart from the features provided by Mason (LSP, Hightighing, autocompletion..).
  * **e2e testing**: We to not provide a e2e plugin. But we do provide the :TestNodejsE2e command you can customize on [/lua/base/3-autocmds.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/3-autocmds.lua) along with all the other testing commands.

## Credits
Originally it took AstroVim as base. But implements [this VIM config](https://github.com/Zeioth/vim-zeioth-config). Code has been simplified while retaining its core features.

