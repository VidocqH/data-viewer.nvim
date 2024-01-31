# DataViewer.nvim

<a href="https://github.com/neovim/neovim/releases/tag/stable"><img alt="Neovim-stable" src="https://img.shields.io/badge/Neovim-stable-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green" /></a>
<a href="https://github.com/vidocqh/data-viewer.nvim/search?l=lua"><img alt="Top Language" src="https://img.shields.io/github/languages/top/vidocqh/data-viewer.nvim?style=flat-square&label=Lua&logo=lua&logoColor=darkblue" /></a>
<a href="https://github.com/vidocqh/data-viewer.nvim/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/vidocqh/data-viewer.nvim?style=flat-square&logo=MIT&label=License" /></a>

Lightweight neovim plugin provides a table view for inspect data files such as `csv`, `tsv`

<p align='center'>
  <b>Floating View</b>
  <img width="1357" alt="image" src="https://github.com/VidocqH/data-viewer.nvim/assets/16725418/e4e494e5-ff8b-4a5c-9f4d-07fc1982bace">
</p>

<p align='center'>
  <b>Tab View</b>
  <img width="1164" alt="image" src="https://github.com/VidocqH/data-viewer.nvim/assets/16725418/468ecb0a-2dd3-4dc9-ad61-6c55516fbdec">
</p>

### Supported filetypes

- csv
- tsv
- sqlite

## Requirements

- neovim >= 0.8
- [plenary](https://github.com/nvim-lua/plenary.nvim)
- [sqlite.lua](https://github.com/kkharji/sqlite.lua) (Optional)

## Usage

### Commands

- `:DataViewer` -- open with current file and auto detect filetype
- `:DataViewer [filetype]` -- open with current file with given filetype
- `:DataViewer [filepath] [filetype]` -- open with given file and given filetype

- `:DataViewerNextTable`
- `:DataViewerPrevTable`

- `:DataViewerClose`

## Installation

### Lazy:

```lua
require("lazy").setup({
  {
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    }
  },
})
```

## Config

### Default config:

```lua
local config = {
  autoDisplayWhenOpenFile = false,
  maxLineEachTable = 100,
  columnColorEnable = true,
  columnColorRoulette = { -- Highlight groups
    "DataViewerColumn0",
    "DataViewerColumn1",
    "DataViewerColumn2",
  },
  view = {
    float = true, -- False will open in current window
    width = 0.8, -- Less than 1 means ratio to screen width, valid when float = true
    height = 0.8, -- Less than 1 means ratio to screen height, valid when float = true
    zindex = 50, -- Valid when float = true
  },
  keymap = {
    quit = "q",
    next_table = "<C-l>",
    prev_table = "<C-h>",
  },
}
```

### Highlight Groups

You can use your own highlights for columns by change config

- DataViewerColumn0
- DataViewerColumn1
- DataViewerColumn2

- DataViewerFocusTable

## TODO

- More filetypes support
- Table styles
