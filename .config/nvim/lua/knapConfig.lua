-- Set Okular as viewer using knap's global option (no setup() needed!)
local gknapsettings = {
    texoutputext = "pdf",
    textopdf = "pdflatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%",
    textopdfviewerlaunch = "okular %outputfile%",
    textopdfviewerrefresh = "kill -HUP %pid%"
}
vim.g.knap_settings = gknapsettings

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(ev)
    local bufnr = ev.buf
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set({ "n", "v", "i" }, "<F5>", function()
      require("knap").process_once()
    end, opts)

    vim.keymap.set({ "n", "v", "i" }, "<F6>", function()
      require("knap").close_viewer()
    end, opts)

    vim.keymap.set({ "n", "v", "i" }, "<F7>", function()
      require("knap").toggle_autopreviewing()
    end, opts)

    vim.keymap.set({ "n", "v", "i" }, "<F8>", function()
      require("knap").forward_jump()
    end, opts)
  end,
})
