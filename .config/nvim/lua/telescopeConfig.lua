local telescope = require("telescope")
local actions = require("telescope.actions")
require('telescope').setup{
	defaults = {
		path_display = { "smart" },
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
	}
}
local function find_in_current()
	require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })
end

