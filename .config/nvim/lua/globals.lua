--////////////////////////////////////////////////////////////////////////////
--set variables
--////////////////////////////////////////////////////////////////////////////
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.path = vim.opt.path + "**"
vim.opt.wildmenu = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.smarttab = true

--////////////////////////////////////////////////////////////////////////////
--Text formatting
--////////////////////////////////////////////////////////////////////////////
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "text", "markdown" },
	callback = function()
		local opt = vim.opt_local
		opt.wrap = true
		opt.linebreak = true
		opt.list = false
		opt.textwidth = 80
		opt.formatoptions:append("t")
		opt.formatoptions:remove("l")
	end,
})

--////////////////////////////////////////////////////////////////////////////
--Set code folding
--////////////////////////////////////////////////////////////////////////////
vim.opt.foldmethod = "manual"
vim.opt.foldcolumn = "1"
vim.opt.foldenable = false
vim.o.laststatus = 2 -- always show statusline

--////////////////////////////////////////////////////////////////////////////
-- Name each tab after its current buffer's filename
--////////////////////////////////////////////////////////////////////////////
vim.o.tabline = "%!v:lua.TabLine()"

function _G.TabLine()
	local tabs = {}

	for tabnr = 1, vim.fn.tabpagenr("$") do
		local bufnr = vim.fn.tabpagebuflist(tabnr)[1]
		local name = vim.fn.bufname(bufnr)

		-- Get filename only, without the path
		name = vim.fn.fnamemodify(name, ":t")

		-- Fallback for unnamed buffers
		if name == "" then
			name = "[No Name]"
		end

		-- Highlight the current tab
		if tabnr == vim.fn.tabpagenr() then
			table.insert(tabs, "%#TabLineSel#")
		else
			table.insert(tabs, "%#TabLine#")
		end

		table.insert(tabs, " " .. name .. " ")
	end

	table.insert(tabs, "%#TabLineFill#")
	return table.concat(tabs)
end

--////////////////////////////////////////////////////////////////////////////
-- Tabline
--////////////////////////////////////////////////////////////////////////////
function _G.CustomTabLine()
	local result = {}

	local current_tab = vim.fn.tabpagenr()
	local tab_count = vim.fn.tabpagenr("$")

	for tabnr = 1, tab_count do
		local bufnr = vim.fn.tabpagebuflist(tabnr)[1]

		local filename = vim.fn.fnamemodify(
			vim.fn.bufname(bufnr),
			":t"
		)

		if filename == "" then
			filename = "[No Name]"
		end

		local selected = tabnr == current_tab

		-- Select background color for this tab
		if selected then
			table.insert(result, "%#TabSelected#")
		else
			table.insert(result, "%#TabNormal#")
		end

		-- Tab contents
		table.insert(result, " " .. filename .. " ")

		-- Reset to normal background for the gap
		table.insert(result, "%#TabGap#")
		table.insert(result, " ")
	end

	-- Fill remaining space with normal background
	table.insert(result, "%#TabGap#")

	return table.concat(result)
end
vim.o.tabline = "%!v:lua.CustomTabLine()"
