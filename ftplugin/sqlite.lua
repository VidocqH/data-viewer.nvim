if vim.b.did_data_viewer_ftplugin == 1 then
  return
end

local config = require("data-viewer.config")

if not config.config.skipSqlite then
  vim.schedule(function () require("data-viewer").start({ args = "", force_replace = true }) end)
end
