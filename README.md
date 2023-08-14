<div align="center">
  <img src="https://github.com/NormalNvim/NormalNvim/assets/3357792/76197752-0947-4392-a6bd-a59d64319028"></img>
  <h1>NormalNvim</h1>
  <h3>*✨ ~ ⭐ - A normal NeoVim config - ⭐ ~ ✨*</h3>
  <a href="https://discord.gg/ymcMaSnq7d" rel="nofollow">
      <img src="https://img.shields.io/discord/1121138836525813760?color=azure&labelColor=6DC2A4&logo=discord&logoColor=black&label=Join the discord server&style=for-the-badge" data-canonical-src="https://img.shields.io/discord/1121138836525813760">
    </a>
</div>

---


Tokyo Night (Night) theme by default
![screenshot_2023-05-27_16-41-26_120206834](https://github.com/Zeioth/NormalNvim/assets/3357792/8f3b76c8-3ceb-4b8d-a0e1-50f73c94eb00)

The space key shows [all you can do](https://github.com/Zeioth/NormalNvim/wiki/basic-mappings)
![screenshot_2023-06-14_11-41-03_398515538](https://github.com/NormalNvim/NormalNvim/assets/3357792/af73f0b2-b56e-47d8-9bb8-f68b76e4b577)


## Install (Linux/MacOS)
On UNIX, the installer will automatically install the [extra goodies](https://github.com/NormalNvim/NormalPackages), which are preconfigured debuggers, formatters, linters, treesitter, and LSP configs. If you prefer to install this manually using mason, just run the command until the first `&&`.
```sh
# Strongly recommended: Fork the repo and clone YOUR fork.
git clone git@github.com:NormalNVim/NormalNVim.git ~/.config/nvim && echo "Downloading packages:"; wget -N -O /tmp/normalnvim_packages.tar.gz https://github.com/NormalNvim/NormalPackages/raw/main/packages.tar.gz && mkdir -p ~/.local/share/nvim/lazy/ && tar -xzf /tmp/normalnvim_packages.tar.gz -C ~/.local/share/nvim/lazy/ && echo "DONE - Starting neovim."; nvim
```

## Install (Windows)
On Windows you can optionally install the [extra goodies](https://github.com/NormalNvim/NormalPackages) manually.
```sh
# Strongly recommended: Fork the repo and clone YOUR fork.
git clone git@github.com:NormalNVim/NormalNVim.git %USERPROFILE%\AppData\Local\nvim && nvim
```

## System dependencies
If you miss a dependency it won't cause any error, but it will disable the feature.
```sh
ranger       # Necessary for Rnvimr.
pynvim       # Necessary for Rnvimr.
ripgrep      # Necessary for Spectre.
yarn         # Necessary for Markmap.
delta        # Necessary for telescope-undo.
grcov        # Necessary for test coverage.
jdtls        # Necessary for the java debugger.
dlv          # Necessary for the go debugger.
jest         # Necessary for neotest-jest (installed as yarn global add jest).
pytest       # Necessary for neotest-python
cargo-nextest # Nesessary for neotest-rust (installed as cargo install cargo-nextest)
nunit        # Necessary for neotest-dotnet (installed as dotnet tool install --global nunit)
```
To use the compiler, you will neeed its depedencies too. [Check here](https://github.com/Zeioth/Compiler.nvim/wiki/how-to-install-the-required-dependencies)

## Distro features

* ⚡ **Lazy:** Plugins are loaded lazily, providing super fast performance.
* 😎 **Plugins are self-contained:** Allowing you to easily delete what you don't want.
* 🔋 **Batteries included:** Most plugins you will ever need are included and debugged by default. Get the best user experience out of the box and forget about nasty bugs in your Neovim config.
* 🐞 **IDE:** Debuggers, Linters, Formatters, linters, LSP... preinstalled, preconfigured and ready to code for the top 12 most popular programming languages.
* 🔒 **Plugin version lock:** You can choose "stable" or "nightly" update channels. Or if you prefer, use :NvimFreezePluginVersions to create your own stable versions!
* 🔙 **Rollbacks:** You can easily recover from a nvim distro update using :NvimRollbackRestore
* 🔥 **Hot reload:** Every time you change something in your config, the changes are reflected on nvim on real time without need to restart.
* 📱 **Phone friendly:** Good usability even on smalll screens.
* ⌨️ **Alternative mappings:** By default the distro uses qwerty, but colemak-dh can be found [here](https://github.com/Zeioth/NormalNvim/wiki/colemak-dh).
* ❤️ **We don't treat you like you are stupid:** Code comments guide you to easily customize everything. We will never [hide or abstract](https://i.imgur.com/FCiZvp2.png) stuff from you.

## Philosophy and design decisions
__You are expected to fork the project before cloning it. So you are the only one in control. It is also recommended to use [neovim's appimage](https://github.com/neovim/neovim/releases).__

> This is not a distro you are expected to update often from upstream. It is meant to be used as a base to create your own distro.

[NormalNvim](https://github.com/Zeioth/NormalNvim) won't be the next [/r/UnixPorn](https://www.reddit.com/r/unixporn/) sensation. It is a normal nvim config you can trust 100% will never unexpectedly break while you are working. Nothing flashy. Nothing brightful. Just bread and butter.

## Commands

|  Command            | Description                             |
|---------------------|-----------------------------------------|
| **:healthcheck base**   | Look for errors in NormalNvim. |
| **:NvimFreezePluginVersions** | Creates `lazy_versions.lua` in your config directory, containing your current plugin versions. If you are using the `stable` updates channel, this file will be used to decide what plugin versions will be installed, and even if you manually try to update your plugins using lazy package manager, the versions file will be respected. If you are using the `nightly` channel, the first time you open nvim, the versions from `lazy_versions.lua` will be installed, but it will be possible to download the last versions by manually updating your plugins with lazy. Note that after running this command, you can manually modify `lazy_versions.lua` in case you only want to freeze some plugins. |
| **:NvimReload** | Hot reloads the config without leaving nvim. It can cause unexpected issues sometimes. It is automatically triggered when writing the files `1-options.lua` and `4-mappings`. | 
| **:NvimRollbackCreate** | Creates a recovery point. It is triggered automatically when running `:NvimUpdateConfig`. | 
| **:NvimRollbackRestore** | Uses git to bring your config to the state it had when `:NvimRollbackCreate` was called. | 
| **:NvimUpdateConfig** | Pulls the latest changes from the current git repository of your nvim config. Useful to keep your config fresh when you use it in more than one machine. If the updates channel is `stable` this command will pull from the latest available tag release in your github repository. Only tag releases starting by 'v', such as v1.0.0 are recognized. It is also possible to define an specific stable version in `2-lazy.lua` by setting the option `stable_vesion_release`. If the channel is `nightly` it will pull from the nightly branch. Note that uncommited local changes in your config will be lost after an update, so it's important you commit before updating your distro config. |
| **:NvimUpdatePlugins** | Uses lazy to update the plugins. |
| **:NvimVersion** | Prints the commit number of the current NormalNvim version. |

For more info, [read the wiki](https://github.com/Zeioth/NormalNvim/wiki).

## FAQ
Please before opening an issue, check [the AstroNvim manual](https://astronvim.com/) and the [AstroVim Community](https://github.com/AstroNvim/astrocommunity) repos where you can find help about how to install and configure most plugins.

* **NormalNvim is not working. How can I know why?**

    `:healthcheck base`

* **Supports Windows?**
Yes, 100%. This is not necessary, but we advise you to launch NormalNvim using [WLS](https://www.youtube.com/watch?v=nARnhEkVAxY). If you do, you can install stuff with the command `apt install mydependency`. This is particulary cool if you want to use `F6` to run [compiler.nvim](https://github.com/Zeioth/compiler.nvim), because you can only compile with the compilers you have installed.

* **How can I disable the tabline?** On the options file, search for `showtabline` and set it to 0. If instead you want to remove the functionality completely from nvim, then check the plugin heirline. Here is where we implement the tabline logic. Also check [./lua/base/utils/status.lua](https://github.com/NormalNvim/NormalNvim/blob/main/lua/base/utils/status.lua) if you want to delete heirline helpers functions.

* **How can I disable the animations?** You can delete the plugin [mini.animate](https://github.com/echasnovski/mini.animate). In case you only want to disable some animations look into the plugin docs.

* **How can I use `Ask chatgpt`?** On your operative system, set the next env var. You can get an API key from chatgpt's website.

```sh
CHATGPT_API_KEY="my_key_here"
```

* **What scenarios are not covered by this distro?**
  * **Kubernetes**: We do not provide a kubernetes plugin. But we recommend using friendly-snippets, to quickly write code, and [overseer.nvim](https://github.com/stevearc/overseer.nvim) to run kubernetes commands from inside nvim without having to wait for the server response.
  * **e2e testing**: We do not provide an e2e plugin. But we do provide the :TestNodejsE2e command you can customize on [/lua/base/3-autocmds.lua](https://github.com/Zeioth/NormalNvim/blob/main/lua/base/3-autocmds.lua) along with all the other testing commands. You can also rename the commands to anything you want in case you don't use nodejs.

## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/NormalNvim/NormalNvim.svg)](https://starchart.cc/NormalNvim/NormalNvim)

## Credits
Originally it took AstroNvim as base. But implements [this VIM config](https://github.com/amix/vimrc) with some extras. Code has been simplified while retaining its core features. NormalNvim has also contributed to the code of many of the plugins included, in order to debug them and make them better.

Special thanks to LeoRed04 for designing the logo.

## Roadmap
* ~~Porting vim-dooku to neovim/lua~~.
* Ship debuggers/testers/formatters/linters with NormalNvim.
* Create a clear link to the list of included plugins.
* Setup contributors page.
* Creating a landing page.
* Add all the debuggers to a link in the dependencies section, to make easier for users setting up dap.
* While on the debugger, add an option to the contextual menu to toggle breakpoint.

## Scratchpad
(WIP, this is not ready yet, these are just my notes.)

Also, WIP for testers:

```
# jest
Requires jest in your project, or system.

# Python
Requires the system package pytest

# Rust
Requires the system package rust-nextest

# Dotnet
Requires the nuget pacakge nunit
dotnet tool install --global nunit

# Go
Doesn't require any dependency.
```
