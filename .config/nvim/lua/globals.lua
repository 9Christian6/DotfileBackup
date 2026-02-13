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
--Text formatting
--////////////////////////////////////////////////////////////////////////////

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown" },
  callback = function()
    local opt = vim.opt_local
    opt.wrap = true
    opt.linebreak = true
    opt.list = false
    opt.textwidth = 0
    opt.formatoptions:append("t")
    opt.formatoptions:remove("l")
  end,
})
-- vim.opt_local.wrap = true          -- visual wrapping
-- vim.opt_local.linebreak = true    -- wrap at word boundaries
-- vim.opt_local.list = false        -- no wrap junk characters
-- 
-- vim.opt_local.textwidth = 0       -- use window width for formatting
-- vim.opt_local.formatoptions:append("t") -- auto-wrap text
-- vim.opt_local.formatoptions:remove("l") -- never split words

--////////////////////////////////////////////////////////////////////////////
--Set code folding
--////////////////////////////////////////////////////////////////////////////
vim.opt.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.opt.foldenable = false

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
