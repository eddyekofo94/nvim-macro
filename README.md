<h1 align="center"> Bekaboo's Neovim Configuration </h1>

<center>
    <div>
        <img src="https://github.com/Bekaboo/nvim/assets/76579810/ff20fc73-4d21-478b-ae13-728832e4f3db" width=47.5%>
        <img src="https://github.com/Bekaboo/nvim/assets/76579810/1f2ceeaf-3b78-4777-afc7-db0b7f6ba69a" width=47.5%>
    </div>
</center>

## Table of Contents

<!--toc:start-->
- [Table of Contents](#table-of-contents)
- [Features](#features)
- [Requirements and Dependencies](#requirements-and-dependencies)
  - [Basic](#basic)
  - [Tree-sitter](#tree-sitter)
  - [LSP](#lsp)
  - [DAP](#dap)
  - [Formatter](#formatter)
  - [Other External Tools](#other-external-tools)
- [Installation](#installation)
- [Config Structure](#config-structure)
- [Tweaking this Configuration](#tweaking-this-configuration)
  - [Managing Plugins with Modules](#managing-plugins-with-modules)
  - [Installing Packages to an Existing Module](#installing-packages-to-an-existing-module)
  - [Installing Packages to a New Module](#installing-packages-to-a-new-module)
  - [General Settings and Options](#general-settings-and-options)
  - [Keymaps](#keymaps)
  - [Colorscheme](#colorscheme)
  - [Auto Commands](#auto-commands)
  - [LSP Server Configurations](#lsp-server-configurations)
  - [DAP Configurations](#dap-configurations)
  - [Snippets](#snippets)
  - [Enabling VSCode Integration](#enabling-vscode-integration)
- [Appendix](#appendix)
  - [Default Modules and Plugins of Choice](#default-modules-and-plugins-of-choice)
      - [Third Party Plugins](#third-party-plugins)
    - [Local Plugins](#local-plugins)
  - [Startuptime Statistics](#startuptime-statistics)
<!--toc:end-->

## Features

- Modular design
    - Install and manage packages in groups
    - Make it easy to use different set of configuration for different use
      cases
- [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) integration
    - Feels at home in VSCode when you occasionally need it
- Massive [TeX math snippets](https://github.com/Bekaboo/nvim/blob/master/lua/snippets/shared/math.lua)
- Custom UI elements ([statusline](https://github.com/Bekaboo/nvim/blob/master/plugin/statusline.lua), [statuscolumn](https://github.com/Bekaboo/nvim/blob/master/plugin/statuscolumn.lua), [winbar](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/winbar)) and [colorschemes](https://github.com/Bekaboo/nvim/tree/master/colors)
- [Fine-tuned plugins](https://github.com/Bekaboo/nvim/tree/master/lua/configs) with [custom patches](https://github.com/Bekaboo/nvim/tree/master/patches)
- Fast startup around [15 ~ 35 ms](#startuptime-statistics)

## Requirements and Dependencies

### Basic

- [Neovim](https://github.com/neovim/neovim) ***nightly***
- [Git](https://git-scm.com/)
- A decent terminal emulator
- A nerd font, e.g. [JetbrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono)

### Tree-sitter

Tree-sitter installation and configuration is handled by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

To add or remove support for a language, install or uninstall the corresponding
parser using `:TSInstall` or `:TSUninstall`.

To make the change persistent, add or remove corresponding entries in `M.langs`
in [lua/utils/static.lua](https://github.com/Bekaboo/nvim/blob/master/lua/utils/static.lua).

### LSP

For LSP support, install the following language servers manually use your
favorite package manager:

- Bash: install [BashLS](https://github.com/bash-lsp/bash-language-server)

    Example for ArchLinux users:

    ```sh
    sudo pacman -S bash-language-server
    ```

- C/C++: install [Clang](https://clang.llvm.org/)
- Lua: install [LuaLS](https://github.com/LuaLS/lua-language-server)
- Python: install [PyLSP](https://github.com/python-lsp/python-lsp-server)
- Rust: install [Rust Analyzer](https://rust-analyzer.github.io/)
- LaTeX: install [TexLab](https://github.com/latex-lsp/texlab)
- VimL: install [VimLS](https://github.com/iamcco/vim-language-server)
- Markdown: install [Marksman](https://github.com/artempyanykh/marksman)
- \*General-purpose LSP: install [EFM Language Server](https://github.com/mattn/efm-langserver)
    - Already configured for [Black](https://github.com/psf/black), [Shfmt](https://github.com/mvdan/sh), and [StyLua](https://github.com/JohnnyMorganz/StyLua)
    - Find configuration in [lua/configs/lsp-server-configs/efm.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/lsp-server-configs/efm.lua)

To add support for other languages, install corresponding LS manually and
append the language and its language server to `M.langs` in [lua/utils/static.lua](https://github.com/Bekaboo/nvim/blob/master/lua/utils/static.lua)
so that [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) will pick them up.

### DAP

Install the following debug adapters manually:

- Bash:

    Go to [vscode-bash-debug release page](https://github.com/rogalmic/vscode-bash-debug/releases),
    download the latest release (`bash-debug-x.x.x.vsix`), extract
    (change the extension from `.vsix` to `.zip` then unzip it) the contents
    to a new directory `vscode-bash-debug/` and put it under stdpath `data`
    (see `:h stdpath`).

    Make sure `node` is executable.

- C/C++: install [CodeLLDB](https://github.com/vadimcn/codelldb).

    Example for ArchLinux users:

    ```sh
    yay -S codelldb     # Install from AUR
    ```

- Python: install [DebugPy](https://github.com/microsoft/debugpy)

    Example for ArchLinux users:

    ```sh
    sudo pacman -S python-debugpy
    ```

    or

    ```sh
    pip install --local debugpy # Install to user's home directory
    ```

### Formatter

- Bash: install [Shfmt](https://github.com/mvdan/sh)
- C/C++: install [Clang](https://clang.llvm.org/) to use `clang-format`
- Lua: install [StyLua](https://github.com/JohnnyMorganz/StyLua)
- Rust: install [Rust](https://www.rust-lang.org/tools/install) to use `rustfmt`
- Python: install [Black](https://github.com/psf/black)
- LaTeX: install [texlive-core](http://tug.org/texlive/) to use `latexindent`

### Other External Tools

- [Lazygit](https://github.com/jesseduffield/lazygit) for improved git integration
- [Fd](https://github.com/sharkdp/fd), [Ripgrep](https://github.com/BurntSushi/ripgrep), and [Fzf](https://github.com/junegunn/fzf) for fuzzy search
- [Neovim Remote](https://github.com/mhinz/neovim-remote) and [Ranger](https://github.com/ranger/ranger) for file manager support
- [Pandoc](https://pandoc.org/), [custom scripts](https://github.com/Bekaboo/dot/tree/master/.scripts) and [TexLive](https://www.tug.org/texlive/) (for ArchLinux users, it is `texlive-core` and `texlive-extra`) for markdown → PDF conversion

## Installation

1. Backup your own settings.
2. Make sure you have satisfied the requirements.
3. Clone this repo to your config directory
    ```
    git clone https://github.com/Bekaboo/nvim ~/.config/nvim
    ```
4. Open neovim, manually run `:Lazy sync` if lazy.nvim does not
    automatically sync.
5. Run `:checkhealth` to check potential dependency issues.
6. Enjoy!

## Config Structure

```
.
├── colors                      # colorschemes
├── plugin                      # custom plugins
├── ftplugin                    # custom filetype plugins
├── init.lua                    # entry of config
├── lua
│   ├── init                    # files under this folder is required by 'init.lua'
│   │   ├── autocmds.lua
│   │   ├── general.lua         # options and general settings
│   │   ├── keymaps.lua
│   │   └── plugins.lua         # specify which modules to use in different conditions
│   ├── modules                 # all plugin specifications and configs go here
│   │   ├── base.lua            # plugin specifications in module 'base'
│   │   ├── completion.lua      # plugin specifications in module 'completion'
│   │   ├── debug.lua           # plugin specifications in modules 'debug'
│   │   ├── lsp.lua             # plugin specifications in module 'lsp'
│   │   ├── markup.lua          # ...
│   │   ├── misc.lua
│   │   ├── tools.lua
│   │   ├── treesitter.lua
│   │   └── ui.lua
│   ├── configs                 # configs for each plugin
│   ├── snippets                # snippets
│   ├── plugin                  # the actual implementation of custom plugins
│   └── utils
└── syntax                      # syntax files
```

## Tweaking this Configuration

### Managing Plugins with Modules

In order to enable or disable a module, one need to change the table in
[lua/init/plugins.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua) passed to `manage_plugins()`, for example

```lua
enable_modules({
  'base',
  'treesitter',
  'edit',
  -- ...
})
```

the format of argument passed to `manage_plugins` is the same as that passed to
lazy.nvim's setup function.

### Installing Packages to an Existing Module

To install plugin `foo` under module `bar`, just insert the
corresponding specification to the big table
`lua/modules/bar.lua` returns, for instance,

`lua/modules/bar.lua`:

```lua
return {
  -- ...
  {
    'foo/foo',
    dependencies = 'foo_dep',
  },
}
```

### Installing Packages to a New Module

To install plugin `foo` under module `bar`, one should first
create module `bar` under [lua/modules](https://github.com/Bekaboo/nvim/tree/master/lua/modules):

```
.
└── lua
    └── modules
        └── bar.lua
```

a module should return a big table containing all specifications of plugins
under that module, for instance:

```lua
return {
  {
    'goolord/alpha-nvim',
    cond = function()
      return vim.fn.argc() == 0 and
          vim.o.lines >= 36 and vim.o.columns >= 80
    end,
    dependencies = 'nvim-web-devicons',
  },

  {
    'romgrk/barbar.nvim',
    dependencies = 'nvim-web-devicons',
    config = function() require('bufferline').setup() end,
  },
}
```

After creating the new module `bar`, enable it in [lua/init/plugins.lua](hub.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua):

```lua
enable_modules({
  -- ...
  'bar',
  -- ...
})
```

### General Settings and Options

See [lua/init/general.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/general.lua).

### Keymaps

See [lua/init/keymaps.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/keymaps.lua), or see module config files for
corresponding plugin keymaps.

### Colorscheme

- Nano

    <div>
        <img src="https://github.com/Bekaboo/nvim/assets/76579810/a79e1322-114c-46c8-80ff-c29129f8cb2a" width=47.5%>
        <img src="https://github.com/Bekaboo/nvim/assets/76579810/be61e9bf-84d8-472a-a3b1-a0d2962e636a" width=47.5%>
    </div>

- Cockatoo

    <div>
        <img src="https://github.com/Bekaboo/nvim/assets/76579810/de4c61f6-a8a8-409d-bb6d-6bb144e65832" width=47.5%>
        <img src="https://github.com/Bekaboo/nvim/assets/76579810/035eb032-bbe5-48a5-abaf-4b334516c2cd" width=47.5%>
    </div>

`cockatoo` and `nano` are two builtin custom colorschemes, with seperate
palettes for dark and light background.

Neovim is configured to restore the previous background and colorscheme
settings on startup, so there is no need to set them up in the config
file explicitly.

To disable the auto-restore feature, remove corresponding lines in
[lua/init/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/autocmds.lua)

To tweak this colorscheme, see [colors/cockatoo.lua](https://github.com/Bekaboo/nvim/tree/master/colors/cockatoo.lua) and [colors/nano.lua](https://github.com/Bekaboo/nvim/tree/master/colors/nano.lua)

### Auto Commands

See [lua/init/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/autocmds.lua).

### LSP Server Configurations

See [lua/configs/lsp-server-configs](https://github.com/Bekaboo/nvim/tree/master/lua/configs/lsp-server-configs) and [lua/configs/nvim-lspconfig.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-lspconfig.lua).

### DAP Configurations

See [lua/configs/dap-configs](https://github.com/Bekaboo/nvim/tree/master/lua/configs/dap-configs), [lua/configs/nvim-dap.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-dap.lua), and [lua/configs/nvim-dap-ui.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-dap-ui.lua).

### Snippets

This configuration use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) as the snippet engine,
custom snippets for different filetypes
are defined under [lua/snippets](https://github.com/Bekaboo/nvim/tree/master/lua/snippets).

### Enabling VSCode Integration

VSCode integration takes advantages of the modular design, allowing to use
a different set of modules when Neovim is launched by VSCode, relevant code is
in [plugin/vscode-neovim.vim](https://github.com/Bekaboo/nvim/blob/master/plugin/vscode-neovim.vim) and [lua/init/plugins.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua).

To make VSCode integration work, please install [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) in VSCode
and configure it correctly.

After setting up VSCode-Neovim, re-enter VSCode, open a random file
and it should work out of the box.

## Appendix

### Default Modules and Plugins of Choice

#### Third Party Plugins

Total # of plugins: 44 (package manager included).

- **Base**
    - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
    - [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
    - [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- **Completion**
    - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    - [cmp-calc](https://github.com/hrsh7th/cmp-calc)
    - [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
    - [fuzzy.nvim](https://github.com/tzachar/fuzzy.nvim)
    - [cmp-fuzzy-path](https://github.com/tzachar/cmp-fuzzy-path)
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
    - [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
    - [cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
    - [cmp-dap](https://github.com/rcarriga/cmp-dap)
    - [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
    - [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **LSP**
    - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    - [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim)
    - [glance.nvim](https://github.com/dnlhc/glance.nvim)
- **Markup**
    - [vimtex](https://github.com/lervag/vimtex)
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    - [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
- **Edit**
    - [nvim-surround](https://github.com/kylechui/nvim-surround)
    - [Comment.nvim](https://github.com/numToStr/Comment.nvim)
    - [vim-sleuth](https://github.com/tpope/vim-sleuth)
    - [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
    - [fcitx.nvim](https://github.com/h-hg/fcitx.nvim)
    - [vim-easy-align](https://github.com/junegunn/vim-easy-align)
- **Tools**
    - [fzf-lua](https://github.com/ibhagwan/fzf-lua)
    - [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
    - [flatten.nvim](https://github.com/willothy/flatten.nvim)
    - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
    - [git-conflict](akinsho/git-conflict.nvim)
    - [rnvimr](https://github.com/kevinhwang91/rnvimr)
    - [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive)
- **Treesitter**
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
    - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
    - [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
    - [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)
    - [treesj](https://github.com/Wansmer/treesj)
    - [cellular-automaton.nvim](https://github.com/Eandrju/cellular-automaton.nvim)
- **DEBUG**
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap)
    - [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
    - [one-small-step-for-vimkind](https://github.com/jbyuki/one-small-step-for-vimkind)

#### Local Plugins

- [colorcolumn](https://github.com/Bekaboo/nvim/tree/master/plugin/colorcolumn.lua)
    - shows color column dynamically based on current line width
    - released as [deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)
- [expandtab](https://github.com/Bekaboo/nvim/tree/master/plugin/expandtab.lua)
    - always use spaces for alignment
- [hlsearch](https://github.com/Bekaboo/nvim/tree/master/plugin/hlsearch.lua)
    - toggles `'hlsearch'` smartly
- [readline](https://github.com/Bekaboo/nvim/tree/master/plugin/readline.lua)
    - readline-like keybindings in insert and command mode
- [statuscolumn](https://github.com/Bekaboo/nvim/tree/master/plugin/statuscolumn.lua)
    - custom statuscolumn, with git signs on the right of line numbers
- [statusline](https://github.com/Bekaboo/nvim/tree/master/plugin/statusline.lua)
    - custom statusline inspired by [nano-emacs](https://github.com/rougier/nano-emacs)
- [tabout](https://github.com/Bekaboo/nvim/tree/master/plugin/tabout.lua)
    - tab in and out with `<Tab>` and `<S-Tab>`
- [vscode-neovim](https://github.com/Bekaboo/nvim/tree/master/plugin/vscode-neovim.vim)
    - integration with [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim)
- [winbar](https://github.com/Bekaboo/nvim/blob/master/plugin/winbar.lua)
    - a winbar with drop-down menus and multiple backends
    - released as [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)

### Startuptime Statistics

Last update: 2023-06-27

Neovim Version: `NVIM v0.10.0-dev-585+g2e055e49a3`

Config Commit: `25d92d44dcfa20ec3a980132b3d2fd053cf2daa0` (#1582)

System: Arch Linux 6.3.9

Machine: Dell XPS-13-7390

Command: `nvim --startuptime startuptime.log`

<details>
  <summary>startuptime log</summary>

  ```
    times in msec
     clock   self+sourced   self:  sourced script
     clock   elapsed:              other lines

    000.005  000.005: --- NVIM STARTING ---
    000.058  000.053: event init
    000.105  000.047: early init
    000.139  000.034: locale set
    000.170  000.031: init first window
    000.371  000.201: inits 1
    000.382  000.012: window checked
    000.384  000.002: parsing arguments
    000.762  000.053  000.053: require('vim.shared')
    000.859  000.035  000.035: require('vim._meta')
    000.861  000.095  000.061: require('vim._editor')
    000.862  000.195  000.047: require('vim._init_packages')
    000.866  000.286: init lua interpreter
    000.921  000.055: expanding arguments
    000.951  000.030: inits 2
    001.186  000.235: init highlight
    001.187  000.001: waiting for UI
    001.332  000.145: done waiting for UI
    001.341  000.009: clear screen
    001.455  000.114: init default mappings & autocommands
    001.751  000.045  000.045: sourcing /usr/share/nvim/runtime/ftplugin.vim
    001.799  000.023  000.023: sourcing /usr/share/nvim/runtime/indent.vim
    001.839  000.008  000.008: sourcing /usr/share/nvim/archlinux.vim
    001.842  000.023  000.015: sourcing /etc/xdg/nvim/sysinit.vim
    002.480  000.612  000.612: require('init.general')
    002.649  000.025  000.025: require('utils')
    002.660  000.008  000.008: require('vim.keymap')
    003.445  000.033  000.033: require('utils.funcs')
    003.485  000.036  000.036: require('utils.funcs.keymap')
    003.619  001.135  001.033: require('init.keymaps')
    003.959  000.339  000.339: require('init.autocmds')
    004.553  000.271  000.271: require('modules.base')
    004.642  000.050  000.050: require('modules.completion')
    004.721  000.042  000.042: require('modules.debug')
    004.766  000.041  000.041: require('modules.editor')
    004.806  000.036  000.036: require('modules.lsp')
    004.846  000.036  000.036: require('modules.markup')
    004.936  000.085  000.085: require('modules.tools')
    005.018  000.078  000.078: require('modules.treesitter')
    005.043  000.021  000.021: require('modules.ui')
    005.139  000.092  000.092: require('lazy')
    005.180  000.012  000.012: require('ffi')
    005.209  000.026  000.026: require('vim.loader')
    005.274  000.015  000.015: require('vim.fs')
    005.543  000.298  000.283: require('lazy.stats')
    005.707  000.142  000.142: require('lazy.core.util')
    005.841  000.131  000.131: require('lazy.core.config')
    006.133  000.186  000.186: require('lazy.core.handler')
    006.281  000.145  000.145: require('lazy.core.plugin')
    006.290  000.446  000.116: require('lazy.core.loader')
    008.936  000.149  000.149: require('lazy.core.handler.event')
    009.077  000.136  000.136: require('lazy.core.handler.ft')
    009.166  000.084  000.084: require('lazy.core.handler.cmd')
    009.225  000.056  000.056: require('lazy.core.handler.keys')
    009.330  000.028  000.028: sourcing /home/zeng/.local/share/nvim/site/pack/packages/opt/vimtex/ftdetect/cls.vim
    009.372  000.019  000.019: sourcing /home/zeng/.local/share/nvim/site/pack/packages/opt/vimtex/ftdetect/tex.vim
    009.409  000.014  000.014: sourcing /home/zeng/.local/share/nvim/site/pack/packages/opt/vimtex/ftdetect/tikz.vim
    011.277  000.246  000.246: sourcing /usr/share/nvim/runtime/filetype.lua
    011.615  000.242  000.242: require('configs.rnvimr')
    011.854  000.130  000.130: sourcing /home/zeng/.config/nvim/plugin/colorcolumn.lua
    011.984  000.104  000.104: sourcing /home/zeng/.config/nvim/plugin/expandtab.lua
    012.197  000.185  000.185: sourcing /home/zeng/.config/nvim/plugin/hlsearch.lua
    012.285  000.060  000.060: sourcing /home/zeng/.config/nvim/plugin/readline.lua
    012.424  000.112  000.112: sourcing /home/zeng/.config/nvim/plugin/statuscolumn.lua
    012.586  000.117  000.117: sourcing /home/zeng/.config/nvim/plugin/statusline.lua
    012.746  000.116  000.116: sourcing /home/zeng/.config/nvim/plugin/tabout.lua
    012.788  000.013  000.013: sourcing /home/zeng/.config/nvim/plugin/vscode-neovim.vim
    012.871  000.062  000.062: sourcing /home/zeng/.config/nvim/plugin/winbar.lua
    013.095  000.106  000.106: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
    013.265  000.142  000.142: sourcing /usr/share/nvim/runtime/plugin/man.lua
    013.438  000.143  000.143: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
    013.748  000.154  000.154: sourcing /usr/share/nvim/runtime/plugin/nvim.lua
    013.964  000.142  000.142: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
    014.046  000.052  000.052: sourcing /usr/share/nvim/runtime/plugin/shada.vim
    014.109  000.020  000.020: sourcing /usr/share/nvim/runtime/plugin/spellfile.vim
    014.297  000.069  000.069: sourcing /home/zeng/.local/share/nvim/site/pack/packages/opt/rnvimr/after/plugin/rnvimr.vim
    014.427  010.465  005.957: require('init.plugins')
    014.429  012.573  000.022: sourcing /home/zeng/.config/nvim/init.lua
    014.436  000.318: sourcing vimrc file(s)
    014.625  000.088  000.088: sourcing /usr/share/nvim/runtime/filetype.lua
    014.770  000.064  000.064: sourcing /usr/share/nvim/runtime/syntax/synload.vim
    014.841  000.177  000.113: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
    014.860  000.158: inits 3
    015.619  000.759: reading ShaDa
    015.755  000.006  000.006: require('vim.F')
    015.931  000.307: opening buffers
    016.103  000.116  000.116: sourcing /home/zeng/.local/share/nvim/site/pack/packages/opt/rnvimr/autoload/rnvimr.vim
    016.125  000.078: BufEnter autocommands
    016.127  000.002: editing files in windows
    016.134  000.007: executing command arguments
    016.136  000.001: VimEnter autocommands
    017.069  000.880  000.880: sourcing /home/zeng/.config/nvim/colors/nano.lua
    017.106  000.090: UIEnter autocommands
    017.108  000.002: before starting main loop
    017.326  000.051  000.051: require('utils.funcs.stl')
    017.411  000.048  000.048: require('utils.funcs.git')
    017.638  000.220  000.220: require('vim._system')
    019.474  002.047: first screen update
    019.477  000.003: --- NVIM STARTED ---
  ```

</details>

<details>
  <summary>statistics of 100 startups (sorted)</summary>


  ```
    017.735  000.003: --- NVIM STARTED ---
    018.343  000.003: --- NVIM STARTED ---
    018.382  000.003: --- NVIM STARTED ---
    018.512  000.003: --- NVIM STARTED ---
    018.536  000.003: --- NVIM STARTED ---
    018.691  000.003: --- NVIM STARTED ---
    018.702  000.003: --- NVIM STARTED ---
    018.718  000.003: --- NVIM STARTED ---
    018.851  000.003: --- NVIM STARTED ---
    018.868  000.003: --- NVIM STARTED ---
    018.947  000.003: --- NVIM STARTED ---
    018.978  000.004: --- NVIM STARTED ---
    019.008  000.003: --- NVIM STARTED ---
    019.074  000.003: --- NVIM STARTED ---
    019.081  000.003: --- NVIM STARTED ---
    019.243  000.005: --- NVIM STARTED ---
    019.391  000.005: --- NVIM STARTED ---
    019.430  000.003: --- NVIM STARTED ---
    019.465  000.003: --- NVIM STARTED ---
    019.476  000.004: --- NVIM STARTED ---
    019.477  000.003: --- NVIM STARTED ---
    019.478  000.004: --- NVIM STARTED ---
    019.506  000.004: --- NVIM STARTED ---
    019.540  000.003: --- NVIM STARTED ---
    019.551  000.006: --- NVIM STARTED ---
    019.570  000.005: --- NVIM STARTED ---
    019.626  000.003: --- NVIM STARTED ---
    019.628  000.004: --- NVIM STARTED ---
    019.676  000.003: --- NVIM STARTED ---
    019.736  000.004: --- NVIM STARTED ---
    019.769  000.004: --- NVIM STARTED ---
    019.780  000.004: --- NVIM STARTED ---
    019.783  000.004: --- NVIM STARTED ---
    019.818  000.003: --- NVIM STARTED ---
    019.837  000.003: --- NVIM STARTED ---
    019.892  000.003: --- NVIM STARTED ---
    019.917  000.003: --- NVIM STARTED ---
    019.933  000.004: --- NVIM STARTED ---
    019.940  000.003: --- NVIM STARTED ---
    019.963  000.006: --- NVIM STARTED ---
    020.125  000.003: --- NVIM STARTED ---
    020.129  000.005: --- NVIM STARTED ---
    020.190  000.003: --- NVIM STARTED ---
    020.194  000.003: --- NVIM STARTED ---
    020.418  000.004: --- NVIM STARTED ---
    020.560  000.005: --- NVIM STARTED ---
    020.589  000.005: --- NVIM STARTED ---
    020.624  000.006: --- NVIM STARTED ---
    020.699  000.004: --- NVIM STARTED ---
    020.713  000.003: --- NVIM STARTED ---
    020.799  000.006: --- NVIM STARTED ---
    020.901  000.003: --- NVIM STARTED ---
    020.903  000.004: --- NVIM STARTED ---
    020.925  000.007: --- NVIM STARTED ---
    021.008  000.003: --- NVIM STARTED ---
    021.011  000.004: --- NVIM STARTED ---
    021.017  000.005: --- NVIM STARTED ---
    021.037  000.004: --- NVIM STARTED ---
    021.047  000.004: --- NVIM STARTED ---
    021.147  000.003: --- NVIM STARTED ---
    021.162  000.004: --- NVIM STARTED ---
    021.166  000.003: --- NVIM STARTED ---
    021.261  000.006: --- NVIM STARTED ---
    021.334  000.003: --- NVIM STARTED ---
    021.334  000.003: --- NVIM STARTED ---
    021.357  000.005: --- NVIM STARTED ---
    021.374  000.003: --- NVIM STARTED ---
    021.411  000.004: --- NVIM STARTED ---
    021.420  000.005: --- NVIM STARTED ---
    021.538  000.003: --- NVIM STARTED ---
    021.542  000.003: --- NVIM STARTED ---
    021.557  000.008: --- NVIM STARTED ---
    021.664  000.003: --- NVIM STARTED ---
    021.693  000.003: --- NVIM STARTED ---
    021.706  000.004: --- NVIM STARTED ---
    021.760  000.004: --- NVIM STARTED ---
    021.766  000.004: --- NVIM STARTED ---
    021.771  000.004: --- NVIM STARTED ---
    021.823  000.007: --- NVIM STARTED ---
    021.831  000.003: --- NVIM STARTED ---
    021.877  000.004: --- NVIM STARTED ---
    021.945  000.003: --- NVIM STARTED ---
    022.191  000.004: --- NVIM STARTED ---
    022.242  000.004: --- NVIM STARTED ---
    022.262  000.007: --- NVIM STARTED ---
    022.307  000.003: --- NVIM STARTED ---
    022.429  000.004: --- NVIM STARTED ---
    022.601  000.003: --- NVIM STARTED ---
    022.898  000.004: --- NVIM STARTED ---
    022.940  000.004: --- NVIM STARTED ---
    023.014  000.003: --- NVIM STARTED ---
    023.025  000.004: --- NVIM STARTED ---
    023.093  000.003: --- NVIM STARTED ---
    023.151  000.003: --- NVIM STARTED ---
    023.258  000.004: --- NVIM STARTED ---
    023.553  000.004: --- NVIM STARTED ---
    023.571  000.006: --- NVIM STARTED ---
    024.175  000.005: --- NVIM STARTED ---
    024.182  000.005: --- NVIM STARTED ---
    025.475  000.005: --- NVIM STARTED ---

    Mean:  2076.55 / 100 = 20.7655
  ```

</details>
