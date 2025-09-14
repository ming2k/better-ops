require("plugins.luasnip")
require("plugins.nvim-cmp")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.nvim-colorizer")

-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = {"*.md", "*.markdown"},
--   callback = function()
--     vim.cmd("packadd render-markdown.nvim")
--     vim.cmd("packadd nvim-web-devicons")
--     vim.cmd("packadd mini.nvim")
--     require("plugins.render-markdown-nvim")
--   end,
-- })

