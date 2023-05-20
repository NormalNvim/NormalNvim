# NormalNVim
A normal NeoVim config

## Install

```sh
git clone --depth 1 git@github.com:Zeioth/NormalNVim.git ~/.config/nvim
nvim
```

## Plugins

WIP

## Distro features

* 😴 Lazy: Plugins are loaded lazily, providing super fast startup times.
* 😎 Plugins are self-contained: Allowing you to easily delete what you don't want.
* 🔒 Plugin version lock: Options to choose "stable" or "nightly" channels to choose between locking your plugin versions, or go bleeding edge and have the latest updates.
* 🔙 Rollbacks: You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 Hot reload: Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* ❤️ We don't treat you like you stupid: Code comments guide you to easily customize everything. We will never hide or abstract stuff from you.

## Credits
Originally it took AstroVim as base. But implements [this VIM config](https://github.com/Zeioth/vim-zeioth-config). Code has been simplified while retaining its core features.
