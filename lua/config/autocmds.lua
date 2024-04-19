-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- BufferSpecific
vim.api.nvim_create_augroup('BufferStuff', { clear = true })
vim.api.nvim_create_autocmd(
  { 'TermOpen' },
  {
    callback = function()
      vim.api.nvim_set_option_value("spell", false, { scope = "local" })
      vim.api.nvim_set_option_value("number", false, { scope = "local" })
    end,
    group = "BufferStuff"
  }
)
vim.api.nvim_create_autocmd({ 'FileType' },
  { callback = function() vim.wo.spell = false end, pattern = "nofile", group = "BufferStuff" })
