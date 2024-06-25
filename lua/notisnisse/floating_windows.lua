local M = {}

-- Function to show the floating window for title input
function M.show_title_input()
	-- Create a new empty buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.api.nvim_buf_set_option(buf, "buflisted", false)
	-- Prevent new lines
	vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "<Esc>:q!<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":q!<CR>", { noremap = true, silent = true })

	-- Disable statusline for the floating window buffer
	vim.cmd("autocmd BufEnter <buffer> setlocal statusline=")

	-- Open the floating window
	local width = math.floor(vim.o.columns * 0.8)
	local height = 3
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Set focus to the floating window and enter insert mode
	vim.api.nvim_set_current_win(win)
	vim.cmd("startinsert")

	-- Define a globally unique function name for capturing the title
	_G.UniqueCaptureTitleFunctionName = function()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local title = table.concat(lines, "\n"):gsub("%\n$", "") -- Remove trailing newline
		title = title:gsub("^%%", "") -- Remove leading '%' character if present
		print("Title submitted:", title) -- Replace this with whatever you want to do with the title
		vim.api.nvim_win_close(win, true) -- Close the floating window
	end

	-- Set autocmd to capture title when window closes
	vim.cmd("autocmd BufLeave <buffer> lua UniqueCaptureTitleFunctionName()")
end

return M
