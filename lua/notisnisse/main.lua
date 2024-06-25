local database = require("notisnisse.database")

local M = {}

function M.add_note()
	-- Make sure the database is setup
	database.setup()

	-- Open window to get note name
	require("notisnisse.input_window").input_note_window(function(input)
		--save to database
		database.add_note({ note = input })
	end, { title = "Title" })
end

function M.list_notes()
	-- Get all notes
	database.setup()

	local notes = database.get_notes()

	-- Print all notes
	for _, note in ipairs(notes) do
		print(note.note)
	end
end

function M.get_note_by_project()
	-- Get the note by project
	database.setup()

	-- FIXME: Read project from current file. Look for root directory and use that as project name. (use lsp for this?)
	local notes = database.get_notes({ by = "project", project = "project" })

	-- Print all notes
	for _, note in ipairs(notes) do
		print(note.note)
	end
end

-- NOTE: Should this method exist at all?
function M.get_note_by_id()
	-- Get the note by id
	database.setup()

	-- FIXME: Set id to something sensible!
	local note = database.get_notes({ by = "id", id = 1 })

	-- Print the note
	print(note.note)
end

return M
