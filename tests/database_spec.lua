-- Import necessary modules
local assert = require("luassert")

describe("database", function()
	-- System under test (database)
	local sut = require("notisnisse.database")

	describe("get_notes", function()
		it("should_return_empty_table_with_nonexisting_opt_by_value", function()
			assert.are.same({}, sut.get_notes({ by = "nonexisting" }))
		end)
	end)
end)
