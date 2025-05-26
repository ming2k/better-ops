-- ~/config/nvim/lua/utils/autofold_frontmatter.lua (Recommended location)
--
-- Automatically folds YAML/TOML/Markdown front matter in Neovim and provides custom fold text.
-- Uses 'foldmethod=expr' with custom Lua functions for 'foldexpr' and 'foldtext'.
-- Folds are applied per-window and automatically closed on entering the buffer/window.
--
-- Load this module in your init.lua using:
-- require('utils.autofold_frontmatter')

-- Define a module table (good practice for organization)
local M = {}

--- Finds the line number where the front matter section ends.
-- Front matter is defined as starting on line 1 with '---' or '+++',
-- and ending with the *next* occurrence of the same delimiter.
-- @param bufnr (number) The buffer number to check.
-- @return (number | nil) The 1-based line number of the closing delimiter, or nil if not found or invalid.
local function find_frontmatter_end(bufnr)
  -- Basic validation: Ensure buffer is valid and has at least 2 lines
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_buf_line_count(bufnr) < 2 then
    return nil
  end

  -- Fetch the first two lines efficiently.
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 2, false)
  local line1 = lines[1]
  if not line1 then
    return nil
  end

  local delimiter = nil
  -- Determine the delimiter based on the first line.
  if line1 == "---" then
    delimiter = "---"
  elseif line1 == "+++" then
    delimiter = "+++"
  else
    return nil -- Line 1 is not a recognized delimiter.
  end

  -- Optimization: Check if the second line is the closing delimiter.
  if lines[2] and lines[2] == delimiter then
    return 2
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  -- Search for the closing delimiter starting from line 3.
  -- Limit the search range for performance.
  local search_limit = math.min(line_count, 50) -- Check up to 50 lines or file end.
  for lnum = 3, search_limit do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
    if line_content[1] and line_content[1] == delimiter then
      return lnum -- Found the closing delimiter
    end
  end

  -- Closing delimiter was not found within the search limit.
  return nil
end


-- Global Function for 'foldexpr':
-- Must be global if called via 'v:lua.FunctionName'.
--- The core function evaluated by Neovim's 'foldexpr' setting to determine fold levels.
-- @return (string) Fold level indicator: ">1", "1", "0".
_G.MyNeovimFrontMatterFoldExpr = function()
  local lnum = vim.v.lnum -- Current line number (1-based)

  -- Use buffer-local cache (`vim.b`) for efficiency.
  if vim.b.my_frontmatter_fold_end_lnum == nil then
    vim.b.my_frontmatter_fold_end_lnum = find_frontmatter_end(0) or -1
  end
  local end_lnum = vim.b.my_frontmatter_fold_end_lnum

  if end_lnum == -1 then
    return "0" -- Base level if no front matter
  end

  -- Determine fold level based on line number relative to front matter block.
  if lnum >= 1 and lnum <= end_lnum then
    if lnum == 1 then
      return ">1" -- Start level 1 fold
    else
      return "1" -- Continue level 1 fold
    end
  else
    return "0" -- Outside front matter, base level 0
  end
end


-- Global Function for 'foldtext':
-- Must be global if called via 'v:lua.FunctionName'.
--- Generates the text displayed for a closed fold.
-- Checks if the fold is the front matter fold (starts at line 1)
-- and returns custom text, otherwise returns default fold text.
-- @return (string) The text to display for the closed fold.
_G.MyNeovimFrontMatterFoldText = function()
  -- v:foldstart and v:foldend are 1-based line numbers of the fold range.
  local start_line = vim.v.foldstart
  local end_line = vim.v.foldend
  -- v:folddashes contains the visual prefix like '+--'
  local dashes = vim.v.folddashes

  -- Check if the fold being processed starts exactly at line 1.
  -- This identifies our front matter fold.
  if start_line == 1 then
    local line_count = end_line - start_line + 1
    -- Return custom text including the standard fold dashes prefix.
    return string.format("%s Front Matter (%d lines)", dashes, line_count)
  else
    -- For any other fold, fall back to Neovim's default foldtext function.
    return vim.fn.foldtext()
  end
end


--- Sets up the necessary window-local options for front matter folding.
-- Called by the autocommand on BufWinEnter.
local function setup_frontmatter_folding()
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()

  -- Clear the buffer-local cache on each setup call.
  -- Use vim.b[bufnr] to ensure it's buffer-local, not global `vim.b`.
  vim.b[bufnr].my_frontmatter_fold_end_lnum = nil

  -- Check if front matter exists for this buffer.
  local end_lnum = find_frontmatter_end(bufnr)

  -- Only apply settings if valid front matter was found.
  if end_lnum and end_lnum > 1 then
    -- Set window-local options for folding.
    vim.wo[winid].foldmethod = 'expr'
    vim.wo[winid].foldexpr = 'v:lua.MyNeovimFrontMatterFoldExpr()'
    vim.wo[winid].foldenable = true
    vim.wo[winid].foldlevel = 99 -- Keep existing folds open initially.
    -- Set the custom fold text function.
    vim.wo[winid].foldtext = 'v:lua.MyNeovimFrontMatterFoldText()'
    -- vim.wo[winid].foldcolumn = '1' -- Optional: Show fold indicator column

    -- Schedule closing the front matter fold.
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(winid)
          and vim.api.nvim_buf_is_valid(bufnr)
          and vim.wo[winid].foldmethod == 'expr' then -- Check if still using our method
        -- Execute in the correct window context.
        vim.api.nvim_win_call(winid, function()
          -- Check if line 1 actually has a fold before closing.
          if vim.fn.foldlevel(1) > 0 then
            vim.cmd('1foldclose') -- Close fold at line 1.
          end
        end)
      end
    end)
  else
    -- No valid front matter found.
    -- Ensure folding is enabled for other potential methods (manual, syntax).
    vim.wo[winid].foldenable = true
    -- Reset foldtext to default if it was set to our custom function.
    if vim.wo[winid].foldtext == 'v:lua.MyNeovimFrontMatterFoldText()' then
      vim.wo[winid].foldtext = '' -- Resetting to empty restores default.
    end
    -- Optionally reset foldmethod/foldexpr if desired, otherwise leave them
    -- (another plugin/setting might use 'expr' or another method).
  end
end


-- Autocommand Setup:
-- Create a dedicated autocommand group to prevent duplicates on reload.
local group = vim.api.nvim_create_augroup("AutoFoldFrontMatterGroup", { clear = true })

-- Define the autocommand trigger.
-- "BufWinEnter" fires when entering a window displaying a buffer matching the pattern.
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = group,
  -- Apply only to specified file patterns.
  pattern = {
    "*.md",
    "*.markdown",
    "*.yaml",
    "*.yml",
    "*.toml",
    "*.qmd", -- Quarto Markdown
    -- Add more file patterns as needed
  },
  desc = "Automatically fold front matter and set custom fold text",
  -- Call our setup function.
  callback = setup_frontmatter_folding,
})


-- Return the module table (standard Lua module practice).
return M
