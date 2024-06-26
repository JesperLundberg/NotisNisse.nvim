local M = {}

M.check = function()
	vim.health.start("Sqlite3")

	-- Check if `sqlite3` is installed
	if vim.fn.executable("sqlite3") == 0 then
		vim.health.error("sqlite3")
	else
		-- Run `sqlite3 --version` to get the version of dotnet
		local handle = io.popen("sqlite3 --version")

		-- If the output is nil then report an error (this should never happen)
		if handle == nil then
			vim.health.error("error on attempting to read `sqlite3 --version`")
			return
		end

		-- Read the result of running `sqlite3 --version`
		local result = handle:read("*a")
		handle:close()

		-- Get the first word of the output (i.e. the version)
		local version = result:match("%S+")

		-- Report the version of `sqlite3`
		vim.health.ok("`sqlite3` found " .. version)
	end
end

return M
