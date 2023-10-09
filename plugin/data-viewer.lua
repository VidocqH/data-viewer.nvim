vim.api.nvim_create_user_command("DataViewer", require("data-viewer").start, {})

vim.api.nvim_set_hl(0, "DataViewerColumn0", { fg = "#bb0000" })
vim.api.nvim_set_hl(0, "DataViewerColumn1", { fg = "#00bb00" })
vim.api.nvim_set_hl(0, "DataViewerColumn2", { fg = "#0000bb" })
