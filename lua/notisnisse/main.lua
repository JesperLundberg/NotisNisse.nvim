local utils = require("notisnisse.utils")
local database = require("notisnisse.database")
local floating_window = require("notisnisse.floating_window")

local M = {}

function M.add_note()
	database.setup()

	-- Open emtpy window to get note name
	require("notisnisse.input_window").input_note_window("", function(input)
		-- Get the project path
		local project_path = utils.get_root_dir()

		--save to database
		database.add_note({ note = input, project = project_path })
	end, { title = "Title" })
end

function M.list_notes()
	-- Get all notes
	database.setup()

	-- Give an emtpy table to get all notes
	local notes = database.get_notes({})

	-- Print all notes
	local win, buf = floating_window.open()
	floating_window.update(win, buf, notes)
end

function M.get_note_by_project()
	-- Get the project path
	local project_path = utils.get_root_dir()

	-- Get note by project
	local notes = database.get_notes({ by = "project", project = project_path })

	-- Print all notes for the project
	local win, buf = floating_window.open()
	floating_window.update(win, buf, notes)
end

return M
