--////////////////////////////////////////////////////////////////////////////
-- Set Leader
--////////////////////////////////////////////////////////////////////////////
vim.g.mapleader = "\\"

local opts = { noremap = true, silent = true }

--//////////////////////////////////////////////////////////////////////////
-- Global Keybindings
--//////////////////////////////////////////////////////////////////////////

-- Scroll remapping
vim.api.nvim_set_keymap("n", "<ScrollWheelUp>",   "<C-y>", opts)
vim.api.nvim_set_keymap("n", "<C-f>", "30<C-e>", opts)
vim.api.nvim_set_keymap("n", "<C-b>", "30<C-y>", opts)
vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<C-e>", opts)
vim.api.nvim_set_keymap("v", "<ScrollWheelUp>",   "<C-y>", opts)
vim.api.nvim_set_keymap("v", "<ScrollWheelDown>", "<C-e>", opts)
vim.api.nvim_set_keymap("i", "<ScrollWheelUp>",   "<C-o><C-y>", opts)
vim.api.nvim_set_keymap("i", "<ScrollWheelDown>", "<C-o><C-e>", opts)

-- Disable Ctrl+Scroll entirely
for _, mode in ipairs({ "n", "v", "i" }) do
  vim.api.nvim_set_keymap(mode, "<C-ScrollWheelUp>",   "gk", opts)
  vim.api.nvim_set_keymap(mode, "<C-ScrollWheelDown>", "gj", opts)
end

-- Resize windows
vim.api.nvim_set_keymap("n", "<C-W>+", ":horizontal resize +10<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-W>-", ":horizontal resize -10<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-W>>", ":vertical resize +10<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-W><", ":vertical resize -10<CR>", opts)

-- LSP Actions
vim.api.nvim_set_keymap("n", "<LEADER>qf", 	":lua vim.lsp.buf.code_action()<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>e",  	":lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>E",  	":lua vim.diagnostic.goto_prev()<CR>", opts)

vim.api.nvim_set_keymap("i", "<C-l>",      	"<ESC>:noh<CR>i", opts)
vim.api.nvim_set_keymap("v", "<C-l>", 		":<C-u>noh<CR>gv", opts)

-- Tab navigation
vim.api.nvim_set_keymap("n", "<LEADER>tt", ":tabnew<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>tn", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>tp", ":tabprevious<CR>", opts)

-- Terminal
vim.api.nvim_set_keymap("n", "<LEADER>t", ":set splitbelow<CR>:10Term<CR>", opts)
vim.api.nvim_set_keymap("t", "<Esc>",      "<C-\\><C-n>", opts)

-- Save / Quit
vim.api.nvim_set_keymap("n", "<LEADER>w",  ":w<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>q",  ":q<CR>", opts)
vim.api.nvim_set_keymap("n", ":Q<CR>",  ":q<CR>", opts)
vim.api.nvim_set_keymap("n", "<LEADER>wq", ":wq<CR>", opts)

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
-- vim.api.nvim_set_keymap("n", "<C-l>", api.tree.change_root_to_node, opts)

-- Case-insensitive search
vim.api.nvim_set_keymap("n", "/", "/\\c", opts)

-- Undotree toggle
vim.api.nvim_set_keymap("n", "<LEADER>u", ":UndotreeToggle<CR>", opts)

--//////////////////////////////////////////////////////////////////////////
-- LaTeX-specific Keybindings
--//////////////////////////////////////////////////////////////////////////

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Vimtex compile
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>l', ':VimtexCompile<CR>', opts)

    -- Vimtex clean
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lc', ':VimtexClean<CR>', opts)

    -- LSP Bindings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'KK', ':lua vim.diagnostic.setloclist()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>re', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

    -- Build & View
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>b', ':VimtexCompile<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>v', ':VimtexView<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>o', ':VimtexTocOpen<CR>', opts)

    -- Navigation
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[s', ':VimtexGotoPrevSection<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']s', ':VimtexGotoNextSection<CR>', opts)

    -- Spell toggle
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>S', ':set spell!<CR>', opts)
  end
})

--//////////////////////////////////////////////////////////////////////////
-- C++ Programming Keybindings
--//////////////////////////////////////////////////////////////////////////

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
        local bufnr = vim.fn.bufnr('%')
        vim.keymap.set("n", "<cr>", function()
            vim.api.nvim_command([[execute "normal! \<cr>"]])
            vim.api.nvim_command(bufnr .. 'bd')
        end, { buffer = bufnr })
    end,
    pattern = "qf",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"cpp","c"},
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- LSP Bindings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>fu', '<cmd>lua findFunctionSymbols()<CR>i', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>re', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- Build with CMake
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>cmb', ':CMakeBuild<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>cmr', ':CMakeRun<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>cmt', ':CMakeToggleTerminal<CR>', opts)
  end
})
