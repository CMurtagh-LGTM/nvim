-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'
vim.o.mousemodel = 'extend'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,preview'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Tab default when sleuth cannot find it
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.expandtab = true

-- TODO underline spell
vim.api.nvim_set_hl(0, 'SpellBad', { bg = "#543A48" })
vim.o.spelllang = 'en_gb'
vim.o.spell = true

vim.o.scrolloff = 16
vim.o.sidescrolloff = 8

-- when scrollbind also do horizontal
vim.o.scrollopt = 'ver,hor,jump'

vim.o.breakindent = true

-- vim.o.inccommand = "split" -- As cool as this is, it is visually annoying

-- Default use open split
vim.o.switchbuf = "useopen,uselast"

-- Hide default command line
vim.o.cmdheight = 0
vim.o.ls = 0
vim.o.showmode = false
vim.o.ruler = false
vim.api.nvim_set_hl(0, 'Statusline', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'StatuslineNC', { link = 'Normal' })
local str = string.rep('-', vim.api.nvim_win_get_width(0))
vim.opt.statusline = str
