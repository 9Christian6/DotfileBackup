-- Import nvim-cmp plugin safely
local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

-- Import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

-- Load VSCode-like snippets from plugins (e.g., friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

-- Set completion options
vim.opt.completeopt = "menu,menuone,noselect"

local function has_lsp_attached(bufnr)
	if vim.lsp.get_clients then
		return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
	end

	return #vim.lsp.buf_get_clients(bufnr) > 0
end

local function cmp_enabled()
	local bufnr = vim.api.nvim_get_current_buf()
	if has_lsp_attached(bufnr) then
		return true
	end

	return vim.b[bufnr].cmp_manual_enabled == true
end

-- Setup nvim-cmp
local cmp_window = {
	border = "rounded",
	winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
}

cmp.setup({
	enabled = cmp_enabled,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(cmp_window),
		documentation = cmp.config.window.bordered(cmp_window),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- confirm completion
		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- LSP
		{ name = "luasnip" }, -- snippets
		{ name = "buffer" }, -- text within the current buffer
		{ name = "path" }, -- file system paths
	}),
})

cmp.setup.filetype({ "tex", "latex" }, {
	enabled = cmp_enabled,
	sources = cmp.config.sources({
		{ name = "latex_symbols", option = { strategy = 0 } }, -- LaTeX symbols preview
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

vim.api.nvim_create_user_command("AutocompleteEnable", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.b[bufnr].cmp_manual_enabled = true
	vim.notify("Autocomplete enabled for this buffer")
end, {
	desc = "Enable nvim-cmp for current buffer when no LSP is attached",
	force = true,
})

vim.api.nvim_create_user_command("AutocompleteDisable", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.b[bufnr].cmp_manual_enabled = false
	vim.notify("Autocomplete disabled for this buffer (LSP-attached buffers stay enabled)")
end, {
	desc = "Disable nvim-cmp for current buffer when no LSP is attached",
	force = true,
})
