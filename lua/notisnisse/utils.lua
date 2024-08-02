local path = require("plenary.path")

local M = {}

--- Flatten notes into one table of strings in array format
--- @param notes table The notes to be flattened
--- @return table The flattened notes
function M.flatten_notes(notes)
	local flattened_notes = {}

	for _, note in ipairs(notes) do
		table.insert(flattened_notes, note.id .. "\t\t" .. note.note .. "\t\t" .. note.project)
	end

	return flattened_notes
end

--- Get the root directory of the current git repository
--- @return string The absolute path to the root directory of the current git repository or the current directory if not in a git repository
function M.get_root_dir()
	-- Find the path of the .git directory
	local root_path = vim.fn.finddir(".git", ".;")

	-- Get the absolute path of the root directory
	local absolute_root_path = path:new(root_path):absolute()

	-- Remove the .git directory from the path if it exists (pattern looks for .git at the end of the string)
	absolute_root_path = string.gsub(absolute_root_path, ".git$", "")

	return absolute_root_path
end

return M
