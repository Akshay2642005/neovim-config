Neovim Configuration
====================

This file documents the configuration for the Neovim text editor, customized for
performance and efficiency. It utilizes the `lazy.nvim` package manager and a
curated set of Lua-based plugins.

Table of Contents
-----------------
1. Introduction
2. Requirements
3. Installation
4. Directory Structure
5. Key Bindings
6. Typography
7. License

1. Introduction
---------------
This configuration aims to provide a robust environment for software development.
It emphasizes speed, minimal visual clutter, and keyboard-centric workflow.
The system is built upon the Lua programming language and leverages modern Neovim
features such as the built-in LSP client and Treesitter for syntax highlighting.

2. Requirements
---------------
To utilize this configuration, the following software must be installed on your
system:

   * Neovim (v0.10.0 or greater)
   * Git (for version control and plugin management)
   * Ripgrep (rg) (for fast text searching)
   * A C compiler (gcc or clang) (for compiling Treesitter parsers)
   * Node.js and NPM (for language server installation via Mason)

Optional but recommended:
   * Lazygit (for git integration)
   * fd (for fast file finding)

3. Installation
---------------
To install this configuration, clone the repository to your local machine.

On Unix-like systems (Linux, macOS):
```sh
git clone https://github.com/Akshay2642005/neovim-config ~/.config/nvim
```

On Windows (PowerShell):
```ps1
git clone https://github.com/Akshay2642005/neovim-config $env:LOCALAPPDATA\nvim
```

Upon the first launch of Neovim, the plugin manager (lazy.nvim) will
bootstrap itself and automatically install all defined plugins. Please allow
several minutes for this process to complete.

4. Directory Structure
----------------------
The configuration is organized strictly under the `lua/` directory to ensure
modularity.

```
   ~/.config/nvim/
   |-- init.lua             # Entry point
   |-- lazy-lock.json       # Plugin versions lockfile
   `-- lua/
       `-- cfg/
           |-- core/        # Core settings
           |   |-- options.lua      # Editor options (set first)
           |   |-- keymaps/         # Keyboard mappings
           |   `-- autocmds.lua     # Automatic commands
           |-- plugins/     # Plugin specifications
           `-- lazy.lua     # Plugin manager configuration
```

5. Key Bindings
---------------
The `<Leader>` key is mapped to the Space bar.

General
~~~~~~~
```
<Space> <Space>    Find files (Snacks Picker)
<Space> ff         Find files (Snacks Picker)
<Space> lg         Live grep (search text in project)
<Space> bf         List open buffers
<Space> hh         Search help tags
```

Git Integration
~~~~~~~~~~~~~~~
```
<Space> gg         Open Lazygit interface
<Space> gl         Show git log for current directory
<Space> gf         Show git log for current file
<Space> gb         Git blame current line
<Space> gs         Git status
```

LSP & Coding
~~~~~~~~~~~~
```
K                  Hover documentation
gd                 Go to definition
gr                 Go to references
<Space> ca         Code actions
<Space> rn         Rename symbol
```

Terminal
~~~~~~~~
```
<Ctrl> /           Toggle floating terminal
<Ctrl> _           Toggle floating terminal (alternative)
```

6. Typography
-------------
For the most authentic experience, it is recommended to configure your terminal
emulator to use a traditional monospace font.

Recommended typefaces:
   * Bitstream Vera Sans Mono
   * Lucida Console
   * Courier New
   * Terminus
   * Fixed

Ensure the selected font supports the necessary glyphs if you intend to use
fancy icons; otherwise, the interface remains purely textual and functional.

7. License
----------
This configuration is provided "as is", without warranty of any kind.
See the accompanying LICENSE file for terms of use, if applicable.
