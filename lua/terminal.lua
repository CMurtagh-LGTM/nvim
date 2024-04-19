local M = {}

local term_callback = function() end
local shell_callback = function(_, data)
  vim.api.nvim_chan_send(M.channel_id, data)
end

M.term_buf = vim.api.nvim_create_buf(true, true)
vim.api.nvim_buf_set_name(M.term_buf, "terminal")
M.channel_id = vim.api.nvim_open_term(M.term_buf, { on_input = term_callback })

-- neovim 0.10
M.shell = vim.system({"csh"}, { stdin = true, stdout = shell_callback }, function() end)

return M
