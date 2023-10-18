---@class ViewConfig
---@field width number
---@field height number
---@field zindex number
local ViewConfig = {
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
---@field view ViewConfig
local DefaultConfig = {
  autoDisplayWhenOpenFile = false,
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

  -- compute ratio popup size
  local screenHeight = vim.opt.lines:get()
  local screenWidth = vim.opt.columns:get()
  if M.config.view.height < 1 then
    M.config.view.height = math.max(1, math.floor(screenHeight * M.config.view.height))
  end
  if M.config.view.width < 1 then
    M.config.view.width = math.max(1, math.floor(screenWidth * M.config.view.width))
  end
end

return M
