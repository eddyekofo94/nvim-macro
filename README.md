<h1 align="center"> Bekaboo's Neovim Configuration </h1>

<center>

<img src="pic/README/splashscreen.png">

<img src="pic/README/screenshot.png">

</center>

## Table of Contents

1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Tweaking this Configuration](#tweaking-this-configuration)
    1. [Config Structure](#config-structure)
    2. [Boot Process](#boot-process)
    3. [Enabling or Disabling a Module](#enabling-or-disabling-a-module)
    4. [Installing Packages to an Existing Module](#installing-packages-to-an-existing-module)
    5. [Installing Packages to a New Module](#installing-packages-to-a-new-module)
    6. [General Settings and Options](#general-settings-and-options)
    7. [Keymaps](#keymaps)
    8. [Colorscheme](#colorscheme)
    9. [Auto Commands](#auto-commands)
    10. [LSP Server Configurations](#lsp-server-configuration)
    11. [Snippets](#snippets)
    12. [Enabling VSCode Integration](#enabling-vscode-integration)
5. [Appendix](#appendix)
    1. [Default Modules and Plugins of Choice](#default-modules-and-plugins-of-choice)

## Features

- Modular Design
    - Install and manage packages in groups
    - Make it easy to use different set of configuration for different use cases
- [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) integration
    - Feels at home in VSCode when you occasionally need it
- Fast Startup around 15 ~ 35 ms

## Requirements

- [Neovim](https://github.com/neovim/neovim) (latest release)
- [Neovim Remote](https://github.com/mhinz/neovim-remote) and [Ranger](https://github.com/ranger/ranger) for file manager support
- [Fd](https://github.com/sharkdp/fd) and [Ripgrep](https://github.com/BurntSushi/ripgrep) for the fuzzy finder `telescope`
- [Git](https://git-scm.com/), of course
- A decent terminal emulator, [Kitty](https://sw.kovidgoyal.net/kitty/) for example
- A nerd font, I personally use [FiraCode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)

## Installation

1. Backup your own settings.
2. Make sure you have satisfied the requirements.
3. Clone this repo to your config directory
    ```
    git clone https://github.com/Bekaboo/nvim ~/.config/nvim
    ```
4. Open neovim, manually run `:PackerSync` if packer does not
    automatically syncs.
5. Run `:checkhealth` to check potential dependency issues.
6. Enjoy!

## Tweaking this Configuration

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

### Enabling or Disabling a Module

In order to enable or disable a module, one need to change the table in
`lua/init/plugins.lua` passed to `manage_plugins()`, for example

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

---

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
      snapshot_path = fn.stdpath('config') .. '/snapshots',
      opt_default = false,
      transitive_opt = true,
      display = {
        open_fn = function()
          return require('packer.util').float({ border = 'single' })
        end,
        working_sym = '',
        error_sym = '',
        done_sym = '',
        removed_sym = '',
        moved_sym = 'ﰲ',
        keybindings = {
          toggle_info = '<Tab>'
        },
      },
    },
  }
  ```

</details>

---

### Installing Packages to an Existing Module

To install plugin `foo` under module `misc`, just insert the
corresponding specification to the big table
`lua/modules/misc/init.lua` returns, for instance,

`lua/modules/init.lua`:

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
create module `bar` under `lua/modules`, there are two choices:

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

### General Settings and Options

See `lua/init/general.lua`.

### Keymaps

See `lua/init/keymaps.lua`, or see module config files for
corresponding plugin keymaps.

### Colorscheme

`nvim-falcon` is a custom colorscheme builtin in this configuration and is
enabled by default.

To disable it, remove the corresponding line in `lua/init/general.lua`.

To tweak this colorscheme, see `lua/colors/nvim-falcon`.

### Auto Commands

See `lua/init/autocmds.lua`.

### LSP Server Configurations

See `lua/modules/lsp/lsp-server-configs`.

### Snippets

This configuration use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) as the snippet engine,
custom snippets for different filetypes
are defined under `lua/modules/completion/snippets`.

### Enabling VSCode Integration

VSCode integration takes advantages of the modular design, allowing to use
a different set of modules when Neovim is launched by VSCode, relevant code is
in `plugin/vscode_neovim.vim` and `lua/init/plugins.lua`.

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
    - [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)
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
- **Treesitter**
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - [nvim-ts-rainbow](https://github.com/p00f/nvim-ts-rainbow)
  - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
  - [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
- **UI**
  - [barbar.nvim](https://github.com/romgrk/barbar.nvim)
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
  - [alpha-nvim](https://github.com/goolord/alpha-nvim)
