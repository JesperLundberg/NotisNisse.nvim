local M = {}

local map = vim.keymap.set

local function apply(curr, win)
	local newName = vim.trim(vim.fn.getline("."))
	vim.api.nvim_win_close(win, true)

	if #newName > 0 and newName ~= curr then
		-- save to database
	end
end

function M.input_title_window(opts)
	local win = require("plenary.popup").create("", {
		title = opts.title or "",
		style = "minimal",
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		relative = "cursor",
		borderhighlight = "NotisNisseBorder",
		titlehighlight = "NotisNisseTitle",
		focusable = true,
		width = 25,
		height = 1,
		line = "cursor+2",
		col = "cursor-1",
	})

	vim.cmd("normal A")
	vim.cmd("startinsert")

	map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

	map({ "i", "n" }, "<CR>", function()
		apply("", win)
		vim.cmd.stopinsert()
	end, { buffer = 0 })
end

return M
