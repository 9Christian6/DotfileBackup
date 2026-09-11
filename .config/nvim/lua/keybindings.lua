--////////////////////////////////////////////////////////////////////////////
-- Set Leader
--////////////////////////////////////////////////////////////////////////////
vim.g.mapleader = "\\"

local opts = { noremap = true, silent = true }

--//////////////////////////////////////////////////////////////////////////
-- Global Keybindings
--//////////////////////////////////////////////////////////////////////////

-- Scroll remapping
vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<C-y>", opts)
vim.api.nvim_set_keymap("n", "<C-f>", "30<C-e>", opts)
vim.api.nvim_set_keymap("n", "<C-b>", "30<C-y>", opts)
vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<C-e>", opts)
vim.api.nvim_set_keymap("v", "<ScrollWheelUp>", "<C-y>", opts)
vim.api.nvim_set_keymap("v", "<ScrollWheelDown>", "<C-e>", opts)
vim.api.nvim_set_keymap("i", "<ScrollWheelUp>", "<C-o><C-y>", opts)
vim.api.nvim_set_keymap("i", "<ScrollWheelDown>", "<C-o><C-e>", opts)

-- Disable Ctrl+Scroll entirely
for _, mode in ipairs({ "n", "v", "i" }) do
	vim.api.nvim_set_keymap(mode, "<C-ScrollWheelUp>", "gk", opts)
	vim.api.nvim_set_keymap(mode, "<C-ScrollWheelDown>", "gj", opts)
end

-- Resize windows
vim.api.nvim_set_keymap("n", "<C-W>+", ":horizontal resize +10<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-W>-", ":horizontal resize -10<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-W>>", ":vertical resize +10<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-W><", ":vertical resize -10<CR>", opts)

-- LSP Actions
vim.api.nvim_set_keymap("n", "<LEADER>qf", ":lua vim.lsp.buf.code_action()<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<LEADER>e",  	":lua vim.diagnostic.goto_next()<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<LEADER>E",  	":lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>e", ":lua vim.diagnostic.jump({count=1, float=true})<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>E", ":lua vim.diagnostic.jump({count=-1, float=true})<CR>", opts)
local cmd = vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {})

vim.api.nvim_set_keymap("i", "<C-l>", "<ESC>:noh<CR>i", opts)
vim.api.nvim_set_keymap("v", "<C-l>", ":<C-u>noh<CR>gv", opts)

-- Tab navigation
vim.api.nvim_set_keymap("n", "<LEADER>tt", ":tabnew<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>tn", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>tp", ":tabprevious<CR>", opts)

-- Terminal
vim.api.nvim_set_keymap("n", "<LEADER>t", ":set splitbelow<CR>:10Term<CR>", opts)
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Save / Quit
vim.api.nvim_set_keymap("n", "<LEADER>w", ":w<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>q", ":q<CR>", opts)
vim.api.nvim_set_keymap("n", ":Q<CR>", ":q<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>wq", ":wq<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>wq", ":wq<CR>", opts)

-- Save and edit
local function write_edit(path)
	local base_dir = vim.fn.expand("%:p:h")
	local full_path = vim.fn.fnamemodify(base_dir .. "/" .. path, ":p")
	local dir = vim.fn.fnamemodify(full_path, ":h")

	-- create directory if it doesn't exist
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	vim.cmd("saveas " .. vim.fn.fnameescape(full_path))
end

vim.api.nvim_create_user_command("We", function(opts)
	write_edit(opts.args)
end, { nargs = 1, complete = "file" })

vim.cmd([[cabbrev <expr> we getcmdtype() == ':' && getcmdline() ==# 'we' ? 'We' : 'we']])

-- File finding
vim.api.nvim_set_keymap("n", "<LEADER>f", ":Files .<CR>", opts)

-- vim.api.nvim_set_keymap("n", "<LEADER>fs", ":lua require('telescope.builtin').live_grep"<CR>, opts)
vim.api.nvim_set_keymap("n", "<LEADER>fs", ":lua require('telescope.builtin').live_grep()<CR>", opts)

-- Hover / Move Selection
vim.api.nvim_set_keymap("n", "<C-h>", ":lua vim.lsp.buf.hover()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "telescope.actions.move_selection_previous()", opts)

-- Movement fixes
vim.api.nvim_set_keymap("n", "j", "gj", opts)
vim.api.nvim_set_keymap("n", "k", "gk", opts)
vim.api.nvim_set_keymap("n", "$", "g$", opts)
vim.api.nvim_set_keymap("n", "gj", "j", opts)
vim.api.nvim_set_keymap("n", "gk", "k", opts)
vim.api.nvim_set_keymap("n", "g$", "$", opts)

-- NvimTree
vim.api.nvim_set_keymap("n", "<Leader>nt", ":NvimTreeToggle<CR>", opts)

-- Case-insensitive search
vim.api.nvim_set_keymap("n", "/", "/\\c", opts)

-- Undotree toggle
vim.api.nvim_set_keymap("n", "<LEADER>u", ":UndotreeToggle<CR>", opts)

--//////////////////////////////////////////////////////////////////////////
-- Git integration
--//////////////////////////////////////////////////////////////////////////
vim.api.nvim_set_keymap("n", "<Leader>gg", ":lua require('gitConfig').toggleNeogit()<CR>", { desc = "Open Neogit UI" })
vim.api.nvim_set_keymap(
	"n",
	"<Leader>gd",
	":lua require('gitConfig').toggle_linehl()<CR>",
	{ desc = "Toggle inline git diff signs" }
)
vim.api.nvim_set_keymap("n", "<Leader>gn", ":lua require('gitConfig').next_hunk()<CR>", { desc = "Go to next hunk" })
vim.api.nvim_set_keymap(
	"n",
	"<Leader>gp",
	":lua require('gitConfig').prev_hunk()<CR>",
	{ desc = "Go to previous hunk" }
)

--//////////////////////////////////////////////////////////////////////////
-- LaTeX-specific Keybindings
--//////////////////////////////////////////////////////////////////////////

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		local ls = require("luasnip")
		local bufnr = vim.api.nvim_get_current_buf()

		-- Vimtex compile
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>l", ":VimtexCompile<CR>", opts)

		-- Vimtex clean
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>lc", ":VimtexClean<CR>", opts)

		-- TeX-specific LSP behavior
		vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "KK", ":lua vim.diagnostic.setloclist()<CR>", opts)

		-- Build & View
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<localleader>b", ":VimtexCompile<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<localleader>v", ":VimtexView<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<localleader>o", ":VimtexTocOpen<CR>", opts)

		-- Navigation
		vim.api.nvim_buf_set_keymap(bufnr, "n", "[s", ":VimtexGotoPrevSection<CR>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "]s", ":VimtexGotoNextSection<CR>", opts)

		-- Spell toggle
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<localleader>S", ":set spell!<CR>", opts)
	end,
})

--//////////////////////////////////////////////////////////////////////////
-- Programming Keybindings
--//////////////////////////////////////////////////////////////////////////

function findReferences()
	require("telescope.builtin").lsp_references({
		symbols = { "Function", "Method", "Constructor" },
		layout_strategy = "horizontal",
		symbol_width = 70,
		layout_config = {
			width = 0.8,
			height = 0.9,
			prompt_position = "bottom",
		},
	})
end

function findFunctionSymbols()
	require("telescope.builtin").lsp_document_symbols({
		symbols = { "Function", "Method", "Constructor" },
		layout_strategy = "horizontal",
		symbol_width = 70,
		layout_config = {
			width = 0.8,
			height = 0.9,
			prompt_position = "bottom",
		},
	})
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		local bufnr = vim.fn.bufnr("%")
		vim.keymap.set("n", "<cr>", function()
			vim.api.nvim_command([[execute "normal! \<cr>"]])
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end, { buffer = bufnr })
	end,
	pattern = "qf",
})

-- 1. Define the foldtext formatter globally once
_G.cpp_function_foldtext = _G.cpp_function_foldtext
	or function()
		local line = vim.fn.getline(vim.v.foldstart)
		local line_count = vim.v.foldend - vim.v.foldstart + 1

		-- Clean up whitespace and truncate if too long
		local clean_line = line:gsub("^%s+", ""):gsub("%s+$", "")
		if #clean_line > 80 then
			clean_line = clean_line:sub(1, 77) .. "..."
		end

		return clean_line .. "  [" .. line_count .. " lines]"
	end

-- 2. Your extended LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype

		-- Get the client that just attached
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		-- Optional: Keep your original filetype restriction
		-- local allowed_fts = { "tex", "cpp", "c", "python", "rs", "js", "sh" }
		-- if not vim.tbl_contains(allowed_fts, ft) then return end

		-- Modern keymap options: noremap and silent are true by default in recent Neovim
		local opts = { buffer = bufnr, silent = true, noremap = true }

		-- ==========================================
		-- CLANGD FOLDING CONFIGURATION
		-- ==========================================
		if client.name == "clangd" then
			-- Enable LSP-driven folding (Requires Neovim 0.10+)
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
			vim.opt_local.foldlevel = 99 -- Start unfolded
			vim.opt_local.foldtext = "v:lua.cpp_function_foldtext()"

			-- Clever toggle: zC closes recursively (collapses inner blocks + function)
			-- zO opens recursively. Leaves function name visible.
			vim.keymap.set("n", "<Leader>tf", function()
				if vim.fn.foldclosed(".") ~= -1 then
					vim.cmd("normal! zO")
				else
					vim.cmd("normal! zC")
				end
			end, opts)
		end
		-- ==========================================

		-- Direct function references (cleaner & faster than <cmd>lua ...<CR>)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)

		-- Custom global functions (kept as <cmd> strings)
		vim.keymap.set("n", "<space>fu", "<cmd>lua findFunctionSymbols()<CR>i", opts)
		vim.keymap.set("n", "<Leader>re", "<cmd>lua findReferences()<CR>", opts)

		-- Override `K` for all filetypes except LaTeX
		if ft ~= "tex" then
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		end
	end,
})
-- // -- LSP Keybindings: Set only when an LSP client actually attaches to the buffer
-- // vim.api.nvim_create_autocmd("LspAttach", {
-- // 	callback = function(args)
-- // 		local bufnr = args.buf
-- // 		local ft = vim.bo[bufnr].filetype
-- //
-- // 		-- Optional: Keep your original filetype restriction
-- // 		-- local allowed_fts = { "tex", "cpp", "c", "python", "rs", "js", "sh" }
-- // 		-- if not vim.tbl_contains(allowed_fts, ft) then return end
-- //
-- // 		-- Modern keymap options: noremap and silent are true by default in recent Neovim
-- // 		local opts = { buffer = bufnr, silent = true, noremap = true }
-- //
-- // 		-- Direct function references (cleaner & faster than <cmd>lua ...<CR>)
-- // 		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
-- // 		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
-- // 		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
-- // 		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
-- // 		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
-- // 		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
-- // 		vim.keymap.set("n", "<space>wl", function()
-- // 			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- // 		end, opts)
-- // 		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
-- // 		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
-- // 		vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
-- //
-- // 		-- Custom global functions (kept as <cmd> strings)
-- // 		vim.keymap.set("n", "<space>fu", "<cmd>lua findFunctionSymbols()<CR>i", opts)
-- // 		vim.keymap.set("n", "<Leader>re", "<cmd>lua findReferences()<CR>", opts)
-- //
-- // 		-- Override `K` for all filetypes except LaTeX
-- // 		if ft ~= "tex" then
-- // 			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- // 		end
-- // 	end,
-- // })

-- C/C++ CMake bindings remain on FileType (they don't require an LSP)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "c" },
	callback = function(args)
		local bufnr = args.buf
		local opts = { buffer = bufnr, silent = true, noremap = true }

		vim.keymap.set("n", "<Leader>cmb", ":CMakeBuild<CR>", opts)
		vim.keymap.set("n", "<Leader>cmr", ":CMakeRun<CR>", opts)
		vim.keymap.set("n", "<Leader>cmt", ":CMakeToggleTerminal<CR>", opts)
	end,
})

-- Code Companion keybinds
vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", opts)
vim.api.nvim_set_keymap("v", "<leader>ci", "<cmd>CodeCompanion<CR>", opts)

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "tex", "cpp", "c", "python", "rs" , "js", "sh"},
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local ft = vim.bo[bufnr].filetype
--
--     -- Shared LSP Bindings
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>fu', '<cmd>lua findFunctionSymbols()<CR>i', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>re', '<cmd>lua findReferences()<CR>', opts)
--
--     if ft ~= "tex" then
--       vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--     end
--   end
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "cpp", "c" },
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--
--     -- Build with CMake
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>cmb', ':CMakeBuild<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>cmr', ':CMakeRun<CR>', opts)
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>cmt', ':CMakeToggleTerminal<CR>', opts)
--   end
-- })
