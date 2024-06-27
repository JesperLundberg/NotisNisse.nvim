local M = {}

local sqlite = require("sqlite") -- Ensure this matches the plugin's require statement

-- Get the database directory
local dbdir = vim.fn.stdpath("data") .. "/databases"

--- Ensure the database exists
local function ensure()
	if not vim.loop.fs_stat(dbdir) then
		vim.loop.fs_mkdir(dbdir, 493)
	end
end

ensure()

-- Initialize the database
local db = sqlite({
	uri = dbdir .. "/notisnisse.db",
	notes = {
		id = true, -- same as { type = "integer", required = true, primary = true }
		note = "text",
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
	return self:get({ where = { project = project } })
end

--- Get all notes
--- @return table All notes
function notes:get_all_notes()
	-- return all notes
	return self:get()
end

--- Add a note to the database
--- @param note_to_add table The note to add
function notes:add_note(note_to_add)
	-- Add a note to the database
	self:insert({ note = note_to_add.note, project = note_to_add.project })
end

--- Update a note in the database
--- @param note_to_update table The note to update
function notes:update_note(note_to_update)
	-- Update a note in the database
	self:update({ id = note_to_update.id }, { note = note_to_update.note, project = note_to_update.project })
end

local function create_return_table(rows)
	local result = {}
	for _, row in ipairs(rows) do
		table.insert(result, { id = row.id, note = row.note, project = row.project or "no_project" })
	end

	return result
end

--- Add a note to the database
--- @param note_to_add table The note to add
function M.add_note(note_to_add)
	-- Add a note to the database
	notes:add_note(note_to_add)
end

--- Get all notes from the database
--- @return table All notes from the database
function M.get_notes(opts)
	-- Get all notes
	-- if by is not provided, get all notes
	if not opts then
		return create_return_table(notes:get_all_notes())
	end

	if opts.by == "project" then
		return create_return_table(notes:get_all_notes_by_project(opts.project))
	end

	-- FIXME: Unnecessary?
	if opts.by == "id" then
		return create_return_table(notes:get_note_by_id(opts.id))
	end

	-- Should never get here unless the opts are wrong
	return {}
end

return M
