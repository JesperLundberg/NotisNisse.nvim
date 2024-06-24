local M = {}

local sqlite = require("sqlite.db") --- for constructing sql databases
local tbl = require("sqlite.tbl") --- for constructing sql tables
local uri = "/tmp/bm_db_v1" -- defined here to be deleted later

--- sqlite builtin helper functions
local julianday, strftime = sqlite.lib.julianday, sqlite.lib.strftime

local entries = tbl("entries", {
	id = true, -- same as { type = "integer", required = true, primary = true }
	link = { "text", required = true },
	title = "text",
	since = { "date", default = strftime("%s", "now") },
	collection = {
		type = "text",
		reference = "collection.title",
		on_update = "cascade", -- means when collection get updated update
		on_delete = "null", -- means when collection get deleted, set to null
	},
})

-- sqlite.lua db object will be injected to every table at evaluation.
-- Though no connection will be open until the first sqlite operation.
local BM = sqlite({
	uri = uri,
	entries = entries,
	collection = { -- Yes, tables can be inlined without requiring sql.table.
		title = {
			"text",
			required = true,
			unique = true,
			primary = true,
		},
	},
	ts = {
		_name = "timetamps", -- use this as table name not the field key.
		id = true,
		timestamp = { "real", default = julianday("now") },
		entry = {
			type = "integer",
			reference = "entries.id",
			on_delete = "cascade", --- when referenced entry is deleted, delete self
		},
	},
	-- custom sqlite3 options, if you really know what you want. + keep_open + lazy
	opts = {},
})

--- Doesn't need to annotated.
local collection, ts = BM.collection, BM.ts

local function setup_database()
	-- Setup the database
end

function M.get_notes()
	-- Get all notes from the database
end

function M.add_note()
	-- Add a note to the database
end

return M
