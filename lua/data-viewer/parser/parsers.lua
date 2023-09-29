-- Return a table { headers = headers, bodyLines = bodyLines }
-- headers: string[]                  -- Contains all column names by display order
-- bodyLines: table<string, string>[] -- Array of tables, each table represents a line by type {[columnName]: value}

---@class Parsers
local M = {
  csv = require('data-viewer.parser.csv'),
  tsv = require('data-viewer.parser.tsv'),
}

return M
