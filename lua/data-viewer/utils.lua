local plenaryStrings = require("plenary.strings")
local config = require("data-viewer.config")

---@class Utils
local M = {}

---@param array1 any[]
---@param array2 any[]
---@return any[]
M.merge_array = function(array1, array2)
  local ret_array = {}
  for _, val in ipairs(array1) do
    table.insert(ret_array, val)
  end
  for _, val in ipairs(array2) do
    table.insert(ret_array, val)
  end
  return ret_array
end

---@generic T
---@param array T[]
---@param num number
---@return T[]
M.slice_array = function(array, num)
  if num <= 0 then
    return array
  end

  local ret = {}
  for i, val in ipairs(array) do
    if i <= num then
      table.insert(ret, val)
    end
  end
  return ret
end

---@param str string
---@return number
M.getStringDisplayLength = function(str)
  return plenaryStrings.strdisplaywidth(str)
end

---@param str string
---@param sep string
---@return string[]
M.split_string = function(str, sep)
  local ret = {}
  local pattern = "[^" .. sep .. "]+"

  for segment in string.gmatch(str, pattern) do
    table.insert(ret, segment)
  end
  return ret
end

---@param file string | number
---@return string[]
M.read_file = function(file)
  local maxLines = config.config.maxLineEachTable
  if type(file) == "number" then
    -- buf_number
    local lines = vim.api.nvim_buf_get_lines(file, 0, -1, false)
    return M.slice_array(lines, maxLines)
  elseif type(file) == "string" then
    -- file path
    local lines = vim.fn.readfile(file)
    return M.slice_array(lines, maxLines)
  else
    return {}
  end
end

---@param win_id number
---@return boolean
M.check_win_valid = function(win_id)
  if vim.api.nvim_win_is_valid(win_id) and vim.api.nvim_get_current_win() == win_id then
    return true
  else
    return false
  end
end

return M
