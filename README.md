# DataViewer.nvim

Table views for data files such as 'csv'

<img width="1352" alt="image" src="https://github.com/VidocqH/data-viewer.nvim/assets/16725418/7b933b3a-fd4e-4758-9917-9055c35796db">

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
  columnColorEnable = true,
  columnColorRoulette = {"DataViewerColumn0", "DataViewerColumn1", "DataViewerColumn2"}, -- Highlight groups
  view = {
    width = 0.8, -- Less than 1 means ratio to screen width
    height = 0.8, -- Less than 1 means ratio to scree height
    zindex = 50,
  }
}
```

## TODO
- More filetypes support
- Table styles
