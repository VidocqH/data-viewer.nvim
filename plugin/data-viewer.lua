local config = require('data-viewer.config').config

vim.api.nvim_create_user_command("DataViewer", require("data-viewer").start, {})

if (config.autoDisplayWhenOpenFile) then
  vim.api.nvim_create_augroup("DataViewer", { clear = true })
  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead" }, {
    group = "DataViewer",
    callback = function ()
      require("data-viewer").start({ silent = true })
    end
  })
end

vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#bb0000" })
vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#00bb00" })
vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#0000bb" })

