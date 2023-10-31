---@class ViewConfig
---@field width number
---@field height number
---@field zindex number
local ViewConfig = {
  float = true, -- use float window or not
  width = 0.8,
  height = 0.8,
  zindex = 50,
}

---@class KeymapConfig
---@field quit string
---@field next_table string
---@field prev_table string
local KeymapConfig = {
  quit = "q",
  next_table = "<C-l>",
  prev_table = "<C-h>",
}

---@class Config
---@field columnColorEnable boolean
---@field maxLineEachTable number
---@field columnColorRoulette string[]
---@field autoDisplayWhenOpenFile boolean
---@field skipSqlite boolean
---@field view ViewConfig
local DefaultConfig = {
  autoDisplayWhenOpenFile = false,
  skipSqlite = false,
  maxLineEachTable = 100,
  columnColorEnable = true,
  columnColorRoulette = { "DataViewerColumn0", "DataViewerColumn1", "DataViewerColumn2" },
  view = ViewConfig,
  keymap = KeymapConfig,
}

---@class ConfidModule
local M = {}

M.config = DefaultConfig

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

return M
