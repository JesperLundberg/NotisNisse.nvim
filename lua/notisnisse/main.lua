local utils = require("notisnisse.utils")
local database = require("notisnisse.database")

local M = {}

function M.add_note()
	-- Open window to get note name
	require("notisnisse.input_window").input_note_window(function(input)
		-- Get the project path
		local project_path = utils.get_root_dir()

		--save to database
		database.add_note({ note = input, project = project_path })
	end, { title = "Title" })
end

function M.list_notes()
	-- Get all notes
	database.setup()
	local notes = database.get_notes()

	-- Print all notes
	for _, item in ipairs(notes) do
		print(item.note .. " " .. item.project)
	end
end

function M.get_note_by_project()
	-- Get the project path
	local project_path = utils.get_root_dir()

	-- Get note by project
	-- FIXME: Read project from current file. Look for root directory and use that as project name. (use lsp for this?)
	local notes = database.get_notes({ by = "project", project = project_path })

	print(vim.inspect(notes))

	-- Print all notes
	for _, item in ipairs(notes) do
		print(item.note)
	end
end

return M
