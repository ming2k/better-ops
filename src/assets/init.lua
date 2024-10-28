vim.opt.encoding = "utf-8"

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
-- vim.g.maplocalleader = "\\"

-- set table
vim.opt.tabstop = 4
vim.opt.expandtab = false
vim.opt.softtabstop = 4
vim.opt.smarttab = true

vim.opt.colorcolumn = "80"

-- Enable LSP flod
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Set the time in milliseconds to wait before triggering the CursorHold event
vim.opt.updatetime = 200

-- diagnostic
-- vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Whether wrap text when text exceeds screen width
vim.opt.wrap = false

-- list-mode: Display invisible characters in a preset style
-- vim.opt.list = true
-- vim.opt.listchars = { eol = "󰌑", tab = "-->", trail = "·" }

-- how command
vim.opt.showcmd = true
vim.opt.cmdheight = 1

-- 行号设置
vim.opt.number = true
vim.opt.relativenumber = true

-- config status bar
-- vim.opt.laststatus = 2
-- vim.opt.statusline = "%<%F %m%=%l:%c 0x%B"

-- enable mouse
vim.opt.mouse = "a"

-- 设置隐藏缓冲区
vim.opt.hidden = true

-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 1000

-- Optional: Display line diagnostics automatically in hover window
vim.cmd([[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
vim.diagnostic.config({
  virtual_text = false,
})
vim.lsp.set_log_level("debug")

-- cmp behavior
vim.o.completeopt = "menuone,noselect"
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"

-- remember fold
vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  command = "mkview",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  command = "silent! loadview",
})

-- remember the cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = {"*"},
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
})


