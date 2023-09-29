-- main module file
local module = require("data-viewer.module")
local parsers = require('data-viewer.parser.parsers')

---@class ViewConfig
---@field width number
---@field height number
---@field zIndex number
local viewConfig = {
  width = 0.8,
  height = 0.8,
  zindex = 50,
}

---@class Config
---@field view ViewConfig
local config = {
  columnColors = { "yellow", "green", "cyan", "blue", "purple", "orange", "red" },
  view = viewConfig,
}

---@class DataViewer
local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
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

M.start = function()
  -- module.start_process()
  local cur_buffer = vim.api.nvim_get_current_buf()

  local ft = module.is_support_filetype(cur_buffer)
  if ft == 'unsupport' then
    print("Filetype unsupported")
    return
  end

  local lines = module.read_file(cur_buffer)
  local parsedData = parsers[ft](lines)
  local formatedLines = module.format_lines(parsedData.headers, parsedData.bodyLines)
  module.open_win(formatedLines, M.config.view)
end

return M
