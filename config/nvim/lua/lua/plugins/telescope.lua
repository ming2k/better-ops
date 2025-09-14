local telescope = require("telescope")
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

-- Setup telescope with fixed layout configuration
telescope.setup {
  vimgrep_arguments = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case'
  },
  defaults = {
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    winblend = 0,
    
    -- Make results more readable
    entry_prefix = "  ",
    selection_caret = "  ",

    -- Fixed layout settings
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.95,
      height = 0.95,
      preview_width = 0.64,
      preview_cutoff = 80,
      prompt_position = "bottom",
    },
    -- Truncate long lines in the results to prevent overflow
    path_display = {
      "truncate" -- Truncate paths that are too long
    },
    -- Show title at the top of preview
    preview = {
      title = true,
    },
    dynamic_preview_title = true,
  },
  pickers = {
    find_files = {
      -- Using the default layout from above
    },
    live_grep = {
      -- Using the default layout from above
    },
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-c>"] = actions.close,
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-c>"] = actions.close,
          ["dd"] = actions.delete_buffer,
        }
      }
    }
  }
}

-- File search with common exclusions
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    hidden = true,
    file_ignore_patterns = {
      "^.git/",
      "^node_modules/",
      "^dist/"
    }
  })
end, { desc = 'Telescope find files with exclusions' })

-- File search with no exclusions (find all files)
vim.keymap.set('n', '<leader>fF', function()
  builtin.find_files({
    hidden = true,
    no_ignore = true,  -- Include files that are typically ignored
  })
end, { desc = 'Telescope find all files' })

-- Text search (grep) with common exclusions
vim.keymap.set('n', '<leader>fg', function()
  builtin.live_grep({
    additional_args = function()
      return {
        "--glob", "!**/.git/**",
        "--glob", "!**/node_modules/**",
        "--glob", "!**/dist/**"
      }
    end
  })
end, { desc = 'Telescope live grep with exclusions' })

-- Text search (grep) with no exclusions (search all files)
vim.keymap.set('n', '<leader>fG', function()
  builtin.live_grep({
    no_ignore = true,
    hidden = true
  })
end, { desc = 'Telescope live grep (all files)' })

-- Buffer management
vim.keymap.set('n', '<leader>fb', function()
  builtin.buffers()
end, { desc = 'Telescope buffers' })

