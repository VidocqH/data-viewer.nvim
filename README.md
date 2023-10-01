# DataViewer.nvim

<a href="https://github.com/neovim/neovim/releases/tag/stable"><img alt="Neovim-stable" src="https://img.shields.io/badge/Neovim-stable-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green" /></a>
<a href="https://github.com/vidocqh/data-viewer.nvim/search?l=lua"><img alt="Top Language" src="https://img.shields.io/github/languages/top/vidocqh/data-viewer.nvim?style=flat-square&label=Lua&logo=lua&logoColor=darkblue" /></a>
<a href="https://github.com/vidocqh/data-viewer.nvim/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/vidocqh/data-viewer.nvim?style=flat-square&logo=MIT&label=License" /></a>

Lightweight neovim plugin provides a table view for inspect data files such as `csv`, `tsv`

<img width="1352" alt="image" src="https://github.com/VidocqH/data-viewer.nvim/assets/16725418/7b933b3a-fd4e-4758-9917-9055c35796db">

### Supported filetypes

- csv
- tsv

## Requirements

- neovim >= 0.8
- [plenary](https://github.com/nvim-lua/plenary.nvim)

## Usage

### Commands

- `:DataViewer`

## Installation

### Lazy:

```lua
requir("lazy").setup({
  {
    'vidocqh/data-viewer.nvim',
    opts={},
    dependencies = { "nvim-lua/plenary.nvim" }
  },
})
```

## Config

### Default config:

```lua
local config = {
  autoDisplayWhenOpenFile = false,
  columnColorEnable = true,
  columnColorRoulette = { -- Highlight groups
    "DataViewerColumn0",
    "DataViewerColumn1",
    "DataViewerColumn2",
  },
  view = {
    width = 0.8, -- Less than 1 means ratio to screen width
    height = 0.8, -- Less than 1 means ratio to screen height
    zindex = 50,
  }
}
```

## TODO

- More filetypes support
- Table styles
