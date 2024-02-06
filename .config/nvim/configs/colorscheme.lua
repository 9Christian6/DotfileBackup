local colorscheme = "onedark"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
vim.o.background = "dark"
if not ok then 
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
