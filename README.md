## Neovim :: M Λ C R O

[**Neovim :: M Λ C R O**](https://github.com/Bekaboo/nvim) is a collection of Neovim configuration files inspired
by [Emacs / N Λ N O](https://github.com/rougier/nano-emacs).

The goal of macro-neovim is to provide a clean and elegant user interface
while remaining practical for daily tasks, striking a balance between a
streamlined design and effective functionality. See [showcases](#showcases) to
get a glimpse of the basic usage and what this configuration looks like.

This is a highly personalized and opinionated Neovim configuration, not a
distribution. While it's not meant for direct use, you're welcome to fork,
experiment, and adapt it to your liking. Feel free to use it as a starting
point for your configuration or borrow elements you find useful. Issues and PRs
are welcome.

<center>
    <img src="https://github.com/Bekaboo/nvim/assets/76579810/299137e7-9438-489b-b98b-7211a62678ae" width=46%>  
    <img src="https://github.com/Bekaboo/nvim/assets/76579810/9e546e33-7678-47e2-8a80-368d7c59534a" width=46%>
</center>

## Table of Contents

<!--toc:start-->
- [Features](#features)
- [Requirements and Dependencies](#requirements-and-dependencies)
  - [Basic](#basic)
  - [Tree-sitter](#tree-sitter)
  - [LSP](#lsp)
  - [DAP](#dap)
  - [Formatter](#formatter)
  - [Other External Tools](#other-external-tools)
- [Installation](#installation)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Config Structure](#config-structure)
- [Tweaking this Configuration](#tweaking-this-configuration)
  - [Managing Plugins with Modules](#managing-plugins-with-modules)
  - [Installing Packages to an Existing Module](#installing-packages-to-an-existing-module)
  - [Installing Packages to a New Module](#installing-packages-to-a-new-module)
  - [General Settings and Options](#general-settings-and-options)
  - [Keymaps](#keymaps)
  - [Colorschemes](#colorschemes)
  - [Auto Commands](#auto-commands)
  - [LSP Server Configurations](#lsp-server-configurations)
  - [DAP Configurations](#dap-configurations)
  - [Snippets](#snippets)
  - [Enabling VSCode Integration](#enabling-vscode-integration)
- [Appendix](#appendix)
  - [Showcases](#showcases)
  - [Default Modules and Plugins of Choice](#default-modules-and-plugins-of-choice)
    - [Third Party Plugins](#third-party-plugins)
    - [Builtin Plugins](#builtin-plugins)
  - [Startuptime](#startuptime)
<!--toc:end-->

## Features

- Modular design
    - Install and manage packages in groups
    - Make it easy to use different set of configuration for different use
      cases
- Clean and uncluttered UI, including customized versions of:
    - [winbar](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/winbar)
    - [statusline](https://github.com/Bekaboo/nvim/blob/master/lua/plugin/statusline.lua)
    - [statuscolumn](https://github.com/Bekaboo/nvim/blob/master/lua/plugin/statuscolumn.lua)
    - [colorschemes](https://github.com/Bekaboo/nvim/tree/master/colors)
    - [intro message](https://github.com/Bekaboo/nvim/blob/master/plugin/intro.lua)
- [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) integration, makes you feel at home in VSCode when you
  occasionally need it
- Massive [TeX math snippets](https://github.com/Bekaboo/nvim/blob/master/lua/snippets/shared/math.lua)
- Image rendering in markdown files (requires [ueberzug](https://github.com/ueber-devel/ueberzug))
- Jupyter Notebook integration: edit notebooks like markdown files, run code in
  cells with simple commands and shortcuts
- [Fine-tuned plugins](https://github.com/Bekaboo/nvim/tree/master/lua/configs) with [custom patches](https://github.com/Bekaboo/nvim/tree/master/patches)
- Optimization for large files, open any file larger than 100 MB and edit like
  butter
- Fast startup around [~25 ms](#startuptime)

## Requirements and Dependencies

### Basic

- [Neovim](https://github.com/neovim/neovim) ***nightly***, for exact version see [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt)
- [Git](https://git-scm.com/)
- A decent terminal emulator
- A nerd font, e.g. [JetbrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono)

### Tree-sitter

Tree-sitter installation and configuration is handled by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

To add or remove support for a language, install or uninstall the corresponding
parser using `:TSInstall` or `:TSUninstall`.

To make the change permanent, add or remove corresponding parsers in the
`ensure_installed` field in the call to nvim-treesitter's `setup()` function,
see [lua/configs/nvim-treesitter.lua](https://github.com/Bekaboo/nvim/blob/master/lua/configs/nvim-treesitter.lua).

### LSP

For LSP support, install the following language servers manually using your
favorite package manager:

- Bash: [BashLS](https://github.com/bash-lsp/bash-language-server)

    Example for ArchLinux users:

    ```sh
    sudo pacman -S bash-language-server
    ```

- C/C++: [Clang](https://clang.llvm.org/)
- Lua: [LuaLS](https://github.com/LuaLS/lua-language-server)
- Python: one of
    - [Jedi Language Server](https://github.com/pappasam/jedi-language-server)
    - [Python LSP Server](https://github.com/python-lsp/python-lsp-server)
    - [Pyright](https://github.com/microsoft/pyright)
- Rust: [Rust Analyzer](https://rust-analyzer.github.io/)
- LaTeX: [TexLab](https://github.com/latex-lsp/texlab)
- VimL: [VimLS](https://github.com/iamcco/vim-language-server)
- Markdown: [Marksman](https://github.com/artempyanykh/marksman)
- General-purpose language server: [EFM Language Server](https://github.com/mattn/efm-langserver)
    - Already configured for [Black](https://github.com/psf/black), [Shfmt](https://github.com/mvdan/sh), [Fish-indent](https://fishshell.com/docs/current/cmds/fish_indent.html), and [StyLua](https://github.com/JohnnyMorganz/StyLua)

To add support for other languages, install corresponding language servers
manually then add `lsp.lua` files under [after/ftplugin](https://github.com/Bekaboo/nvim/tree/master/after/ftplugin) to automatically lanuch
them for differnt filetypes.

Some examples of `lsp.lua` files:

- [after/ftplugin/lua/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/lua/lsp.lua)
- [after/ftplugin/python/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/python/lsp.lua)
- [after/ftplugin/rust/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/rust/lsp.lua)
- [after/ftplugin/sh/lsp.lua](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/sh/lsp.lua)

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

- Bash: install [Shfmt](https://github.com/mvdan/sh)\*
- C/C++: install [Clang](https://clang.llvm.org/) to use `clang-format`
- Lua: install [StyLua](https://github.com/JohnnyMorganz/StyLua)\*
- Rust: install [Rust](https://www.rust-lang.org/tools/install) to use `rustfmt`
- Python: install [Black](https://github.com/psf/black)\*
- LaTeX: install [texlive-core](http://tug.org/texlive/) to use `latexindent`

<sub>\*Need [EFM Language Server](https://github.com/mattn/efm-langserver) to work with `vim.lsp.buf.format()`</sub>

### Other External Tools

- [Fd](https://github.com/sharkdp/fd), [Ripgrep](https://github.com/BurntSushi/ripgrep), and [Fzf](https://github.com/junegunn/fzf) for fuzzy search
- [Pandoc](https://pandoc.org/), [custom scripts](https://github.com/Bekaboo/dot/tree/master/.scripts) and [TexLive](https://www.tug.org/texlive/) (for ArchLinux users, it is `texlive-core` and `texlive-extra`) for markdown → PDF conversion (`:MarkdownToPDF`)
- [Draw.io desktop](https://www.drawio.com/blog/diagrams-offline) for creating and inserting simple PNG diagrams in markdown files (`:MarkdownInsertImage`)
- [Node.js](https://nodejs.org/en) for installing dependencies for [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- [Magick LuaRocks](https://github.com/leafo/magick), [ImageMagick](https://github.com/ImageMagick/ImageMagick) executable, and [ueberzug](https://github.com/ueber-devel/ueberzug) for in-place image preview in markdown files
- [Jupytext](https://github.com/mwouts/jupytext) and [Pynvim](https://github.com/neovim/pynvim) for editing Jupyter notebooks

## Installation

1. Make sure you have required dependencies installed.
2. Clone this repo to your config directory

    ```sh
    git clone https://github.com/Bekaboo/nvim ~/.config/nvim-macro
    ```

4. Open neovim using 

    ```sh
    NVIM_APPNAME=nvim-macro nvim
    ```

    On first installation, neovim will prompt you to decide whether to install
    third-party plugins, press `y` to install, `n` to skip, `never` to skip and
    disable the prompt in the future (aka "do not ask again").

    The suggestion is to use `n` to skip installing plugins on first launch,
    and see if everything works OK under a bare minimum setup. Depending on
    your needs, you can choose whether to install third-party plugins later
    using `y`/`yes` or `never` on the second launch.

    **Some notes about third-party plugins**

    Installing third-party plugins is known to cause issues in some cases,
    including:

    1. Partially cloned plugins and missing dependencies due to slow network
       connection
    2. Building failure especially for plugins like [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
       and [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) due to missing building dependencies or slow
       installation process
    3. Some plugins like [copilot.lua](https://github.com/zbirenbaum/copilot.lua) needs authentication to work
    4. Treesitter plugins can easily cause issues if you are on a different
       nvim version, check [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt) for the version of nvim targeted by
       this config

    To avoid these issues,

    1. Ensure you have a fast network before installing third-party plugins
    2. If the building process failed, go to corresponding project directory
       under `g:package_path` and manually run the build command from there.
       The build commands are declared in module specification files under
       [lua/modules](https://github.com/Bekaboo/nvim/tree/master/lua/modules)
    3. Disable [copilot.lua](https://github.com/zbirenbaum/copilot.lua) if you do not have access to it
    4. Ensure you are on the same version of nvim as specified in
       [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt) if you encounter any issue related to treesitter

5. After entering neovim, Run `:checkhealth` to check potential dependency
   issues.
6. Enjoy!

## Troubleshooting

If you encounter any issue, please try the following steps:

1. Run `:Lazy restore` once to ensure that all packages are properly
   installed and **patched**

2. Run `:checkhealth` to check potential dependency issues

3. Check `:version` to make sure you are on the same (of above) version\* of
   neovim as specified in [nvim-version.txt](https://github.com/Bekaboo/nvim/blob/master/nvim-version.txt)

    - \* The commit SHA matters for nightly/dev builds of Neovim!

4. Try removing the following paths then restart Neovim:

    - `:echo stdpath('cache')`
    - `:echo stdpath('state')`
    - `:echo stdpath('data')`

5. If still not working, please open an issue and I will be happy to help

## Uninstallation

You can uninstall this config completely by simply removing the following
paths:

- `:echo stdpath('config')`
- `:echo stdpath('cache')`
- `:echo stdpath('state')`
- `:echo stdpath('data')`

## Config Structure

```
.
├── colors                      # colorschemes
├── plugin                      # custom plugins
├── ftplugin                    # custom filetype plugins
├── init.lua                    # entry of config
├── lua
│   ├── core                    # files under this folder is required by 'init.lua'
│   │   ├── autocmds.lua
│   │   ├── general.lua         # options and general settings
│   │   ├── keymaps.lua
│   │   └── packages.lua        # bootstraps package manager and specifies what packages to include
│   ├── modules                 # all plugin specifications and configs go here
│   │   ├── lib.lua             # plugin specifications in module 'lib'
│   │   ├── completion.lua      # plugin specifications in module 'completion'
│   │   ├── debug.lua           # plugin specifications in modules 'debug'
│   │   ├── lsp.lua             # plugin specifications in module 'lsp'
│   │   ├── markup.lua          # ...
│   │   ├── misc.lua
│   │   ├── tools.lua
│   │   ├── treesitter.lua
│   │   └── colorschemes.lua
│   ├── configs                 # configs for each plugin
│   ├── snippets                # snippets
│   ├── plugin                  # the actual implementation of custom plugins
│   └── utils
└── syntax                      # syntax files
```

## Tweaking this Configuration

### Managing Plugins with Modules

In order to enable or disable a module, one need to change the table in
[lua/core/packages.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/packages.lua) passed to `enable_modules()`, for example

```lua
enable_modules({
  'lib',
  'treesitter',
  'edit',
  -- ...
})
```

### Installing Packages to an Existing Module

To install plugin `foo` under module `bar`, just insert the corresponding
specification to the big table `lua/modules/bar.lua` returns, for instance,

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

After creating the new module `bar`, enable it in [lua/core/packages.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/packages.lua):

```lua
enable_modules({
  -- ...
  'bar',
  -- ...
})
```

### General Settings and Options

See [lua/core/general.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/general.lua).

### Keymaps

See [lua/core/keymaps.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/keymaps.lua), or see module config files for
corresponding plugin keymaps.

### Colorschemes

`cockatoo`, `nano`, and `macro` are three builtin custom colorschemes, with
separate palettes for dark and light background.

Neovim is configured to restore the previous background and colorscheme
settings on startup, so there is no need to set them up in the config file
explicitly.

To disable the auto-restore feature, remove the plugin [plugin/colorswitch.lua](https://github.com/Bekaboo/nvim/tree/master/plugin/colorswitch.lua).

To tweak this colorscheme, edit corresponding colorscheme files under [colors](https://github.com/Bekaboo/nvim/tree/master/colors).

### Auto Commands

See [lua/core/autocmds.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/autocmds.lua).

### LSP Server Configurations

See [lua/utils/lsp.lua](https://github.com/Bekaboo/nvim/tree/master/lua/utils/lsp.lua) and `lsp.lua` files under [after/ftplugin](https://github.com/Bekaboo/nvim/tree/master/after/ftplugin).

### DAP Configurations

See [lua/configs/dap-configs](https://github.com/Bekaboo/nvim/tree/master/lua/configs/dap-configs), [lua/configs/nvim-dap.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-dap.lua), and [lua/configs/nvim-dap-ui.lua](https://github.com/Bekaboo/nvim/tree/master/lua/configs/nvim-dap-ui.lua).

### Snippets

This configuration use [LuaSnip](https://github.com/L3MON4D3/LuaSnip) as the snippet engine,
custom snippets for different filetypes
are defined under [lua/snippets](https://github.com/Bekaboo/nvim/tree/master/lua/snippets).

### Enabling VSCode Integration

VSCode integration takes advantages of the modular design, allowing to use
a different set of modules when Neovim is launched by VSCode, relevant code is
in [autoload/plugin/vscode.vim](https://github.com/Bekaboo/nvim/blob/master/autoload/plugin/vscode.vim) and [lua/core/packages.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/packages.lua).

To make VSCode integration work, please install [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim) in VSCode
and configure it correctly.

After setting up VSCode-Neovim, re-enter VSCode, open a random file
and it should work out of the box.

## Appendix

### Showcases

- File manager using [oil.nvim](https://github.com/stevearc/oil.nvim)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/26bb146f-7637-4f68-acd7-baecc08f1eaf" width=75%>

- DAP support powered by [nvim-dap](https://github.com/mfussenegger/nvim-dap) and [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/f6c7e6ce-283b-43d7-8bc3-e8b24513a03b" width=75%>

- Rendering images in markdown files with [image.nvim](https://github.com/3rd/image.nvim) \*

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/af2a3b2b-0601-482f-bf1e-b14e091ff179" width=75%>

- Jupyter Notebook integration using [jupytext](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/jupytext.lua) and [molten-nvim](https://github.com/benlubas/molten-nvim)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/ce212348-8b89-4a03-a222-ab74f0338a7d" width=75%>

- Winbar with IDE-like drop-down menus using [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/247401a9-6127-4d73-bb21-ceb847d8f7b9" width=75%>

- LSP hover & completion thanks to Neovim builtin LSP client and [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/13589137-b5c7-4104-810c-f8cdc56f9d1b" width=75%>

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/60c5b599-4191-494d-ad83-1ca7a84eab17" width=75%>

- Git integration: [fugitive](https://github.com/tpope/vim-fugitive) and [gitsigns.nvim](https://github.com/tpope/vim-fugitive)

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/a5e0a41d-4e85-4bfc-a39d-cc7b76abedcf" width=75%>

    <img src="https://github.com/Bekaboo/nvim/assets/76579810/73da4ee1-8f6c-440a-9eb9-0bcf3bc8e3ea" width=75%>

### Default Modules and Plugins of Choice

#### Third Party Plugins

Total # of plugins: 49 (package manager included).

- **Lib**
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
    - [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim)
- **Markup**
    - [vimtex](https://github.com/lervag/vimtex)
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    - [vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
    - [image.nvim](https://github.com/3rd/image.nvim)
    - [otter.nvim](https://github.com/jmbuhr/otter.nvim)
    - [molten-nvim](https://github.com/benlubas/molten-nvim)
    - [headlines.nvim](https://github.com/lukas-reineke/headlines.nvim)
- **Edit**
    - [nvim-surround](https://github.com/kylechui/nvim-surround)
    - [Comment.nvim](https://github.com/numToStr/Comment.nvim)
    - [vim-sleuth](https://github.com/tpope/vim-sleuth)
    - [ultimate-autopairs.nvim](https://github.com/altermo/ultimate-autopair.nvim)
    - [vim-easy-align](https://github.com/junegunn/vim-easy-align)
- **Tools**
    - [fzf-lua](https://github.com/ibhagwan/fzf-lua)
    - [flatten.nvim](https://github.com/willothy/flatten.nvim)
    - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
    - [git-conflict](https://github.com/akinsho/git-conflict.nvim)
    - [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive)
    - [oil.nvim](https://github.com/stevearc/oil.nvim)
- **Treesitter**
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
    - [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
    - [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
    - [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise)
    - [treesj](https://github.com/Wansmer/treesj)
    - [cellular-automaton.nvim](https://github.com/Eandrju/cellular-automaton.nvim)
- **Debug**
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap)
    - [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
    - [one-small-step-for-vimkind](https://github.com/jbyuki/one-small-step-for-vimkind)
- **Colorschemes**
    - [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
    - [rose-pine/neovim](https://github.com/rose-pine/neovim)
    - [everforest](https://github.com/sainnhe/everforest)
    - [gruvbox-material](https://github.com/sainnhe/gruvbox-material)

#### Builtin Plugins

- [colorcolumn](https://github.com/Bekaboo/nvim/tree/master/plugin/colorcolumn.lua)
    - Shows color column dynamically based on current line width
    - Released as [deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)
- [colorswitch](https://github.com/Bekaboo/nvim/tree/master/plugin/colorswitch.lua)
    - Remembers and restores previous background and colorscheme settings
    - Syncs background and colorscheme settings among multiple Neovim instances
      if scripts [setbg](https://github.com/Bekaboo/dot/blob/master/.scripts/setbg) and [setcolor](https://github.com/Bekaboo/dot/blob/master/.scripts/setcolor) are in `$PATH`
- [expandtab](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/expandtab.lua)
    - Always use spaces for alignment, even if `&expandtab` is not set
- [im](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/im.lua)
    - Switches and restores fcitx state in each buffer asynchronouly
- [jupytext](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/jupytext.lua)
    - Edits jupyter notebook like markown files
    - Writes into jupyter notebook asynchronouly, which gives a smoother
      experience than [jupytext.vim](https://github.com/goerz/jupytext)
- [intro](https://github.com/Bekaboo/nvim/tree/master/plugin/intro.lua)
    - Shows a custom intro message on startup
- [lsp-diags](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/lsp-diags.lua)
    - Sets up LSP and diagnostic options and commands on `LspAttach` or
      `DiagnosticChanged`
- [readline](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/readline.lua)
    - Readline-like keybindings in insert and command mode
- [statuscolumn](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/statuscolumn.lua)
    - Custom statuscolumn, with git signs on the right of line numbers
- [statusline](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/statusline.lua)
    - Custom statusline inspired by [nano-emacs](https://github.com/rougier/nano-emacs)
- [tabout](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/tabout.lua)
    - Tab out and in with `<Tab>` and `<S-Tab>`
- [term](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/term.lua)
    - Some nice setup for terminal buffers
- [tmux](https://github.com/Bekaboo/nvim/tree/master/lua/plugin/tmux.lua)
    - Integration with tmux, provides unified keymaps for navigation, resizing,
      and many other window operations
- [vscode](https://github.com/Bekaboo/nvim/tree/master/autoload/plugin/vscode.vim)
    - Integration with [VSCode-Neovim](https://github.com/vscode-neovim/vscode-neovim)
- [winbar](https://github.com/Bekaboo/nvim/blob/master/lua/plugin/winbar.lua)
    - A winbar with drop-down menus and multiple backends
    - Released as [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)
- [markdown-capitalized-title](https://github.com/Bekaboo/nvim/blob/master/after/ftplugin/markdown/capitalized-title.lua)
    - Automatically capitalize the first letter of each word in markdown titles
    - Use `:MarkdownSetCapTitle enable/disable` to enable or disable this
      feature

### Startuptime

- Neovim Version:

    ```
    NVIM v0.10.0-dev-2272+gcd3399f6bd
    Build type: Release
    LuaJIT 2.1.1702233742
    ```

- Config Commit: `ce357d5d`

- System: Arch Linux 6.7.3-arch1-1

- Machine: Dell XPS 13-7390

- Startup time with `--clean`:

    ```sh
    hyperfine 'nvim --clean +q'
    ```

    ```
    Benchmark 1: nvim --clean +q
      Time (mean ± σ):       9.9 ms ±   1.4 ms    [User: 6.5 ms, System: 3.4 ms]
      Range (min … max):     7.9 ms …  14.0 ms    244 runs
    ```

- Startup time with this config:

    ```sh
    hyperfine 'nvim +q'
    ```

    ```
    Benchmark 1: nvim +q
      Time (mean ± σ):      18.1 ms ±   1.5 ms    [User: 13.9 ms, System: 4.1 ms]
      Range (min … max):    15.9 ms …  22.7 ms    142 runs
    ```

    <details>
      <summary>startuptime log</summary>

    ```
    times in msec
     clock   self+sourced   self:  sourced script
     clock   elapsed:              other lines

    000.007  000.007: --- NVIM STARTING ---
    000.144  000.137: event init
    000.218  000.074: early init
    000.268  000.051: locale set
    000.309  000.041: init first window
    000.542  000.233: inits 1
    000.554  000.012: window checked
    000.556  000.002: parsing arguments
    001.063  000.035  000.035: require('vim.shared')
    001.149  000.042  000.042: require('vim.inspect')
    001.201  000.038  000.038: require('vim._options')
    001.202  000.136  000.056: require('vim._editor')
    001.204  000.256  000.085: require('vim._init_packages')
    001.205  000.394: init lua interpreter
    001.256  000.051: expanding arguments
    001.271  000.015: inits 2
    001.528  000.257: init highlight
    001.530  000.001: waiting for UI
    001.627  000.097: done waiting for UI
    001.630  000.004: clear screen
    001.668  000.006  000.006: require('vim.keymap')
    001.965  000.332  000.326: require('vim._defaults')
    001.968  000.005: init default mappings & autocommands
    002.458  000.070  000.070: sourcing /usr/share/nvim/runtime/ftplugin.vim
    002.537  000.030  000.030: sourcing /usr/share/nvim/runtime/indent.vim
    002.594  000.011  000.011: sourcing /usr/share/nvim/archlinux.vim
    002.597  000.030  000.020: sourcing /etc/xdg/nvim/sysinit.vim
    003.320  000.133  000.133: require('vim.uri')
    003.341  000.199  000.067: require('vim.loader')
    004.023  001.386  001.187: require('core.general')
    004.057  000.017  000.017: require('vim.fs')
    006.044  002.018  002.001: require('core.keymaps')
    006.305  000.258  000.258: require('core.autocmds')
    006.478  000.076  000.076: require('utils')
    006.549  000.068  000.068: require('utils.static')
    006.893  000.232  000.232: require('utils.static.icons._icons')
    006.895  000.344  000.111: require('utils.static.icons')
    007.166  000.075  000.075: require('modules.lib')
    007.233  000.060  000.060: require('modules.lsp')
    007.341  000.104  000.104: require('modules.edit')
    007.456  000.110  000.110: require('modules.debug')
    007.539  000.078  000.078: require('modules.tools')
    007.595  000.051  000.051: require('modules.markup')
    007.652  000.053  000.053: require('modules.completion')
    007.706  000.050  000.050: require('modules.treesitter')
    007.754  000.044  000.044: require('modules.colorschemes')
    008.416  000.659  000.659: require('lazy')
    008.443  000.011  000.011: require('ffi')
    008.497  000.048  000.048: require('lazy.stats')
    008.606  000.090  000.090: require('lazy.core.util')
    008.677  000.068  000.068: require('lazy.core.config')
    008.867  000.083  000.083: require('lazy.core.handler')
    009.043  000.173  000.173: require('lazy.core.plugin')
    009.063  000.385  000.129: require('lazy.core.loader')
    011.455  000.182  000.182: require('lazy.core.handler.event')
    011.619  000.152  000.152: require('lazy.core.handler.keys')
    011.687  000.064  000.064: require('lazy.core.handler.cmd')
    011.773  000.081  000.081: require('lazy.core.handler.ft')
    013.417  000.024  000.024: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/cls.vim
    013.456  000.016  000.016: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/tex.vim
    013.493  000.016  000.016: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/tikz.vim
    013.854  000.181  000.181: sourcing /usr/share/nvim/runtime/filetype.lua
    013.893  000.005  000.005: require('vim.F')
    014.445  000.110  000.110: sourcing /home/zeng/.config/nvim/plugin/_load.lua
    014.712  000.124  000.124: require('utils.hl')
    014.763  000.290  000.166: sourcing /home/zeng/.config/nvim/plugin/colorcolumn.lua
    014.896  000.044  000.044: require('utils.json')
    014.938  000.039  000.039: require('utils.fs')
    016.334  000.857  000.857: sourcing /home/zeng/.config/nvim/colors/macro.lua
    016.502  001.715  000.775: sourcing /home/zeng/.config/nvim/plugin/colorswitch.lua
    016.885  000.097  000.097: require('vim.highlight')
    016.988  000.459  000.362: sourcing /home/zeng/.config/nvim/plugin/intro.lua
    017.197  000.058  000.058: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
    017.238  000.013  000.013: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
    017.354  000.095  000.095: sourcing /usr/share/nvim/runtime/plugin/man.lua
    017.414  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
    017.605  000.131  000.131: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
    017.661  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
    017.818  000.129  000.129: sourcing /usr/share/nvim/runtime/plugin/nvim.lua
    017.927  000.083  000.083: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
    017.960  000.008  000.008: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
    018.031  000.052  000.052: sourcing /usr/share/nvim/runtime/plugin/shada.vim
    018.074  000.016  000.016: sourcing /usr/share/nvim/runtime/plugin/spellfile.vim
    018.106  000.010  000.010: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
    018.135  000.007  000.007: sourcing /usr/share/nvim/runtime/plugin/tohtml.vim
    018.160  000.006  000.006: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
    018.202  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
    018.368  012.060  005.748: require('core.packages')
    018.371  015.751  000.029: sourcing /home/zeng/.config/nvim/init.lua
    018.376  000.527: sourcing vimrc file(s)
    018.501  000.073  000.073: sourcing /usr/share/nvim/runtime/filetype.lua
    018.647  000.055  000.055: sourcing /usr/share/nvim/runtime/syntax/synload.vim
    018.743  000.202  000.147: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
    018.755  000.104: inits 3
    018.910  000.103  000.103: require('plugin.statuscolumn')
    019.067  000.209: opening buffers
    019.086  000.020: BufEnter autocommands
    019.088  000.001: editing files in windows
    019.104  000.016: VimEnter autocommands
    019.175  000.071: UIEnter autocommands
    019.400  000.177  000.177: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
    019.406  000.055: before starting main loop
    019.694  000.059  000.059: require('utils.stl')
    020.095  000.335  000.335: require('plugin.statusline')
    020.340  000.193  000.193: require('utils.git')
    020.591  000.234  000.234: require('vim._system')
    021.847  001.620: first screen update
    021.850  000.003: --- NVIM STARTED ---
    ```

    </details>
