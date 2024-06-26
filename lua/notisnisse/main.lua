local database = require("notisnisse.database")

local M = {}

function M.add_note()
	-- Open window to get note name
	require("notisnisse.input_window").input_note_window(function(input)
		--save to database
		database.add_note({ note = input })
	end, { title = "Title" })
end

function M.list_notes()
	-- Get all notes
	local notes = database.get_notes()

	-- Print all notes
	for _, item in ipairs(notes) do
		print(item.note)
	end
end

function M.get_note_by_project()
	-- Get note by project
	-- FIXME: Read project from current file. Look for root directory and use that as project name. (use lsp for this?)
	local notes = database.get_notes({ by = "project", project = "project" })

	-- Print all notes
	for _, item in ipairs(notes) do
		print(item.note)
	end
end

-- NOTE: Should this method exist at all?
function M.get_note_by_id()
	-- Get note by id
	-- FIXME: Set id to something sensible!
	local note = database.get_notes({ by = "id", id = 1 })

	-- Print the note
	for _, item in ipairs(note) do
		print(item.note)
	end
end

return M
