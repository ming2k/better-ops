vim.opt.foldenable = true
vim.opt.foldmethod = 'expr'
-- Enable folding using Treesitter expression
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' 

-- NOTE: The evaluation timing of `foldlevel` is determined by `foldmethod`
-- ref: 
-- - https://neovim.io/doc/user/fold.html
-- - https://neovim.io/doc/user/usr_28.html#usr_28.txt

vim.opt.foldlevelstart = 99  -- Start with folds open when loading a file (initial level)
-- vim.opt.foldlevel = 99

-- NOTE: `foldlevelstart` vs `foldlevel`:
-- `vim.opt.foldlevelstart`: Global, sets initial `foldlevel` for new buffers on load. Applies once, e.g., `0` closes all folds.
-- `vim.opt.foldlevel`: Global or buffer-local, controls current buffer's fold level, changeable anytime, e.g., `1` opens level-1 folds.
-- Relation: `foldlevelstart` initializes `foldlevel`; after loading, `foldlevel` can be adjusted independently. Both depend on `foldmethod`.

-- vim.opt.foldcolumn = "4" 
vim.opt.foldcolumn = 'auto:1'

-- Automatically save fold states when leaving a buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    if vim.fn.expand('%') ~= '' and not vim.fn.expand('%:p'):match('^/tmp') then
      pcall(vim.cmd, 'mkview')
    end
  end
})

-- Automatically load fold states when entering a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.expand('%') ~= '' and not vim.fn.expand('%:p'):match('^/tmp') then
      pcall(vim.cmd, 'silent! loadview')
    end
  end
})

