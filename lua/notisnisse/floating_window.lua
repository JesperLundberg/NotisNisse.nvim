local M = {}

local api = vim.api
local map = vim.keymap.set

local utils = require("notisnisse.utils")

--- Method to center a string in a window
--- @param str string
local function center(str)
	-- Get the width of the current window
	local width = api.nvim_win_get_width(0)
	-- Calculate the shift needed to center the string
	local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
	return string.rep(" ", shift) .. str
end

--- Method to delete note
local function delete_note()
	-- get the line where the cursor is
	local line = api.nvim_get_current_line()

	-- parse the node id (first word in the line)
	local id = string.match(line, "%d+")

	-- if there is no id, return silently
	if not id then
		return
	end

	-- call the delete_note function with the id
	require("notisnisse.database").delete_note(id)

	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_get_current_buf()

	-- Make the buffer modifiable
	api.nvim_set_option_value("modifiable", true, { buf = buf })

	-- remove the line from the buffer
	-- NOTE: api.nvim_win_get_cursor(win)[1] - 1 is the current line due to 0-based indexing
	api.nvim_buf_set_lines(buf, api.nvim_win_get_cursor(win)[1] - 1, api.nvim_win_get_cursor(win)[1], false, {})

	-- Make the buffer unmodifiable again
	api.nvim_set_option_value("modifiable", false, { buf = buf })
end

-- Method to update note
local function update_note()
	-- get the line where the cursor is
	local line = api.nvim_get_current_line()

	-- parse the node id (first word in the line)
	local id = string.match(line, "%d+")

	-- if there is no id, return silently
	if not id then
		return
	end

	-- get the note part of the line
	local note_text = string.match(line, "%d+%s+(.*)%s")

	-- open the inputwindow again and set the previous note as the default value
	require("notisnisse.input_window").input_note_window(note_text, function(input)
		-- call the update_note function with the note to be updated
		require("notisnisse.database").update_note({
			id = id,
			note = input,
		})
	end, { title = "Update note" })
end

--- Floating result window
--- @return number, number
function M.open()
	-- Create buffers for both windows
	local buf = api.nvim_create_buf(false, true)
	local border_buf = api.nvim_create_buf(false, true)

	-- Set the buffer to be a temporary buffer that will be deleted when it is no longer in use
	api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	api.nvim_set_option_value("filetype", "NotisNisse", { buf = buf })

	-- Get dimensions of neovim editor
	local width = api.nvim_get_option_value("columns", { scope = "global" })
	local height = api.nvim_get_option_value("lines", { scope = "global" })

	-- Calculate our floating window size so its 80% of the editor size
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)
	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	local border_opts = {
		style = "minimal",
		relative = "editor",
		width = win_width + 2,
		height = win_height + 2,
		row = row - 1,
		col = col - 1,
	}

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
	}

	-- Set border buffer lines
	local border_lines = { "╔" .. string.rep("═", win_width) .. "╗" }
	local middle_line = "║" .. string.rep(" ", win_width) .. "║"
	for _ = 1, win_height do
		table.insert(border_lines, middle_line)
	end
	table.insert(border_lines, "╚" .. string.rep("═", win_width) .. "╝")
	api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

	-- Open the border window first then the actual window
	api.nvim_open_win(border_buf, true, border_opts)
	local win = api.nvim_open_win(buf, true, opts)

	-- If the window is closed, close the border window as well
	api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. border_buf)

	-- we can add title already here, because first line will never change
	api.nvim_buf_set_lines(buf, 0, -1, false, { center("NotisNisse"), "", "" })

	-- register the delete note function
	map({ "n" }, "D", delete_note)
	-- register the update note function
	map({ "n" }, "U", update_note)

	return win, buf -- Return window and buffer handles
end

--- Method to set the content of the window
--- @param win number window handle
--- @param buf number buffer handle
--- @param notes table the notes to be displayed
function M.update(win, buf, notes)
	-- Make the buffer modifiable
	api.nvim_set_option_value("modifiable", true, { buf = buf })

	-- if there are no notes
	if #notes == 0 then
		notes = { "No notes found" }
	else
		-- flatten the notes so they can be displayed in the buffer
		notes = utils.flatten_notes(notes)
	end

	-- Set the updated lines (start at row 2 to not overwrite the title)
	api.nvim_buf_set_lines(buf, 2, -1, false, notes)

	-- Make the buffer unmodifiable
	api.nvim_set_option_value("modifiable", false, { buf = buf })

	-- Set the cursor to the last line
	api.nvim_win_set_cursor(win, { #notes, 0 })
end

return M
