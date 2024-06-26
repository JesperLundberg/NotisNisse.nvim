local M = {}

function M.get_root_dir(pattern)
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

return M
