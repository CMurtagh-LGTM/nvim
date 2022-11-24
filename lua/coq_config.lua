require('packer').use{'ms-jpq/coq_nvim', run = ':COQdeps', branch = 'coq'}
require('packer').use{'ms-jpq/coq.artifacts', branch = 'artifacts', requires = 'ms-jpq/coq_nvim'}
require('packer').use{'ms-jpg/coq.thirdparty', requires = 'ms-jpq/coq_nvim', branch = '3p'}

vim.g.coq_settings = {keymap = {recommended = false, jump_to_mark = ""}, auto_start = "shut-up"}
vim.api.nvim_set_keymap("i", "<Esc>", "pumvisible() ? \"\\<C-e><Esc>\" : \"\\<Esc>\"", {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-c>", "pumvisible() ? \"\\<C-e><C-c>\" : \"\\<C-c>\"", {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<Tab>", "pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"", {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "pumvisible() ? \"\\<C-p>\" : \"\\<BS>\"", {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-H>", "<cmd>lua if require(\"neogen\").jumpable() then require(\"neogen\").jump_next() else COQ.Nav_mark() end<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-H>", "<cmd>lua if require(\"neogen\").jumpable() then require(\"neogen\").jump_next() else COQ.Nav_mark() end<cr>", {noremap = true})

-- TODO when add dap, add dap mode
require("coq_3p") {
    { src = "nvimlua", short_name = "nLUA", conf_only = true },
    { src = "vimtex", short_name = "vTEX" },
    { src = "orgmode", short_name = "ORG" },
    { src = "figlet", short_name = "BIG", trigger = "!big", fonts = {"/usr/share/figlet/fonts/standard.flf"}},
}
