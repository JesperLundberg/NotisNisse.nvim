local path = require("plenary.path")

local M = {}

--- Get the root directory of the current git repository
-- @return string: The absolute path to the root directory of the current git repository
function M.get_root_dir()
	-- Find the path of the .git directory
	local root_path = vim.fn.finddir(".git", ".;")

	-- Get the absolute path of the root directory
	local absolute_root_path = path:new(root_path):absolute()

	return absolute_root_path
end

return M
