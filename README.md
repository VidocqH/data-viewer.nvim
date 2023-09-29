# DataViewer.nvim

Table views for data files such 'csv'

## Usage

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
  view = {
    width = 0.8, -- Less than 1 means ratio to screen width
    height = 0.8, -- Less than 1 means ratio to scree height
    zindex = 50,
  }
}
```
