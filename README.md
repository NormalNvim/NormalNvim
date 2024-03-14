<div align="center">
  <img src="https://github.com/NormalNvim/NormalNvim/assets/3357792/76197752-0947-4392-a6bd-a59d64319028"></img>
  <h1><a href="https://github.com/NormalNvim/NormalNvim">NormalNvim</a></h1>
  <h3>*✨ ~ ⭐ - A normal Neovim distribution - ⭐ ~ ✨*</h3>
  <a href="https://discord.gg/ymcMaSnq7d" rel="nofollow">
      <img src="https://img.shields.io/discord/1121138836525813760?color=azure&labelColor=6DC2A4&logo=discord&logoColor=black&label=Join the discord server&style=for-the-badge" data-canonical-src="https://img.shields.io/discord/1121138836525813760">
    </a>
</div>

---

- [Screenshots](#screenshots)
- [How to install](#how-to-install)
- [Distro features](#distro-features)
- [Philosophy and design decisions](#philosophy-and-design-decisions)
- [Commands](#commands)
- [Wiki](https://github.com/NormalNvim/NormalNvim/wiki)
- [FAQ](#faq)

## Screenshots

Tokyo Night (Night) theme by default
![screenshot_2023-11-11_05-07-36_209146790](https://github.com/NormalNvim/NormalNvim/assets/3357792/d487a27a-d314-4f20-b209-90f0d25c10d1)

The space key shows [all you can do](https://github.com/NormalNvim/NormalNvim/wiki/basic-mappings)
![screenshot_2024-03-12_22-48-45_446272370](https://github.com/NormalNvim/NormalNvim/assets/3357792/1fb4a576-e04f-481b-9692-67cdcc071d13)

If you are new here don't forget to [check the wiki](https://github.com/NormalNvim/NormalNvim/wiki).

## How to install

### Installer (Linux/MacOS/WSL)
You can preview it [here](https://github.com/Revnixcad/installer)
```sh
wget -q https://raw.githubusercontent.com/NormalNvim/installer/main/installer.sh && chmod +x installer.sh && ./installer.sh
```

### Clone manually (Linux/MacOS/WSL)
```sh
# Strongly recommended: Fork the repo and clone YOUR fork.
git clone https://github.com/Revnixcad/NormalNvim.git ~/.config/nvim
```

### Clone manually (Windows)
```sh
# Strongly recommended: Fork the repo and clone YOUR fork.
git clone https://github.com/Revnixcad/NormalNvim.git %USERPROFILE%\AppData\Local\nvim && nvim
```

### Optional dependencies
This is only necessary if you installed NormalNvim by cloning manually. [To unlock all features you will have to install the dependencies](https://github.com/NormalNvim/NormalNvim/wiki/dependencies).

## Distro features

* ⚡ **Lazy:** Plugins are loaded lazily, providing super fast performance.
* 🔋 **Batteries included:** Most [plugins](https://github.com/NormalNvim/NormalNvim/wiki/plugins) you will ever need are included and debugged by default. Get the best user experience out of the box and forget about nasty bugs in your Neovim config.
* 😎 **Plugins are self-contained:** Allowing you to easily delete what you need.
* 🤖 **IDE tools:** We ship [Compiler.nvim](https://github.com/Zeioth/compiler.nvim) (compiler), [DAP](https://github.com/mfussenegger/nvim-dap) (debugger), [Neotest](https://github.com/nvim-neotest/neotest) (test runner), and [Dooku.nvim](https://github.com/Zeioth/dooku.nvim) (docs generator)
* 🐞 **IDE parsers:** Linters, Formatters, LSP, Treesitter... preinstalled, preconfigured and ready to code for the top 12 most popular programming languages.
* 🥶 **Plugin version freeze:** You can choose "stable" or "nightly" update channels. Or if you prefer, use :DistroFreezePluginVersions to create your own stable versions!
* 🔙 **Rollbacks:** You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 **Hot reload:** Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* 📱 **Phone friendly:** You can also install it on Android Termux. Did you ever have a compiler in your pocket? 😉
* ⌨️ **Alternative mappings:** By default the distro uses qwerty, but colemak-dh can be found [here](https://github.com/NormalNvim/NormalNvim/wiki).
* ✨ **Fully modular:** Every feature is a small plugin.
* 👽 **100% agnostic:** Any plugin NormalNvim ship, can be used in any distro.
* ❤️ **We don't treat you like you are stupid:** Code comments guide you to easily customize everything. We will never [hide or abstract](https://i.imgur.com/FCiZvp2.png) stuff from you.

## Philosophy and design decisions
__You are expected to fork the project before cloning it. So you are the only one in control. It is also recommended to use [neovim's appimage](https://github.com/neovim/neovim/releases).__

> This is not a distro you are expected to update often from upstream. It is meant to be used as a base to create your own distro.

[NormalNvim](https://github.com/NormalNvim/NormalNvim) won't be the next [/r/UnixPorn](https://www.reddit.com/r/unixporn/) sensation. It is a normal nvim config you can trust 100% will never unexpectedly break while you are working. Nothing flashy. Nothing brightful. Just bread and butter.

## Commands
The next relevant commands are provided by [distroupdate.nvim](https://github.com/Zeioth/distroupdate.nvim)

|  Command            | Description                             |
|---------------------|-----------------------------------------|
| **:DistroUpdate** | To update the distro from git origin. Local uncommited changes will be lost. |
| **:DistroUpdateRevert** | To revert the last `:NvimDistroUpdate`. |
| **:DistroFreezePluginVersions** | To save your current plugin versions into `lazy_versions.lua`. |

## FAQ
Please before opening an issue, check the [astrocommunity](https://github.com/AstroNvim/astrocommunity) repo where you can find help about how to install and configure most plugins.

* **NormalNvim is not working. How can I know why?**

    `:checkhealth base`

* **Why can't I see the icons?** You must install the [nerdfont version of your font](https://www.nerdfonts.com/), and use it on your terminal. Alternatively you can edit `base/icons/nerd_fond.lua` to manually specify your own icons.

* **How can I install a new colorscheme?** Go to `plugins/2-ui.lua`, and add the theme you want. Re-open nvim and now you can set your new colorcheme on `base/1-options.lua`. You can also preview all your installed themes with `<space>+ft`.

* **How can I change the user interface?** We use the plugin heirline to create the user interface. You can re-order or change any component of your user interface in `plugins/2-ui.lua`. If you preffer the classic vim appearance, you can delete the plugin.

* **How can I disable the animations?** You can delete the plugin [mini.animate](https://github.com/echasnovski/mini.animate). In case you only want to disable some animations look into the plugin docs.

* **How can I use `Ask chatgpt`?** On your operative system, set the next env var. You can get an API key from [chatgpt's website](https://platform.openai.com/account/api-keys).

```sh
OPENAI_API_KEY="my_key_here"
```

## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/NormalNvim/NormalNvim.svg)](https://starchart.cc/NormalNvim/NormalNvim)

## Fix a bug and send a PR to appear as contributor

<a href="https://github.com/NormalNvim/NormalNvim/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=NormalNvim/NormalNvim" />
</a>

## Credits
Originally it took AstroNvim as base. But implements [this VIM config](https://github.com/amix/vimrc) with some extras. Code has been simplified while retaining its core features. NormalNvim has also contributed to the code of many of the plugins included, in order to debug them and make them better.

Special thanks to LeoRed04 for designing the logo.

## Trivia
Did you know NormalNvim was the first Neovim distro to ship a compiler that [support 22+ programming languages out of the box](https://www.youtube.com/watch?v=O42uCIBaCIQ)?

## Roadmap
* We are currently in a stable state.
* Once selene add [this](https://github.com/Kampfkarren/selene/issues/224) and [this](https://github.com/Kampfkarren/selene/issues/524) and [this](https://github.com/Kampfkarren/selene/pull/591), let's add the new rules.
* On aerial, let's keep an eye on [this](https://github.com/stevearc/aerial.nvim/issues/352) UX improvement.
* Once nvim 0.10 is officially released, replace `get_active_clients` by `get_clients`.
* Once nvim 0.10 is officially released, remove `unpack` in favor of `table.unpack`.
* During 2024, create a landing page. Pretty much it's gonna be the same thing we have on the wiki, but with sparkles.
