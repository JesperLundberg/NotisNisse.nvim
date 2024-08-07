local M = {}

local sqlite = require("sqlite")

-- Get the database directory
local dbdir = vim.fn.stdpath("data") .. "/databases"
local db
local notes

--- Ensure the database exists
function M.setup()
	if not vim.loop.fs_stat(dbdir) then
		vim.loop.fs_mkdir(dbdir, 493)
	end

	-- Initialize the database
	db = sqlite({
		uri = dbdir .. "/notisnisse.db",
		notes = {
			id = true, -- sets primary key and autoincrement
			note = "text",
			project = "text",
		},
		opt = {
			lazy = true,
		},
	})

	notes = db.notes
end

local function create_return_table(rows)
	local result = {}
	for _, row in ipairs(rows) do
		table.insert(
			result,
			{ id = row.id, note = row.note, project = row.project or "no_project_supplied_at_creation" }
		)
	end

	return result
end

--- Get a note by id from the database
--- @param id number The id of the note to get
--- @return table The note with the given id
function M.get_note_by_id(id)
	-- Get a note by id
	return create_return_table(notes:get({ where = { id = id } }))
end

--- Update a note in the database
--- @param note_to_update table The note to update
function M.update_note(note_to_update)
	if not note_to_update or note_to_update.id == nil then
		return error("Note to update is missing id")
	end

	-- Update a note in the database
	notes:update({
		where = { id = note_to_update.id },
		set = { note = note_to_update.note },
	})
end

--- Delete a note from the database
--- @param id_to_delete number The id of the note to delete
function M.delete_note(id_to_delete)
	-- Delete a note from the database
	notes:remove({ id = id_to_delete })
end

--- Add a note to the database
--- @param note_to_add table The note to add
function M.add_note(note_to_add)
	-- Add a note to the database
	notes:insert({ note = note_to_add.note, project = note_to_add.project })
end

--- Get all notes from the database
--- @param opts table Options for getting get_notes
--- @option opts.by string The type of note to get (project or nil/{} for all notes)
--- @return table All notes from the database
function M.get_notes(opts)
	-- Get all notes
	if opts or #opts ~= 0 then
		-- Get notes by project
		if opts.by == "project" then
			return create_return_table(notes:get({ where = { project = opts.project } }))
		end
	end

	-- Get all notes if no opts are provided or the opts do not match existing opts
	return create_return_table(notes:get())
end

return M
