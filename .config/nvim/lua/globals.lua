--////////////////////////////////////////////////////////////////////////////
--set variables
--////////////////////////////////////////////////////////////////////////////
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.path = vim.opt.path + "**"
vim.opt.wildmenu = true
vim.opt.mouse = 'a'
vim.opt.scrolloff = 10
vim.cmd(':set shiftwidth=2 smarttab')

--////////////////////////////////////////////////////////////////////////////
--Set code folding
--////////////////////////////////////////////////////////////////////////////
vim.cmd(':set foldmethod=indent')
vim.cmd(':set foldcolumn=1')
vim.cmd(':set nofoldenable')

--////////////////////////////////////////////////////////////////////////////
--set colorscheme
--////////////////////////////////////////////////////////////////////////////
vim.cmd('colorscheme onedark')
vim.cmd('hi Search guibg=#B31B97')


vim.o.laststatus = 2  -- always show statusline
vim.o.statusline = "%f %h%m%r %=%{v:lua.StatuslineWordCount()} words %l:%c %p%%"

function _G.StatuslineWordCount()
  local wc = vim.fn.wordcount()
  if vim.fn.mode():match("[vV]") and wc.visual_words then
    return wc.visual_words
  else
    return wc.words
  end
end
