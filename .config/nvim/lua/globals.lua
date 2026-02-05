--////////////////////////////////////////////////////////////////////////////
--set variables
--////////////////////////////////////////////////////////////////////////////
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.path = vim.opt.path + "**"
vim.opt.wildmenu = true
vim.opt.mouse = 'a'
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.smarttab = true

--////////////////////////////////////////////////////////////////////////////
--Set code folding
--////////////////////////////////////////////////////////////////////////////
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.opt.foldenable = false

--////////////////////////////////////////////////////////////////////////////
--set colorscheme
--////////////////////////////////////////////////////////////////////////////
vim.cmd.colorscheme("onedark")
vim.api.nvim_set_hl(0, "Search", {bg = "#B31B97"})


vim.o.laststatus = 2  -- always show statusline

function closeQFIfLastBuff()
  local listed_buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  -- Only one buffer left
  if #listed_buffers == 1 then
    -- Close all quickfix windows
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
	vim.api.nvim_win_close(win.winid, true)
      end
    end
  end
end

-- Lua version
vim.api.nvim_create_autocmd({"BufDelete", "BufLeave"}, {
  callback = closeQFIfLastBuff
})
