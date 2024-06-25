local database = require("notisnisse.database")

local M = {}

function M.add_note()
	-- Open window to get note name

	-- Create the note
	database.setup()
	database.add_note({ title = "title1", content = "content1" })

	-- Open the content of the file
end

function M.list_notes()
	-- Get all notes
	database.setup()
	local notes = database.get_notes("", "", 0)

	-- Print all notes
	for _, note in ipairs(notes) do
		print(note.title .. " " .. note.content)
	end
end

function M.get_note_by_id()
	-- Get the note by id
	database.setup()
	local note = database.get_notes("id", "", 1)

	print(vim.inspect(note))

	-- Print the note
	print(note.title .. " " .. note.content)
end

function M.write_title()
	require("notisnisse.input_window")()
end

return M
