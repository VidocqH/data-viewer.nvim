local status, sqlite = pcall(require, "sqlite")

local get_all_table_names = function(db)
  local query = db:eval("SELECT name FROM sqlite_schema WHERE type='table' ORDER BY rootpage ASC")
  local db_table_names = {}
  for _, db_table in ipairs(query) do
    if db_table and db_table["name"] then
      table.insert(db_table_names, db_table["name"])
    end
  end
  return db_table_names
end

local get_table_column_names = function(db, table_name)
  local table_columns = {}
  local query = db:eval("SELECT name FROM PRAGMA_TABLE_INFO('" .. table_name .. "')")
  for _, col in ipairs(query) do
    table.insert(table_columns, col["name"])
  end
  return table_columns
end

local get_table_data = function(db, table_name)
  local query = db:select(table_name)
  return query
end

---@param filepath string
local parse = function(filepath)
  if not status then
    return "SQL dependency not installed"
  end

  local tables_data = sqlite.with_open(filepath, function(db)
    local tables_data = {}
    local db_tables_names = get_all_table_names(db)
    for _, table_name in ipairs(db_tables_names) do
      tables_data[table_name] = {}
      tables_data[table_name]["bodyLines"] = get_table_data(db, table_name)
      tables_data[table_name]["headers"] = get_table_column_names(db, table_name)
    end
    return tables_data
  end)

  return tables_data
end

return parse
