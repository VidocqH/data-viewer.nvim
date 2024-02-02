local utils = require("data-viewer.utils")

---@param line string
---@param delim string
---@return string[]
local function parseLine(line, delim)
  local words = {}
  local quoted = false
  local currentValue = ""

  for i = 1, #line do
    local char = line:sub(i, i) -- Get the current character

    if char == '"' then
      quoted = not quoted
    elseif char == delim and not quoted then
      table.insert(words, currentValue)
      currentValue = ""
    else
      currentValue = currentValue .. char
    end
  end
  table.insert(words, currentValue)
  return words
end

---@param headerStr string
---@param delim string
---@return string[]
local function getHeaders(headerStr, delim)
  ---@type string[]
  return parseLine(headerStr, delim)
end


---@param csvLines string[]
---@param headers string[]
---@param delim string
---@return table<string, string>[]
local function getBody(csvLines, headers, delim)
  ---@type table<string, string>[]
  local body = {}
  for _, line in ipairs(csvLines) do
    local words = parseLine(line, delim)
    local lineObj = {}
    for idx, cell in ipairs(words) do
      lineObj[headers[idx]] = cell
    end
    table.insert(body, lineObj)
  end
  return body
end


---@param fileType string
---@param delim string
local function createParse(fileType, delim)
  ---@param filepath string
  return function(filepath)
	  local lines = utils.read_file(filepath)
	  local headers = getHeaders(lines[1], delim)
	  table.remove(lines, 1)
	  local bodyLines = getBody(lines, headers, delim)
	  local out = {}
	  out[fileType] = { headers = headers, bodyLines = bodyLines }
	  return out
  end
end

return createParse
