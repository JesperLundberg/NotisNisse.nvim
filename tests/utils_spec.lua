local stub = require("luassert.stub")

describe("utils", function()
	local vim_fn_finddir_stub

	before_each(function()
		-- Stub `vim.fn.input` and `vim.notify`
		vim_fn_finddir_stub = stub(vim.fn, "finddir")
	end)

	after_each(function()
		-- Revert stubs after each test to avoid pollution
		if vim_fn_finddir_stub then
			vim_fn_finddir_stub:revert()
		end
	end)

	-- System under test (utils)
	local sut = require("notisnisse.utils")

	describe("flatten_notes", function()
		it("should_return_empty_table_when_empty_table_is_input", function()
			assert.are.same({}, sut.flatten_notes({}))
		end)

		it("should_return_flattened_notes_when_input_is_table_with_one_note", function()
			local input = {
				{ id = 1, note = "Test note", project = "Test project" },
			}
			local expected_output = { "1\t\tTest note\t\tTest project" }

			assert.are.same(expected_output, sut.flatten_notes(input))
		end)

		it("should_return_flattened_notes_when_input_is_table_with_multiple_notes", function()
			local input = {
				{ id = 1, note = "Test note 1", project = "Test project 1" },
				{ id = 2, note = "Test note 2", project = "Test project 2" },
			}
			local expected_output = {
				"1\t\tTest note 1\t\tTest project 1",
				"2\t\tTest note 2\t\tTest project 2",
			}

			assert.are.same(expected_output, sut.flatten_notes(input))
		end)
	end)

	describe("format_note", function()
		it("should_return_formatted_note_when_input_is_note", function()
			local input = { id = 1, note = "Test note", project = "Test project" }
			local expected_output = "1\t\tTest note\t\tTest project"

			assert.are.same(expected_output, sut.format_note(input))
		end)
	end)

	describe("get_root_dir", function()
		it("should_return_current_directory_when_not_in_git_repo", function()
			-- Get the current working directory and add a trailing slash
			local current_dir = vim.fn.getcwd() .. "/"
			local result = sut.get_root_dir()

			assert.are.same(current_dir, result)
		end)

		it("should_return_git_root_directory_when_in_git_repo", function()
			vim_fn_finddir_stub.returns("/tmp/git_repo/.git")

			local result = sut.get_root_dir()

			assert.are.same("/tmp/git_repo/", result)
		end)
	end)
end)
