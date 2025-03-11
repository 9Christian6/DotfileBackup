--////////////////////////////////////////////////////////////////////////////
-- Set Leader
--////////////////////////////////////////////////////////////////////////////
vim.g.mapleader = "\\"

vim.api.nvim_set_keymap(
	"n",
	"<C-W>+",
	":horizontal resize +10<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<C-W>-",
	":horizontal resize -10<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<C-W>>",
	":vertical resize +10<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<C-W><",
	":vertical resize -10<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>qf",
	":lua vim.lsp.buf.code_action()<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>e",
	":lua vim.diagnostic.goto_next()<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<C-l>",
	":noh<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>tt",
	":tabnew<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>tn",
	":tabnext<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>tp",
	":tabprevious<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>t",
	":set splitbelow<CR>:10Term<CR>",
	--":set splitbelow :vsplit term://zsh<CR>I",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"t",
	"<Esc>",
	"<C-\\><C-n>",
	{noremap = true}
)


vim.api.nvim_set_keymap(
	"n",
	"<LEADER>w",
	":w<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>q",
	":q<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>wq",
	":wq<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>f",
	":Telescope find_files hidden=true cwd=.<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<C-k>",
	"telescope.actions.move_selection_previous()",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"j",
	"gj",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"k",
	"gk",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>l",
	":VimtexCompile<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>g",
	"<CMD>lua vim.lsp.buf.definition()<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>r",
	"<CMD>lua vim.lsp.buf.references()<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<F6>",
	":NvimTreeToggle<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>cm",
	":CMakeBuild<CR>",
	{noremap = true}
)
