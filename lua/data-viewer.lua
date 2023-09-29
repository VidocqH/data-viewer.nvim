-- main module file
local module = require("data-viewer.module")
local parsers = require('data-viewer.parser.parsers')
local config = require('data-viewer.config')

---@class DataViewer
local M = {}

M.setup = function(args)
  config.setup(args) -- setup config
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
