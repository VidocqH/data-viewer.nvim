local utils = require("data-viewer.utils")

---@param line string
---@return string[]
local function parseLine(line)
  local words = {}
  local quoted = false
  local currentValue = ""

  for i = 1, #line do
    local char = line:sub(i, i) -- Get the current character

    if char == '"' then
      quoted = not quoted
    elseif char == '\t' and not quoted then
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
---@return string[]
local function getHeaders(headerStr)
  ---@type string[]
  return parseLine(headerStr)
end


---@param csvLines string[]
---@param headers string[]
---@return table<string, string>[]
local function getBody(csvLines, headers)
  ---@type table<string, string>[]
  local body = {}
  for _, line in ipairs(csvLines) do
    local words = parseLine(line)
    local lineObj = {}
    for idx, cell in ipairs(words) do
      lineObj[headers[idx]] = cell
    end
    table.insert(body, lineObj)
  end
  return body
end

---@param filepath string
local function parse(filepath)
  local lines = utils.read_file(filepath)
  local headers = getHeaders(lines[1])
  table.remove(lines, 1)
  local bodyLines = getBody(lines, headers)
  return { headers = headers, bodyLines = bodyLines }
end

return parse
