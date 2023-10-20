local parsers = require("data-viewer.parser.parsers")
local utils = require("data-viewer.utils")
local config = require("data-viewer.config")

local KEYMAP_OPTS = { noremap = true, silent = true }

---@class CustomModule
local M = {}

---@param filetype string
---@return string | "'unsupport'"
M.is_support_filetype = function(filetype)
  for parserName, _ in pairs(parsers) do
    if parserName == filetype then
      return filetype
    end
  end
  return "unsupport"
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

---@param tablesData table<string, any>
---@return string, table<string, string | number>[]
M.get_win_header_str = function(tablesData)
  local pos = {}
  local header = "|"
  local index = 1
  for tableName, _ in pairs(tablesData) do
    table.insert(pos, { name = tableName, startPos = #header + 1 })
    header = header .. " " .. tableName .. " |"
    index = index + 1
  end
  return header, pos
end

---@param tablesData table<string, any>
---@return number, table<string, any>
M.create_bufs = function(tablesData)
  local first_bufnum = -1
  for tableName, tableData in pairs(tablesData) do
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, tableData.formatedLines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_name(buf, "DataViwer-" .. tableName)
    vim.api.nvim_buf_set_keymap(buf, "n", config.config.keymap.next_table, ":DataViewerNextTable<CR>", KEYMAP_OPTS)
    vim.api.nvim_buf_set_keymap(buf, "n", config.config.keymap.prev_table, ":DataViewerPrevTable<CR>", KEYMAP_OPTS)
    vim.api.nvim_buf_set_keymap(buf, "n", config.config.keymap.quit, ":DataViewerClose<CR>", KEYMAP_OPTS)
    tablesData[tableName]["bufnum"] = buf
    if first_bufnum == -1 then
      first_bufnum = buf
    end
  end
  return first_bufnum, tablesData
end

---@param buf_id number
---@return number
M.open_win = function(buf_id)
  if not config.config.view.float then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_buf_set_option(buf_id, "buflisted", true)
    vim.api.nvim_set_current_buf(buf_id)
    return win
  end

  local win = vim.api.nvim_open_win(buf_id, true, {
    relative = "win",
    width = config.config.view.width,
    height = config.config.view.height,
    row = math.max(1, math.floor((vim.opt.lines:get() - config.config.view.height) / 2)),
    col = math.max(1, math.floor((vim.opt.columns:get() - config.config.view.width) / 2)),
    style = "minimal",
    zindex = config.config.view.zindex,
    title = "Data Viewer",
    title_pos = "center",
    border = "single",
  })

  -- Set the window options
  vim.api.nvim_win_set_option(win, "wrap", false)
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "cursorline", false)
  return win
end

---@param bufnum number
---@param headers string[]
---@param colMaxWidth table<string, number>
M.highlight_header = function(bufnum, headers, colMaxWidth)
  local curPos = 1
  for j, colName in ipairs(headers) do
    local hlStart = curPos
    local hlEnd = hlStart + string.len(colName) + colMaxWidth[colName] - utils.getStringDisplayLength(colName)

    vim.api.nvim_buf_add_highlight(
      bufnum,
      0,
      config.config.columnColorRoulette[(j % #config.config.columnColorRoulette) + 1],
      2,
      hlStart,
      hlEnd
    )
    curPos = hlEnd + 1
  end
end

---@param bufnum number
---@param headers string[]
---@param bodyLines table<string, string>[]
---@param colMaxWidth table<string, number>
M.highlight_rows = function(bufnum, headers, bodyLines, colMaxWidth)
  for i = 1, #bodyLines do
    local curPos = 1
    for j, colName in ipairs(headers) do
      local curCellText = bodyLines[i][colName]
      local hlStart = curPos
      local hlEnd = hlStart + string.len(curCellText) + colMaxWidth[colName] - utils.getStringDisplayLength(curCellText)

      vim.api.nvim_buf_add_highlight(
        bufnum,
        0,
        config.config.columnColorRoulette[(j % #config.config.columnColorRoulette) + 1],
        i + 3,
        hlStart,
        hlEnd
      )
      curPos = hlEnd + 1
    end
  end
end

---@param bufnum number
---@param info table<string, string | number>
M.highlight_tables_header = function(bufnum, info)
  vim.api.nvim_buf_add_highlight(bufnum, 0, "DataViewerFocusTable", 0, info.startPos, info.startPos + #info.name)
end

---@param args string
---@return string | number | nil, string | nil
M.get_file_source_from_args = function(args)
  if args == "" then
    local filepath = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(filepath, "filetype")
    return filepath, ft
  else
    local tbl = utils.split_string(args, " ")
    if #tbl ~= 2 then
      return nil, nil
    end
    local filepath = tbl[1]
    local ft = string.lower(tbl[2])
    return filepath, ft
  end
end

---@param win_id number
---@param old_buf number
---@param new_buf number
M.switch_buffer = function(win_id, old_buf, new_buf)
  if not config.config.view.float then
    vim.api.nvim_buf_set_option(old_buf, "buflisted", false)
    vim.api.nvim_buf_set_option(new_buf, "buflisted", true)
  end
  vim.api.nvim_win_set_buf(win_id, new_buf)
end

return M
