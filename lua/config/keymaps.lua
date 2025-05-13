-- document existing key chains
local wk = require("which-key")
wk.add {
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Comment" },
  { "<leader>C", group = "Calls" },
  { "<leader>d", group = "Document" },
  { "<leader>f", group = "Find" },
  { "<leader>p", group = "Peek" },
  { "<leader>q", group = "Diagnostics" },
  { "<leader>r", group = "Replace" },
  { "<leader>s", group = "Split" },
  { "<leader>w", group = "Workspace" },
  { "<leader>", group = "VISUAL <leader>", mode = "v" },
}

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.open_float, { desc = 'Preview diagnostic message' })

-- Terminal
vim.keymap.set('t', '<esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<esc>', function()
  vim.cmd.nohls()
  vim.cmd.redrawtabline()
end)

-- Clean deleting
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "c", '"_c')

-- Better movement
vim.keymap.set("n", "J", "", { desc = "Bah" })
--vim.keymap.set("n", "K", "{", { desc = "Previous empty line" })
vim.keymap.set("n", "H", "0^", { desc = "Start of line" })
vim.keymap.set("n", "L", "$", { desc = "End of line" })
vim.keymap.set("n", "M", "J", { desc = "Merge" })
