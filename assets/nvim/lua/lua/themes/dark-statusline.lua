--[[
  Required nerdfont, icon Selection Priority
  Since an icon may exist in multiple categories, the fonticon selection priority is as follows:
  1. nf-dev (Developer icons)
  2. nf-cod (VS Code icons)
  3. nf-fa (Font Awesome icons)
  
  The system will select icons according to the priority order above.
--]]

-- Tokyo Night inspired dark theme colors
default_color = [[
  highlight StatusLine   guifg=#a9b1d6 guibg=#1a1b26 gui=NONE
  highlight StatusLineNC guifg=#565f89 guibg=#1a1b26 gui=NONE
]]

-- Diagnostic message colors with Tokyo Night style
diagnostic_msg_color = [[
  highlight StError     guifg=#ffffff guibg=#f7768e gui=NONE
  highlight StWarn      guifg=#1a1b26 guibg=#e0af68 gui=NONE
  highlight StHint      guifg=#1a1b26 guibg=#7dcfff gui=NONE
  highlight StInfo      guifg=#ffffff guibg=#41a6b5 gui=NONE
]]

-- Component colors with Tokyo Night style
custom_component_color = [[
  highlight StMode      guifg=#1a1b26 guibg=#bb9af7 gui=bold
  highlight StFile      guifg=#c0caf5 guibg=#24283b gui=NONE
  highlight StGit       guifg=#1a1b26 guibg=#7aa2f7 gui=NONE
]]

status_line_color = default_color .. diagnostic_msg_color .. custom_component_color


vim.cmd(status_line_color)

-- Mode configurations with icons
local modes = {
    ['n']    = ' NORMAL',    -- Normal mode
    ['v']    = ' VISUAL',    -- Visual mode
    ['V']    = ' V·LINE',
    ['i']    = ' INSERT',    -- Insert mode
    ['ic']   = ' INSERT',
    ['R']    = ' REPLACE',   -- Replace mode
    ['Rv']   = ' V·REPLACE',
    ['c']    = ' COMMAND',   -- Command mode
}

-- Function to get current mode
local function get_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format('%%#StMode# %s ', modes[current_mode] or modes['n'])
end

-- Function to get git info with icon
local function get_git_info()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if branch ~= "" then
        return string.format('%%#StGit#  %s ', branch)
    end
    return ''
end

-- Function to get file info with icon
local function get_file_info()
    local file = vim.fn.expand('%:t')
    local full_path = vim.fn.expand('%:p:~')
    if file == '' then file = '[No Name]' end
    
    local file_icon = ' '  -- Default file icon

    local extension = vim.fn.expand('%:e')
    local file_icons = {
        html    = '',
        css     = '',
        js      = '',
        ts      = '',
        jsx     = '',
        tsx     = '',
        vue     = '',
        lua     = '',    -- Moon for Lua
        py      = '',     -- Snake for Python
        json    = '',   -- Package for JSON
        md      = '',     -- Memo for Markdown
        vim     = '',    -- Vim icon
        sh      = '',     -- Shell for shell scripts
        -- Use [] to specify the specific file name
        ['.git'] = '', -- Git icon
    }
    
    local icon = file_icons[extension] or file_icon
    local modified = vim.bo.modified and ' ' or ''  -- Modified indicator
    
    --[[
      Provide more information if conditions permit
      This function will allow status bar shows full file path if width more than 80 columns
    --]]
    local window_width = vim.fn.winwidth(0)
    local display_path
    if window_width > 80 then
        -- Use full path if window is wide enough
        display_path = full_path
        
        -- Smart truncation if path is very long
        if #display_path > window_width / 2 then
            -- Keep the beginning (root) and filename, truncate the middle
            local path_parts = vim.fn.split(display_path, '/')
            if #path_parts > 3 then
                local start = path_parts[1]
                local middle = '...'
                local last_parts = table.concat({path_parts[#path_parts-1], path_parts[#path_parts]}, '/')
                display_path = start .. '/' .. middle .. '/' .. last_parts
            end
        end
    else
        -- Just use filename when window is narrow
        display_path = file
    end
    
    return string.format('%%#StFile# %s %s%s ', icon, display_path, modified)
end

-- Function to get diagnostic info with icons
local function get_diagnostics()
    if vim.fn.exists('*vim.diagnostic.get') == 1 then
        local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        
        local status = ''
        if errors > 0 then status = status .. string.format('%%#StError# %d ', errors) end
        if warnings > 0 then status = status .. string.format('%%#StWarn# %d ', warnings) end
        if hints > 0 then status = status .. string.format('%%#StHint# %d ', hints) end
        return status
    end
    return ''
end

-- Function to get file position with icon
local function get_position()
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    local total_lines = vim.fn.line('$')
    local percent = math.floor(line * 100 / total_lines)
    return string.format('%%#StInfo#  %d:%d %d%%%% ', line, col, percent)
end

-- Function to get file encoding and format
local function get_file_info_right()
    local encode = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
    local format = vim.bo.fileformat
    
    local format_icons = {
        unix = '',
        dos = '',
        mac = '',
    }
    
    local format_icon = format_icons[format] or ''
    
    return string.format('%%#StFile# %s %s ', format_icon, encode:upper())
end

-- Set up the statusline
function StatusLine()
    local status = ''
    
    -- Left side
    status = status .. get_mode()
    status = status .. get_git_info()
    status = status .. get_file_info()
    status = status .. get_diagnostics()
    
    -- Right side
    status = status .. '%='  -- Switch to right side
    status = status .. get_file_info_right()
    status = status .. get_position()
    
    return status
end

-- Apply the statusline
vim.opt.statusline = '%!v:lua.StatusLine()'
vim.opt.laststatus = 3  -- Global statusline
vim.opt.showmode = false  -- Don't show mode in command line
