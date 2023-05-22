# NormalNVim
A normal NeoVim config

## Install

```sh
git clone --depth 1 git@github.com:Zeioth/NormalNVim.git ~/.config/nvim
nvim
```

## Distro features

* 😴 Lazy: Plugins are loaded lazily, providing super fast startup times.
* 😎 Plugins are self-contained: Allowing you to easily delete what you don't want.
* 🔒 Plugin version lock: Options to choose "stable" or "nightly" channels to choose between locking your plugin versions, or go bleeding edge and have the latest updates.
* 🔙 Rollbacks: You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 Hot reload: Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* ❤️ We don't treat you like you stupid: Code comments guide you to easily customize everything. We will never hide or abstract stuff from you.

## Plugins

WIP

## FAQ
Please before opening an issue, check [the AstroVim manual](https://neovim.io/doc/user/pi_health.html).

* How do I check NormalNvim is working ok?

    :healthcheck base

* How do I disable the tabs? You either ":set showtabline=0" or check the plugin heirline. Here is where we implement the logic.

## Credits
Originally it took AstroVim as base. But implements [this VIM config](https://github.com/Zeioth/vim-zeioth-config). Code has been simplified while retaining its core features.

