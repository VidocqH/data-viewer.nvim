local plenaryStrings = require("plenary.strings")

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
  if type(file) == "number" then
    -- buf_number
    local lines = vim.api.nvim_buf_get_lines(file, 0, -1, false)
    return lines
  elseif type(file) == "string" then
    -- file path
    local lines = vim.fn.readfile(file)
    return lines
  else
    return {}
  end
end

M.check_win_valid = function(win_id)
  if vim.api.nvim_win_is_valid(win_id) and vim.api.nvim_get_current_win() == win_id then
    return true
  else
    return false
  end
end

return M
