local M = {}

-- Available commands for NotisNisse
local commands = {
	["add"] = function()
		require("notisnisse.main").add_note()
	end,
	["show_all"] = function()
		require("notisnisse.main").list_notes()
	end,
	["show_project"] = function()
		require("notisnisse.main").get_note_by_project()
	end,
}

local function tab_completion(_, _, _)
	-- Tab completion for NotisNisse
	local tab_commands = {}

	-- Loop through the commands and add the key value to the tab completion
	for k, _ in pairs(commands) do
		table.insert(tab_commands, k)
	end

	return tab_commands
end

vim.api.nvim_create_user_command("NotisNisse", function(opts)
	-- If the command exists then run the corresponding function
	commands[opts.args]()
end, { nargs = "*", complete = tab_completion, desc = "NotisNisse plugin" })

return M
