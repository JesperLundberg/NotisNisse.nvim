local M = {}

local map = vim.keymap.set

--- Create a popup window for user input
--- @param text string text to display in the popup window
--- @param on_confirm function to call when user confirms input
--- @param opts table with options
--- @option opts.title string title of the popup window
function M.input_note_window(text, on_confirm, opts)
	local win = require("plenary.popup").create(text or "", {
		title = opts.title or "",
		style = "minimal",
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		borderhighlight = "NotisNisseBorder",
		titlehighlight = "NotisNisseTitle",
		focusable = true,
		width = 40,
		height = 1,
		pos = "center",
	})

	vim.cmd("normal A")
	vim.cmd("startinsert")

	map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

	map({ "i", "n" }, "<CR>", function()
		local note = vim.trim(vim.fn.getline("."))
		vim.api.nvim_win_close(win, true)

		on_confirm(note)

		vim.cmd.stopinsert()
	end, { buffer = 0 })
end

return M
