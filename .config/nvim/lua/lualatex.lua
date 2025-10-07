vim.g.syntax = enable
vim.g.vimtex_view_method = 'general'
vim.g.vimtex_compiler_method = 'latexmk'

vim.g.vimtex_compiler_latexmk = {
  engine = '-lualatex',
  build_dir = 'build',
  options = {
    '-file-line-error',
    '-halt-on-error',
    '-interaction=nonstopmode',
  },
}

vim.o.statusline = "%f %h%m%r %=%{v:lua.StatuslineWordCount()} words %l:%c %p%%"

function _G.StatuslineWordCount()
  local wc = vim.fn.wordcount()
  if vim.fn.mode():match("[vV]") and wc.visual_words then
    return wc.visual_words
  else
    return wc.words
  end
end


