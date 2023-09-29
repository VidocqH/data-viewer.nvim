local plenaryStrings = require('plenary.strings')

---@class Utils
local M = {}

---@param inputStr string
---@param delimiter string
---@return string[]
M.split_string = function (inputStr, delimiter)
  local strings = {}
  for str in inputStr:gmatch("(.-)" .. delimiter) do
    table.insert(strings, str)
  end
  table.insert(strings, inputStr:match(".+" .. delimiter .. "(.*)$"))
  return strings
end

---@param array1 any[]
---@param array2 any[]
---@return any[]
M.merge_array = function (array1, array2)
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
M.getStringDisplayLength = function (str)
  return plenaryStrings.strdisplaywidth(str)
end

return M
