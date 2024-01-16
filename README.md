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

To make the change permanent, add or remove corresponding entries in `M.langs`
in [lua/utils/static/init.lua](https://github.com/Bekaboo/nvim/blob/master/lua/utils/static/init.lua).

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
- Python: [Jedi Language Server](https://github.com/pappasam/jedi-language-server)
- Rust: [Rust Analyzer](https://rust-analyzer.github.io/)
- LaTeX: [TexLab](https://github.com/latex-lsp/texlab)
- VimL: [VimLS](https://github.com/iamcco/vim-language-server)
- Markdown: [Marksman](https://github.com/artempyanykh/marksman)
- General-purpose language server: [EFM Language Server](https://github.com/mattn/efm-langserver)
    - Already configured for [Black](https://github.com/psf/black), [Shfmt](https://github.com/mvdan/sh), [Fish-indent](https://fishshell.com/docs/current/cmds/fish_indent.html), and [StyLua](https://github.com/JohnnyMorganz/StyLua)

To add support for other languages, install corresponding language server
manually then add `lsp.lua` file under [after/ftplugin](https://github.com/Bekaboo/nvim/tree/master/after/ftplugin) to automatically lanuch
corresponding language servers for differnt filetypes.

Some examples for `lsp.lua` files:

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

- Bash: install [Shfmt](https://github.com/mvdan/sh)
- C/C++: install [Clang](https://clang.llvm.org/) to use `clang-format`
- Lua: install [StyLua](https://github.com/JohnnyMorganz/StyLua)
- Rust: install [Rust](https://www.rust-lang.org/tools/install) to use `rustfmt`
- Python: install [Black](https://github.com/psf/black)
- LaTeX: install [texlive-core](http://tug.org/texlive/) to use `latexindent`

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

    ```
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

`cockatoo`, `nano`, and `dragon` are three builtin custom colorschemes, with
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
in [plugin/vscode-neovim.vim](https://github.com/Bekaboo/nvim/blob/master/autoload/plugin/vscode.vim) and [lua/core/packages.lua](https://github.com/Bekaboo/nvim/blob/master/lua/core/packages.lua).

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

    <sub>\*Disabled by default for performance condsiderations</sub>

- Jupyter Notebook integration using [jupytext.vim](https://github.com/goerz/jupytext) and [molten-nvim](https://github.com/benlubas/molten-nvim)

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

Total # of plugins: 50 (package manager included).

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
    - [jupytext.vim](https://github.com/goerz/jupytext.vim)
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
- [intro](https://github.com/Bekaboo/nvim/tree/master/plugin/intro.lua)
    - Shows a custom intro message on startup
- [lsp-diagnostic](https://github.com/Bekaboo/nvim/tree/master/plugin/lsp-diagnostic.lua)
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

- Last update: 2023-12-25

- Neovim Version:

    ```
    NVIM v0.10.0-dev-1627+g879617c9bb
    Build type: Release
    LuaJIT 2.1.1700008891
    Run "nvim -V1 -v" for more info
    ```

- Config Commit: `f30e9217` (#2345)

- System: Arch Linux 6.6.8-arch1-1

- Machine: ThinkPad P15v Gen1

- Startup time with `--clean`:

    ```sh
    hyperfine "nvim --clean +'call timer_start(0, {-> execute('\''qall!'\'')})'"
    ```

    ```
    Benchmark 1: nvim --clean +'call timer_start(0, {-> execute('\''qall!'\'')})'
      Time (mean ± σ):       9.1 ms ±   0.4 ms    [User: 6.3 ms, System: 2.8 ms]
      Range (min … max):     8.5 ms …  10.8 ms    245 runs
    ```

- Startup time with this config:

    ```sh
    hyperfine "nvim +'call timer_start(0, {-> execute('\''qall!'\'')})'"
    ```

    ```
    Benchmark 1: nvim +'call timer_start(0, {-> execute('\''qall!'\'')})'
      Time (mean ± σ):      24.6 ms ±   0.9 ms    [User: 18.0 ms, System: 5.7 ms]
      Range (min … max):    22.2 ms …  27.6 ms    107 runs
    ```

    <details>
      <summary>startuptime log</summary>

    ```
    times in msec
     clock   self+sourced   self:  sourced script
     clock   elapsed:              other lines

    000.006  000.006: --- NVIM STARTING ---
    000.120  000.114: event init
    000.173  000.053: early init
    000.210  000.037: locale set
    000.247  000.037: init first window
    000.439  000.192: inits 1
    000.450  000.010: window checked
    000.451  000.002: parsing arguments
    000.831  000.066  000.066: require('vim.shared')
    000.905  000.033  000.033: require('vim.inspect')
    000.946  000.029  000.029: require('vim._options')
    000.947  000.113  000.050: require('vim._editor')
    000.948  000.219  000.040: require('vim._init_packages')
    000.950  000.280: init lua interpreter
    000.995  000.045: expanding arguments
    001.007  000.011: inits 2
    001.207  000.200: init highlight
    001.208  000.001: waiting for UI
    001.315  000.107: done waiting for UI
    001.317  000.003: clear screen
    001.353  000.009  000.009: require('vim.keymap')
    001.530  000.211  000.202: require('vim._defaults')
    001.533  000.005: init default mappings & autocommands
    002.013  000.080  000.080: sourcing /usr/share/nvim/runtime/ftplugin.vim
    002.079  000.032  000.032: sourcing /usr/share/nvim/runtime/indent.vim
    002.137  000.008  000.008: sourcing /usr/share/nvim/archlinux.vim
    002.140  000.032  000.023: sourcing /etc/xdg/nvim/sysinit.vim
    002.669  000.090  000.090: require('vim.uri')
    002.684  000.191  000.100: require('vim.loader')
    003.283  001.110  000.920: require('core.general')
    003.331  000.027  000.027: require('vim.fs')
    003.845  000.225  000.225: require('utils')
    005.117  000.079  000.079: require('utils.keymap')
    005.314  002.027  001.697: require('core.keymaps')
    005.502  000.186  000.186: require('core.autocmds')
    005.808  000.063  000.063: require('modules.lib')
    005.890  000.076  000.076: require('modules.lsp')
    006.008  000.113  000.113: require('modules.edit')
    006.088  000.074  000.074: require('modules.debug')
    006.182  000.087  000.087: require('modules.tools')
    006.290  000.102  000.102: require('modules.markup')
    006.397  000.066  000.066: require('modules.completion')
    006.533  000.130  000.130: require('modules.treesitter')
    006.748  000.206  000.206: require('modules.colorschemes')
    007.435  000.675  000.675: require('lazy')
    007.462  000.012  000.012: require('ffi')
    007.515  000.048  000.048: require('lazy.stats')
    007.608  000.076  000.076: require('lazy.core.util')
    007.677  000.067  000.067: require('lazy.core.config')
    007.783  000.043  000.043: require('lazy.core.handler')
    007.847  000.062  000.062: require('lazy.core.plugin')
    007.853  000.174  000.069: require('lazy.core.loader')
    010.115  000.059  000.059: require('lazy.core.handler.cmd')
    010.200  000.080  000.080: require('lazy.core.handler.keys')
    010.315  000.062  000.062: require('lazy.core.handler.event')
    010.318  000.111  000.049: require('lazy.core.handler.ft')
    010.922  000.019  000.019: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/cls.vim
    010.964  000.016  000.016: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/tex.vim
    010.998  000.013  000.013: sourcing /home/zeng/.local/share/nvim/packages/vimtex/ftdetect/tikz.vim
    012.773  000.155  000.155: sourcing /usr/share/nvim/runtime/filetype.lua
    013.434  000.050  000.050: require('utils.hl')
    013.466  000.125  000.075: sourcing /home/zeng/.config/nvim/plugin/colorcolumn.lua
    013.568  000.035  000.035: require('utils.json')
    013.605  000.034  000.034: require('utils.fs')
    014.744  000.644  000.644: sourcing /home/zeng/.config/nvim/colors/dragon.lua
    014.760  001.268  000.555: sourcing /home/zeng/.config/nvim/plugin/colorswitch.lua
    014.827  000.040  000.040: sourcing /home/zeng/.config/nvim/plugin/expandtab.lua
    014.882  000.034  000.034: sourcing /home/zeng/.config/nvim/plugin/im.lua
    015.187  000.051  000.051: require('vim.highlight')
    015.411  000.508  000.457: sourcing /home/zeng/.config/nvim/plugin/intro.lua
    015.482  000.040  000.040: sourcing /home/zeng/.config/nvim/plugin/lsp-diagnostic.lua
    015.566  000.060  000.060: sourcing /home/zeng/.config/nvim/plugin/readline.lua
    015.703  000.036  000.036: require('utils.stl')
    015.727  000.137  000.101: sourcing /home/zeng/.config/nvim/plugin/statuscolumn.lua
    016.082  000.045  000.045: require('utils.static._box')
    016.125  000.039  000.039: require('utils.static._borders')
    016.177  000.050  000.050: require('utils.static._icons')
    016.179  000.321  000.187: require('utils.static')
    016.206  000.437  000.116: sourcing /home/zeng/.config/nvim/plugin/statusline.lua
    016.269  000.039  000.039: sourcing /home/zeng/.config/nvim/plugin/tabout.lua
    016.329  000.038  000.038: sourcing /home/zeng/.config/nvim/plugin/termopts.lua
    016.379  000.029  000.029: sourcing /home/zeng/.config/nvim/plugin/tmux.lua
    016.411  000.010  000.010: sourcing /home/zeng/.config/nvim/plugin/vscode-neovim.vim
    016.470  000.041  000.041: sourcing /home/zeng/.config/nvim/plugin/winbar.lua
    016.604  000.038  000.038: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
    016.638  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
    016.702  000.043  000.043: sourcing /usr/share/nvim/runtime/plugin/man.lua
    016.735  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
    016.915  000.136  000.136: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
    016.969  000.015  000.015: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
    017.050  000.060  000.060: sourcing /usr/share/nvim/runtime/plugin/nvim.lua
    017.185  000.080  000.080: require('vim.iter')
    017.202  000.128  000.047: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
    017.370  000.129  000.129: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
    017.444  000.046  000.046: sourcing /usr/share/nvim/runtime/plugin/shada.vim
    017.498  000.018  000.018: sourcing /usr/share/nvim/runtime/plugin/spellfile.vim
    017.534  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
    017.564  000.008  000.008: sourcing /usr/share/nvim/runtime/plugin/tohtml.vim
    017.589  000.006  000.006: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
    017.623  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
    017.719  012.215  006.313: require('core.packages')
    017.721  015.563  000.024: sourcing /home/zeng/.config/nvim/init.lua
    017.727  000.487: sourcing vimrc file(s)
    017.807  000.040  000.040: sourcing /usr/share/nvim/runtime/filetype.lua
    017.947  000.061  000.061: sourcing /usr/share/nvim/runtime/syntax/synload.vim
    018.018  000.175  000.114: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
    018.032  000.090: inits 3
    018.747  000.715: reading ShaDa
    019.126  000.379: opening buffers
    019.147  000.021: BufEnter autocommands
    019.149  000.002: editing files in windows
    019.151  000.003: VimEnter autocommands
    019.295  000.144: UIEnter autocommands
    019.516  000.181  000.181: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
    019.522  000.047: before starting main loop
    019.912  000.094  000.094: require('utils.git')
    020.006  000.082  000.082: require('vim._system')
    020.958  001.260: first screen update
    020.962  000.004: --- NVIM STARTED ---
    ```

    </details>
