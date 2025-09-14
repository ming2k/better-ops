-- Place this code in your init.lua (or a Lua file required by your init.lua)

-- 1. Store a reference to the original vim.ui.open function
local original_vim_ui_open = vim.ui.open

-- 2. Redefine vim.ui.open with our wrapper function
vim.ui.open = function(url_or_path, opts)
  -- `opts` is an optional table for future compatibility or specific backends,
  -- though not heavily used by the default `xdg-open` backend for `vim.ui.open`.
  -- It's good practice to pass it along.

  -- Call the original vim.ui.open in a "protected call" (pcall).
  -- pcall runs the function and catches any errors without stopping execution.
  -- It returns:
  --   - `true` and the function's actual return values if successful.
  --   - `false` and the error object/message if an error occurred.
  local success, result_or_error = pcall(original_vim_ui_open, url_or_path, opts)

  if not success then
    -- An error occurred. `result_or_error` contains the error message or object.
    local error_message = tostring(result_or_error)

    -- Check if it's the specific "command timeout (124)" error.
    -- The error you saw was: "vim.ui.open: command timeout (124): { "xdg-open", "file:///home/ming/Pictures/zodiac-wheel.png" }"
    -- We need to match the core part: "command timeout (124)"
    -- The parentheses in the pattern need to be escaped with %
    if string.match(error_message, "command timeout %(124%)") then
      -- This is the specific timeout error we want to suppress.
      -- So, we do nothing here, effectively silencing it.
      -- You could optionally log it to a file or a less intrusive notification for debugging:
      -- print("Suppressed vim.ui.open timeout for: " .. tostring(url_or_path))
    else
      -- It's a different error that we don't want to suppress.
      -- We should display it as Neovim normally would.
      vim.notify(error_message, vim.log.levels.ERROR, { title = "vim.ui.open Error" })
    end
  end
  -- If `success` was true, `result_or_error` would contain any return values from
  -- the original `vim.ui.open`. The documentation for `vim.ui.open` doesn't
  -- specify return values on success, so we don't need to do anything with them here.
end

-- vim.notify("Custom vim.ui.open wrapper loaded to suppress timeout (124).", vim.log.levels.INFO)
