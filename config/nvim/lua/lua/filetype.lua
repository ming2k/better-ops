-- Config behavior by filetypes

-- Assign types for unrecognized file types
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {
    -- Gentoo Portage Conf
    -- ---
    "/etc/portage/package.use",
    "/etc/portage/package.mask",
    "/etc/portage/package.unmask",
    "/etc/portage/package.accept_keywords",
    "/etc/portage/package.license",
    "/etc/portage/package.env",
    "/etc/portage/package.use/*",
    "/etc/portage/package.mask/*",
    "/etc/portage/package.unmask/*",
    "/etc/portage/package.accept_keywords/*",
    "/etc/portage/package.license/*",
    "/etc/portage/package.env/*",
    -- Dae
    -- ---
    "/etc/dae/config.dae"
  },
  callback = function()
    vim.bo.filetype = "conf"
  end
})

vim.filetype.add({
  pattern = {
    ['.md'] = 'markdown',
    ['README'] = 'markdown',
  },
})
