local database = require("notisnisse.database")

local M = {}

function M.add_note()
	-- Open window to get note name

	-- Create the note
	database.setup()
	database.add_note("title", "content")

	-- Open the content of the file
end

function M.list_notes()
	-- Get all notes
	database.setup()
	local notes = database.get_notes()

	-- Print all notes
	for _, note in ipairs(notes) do
		print(note.title)
	end
end

return M
