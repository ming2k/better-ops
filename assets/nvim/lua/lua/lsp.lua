-- if true then
--   return {}
-- end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- LSP list: https://mason-registry.dev/registry/list

vim.lsp.enable('lua_ls')

vim.lsp.config('lua_ls', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
    }
  },
})

vim.lsp.enable('rust_analyzer')

vim.lsp.enable('eslint')
-- https://github.com/typescript-language-server/typescript-language-server
vim.lsp.enable('tl_ls')
vim.lsp.config('ts_ls', {
  init_options = {},
  filetypes = {
    "javascript",
    "typescript",
  },
})

