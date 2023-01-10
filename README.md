<h1 align="center"> Bekaboo's Neovim Configuration </h1>

<center>

<img src="pic/README/splashscreen.png">

<img src="pic/README/screenshot.png">

</center>

## Table of Contents

1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Overview](#overview)
    1. [Config Structure](#config-structure)
    2. [Boot Process](#boot-process)
5. [Tweaking this Configuration](#tweaking-this-configuration)
    1. [Managing Plugins with Modules](#managing-plugins-with-modules)
    2. [Installing Packages to an Existing Module](#installing-packages-to-an-existing-module)
    3. [Installing Packages to a New Module](#installing-packages-to-a-new-module)
    4. [General Settings and Options](#general-settings-and-options)
    5. [Keymaps](#keymaps)
    6. [Colorscheme](#colorscheme)
    7. [Auto Commands](#auto-commands)
    8. [LSP Server Configurations](#lsp-server-configuration)
    9. [Snippets](#snippets)
    10. [Enabling VSCode Integration](#enabling-vscode-integration)
6. [Appendix](#appendix)
    1. [Default Modules and Plugins of Choice](#default-modules-and-plugins-of-choice)
    2. [Startuptime Statistics](#startuptime-statistics)

## Features

- Modular Design
    - Install and manage packages in groups
    - Make it easy to use different set of configuration for different use cases
- [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) Integration
    - Feels at home in VSCode when you occasionally need it
- Fast Startup
    - Around [15 ~ 35 ms](#startuptime-statistics)

## Requirements

- [Neovim](https://github.com/neovim/neovim) (***nightly***)
- [Neovim Remote](https://github.com/mhinz/neovim-remote) and [Ranger](https://github.com/ranger/ranger) for file manager support
- [Fd](https://github.com/sharkdp/fd) and [Ripgrep](https://github.com/BurntSushi/ripgrep) for the fuzzy finder `telescope`
- [Git](https://git-scm.com/), of course
- A decent terminal emulator, [Kitty](https://sw.kovidgoyal.net/kitty/) for example
- A nerd font, I personally use [FiraCode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)

For LSP support:

- [Nodejs](https://nodejs.org/en/), for LSP support
- Clangd requires Zip (**not** Gzip) to be installed
- Some other LSP clients may requires Go, Cargo, etc.

Optional:

- [Lazygit](https://github.com/jesseduffield/lazygit) for improved git integration
- [Pandoc](https://pandoc.org/), [custom scripts](https://github.com/Bekaboo/dot/tree/master/.scripts) and [TexLive](https://www.tug.org/texlive/) (for ArchLinux users, it is `texlive-core` and `texlive-extra`) for markdown → PDF conversion

## Installation

1. Backup your own settings.
2. Make sure you have satisfied the requirements.
3. Clone this repo to your config directory
    ```
    git clone https://github.com/Bekaboo/nvim ~/.config/nvim
    ```
4. Open neovim, manually run `:PackerSync` if packer does not
    automatically sync.
5. Run `:checkhealth` to check potential dependency issues.
6. Enjoy!

## Overview

### Config Structure

```
.
├── colors                      # colorschemes loaders
├── plugin                      # custom plugins
├── ftplugin                    # custom filetype plugins
├── init.lua                    # entry of config
├── lua
│   ├── colors                  # the actual implementation of colorshemes
│   ├── init                    # files under this folder is required by 'init.lua'
│   │   ├── autocmds.lua
│   │   ├── general.lua         # options and general settings
│   │   ├── keymaps.lua
│   │   └── plugins.lua         # specify which modules to use in different conditions
│   ├── modules                 # all plugin specifications and configs go here
│   │   ├── base                # module 'base'
│   │   │   ├── configs.lua     # plugin configs
│   │   │   └── init.lua        # plugin specifications
│   │   ├── completion          # module 'completion'
│   │   ├── lsp                 # module 'lsp'
│   │   ├── markup              # ...
│   │   ├── misc
│   │   ├── tools
│   │   ├── treesitter
│   │   └── ui
│   ├── plugin                  # the actual implementation of custom plugins
│   └── utils
├── snapshots                   # packer snapshots go here
└── syntax                      # syntax files
```

### Boot Process

To optimize startup time, nearly all packages are lazy-loaded,
including `packer.nvim`.

```
┌──────────┐
│ init.lua │
└────┬─────┘┌──────────────────────┐
     ├─────►│ lua/init/general.lua │
     │      └──────────────────────┘
     │      ┌──────────────────────┐
     ├─────►│ lua/init/keymaps.lua │
     │      └──────────────────────┘
     │      ┌───────────────────────┐
     ├─────►│ lua/init/autocmds.lua │
     │      └───────────────────────┘
     │      ┌──────────────────────┐
     └─────►│ lua/init/plugins.lua │
            └──────────┬───────────┘
                       │
             specify modules to use
                       │     ┌──────────────────────┐
                       └────►│ lua/utils/packer.lua │
                             └──────────┬───────────┘
                                        │
                               check if packer.nvim
                                   is installed
                                        │
    install and load packer.nvim ◄─ NO ─┴─ YES ─► check if packer_compiled.lua exists
                     │                                         │
                     ▼                                         │        ┌─────────────────────┐
              register plugins ◄───────────── NO ──────────────┴─ YES ─►│ packer_compiled.lua │
                from modules                                            └─────────────────────┘
                     │  ┌──────────────────┐
                     ├─►│ lua/modules/base │
┌─────────────────┐  │  └──────────────────┘
│ lua/modules/lsp │◄─┤
└─────────────────┘  │  ┌────────────────────────┐
                     ├─►│ lua/modules/treesitter │
                     │  └────────────────────────┘
               ... ◄─┤
                     │
                     ▼
                sync plugins
```

## Tweaking this Configuration

### Managing Plugins with Modules

In order to enable or disable a module, one need to change the table in
[lua/init/plugins.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua) passed to `manage_plugins()`, for example

```lua
local manage_plugins = require('utils.packer').manage_plugins
manage_plugins({
  modules = {
    base = true,          -- install all plugins in 'base'
    completion = false,   -- disable all plugins in 'completion' but don't remove
    lsp = nil,            -- remove all plugins in 'lsp'
  },
})
```

you can also pass `root`, `bootstrap`, and `configs` to `manage_plugins()`:

```lua
manage_plugins({
  root = vim.fn.stdpath('data') .. '/foo',
  bootstrap = {
    url = 'https://github.com/wbthomason/packer.nvim',
  },
  configs = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'double' })
      end,
    },
  },
})
```

- `root`: root directory of the plugins
    - Normally setting `root` will automatically set `bootstrap.path` and
        `configs.compile_path` **UNLESS** you explicitly set these
        two options in the argument passed to `manage_plugins()`
- `bootstrap`: information for automatically installing `packer.nvim`
- `configs`: configuration passed to `packer.init()`, see [packer's doc](https://github.com/wbthomason/packer.nvim#custom-initialization)

<details>
  <summary><strong>Default argument passed to `manage_plugins()`:</strong></summary>

  ```lua
  local default_root = fn.stdpath('data') .. '/site'
  local packer_info = {
    modules = {},
    root = default_root,
    bootstrap = {
      path = default_root .. '/pack/packer/opt/packer.nvim',
      url = 'https://github.com/wbthomason/packer.nvim',
    },
    config = {
      compile_path = default_root .. '/lua/packer_compiled.lua',
      opt_default = false,
      transitive_opt = true,
    },
  }
  ```

</details>

### Installing Packages to an Existing Module

To install plugin `foo` under module `misc`, just insert the
corresponding specification to the big table
`lua/modules/misc/init.lua` returns, for instance,

`lua/modules/misc/init.lua`:

```lua
-- ...

M['foo'] = {
  'foo/foo',
  requires = 'foo_dep',
}

-- ...

return M
```

### Installing Packages to a New Module

To install plugin `foo` under module `bar`, one should first
create module `bar` under [lua/modules](https://github.com/Bekaboo/nvim/tree/master/lua/modules), there are two approaches:

```
.
└── lua
    └── modules
        └── bar
            └── init.lua
```

or

```
.
└── lua
    └── modules
        └── bar.lua
```

in either case a module should return a big table containing
all specifications of plugins under that module, for instance:

```lua
{
  {
    'goolord/alpha-nvim',
    cond = function()
      return vim.fn.argc() == 0 and
          vim.o.lines >= 36 and vim.o.columns >= 80
    end,
    requires = 'nvim-web-devicons',
  }, {
    'romgrk/barbar.nvim',
    requries = 'nvim-web-devicons',
    config = function() require('bufferline').setup() end,
  },
}
```

After creating the new module `bar`, enable it in [lua/init/plugins.lua](hub.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua):

```lua
local manage_plugins = require('utils.packer').manage_plugins

manage_plugins({
  modules = {
    -- ...
    bar = true,
    -- ...
  }
})
```

### General Settings and Options

See [lua/init/general.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/general.lua).

### Keymaps

See [lua/init/keymaps.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/keymaps.lua), or see module config files for
corresponding plugin keymaps.

### Colorscheme

![colorscheme-nvim-falcon](pic/README/colorscheme-nvim-falcon.png)

`nvim-falcon` is a builtin custom colorscheme optimized for transparent
background and is enabled by default.

To disable it, remove the [corresponding lines](https://github.com/Bekaboo/nvim/blob/master/lua/init/general.lua#L76-L78) in [lua/init/general.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/general.lua).

To tweak this colorscheme, see [lua/colors/nvim-falcon](https://github.com/Bekaboo/nvim/tree/master/lua/colors/nvim-falcon).

### Auto Commands

See [lua/init/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/autocmds.lua).

### LSP Server Configurations

See [lua/modules/lsp/lsp-server-configs](https://github.com/Bekaboo/nvim/tree/master/lua/modules/lsp/lsp-server-configs).

### Snippets

This configuration use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) as the snippet engine,
custom snippets for different filetypes
are defined under [lua/modules/completion/snippets](https://github.com/Bekaboo/nvim/tree/master/lua/modules/completion/snippets).

### Enabling VSCode Integration

VSCode integration takes advantages of the modular design, allowing to use
a different set of modules when Neovim is launched by VSCode, relevant code is
in [plugin/vscode_neovim.vim](https://github.com/Bekaboo/nvim/blob/master/plugin/vscode_neovim.vim) and [lua/init/plugins.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua).

To make VSCode integration work, please install [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) in VSCode
and configure it correctly.

After setting up VSCode-Neovim, re-enter VSCode, open a random file
and run `:PackerSync`, if the message says "Packer Compiled Successfully!" then
it should work.

<center>

<img src="pic/README/vscode-neovim-message.png" width=50% height=50%>

</center>

## Appendix

### Default Modules and Plugins of Choice

- **Base**
    - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
    - [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
- **Completion**
    - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    - [cmp-calc](https://github.com/hrsh7th/cmp-calc)
    - [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
    - [cmp-path](https://github.com/hrsh7th/cmp-path)
    - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
    - [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
    - [cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
    - [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
    - [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **LSP**
  - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  - [mason.nvim](https://github.com/williamboman/mason.nvim)
  - [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
  - [aerial.nvim](https://github.com/stevearc/aerial.nvim)
  - [nvim-navic](https://github.com/SmiteshP/nvim-navic)
- **Markup**
  - [vimtex](https://github.com/lervag/vimtex)
  - [vim-markdown](https://github.com/preservim/vim-markdown)
  - [clipboard-image.nvim](https://github.com/ekickx/clipboard-image.nvim)
  - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- **Misc**
  - [nvim-surround](https://github.com/kylechui/nvim-surround)
  - [Comment.nvim](https://github.com/numToStr/Comment.nvim)
  - [vim-sleuth](https://github.com/tpope/vim-sleuth)
  - [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- **Tools**
  - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
  - [undotree](https://github.com/mbbill/undotree)
  - [vim-floaterm](https://github.com/voldikss/vim-floaterm)
  - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
  - [rnvimr](https://github.com/kevinhwang91/rnvimr)
  - [tmux.nvim](https://github.com/aserowy/tmux.nvim)
- **Treesitter**
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - [nvim-ts-rainbow](https://github.com/mrjones2014/nvim-ts-rainbow)
  - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
  - [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
- **UI**
  - [barbar.nvim](https://github.com/romgrk/barbar.nvim)
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
  - [alpha-nvim](https://github.com/goolord/alpha-nvim)

### Startuptime Statistics

Last update: 2023-01-10

Neovim Version: `NVIM v0.9.0-dev-646+gef67503320`

Commit: `ee062fcf` (#505)

System: Arch Linux 6.1.4

Machine: Dell XPS-13-7390

Command: `nvim --startuptime startuptime.log`

<details>
  <summary>startuptime log</summary>

  ```
  000.012  000.012: --- NVIM STARTING ---
  000.115  000.103: event init
  000.227  000.112: early init
  000.305  000.078: locale set
  000.349  000.044: init first window
  000.676  000.327: inits 1
  000.707  000.031: window checked
  000.712  000.005: parsing arguments
  001.240  000.063  000.063: require('vim.shared')
  001.349  000.035  000.035: require('vim._meta')
  001.351  000.107  000.072: require('vim._editor')
  001.352  000.198  000.028: require('vim._init_packages')
  001.354  000.444: init lua interpreter
  001.426  000.072: expanding arguments
  001.454  000.028: inits 2
  001.680  000.226: init highlight
  001.681  000.001: waiting for UI
  001.798  000.116: done waiting for UI
  001.803  000.005: clear screen
  001.894  000.091: init default mappings
  001.907  000.013: init default autocommands
  002.254  000.045  000.045: sourcing /usr/share/nvim/runtime/ftplugin.vim
  002.305  000.024  000.024: sourcing /usr/share/nvim/runtime/indent.vim
  002.348  000.008  000.008: sourcing /usr/share/nvim/archlinux.vim
  002.350  000.023  000.015: sourcing /etc/xdg/nvim/sysinit.vim
  003.668  000.032  000.032: require('colors.nvim-falcon.palette')
  003.754  000.487  000.455: require('colors.nvim-falcon.colorscheme')
  003.756  000.527  000.040: require('colors.nvim-falcon')
  004.556  000.053  000.053: require('colors.nvim-falcon.terminal')
  004.560  001.343  000.762: sourcing /home/zeng/.config/nvim/colors/nvim-falcon.lua
  004.564  002.185  000.842: require('init.general')
  004.745  000.013  000.013: require('vim.keymap')
  005.490  000.925  000.912: require('init.keymaps')
  005.593  000.101  000.101: require('init.autocmds')
  005.837  000.191  000.191: require('utils.packer')
  007.549  000.468  000.468: require('packer.load')
  007.936  000.050  000.050: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim
  007.972  000.015  000.015: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim
  008.003  000.015  000.015: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim
  008.031  000.012  000.012: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim
  008.037  002.077  001.517: require('packer_compiled')
  008.072  002.477  000.209: require('init.plugins')
  008.074  005.708  000.021: sourcing /home/zeng/.config/nvim/init.lua
  008.078  000.371: sourcing vimrc file(s)
  008.262  000.010  000.010: sourcing /usr/share/vim/vimfiles/ftdetect/PKGBUILD.vim
  008.282  000.009  000.009: sourcing /usr/share/vim/vimfiles/ftdetect/SRCINFO.vim
  008.336  000.223  000.204: sourcing /usr/share/nvim/runtime/filetype.lua
  008.475  000.066  000.066: sourcing /usr/share/nvim/runtime/syntax/synload.vim
  008.547  000.177  000.111: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
  008.759  000.009  000.009: sourcing /home/zeng/.config/nvim/plugin/vscode_neovim.vim
  008.983  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
  009.001  000.007  000.007: sourcing /usr/share/nvim/runtime/plugin/health.vim
  009.021  000.009  000.009: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
  009.143  000.111  000.111: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
  009.170  000.013  000.013: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
  009.293  000.007  000.007: sourcing /home/zeng/.local/share/nvim/rplugin.vim
  009.299  000.118  000.111: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
  009.353  000.045  000.045: sourcing /usr/share/nvim/runtime/plugin/shada.vim
  009.389  000.017  000.017: sourcing /usr/share/nvim/runtime/plugin/spellfile.vim
  009.416  000.014  000.014: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
  009.439  000.009  000.009: sourcing /usr/share/nvim/runtime/plugin/tohtml.vim
  009.477  000.019  000.019: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
  009.506  000.014  000.014: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
  009.645  000.054  000.054: sourcing /home/zeng/.config/nvim/plugin/auto_hlsearch.lua
  009.690  000.031  000.031: sourcing /home/zeng/.config/nvim/plugin/tabout.lua
  010.047  000.041  000.041: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
  010.130  000.070  000.070: sourcing /usr/share/nvim/runtime/plugin/man.lua
  010.166  000.021  000.021: sourcing /usr/share/nvim/runtime/plugin/nvim.lua
  010.184  001.095: loading rtp plugins
  010.304  000.120: loading packages
  010.658  000.044  000.044: sourcing /home/zeng/.local/share/nvim/site/pack/packer/start/rnvimr/after/plugin/rnvimr.vim
  010.694  000.346: loading after plugins
  010.704  000.011: inits 3
  015.740  005.035: reading ShaDa
  015.899  000.160: opening buffers
  016.021  000.110  000.110: require('utils.funcs')
  016.180  000.115  000.115: sourcing /home/zeng/.local/share/nvim/site/pack/packer/start/rnvimr/autoload/rnvimr.vim
  016.201  000.077: BufEnter autocommands
  016.203  000.002: editing files in windows
  016.226  000.023: VimEnter autocommands
  016.228  000.002: UIEnter autocommands
  016.229  000.001: before starting main loop
  016.358  000.129: first screen update
  016.360  000.002: --- NVIM STARTED ---
  ```

</details>

<details>
  <summary>statistics of 50 startups (sorted)</summary>


  ```
  016.360  000.002: --- NVIM STARTED ---
  016.742  000.002: --- NVIM STARTED ---
  016.749  000.002: --- NVIM STARTED ---
  016.759  000.002: --- NVIM STARTED ---
  016.762  000.002: --- NVIM STARTED ---
  016.787  000.002: --- NVIM STARTED ---
  016.807  000.002: --- NVIM STARTED ---
  016.889  000.002: --- NVIM STARTED ---
  016.906  000.002: --- NVIM STARTED ---
  016.947  000.002: --- NVIM STARTED ---
  016.947  000.002: --- NVIM STARTED ---
  016.961  000.002: --- NVIM STARTED ---
  016.989  000.002: --- NVIM STARTED ---
  016.999  000.002: --- NVIM STARTED ---
  017.038  000.002: --- NVIM STARTED ---
  017.073  000.002: --- NVIM STARTED ---
  017.099  000.002: --- NVIM STARTED ---
  017.117  000.002: --- NVIM STARTED ---
  017.145  000.002: --- NVIM STARTED ---
  017.150  000.002: --- NVIM STARTED ---
  017.231  000.002: --- NVIM STARTED ---
  017.247  000.002: --- NVIM STARTED ---
  017.275  000.002: --- NVIM STARTED ---
  017.294  000.002: --- NVIM STARTED ---
  017.361  000.002: --- NVIM STARTED ---
  017.371  000.002: --- NVIM STARTED ---
  017.410  000.002: --- NVIM STARTED ---
  017.423  000.002: --- NVIM STARTED ---
  017.464  000.002: --- NVIM STARTED ---
  017.494  000.002: --- NVIM STARTED ---
  017.607  000.002: --- NVIM STARTED ---
  017.617  000.002: --- NVIM STARTED ---
  017.686  000.002: --- NVIM STARTED ---
  017.803  000.003: --- NVIM STARTED ---
  017.848  000.002: --- NVIM STARTED ---
  017.942  000.001: --- NVIM STARTED ---
  017.992  000.002: --- NVIM STARTED ---
  018.078  000.002: --- NVIM STARTED ---
  018.186  000.002: --- NVIM STARTED ---
  018.248  000.002: --- NVIM STARTED ---
  018.327  000.002: --- NVIM STARTED ---
  018.969  000.002: --- NVIM STARTED ---
  019.093  000.002: --- NVIM STARTED ---
  019.308  000.002: --- NVIM STARTED ---
  019.859  000.002: --- NVIM STARTED ---
  020.243  000.002: --- NVIM STARTED ---
  020.529  000.001: --- NVIM STARTED ---
  022.157  000.002: --- NVIM STARTED ---
  025.490  000.002: --- NVIM STARTED ---
  027.609  000.002: --- NVIM STARTED ---
  ```

</details>
