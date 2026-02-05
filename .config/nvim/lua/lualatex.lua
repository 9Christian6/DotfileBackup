-- Enable syntax highlighting
vim.g.syntax = 'enable'

-- VimTeX settings
vim.g.vimtex_view_method = 'general'
vim.g.vimtex_compiler_method = 'latexmk'

-- LaTeXmk configuration for LuaLaTeX
vim.g.vimtex_compiler_latexmk = {
  engine = '-lualatex',
  options = {
    '-file-line-error',
    '-halt-on-error',
    '-interaction=nonstopmode',
    '-gg',  -- force full rebuild
  },
}

-- Clean auxiliary files in the build directory after compilation stops
vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompileStopped",
  callback = function()
    -- Delete auxiliary files inside 'build/'
    vim.fn.system('latexmk -c')
    print("✓ Cleaned auxiliary files in build directory.")
  end,
})

