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
  ---@type string | number
  local filepath = 0
  ---@type string
  local ft = ""

  if opts == nil or opts.args == nil then
    vim.print("Invalid Source")
    return
  end

  if opts.args == "" then
    filepath = vim.api.nvim_get_current_buf()
    ft = vim.api.nvim_buf_get_option(filepath, "filetype")
  else
    local tbl = utils.split_string(opts.args, " ")
    if #tbl > 2 then
      vim.print("Usage: DataViewer [filepath] [filetype]")
      return
    end
    filepath = tbl[1]
    ft = tbl[2]
  end

  ft = module.is_support_filetype(ft)
  if ft == "unsupport" then
    if not opts.silent then
      vim.print("Filetype unsupported")
    end
    return
  end

  local lines = utils.read_file(filepath)
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
