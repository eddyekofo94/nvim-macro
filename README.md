<h1 align="center"> Bekaboo's Neovim Configuration </h1>

<center>

![image](https://user-images.githubusercontent.com/76579810/220516563-8c9e9f95-fa8d-4788-b995-04e1efca7124.png)

![image](https://user-images.githubusercontent.com/76579810/220517666-4a6ce796-0972-4b06-98ac-86313036537e.png)

</center>

*\*Plugin and relevant resources for the startup screen has been removed since
commit `d49a2fa` to debloat this config. Revert this commit if you like the
startup screen.*

## Table of Contents

1. [Features](#features)
2. [Requirements and Dependencies](#requirements-and-dependencies)
    1. [Basic](#basic)
    2. [Tree-sitter](#tree-sitter)
    3. [LSP](#lsp)
    4. [DAP](#dap)
    5. [Other External Tools](#other-external-tools)
3. [Installation](#installation)
4. [Overview](#overview)
    1. [Config Structure](#config-structure)
5. [Tweaking this Configuration](#tweaking-this-configuration)
    1. [Managing Plugins with Modules](#managing-plugins-with-modules)
    2. [Installing Packages to an Existing Module](#installing-packages-to-an-existing-module)
    3. [Installing Packages to a New Module](#installing-packages-to-a-new-module)
    4. [General Settings and Options](#general-settings-and-options)
    5. [Keymaps](#keymaps)
    6. [Colorscheme](#colorscheme)
    7. [Auto Commands](#auto-commands)
    8. [LSP Server Configurations](#lsp-server-configurations)
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

To add support for other languages, install corresponding LS manually and
append the language and its language server to `M.langs` in [lua/utils/static.lua](https://github.com/Bekaboo/nvim/blob/master/lua/utils/static.lua)
so that [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) will pick them up.

### DAP

Install the following debug adapters manually:

- Bash:

    Go to [vscode-bash-debug release page](https://github.com/rogalmic/vscode-bash-debug/releases), download the lastest release
    (`bash-debug-x.x.x.vsix`), extract the contents to a new directory
    `vscode-bash-debug/` and put it under stdpath `data`
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
- [Fd](https://github.com/sharkdp/fd) and [Ripgrep](https://github.com/BurntSushi/ripgrep) for the fuzzy finder `telescope`
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
│   ├── colors                  # actual implementation of colorshemes
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
manage_plugins({
    spec = {
      { import = 'modules.base' },
      { import = 'modules.treesitter' },
      { import = 'modules.misc' },
      -- ...
    },
})
```

the format of argument passed to `manage_plugins` is the same as that passed to
lazy.nvim's setup function.

### Installing Packages to an Existing Module

To install plugin `foo` under module `misc`, just insert the
corresponding specification to the big table
`lua/modules/misc.lua` returns, for instance,

`lua/modules/misc.lua`:

```lua
return {
    -- ...
    {
        'foo/foo',
        requires = 'foo_dep',
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
    requires = 'nvim-web-devicons',
  },

  {
    'romgrk/barbar.nvim',
    requries = 'nvim-web-devicons',
    config = function() require('bufferline').setup() end,
  },
}
```

After creating the new module `bar`, enable it in [lua/init/plugins.lua](hub.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua):

```lua
manage_plugins({
    spec = {
      -- ...
      { import = 'modules.bar' },
    },
})
```

### General Settings and Options

See [lua/init/general.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/general.lua).

### Keymaps

See [lua/init/keymaps.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/keymaps.lua), or see module config files for
corresponding plugin keymaps.

### Colorscheme

![image](https://user-images.githubusercontent.com/76579810/220518710-aa55a4cc-6855-471d-8ed8-627bbfdf617c.png)


`cockatoo` is a builtin custom colorscheme, with seperate palettes for dark and light background.

Use `<M-C-d>` to toggle dark/light background.

Neovim is configured to restore the background settings on startup, so there
is no need to setup `vim.opt.bg` in the config.

To disable the auto-restore feature, remove corresponding lines in
[lua/init/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/autocmds.lua)

To tweak this colorscheme, see [lua/colors/cockatoo](https://github.com/Bekaboo/nvim/tree/master/lua/colors/cockatoo).

### Auto Commands

See [lua/init/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/autocmds.lua).

### LSP Server Configurations

See [lua/configs/lsp-server-configs](https://github.com/Bekaboo/nvim/tree/master/lua/configs/lsp-server-configs) and [lua/configs/nvim-lspconfig.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-lspconfig.lua).

### Snippets

This configuration use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) as the snippet engine,
custom snippets for different filetypes
are defined under [lua/snippets](https://github.com/Bekaboo/nvim/tree/master/lua/snippets).

### Enabling VSCode Integration

VSCode integration takes advantages of the modular design, allowing to use
a different set of modules when Neovim is launched by VSCode, relevant code is
in [plugin/vscode_neovim.vim](https://github.com/Bekaboo/nvim/blob/master/plugin/vscode_neovim.vim) and [lua/init/plugins.lua](https://github.com/Bekaboo/nvim/blob/master/lua/init/plugins.lua).

To make VSCode integration work, please install [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) in VSCode
and configure it correctly.

After setting up VSCode-Neovim, re-enter VSCode, open a random file
and it should work out of the box.

## Appendix

### Default Modules and Plugins of Choice

Total # of plugins: 50 (package manager included).

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
    - [cmp-dap](https://github.com/rcarriga/cmp-dap)
    - [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
    - [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **LSP**
    - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    - [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim)
    - [null-lsp.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)
- **Markup**
    - [vimtex](https://github.com/lervag/vimtex)
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    - [zk-nvim](https://github.com/mickael-menu/zk-nvim)
    - [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
- **Misc**
    - [nvim-surround](https://github.com/kylechui/nvim-surround)
    - [Comment.nvim](https://github.com/numToStr/Comment.nvim)
    - [vim-sleuth](https://github.com/tpope/vim-sleuth)
    - [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
    - [fcitx.nvim](https://github.com/h-hg/fcitx.nvim)
    - [vim-easy-align](https://github.com/junegunn/vim-easy-align)
- **Tools**
    - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
    - [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
    - [telescope-undo.nvim](https://github.com/debugloop/telescope-undo.nvim)
    - [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
    - [flatten.nvim](https://github.com/willothy/flatten.nvim)
    - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
    - [rnvimr](https://github.com/kevinhwang91/rnvimr)
    - [tmux.nvim](https://github.com/aserowy/tmux.nvim)
    - [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive)
    - [aerial.nvim](https://github.com/stevearc/aerial.nvim)
- **Treesitter**
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
    - [nvim-ts-rainbow](https://github.com/mrjones2014/nvim-ts-rainbow)
    - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
    - [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
    - [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)
    - [ts-node-action](https://github.com/CKolkey/ts-node-action)
    - [cellular-automaton.nvim](https://github.com/Eandrju/cellular-automaton.nvim)
- **UI**
    - [barbar.nvim](https://github.com/romgrk/barbar.nvim)
    - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
    - [nvim-navic](https://github.com/SmiteshP/nvim-navic)
    - [fidget.nvim](https://github.com/j-hui/fidget.nvim)
- **DEBUG**
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap)
    - [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)

### Startuptime Statistics

Last update: 2023-01-16

Neovim Version: `NVIM v0.9.0-dev-646+gef67503320`

Commit: `db72f37` (#551)

System: Arch Linux 6.1.4

Machine: Dell XPS-13-7390

Command: `nvim --startuptime startuptime.log`

<details>
  <summary>startuptime log</summary>

  ```
    times in msec
     clock   self+sourced   self:  sourced script
     clock   elapsed:              other lines

    000.007  000.007: --- NVIM STARTING ---
    000.054  000.047: event init
    000.102  000.048: early init
    000.137  000.035: locale set
    000.167  000.031: init first window
    000.373  000.205: inits 1
    000.381  000.009: window checked
    000.383  000.002: parsing arguments
    000.741  000.060  000.060: require('vim.shared')
    000.835  000.032  000.032: require('vim._meta')
    000.837  000.092  000.060: require('vim._editor')
    000.838  000.176  000.024: require('vim._init_packages')
    000.839  000.280: init lua interpreter
    000.880  000.041: expanding arguments
    000.904  000.024: inits 2
    001.109  000.205: init highlight
    001.110  000.001: waiting for UI
    001.208  000.098: done waiting for UI
    001.213  000.005: clear screen
    001.305  000.092: init default mappings
    001.316  000.011: init default autocommands
    001.653  000.061  000.061: sourcing /usr/share/nvim/runtime/ftplugin.vim
    001.702  000.022  000.022: sourcing /usr/share/nvim/runtime/indent.vim
    001.741  000.007  000.007: sourcing /usr/share/nvim/archlinux.vim
    001.744  000.021  000.014: sourcing /etc/xdg/nvim/sysinit.vim
    003.039  000.032  000.032: require('colors.nvim-falcon.palette')
    003.146  000.523  000.491: require('colors.nvim-falcon.colorscheme')
    003.148  000.559  000.036: require('colors.nvim-falcon')
    003.952  000.073  000.073: require('colors.nvim-falcon.terminal')
    003.956  001.377  000.746: sourcing /home/zeng/.config/nvim/colors/nvim-falcon.lua
    003.960  002.190  000.813: require('init.general')
    004.077  000.005  000.005: require('vim.keymap')
    004.879  000.918  000.913: require('init.keymaps')
    004.954  000.072  000.072: require('init.autocmds')
    005.194  000.202  000.202: require('utils.packer')
    006.651  000.398  000.398: require('packer.load')
    007.549  000.006  000.006: require('vim.F')
    007.559  000.696  000.690: require('alpha')
    007.691  000.131  000.131: require('alpha.themes.dashboard')
    008.047  000.354  000.354: require('utils.static')
    008.710  000.044  000.044: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim
    008.743  000.015  000.015: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim
    008.775  000.016  000.016: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim
    008.805  000.014  000.014: sourcing /home/zeng/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim
    008.825  003.603  001.936: require('packer_compiled')
    008.852  003.896  000.091: require('init.plugins')
    008.853  007.095  000.020: sourcing /home/zeng/.config/nvim/init.lua
    008.858  000.342: sourcing vimrc file(s)
    009.054  000.009  000.009: sourcing /usr/share/vim/vimfiles/ftdetect/PKGBUILD.vim
    009.074  000.009  000.009: sourcing /usr/share/vim/vimfiles/ftdetect/SRCINFO.vim
    009.131  000.232  000.214: sourcing /usr/share/nvim/runtime/filetype.lua
    009.273  000.072  000.072: sourcing /usr/share/nvim/runtime/syntax/synload.vim
    009.345  000.182  000.110: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
    009.585  000.009  000.009: sourcing /home/zeng/.config/nvim/plugin/vscode_neovim.vim
    009.783  000.010  000.010: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
    009.800  000.007  000.007: sourcing /usr/share/nvim/runtime/plugin/health.vim
    009.816  000.008  000.008: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
    009.936  000.110  000.110: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
    009.961  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
    010.073  000.006  000.006: sourcing /home/zeng/.local/share/nvim/rplugin.vim
    010.080  000.108  000.102: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
    010.135  000.046  000.046: sourcing /usr/share/nvim/runtime/plugin/shada.vim
    010.168  000.016  000.016: sourcing /usr/share/nvim/runtime/plugin/spellfile.vim
    010.192  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
    010.210  000.007  000.007: sourcing /usr/share/nvim/runtime/plugin/tohtml.vim
    010.233  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
    010.294  000.013  000.013: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
    010.500  000.118  000.118: sourcing /home/zeng/.config/nvim/plugin/auto_hlsearch.lua
    010.555  000.038  000.038: sourcing /home/zeng/.config/nvim/plugin/auto_set_spell.lua
    010.600  000.033  000.033: sourcing /home/zeng/.config/nvim/plugin/tabout.lua
    010.811  000.039  000.039: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
    010.879  000.056  000.056: sourcing /usr/share/nvim/runtime/plugin/man.lua
    010.912  000.019  000.019: sourcing /usr/share/nvim/runtime/plugin/nvim.lua
    010.927  000.981: loading rtp plugins
    011.048  000.120: loading packages
    011.489  000.121  000.121: sourcing /home/zeng/.local/share/nvim/site/pack/packer/start/rnvimr/after/plugin/rnvimr.vim
    011.527  000.359: loading after plugins
    011.541  000.014: inits 3
    013.598  002.057: reading ShaDa
    013.783  000.185: opening buffers
    013.914  000.116  000.116: require('utils.funcs')
    014.107  000.113  000.113: sourcing /home/zeng/.local/share/nvim/site/pack/packer/start/rnvimr/autoload/rnvimr.vim
    014.128  000.116: BufEnter autocommands
    014.130  000.002: editing files in windows
    015.761  001.631: VimEnter autocommands
    015.764  000.004: UIEnter autocommands
    015.766  000.002: before starting main loop
    016.512  000.746: first screen update
    016.515  000.002: --- NVIM STARTED ---
  ```

</details>

<details>
  <summary>statistics of 50 startups (sorted)</summary>


  ```
  016.891  000.004: --- NVIM STARTED ---
  018.252  000.003: --- NVIM STARTED ---
  019.379  000.003: --- NVIM STARTED ---
  019.416  000.003: --- NVIM STARTED ---
  019.486  000.003: --- NVIM STARTED ---
  019.490  000.003: --- NVIM STARTED ---
  019.644  000.004: --- NVIM STARTED ---
  019.657  000.003: --- NVIM STARTED ---
  019.746  000.004: --- NVIM STARTED ---
  019.794  000.003: --- NVIM STARTED ---
  019.821  000.003: --- NVIM STARTED ---
  019.846  000.003: --- NVIM STARTED ---
  019.913  000.003: --- NVIM STARTED ---
  019.951  000.003: --- NVIM STARTED ---
  019.961  000.003: --- NVIM STARTED ---
  019.969  000.003: --- NVIM STARTED ---
  019.985  000.003: --- NVIM STARTED ---
  020.053  000.003: --- NVIM STARTED ---
  020.107  000.003: --- NVIM STARTED ---
  020.118  000.003: --- NVIM STARTED ---
  020.133  000.003: --- NVIM STARTED ---
  020.134  000.003: --- NVIM STARTED ---
  020.136  000.003: --- NVIM STARTED ---
  020.202  000.003: --- NVIM STARTED ---
  020.229  000.003: --- NVIM STARTED ---
  020.236  000.003: --- NVIM STARTED ---
  020.236  000.003: --- NVIM STARTED ---
  020.248  000.003: --- NVIM STARTED ---
  020.327  000.003: --- NVIM STARTED ---
  020.346  000.003: --- NVIM STARTED ---
  020.374  000.003: --- NVIM STARTED ---
  020.379  000.003: --- NVIM STARTED ---
  020.401  000.003: --- NVIM STARTED ---
  020.440  000.003: --- NVIM STARTED ---
  020.486  000.003: --- NVIM STARTED ---
  020.509  000.003: --- NVIM STARTED ---
  020.524  000.003: --- NVIM STARTED ---
  020.543  000.003: --- NVIM STARTED ---
  020.555  000.003: --- NVIM STARTED ---
  020.570  000.003: --- NVIM STARTED ---
  020.584  000.003: --- NVIM STARTED ---
  020.635  000.003: --- NVIM STARTED ---
  020.717  000.003: --- NVIM STARTED ---
  020.736  000.003: --- NVIM STARTED ---
  020.763  000.003: --- NVIM STARTED ---
  021.218  000.003: --- NVIM STARTED ---
  021.375  000.003: --- NVIM STARTED ---
  021.800  000.003: --- NVIM STARTED ---
  026.470  000.004: --- NVIM STARTED ---
  027.071  000.004: --- NVIM STARTED ---
  ```

</details>
