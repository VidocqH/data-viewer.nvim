local module = require("data-viewer.module")
local parsers = require("data-viewer.parser.parsers")
local config = require("data-viewer.config")
local utils = require("data-viewer.utils")

---@class StartOptions
---@field silent? boolean
---@field args string
local StartOptions = {
  silent = false,
  args = "",
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
        require("data-viewer").start({ silent = true, args = "" })
      end,
    })
  end
end

---@param opts? StartOptions
M.start = function(opts)
  if opts == nil or opts.args == nil then
    vim.print("Invalid Source")
    return
  end

  local filepath, ft = module.get_file_source_from_args(opts.args)
  if filepath == nil or ft == nil then
    vim.print("Usage: DataViewer [filepath] [filetype]")
    return
  end

  ft = module.is_support_filetype(ft)
  if ft == "unsupport" then
    if not opts.silent then
      vim.print("Filetype unsupported")
    end
    return
  end

  local parsedData = parsers[ft](filepath)
  local colMaxWidth = module.get_max_width(parsedData.headers, parsedData.bodyLines)
  local formatedLines = module.format_lines(parsedData.headers, parsedData.bodyLines, colMaxWidth)
  module.open_win(formatedLines)
  if config.config.columnColorEnable then
    module.highlight_header(parsedData.headers, colMaxWidth)
    module.highlight_rows(parsedData.headers, parsedData.bodyLines, colMaxWidth)
  end
end

return M
