local M = {}

local sqlite = require("sqlite") -- Ensure this matches the plugin's require statement

-- Get the database directory
local dbdir = vim.fn.stdpath("data") .. "/databases"

-- Initialize the database
local db = sqlite({
	uri = dbdir .. "/notisnisse.db",
	notes = {
		id = true, -- same as { type = "integer", required = true, primary = true }
		title = "text",
		content = "text",
		project = "text",
	},
	opt = {
		lazy = true,
	},
})

local notes = db.notes

--- Get a note by id
--- @param id number The id of the note
--- @return table The note with the given id
function notes:get_note_by_id(id)
	-- return a note by id
	return self:get({ where = { id = id } })
end

--- Get all notes by project
--- @param project string The project to get notes for
--- @return table All notes for the given project
function notes:get_all_notes_by_project(project)
	-- return all notes by project
	return self:get({ project = project })
end

--- Get all notes
--- @return table All notes
function notes:get_all_notes()
	-- return all notes
	return self:get()
end

-- FIXME: Make sure folder is created (use plenary?)
--- Ensure the database exists
function notes:ensure()
	if not vim.loop.fs_stat(dbdir) then
		vim.loop.fs_mkdir(dbdir, 493)
	end
end

--- Add a note to the database
--- @param note_to_add table The note to add
function notes:add_note(note_to_add)
	-- Add a note to the database
	self:insert({ title = note_to_add.title, content = note_to_add.content })
end

--- Update a note in the database
--- @param note_to_update table The note to update
function notes:update_note(note_to_update)
	-- Update a note in the database
	self:update({ id = note_to_update.id }, { title = note_to_update.title, content = note_to_update.content })
end

--- Add a note to the database
--- @param note_to_add table The note to add
function M.add_note(note_to_add)
	-- Add a note to the database
	notes:add_note(note_to_add)
end

--- Get all notes from the database
--- @param by string What to get notes by
--- @param project string The project to get notes for
--- @param id number The id of the note
--- @return table All notes from the database
function M.get_notes(by, project, id)
	local rows = {}

	-- Get all notes
	-- if by is not provided, get all notes
	if not by then
		rows = notes:get_all_notes()
	end

	if by == "project" then
		rows = notes:get_all_notes_by_project(project)
	end

	if by == "id" then
		print("Getting by id")
		rows = notes:get_note_by_id(id)
	end

	local result = {}
	for _, row in ipairs(rows) do
		table.insert(result, { id = row.id, title = row.title, content = row.content })
	end

	return result
end

function M.setup()
	-- Ensure the database exists
	notes:ensure()
end

return M
