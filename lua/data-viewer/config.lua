---@class ViewConfig
---@field width number
---@field height number
---@field zindex number
local viewConfig = {
  width = 0.8,
  height = 0.8,
  zindex = 50,
}

---@class Config
---@field view ViewConfig
local config = {
  columnColorEnable = true,
  columnColorRoulette = {"DataViewerColumn0", "DataViewerColumn1", "DataViewerColumn2"},
  view = viewConfig,
}

---@class ConfidModule
local M = {}

M.config = config

---@param args Config?
M.setup = function (args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  -- compute ratio popup size
  local screenHeight = vim.opt.lines:get()
  local screenWidth = vim.opt.columns:get()
  if (config.view.height < 1) then
    config.view.height = math.max(1, math.floor(screenHeight * config.view.height))
  end
  if (config.view.width < 1) then
    config.view.width = math.max(1, math.floor(screenWidth * config.view.width))
  end
end

return M
