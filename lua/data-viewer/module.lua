local parsers = require("data-viewer.parser.parsers")
local utils = require("data-viewer.utils")
local config = require("data-viewer.config")

---@class CustomModule
local M = {}

---@param cur_buffer number
---@return string | "'unsupport'"
M.is_support_filetype = function(cur_buffer)
  local ft = vim.api.nvim_buf_get_option(cur_buffer, "filetype")
  for parserName, _ in pairs(parsers) do
    if parserName == ft then
      return ft
    end
  end
  return "unsupport"
end

---@param cur_buffer number
---@return string[]
M.read_file = function(cur_buffer)
  local lines = vim.api.nvim_buf_get_lines(cur_buffer, 0, -1, false)
  return lines
end

---@param header string[]
---@param lines table<string, string>[]
---@return table<string, number>
M.get_max_width = function(header, lines)
  local colMaxWidth = {}
  for _, colName in ipairs(header) do
    colMaxWidth[colName] = utils.getStringDisplayLength(colName)
  end

  for _, line in ipairs(lines) do
    for _, colName in ipairs(header) do
      colMaxWidth[colName] = math.max(utils.getStringDisplayLength(line[colName]), colMaxWidth[colName])
    end
  end

  return colMaxWidth
end

---@param header string[]
---@param colMaxWidth table<string, number>
---@return string[]
M.format_header = function(header, colMaxWidth)
  local formatedHeader = ""
  for _, colName in ipairs(header) do
    local spaceNum = colMaxWidth[colName] - utils.getStringDisplayLength(colName)
    local spaceStr = string.rep(" ", math.floor(spaceNum / 2))
    formatedHeader = formatedHeader .. "|" .. spaceStr .. colName .. spaceStr .. string.rep(" ", spaceNum % 2)
  end
  formatedHeader = formatedHeader .. "|"

  local tableBorder = string.rep("─", utils.getStringDisplayLength(formatedHeader) - 2)
  local firstLine = "┌" .. tableBorder .. "┐"
  local lastLine = "├" .. tableBorder .. "┤"
  return { firstLine, formatedHeader, lastLine }
end

---@param bodyLines table<string, string>[]
---@param header string[]
---@param colMaxWidth table<string, number>
---@return string[]
M.format_body = function(bodyLines, header, colMaxWidth)
  local formatedLines = {}
  for _, line in ipairs(bodyLines) do
    local formatedLine = ""
    for _, colName in ipairs(header) do
      local spaceNum = colMaxWidth[colName] - (utils.getStringDisplayLength(line[colName]))
      local spaceStr = string.rep(" ", spaceNum)
      formatedLine = formatedLine .. "|" .. line[colName] .. spaceStr
    end
    formatedLine = formatedLine .. "|"
    table.insert(formatedLines, formatedLine)
  end

  table.insert(formatedLines, "└" .. string.rep("─", utils.getStringDisplayLength(formatedLines[1]) - 2) .. "┘")
  return formatedLines
end

---@param header string[]
---@param lines table<string, string>[]
---@param colMaxWidth table<string, number>
M.format_lines = function(header, lines, colMaxWidth)
  local formatedHeader = M.format_header(header, colMaxWidth)
  local formatedBody = M.format_body(lines, header, colMaxWidth)
  return utils.merge_array(formatedHeader, formatedBody)
end

---@param lines string[]
M.open_win = function(lines)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set the buffer options
  vim.api.nvim_buf_set_option(buf, "bufhidden", "delete")
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Open the buffer in a new window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "win",
    width = config.config.view.width,
    height = config.config.view.height,
    row = math.max(1, math.floor((vim.opt.lines:get() - config.config.view.height) / 2)),
    col = math.max(1, math.floor((vim.opt.columns:get() - config.config.view.width) / 2)),
    style = "minimal",
    zindex = config.config.view.zindex,
    -- title = 'Data Viewer',
    -- title_pos = 'center'
    -- border = 'single',
  })

  -- Set the window options
  vim.api.nvim_win_set_option(win, "wrap", false)
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "cursorline", false)
end

---@param headers string[]
---@param colMaxWidth table<string, number>
M.highlight_header = function(headers, colMaxWidth)
  local curPos = 1
  for j, colName in ipairs(headers) do
    local hlStart = curPos
    local hlEnd = hlStart + string.len(colName) + colMaxWidth[colName] - utils.getStringDisplayLength(colName)

    vim.api.nvim_buf_add_highlight(
      0,
      0,
      config.config.columnColorRoulette[(j % #config.config.columnColorRoulette) + 1],
      1,
      hlStart,
      hlEnd
    )
    curPos = hlEnd + 1
  end
end

---@param headers string[]
---@param bodyLines table<string, string>[]
---@param colMaxWidth table<string, number>
M.highlight_rows = function(headers, bodyLines, colMaxWidth)
  for i = 1, #bodyLines do
    local curPos = 1
    for j, colName in ipairs(headers) do
      local curCellText = bodyLines[i][colName]
      local hlStart = curPos
      local hlEnd = hlStart + string.len(curCellText) + colMaxWidth[colName] - utils.getStringDisplayLength(curCellText)

      vim.api.nvim_buf_add_highlight(
        0,
        0,
        config.config.columnColorRoulette[(j % #config.config.columnColorRoulette) + 1],
        i + 2,
        hlStart,
        hlEnd
      )
      curPos = hlEnd + 1
    end
  end
end

return M
