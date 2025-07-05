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
