local module = require("data-viewer.module")
local parsers = require("data-viewer.parser.parsers")
local config = require("data-viewer.config")

---@class StartOptions
---@field silent? boolean
local StartOptions = {
  silent = false,
}

---@class DataViewer
local M = {}

M.setup = function(args)
  config.setup(args) -- setup config

  if config.config.autoDisplayWhenOpenFile then
    vim.api.nvim_create_augroup("DataViewer", { clear = true })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = "DataViewer",
      callback = function()
        require("data-viewer").start({ silent = true })
      end,
    })
  end
end

---@param opts? StartOptions
M.start = function(opts)
  local cur_buffer = vim.api.nvim_get_current_buf()

  local ft = module.is_support_filetype(cur_buffer)
  if ft == "unsupport" then
    if opts and not opts.silent then
      print("Filetype unsupported")
    end
    return
  end

  local lines = module.read_file(cur_buffer)
  local parsedData = parsers[ft](lines)
  local colMaxWidth = module.get_max_width(parsedData.headers, parsedData.bodyLines)
  local formatedLines = module.format_lines(parsedData.headers, parsedData.bodyLines, colMaxWidth)
  module.open_win(formatedLines)
  if config.config.columnColorEnable then
    module.highlight_header(parsedData.headers, colMaxWidth)
    module.highlight_rows(parsedData.headers, parsedData.bodyLines, colMaxWidth)
  end
end

return M
