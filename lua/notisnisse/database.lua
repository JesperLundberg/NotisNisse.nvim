local M = {}

local sqlite = require("sqlite") -- Ensure this matches the plugin's require statement
local tbl = require("sqlite.tbl") --- for constructing sql tables

-- Get the database directory
local dbdir = vim.fn.stdpath("data") .. "/databases"

print(dbdir)

local db_table_notes = tbl("notes", {
	id = true, -- same as { type = "integer", required = true, primary = true }
	title = "text",
	content = "text",
	project = "text",
})

-- Initialize the database
local db = sqlite({
	uri = dbdir .. "/notisnisse.db",
	notes = db_table_notes,
	opt = {
		lazy = true,
	},
})

local notes = db.notes

function notes:get_all_notes()
	print(vim.inspect(self:get()))
	-- print(vim.inspect(db:select("notes")))
	-- return db:select("notes")
	return {}
end

function notes:ensure()
	print(vim.loop.fs_stat(dbdir))

	if not vim.loop.fs_stat(dbdir) then
		vim.loop.fs_mkdir(dbdir, 493)
	end
end

function notes:add_note(note_to_add)
	-- Add a note to the database
	self:insert({ title = note_to_add.title, content = note_to_add.content })
end

function M.add_note(title, content)
	-- Add a note to the database
	notes:add_note({ title = title, content = content })
end

function M.get_notes()
	print("Here is the contents of db:select('notes')")
	-- print(vim.inspect(db:select("notes")))
	print("After select")

	-- Get all notes from the database
	local rows = notes:get_all_notes()

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
