lua << EOF
return require'packer'.startup({function()
use 'wbthomason/packer.nvim'

-- Language server protocol client
use 'neovim/nvim-lspconfig'
use 'kosayoda/nvim-lightbulb' -- Code action
use 'ray-x/lsp_signature.nvim' -- Signature Highlight
use 'brymer-meneses/grammar-guard.nvim' -- Grammar in markdown

-- Syntax
use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
use 'nvim-treesitter/nvim-treesitter-refactor'
use 'nvim-treesitter/nvim-treesitter-textobjects'

-- Icons
use 'kyazdani42/nvim-web-devicons'

-- Powerline
use 'hoob3rt/lualine.nvim'

-- Pretty tabs
use 'akinsho/bufferline.nvim'

-- Comments
use 'numToStr/Comment.nvim'

-- Tag manager
use 'ludovicchabant/vim-gutentags'

-- CursorHold time changer
use 'antoinemadec/FixCursorHold.nvim'

-- Dependency for telescope, git signs
use 'nvim-lua/plenary.nvim'

-- Finder 
use 'nvim-telescope/telescope.nvim'
use 'nvim-telescope/telescope-fzy-native.nvim'
use 'nvim-telescope/telescope-bibtex.nvim'
use 'nvim-telescope/telescope-file-browser.nvim'
use 'nvim-telescope/telescope-github.nvim'

-- Comment generator
use 'danymat/neogen'

-- Terminal
use 'akinsho/toggleterm.nvim'

-- Git
use 'lewis6991/gitsigns.nvim'

-- Undo tree
use 'mbbill/undotree'

-- Better wildmenu
use {'gelguy/wilder.nvim', run = ':UpdateRemotePlugins' }

-- Intent markers
use 'lukas-reineke/indent-blankline.nvim'

-- Keymap explainer
use 'folke/which-key.nvim'

-- Auto pairs
use 'windwp/nvim-autopairs'

-- Virtual text on search, required by scrollbar
use 'kevinhwang91/nvim-hlslens'

-- Scrollbar
use 'petertriho/nvim-scrollbar'

-- Startup Screen
use 'goolord/alpha-nvim'

-- Virtual text on close brackets
use 'haringsrob/nvim_context_vt'

-- See lsp progress
use 'j-hui/fidget.nvim'

-- Display colours
use 'norcalli/nvim-colorizer.lua'

-- Lsp diagnostics
-- use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

-- Resize focused windows
use 'beauwilliams/focus.nvim'

-- Dim unused variables
use 'narutoxy/dim.lua'

-- Tex
use 'lervag/vimtex'

-- orgmode
use 'nvim-orgmode/orgmode'

-- sxhkd highlighting
use 'kovetskiy/sxhkd-vim'

-- eww yuck highlighting
use 'elkowar/yuck.vim'

-- everforest colour theme
use 'sainnhe/everforest'
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})
EOF

" TODO Checkout nvim-dap (with telescope and coq_3p) possibly rcarriga/nvim-dap-ui, goto-preview, telescope-lsp-handlers.nvim, nvim-code-action-menu,
" windline or heirline or feline, telescope-vimwiki + vimwiki, ldelossa/gh.nvim
" m-demare/hlargs.nvim, ahmedkhalf/project.nvim, anuvyklack/hydra.nvim 
" checkout later after more development ray-x/navigator.lua, esensar/nvim-dev-container

" rust-tools.nvim

" For when move to lua shift-d/mappy.nvim, Olical/aniseed, https://github.com/nanotee/nvim-lua-guide

" Theme
set termguicolors
set background=dark
let g:everforest_background='medium'
colorscheme everforest

" Line numbers
set number
" Spelling check
set spelllang=en_gb
set spell
" tab size
set tabstop=4
set shiftwidth=4
set expandtab
" Hide the mode text
set noshowmode
" Use system clipboard
set clipboard=unnamedplus
" Allow unsaved hidden buffers
set hidden
" Allow mouse clicks
set mouse=a
" Use smartcase in searching
set smartcase
" Make the cursor stay in the middle quarter
set scrolloff=12
" Always show sign column
set signcolumn=yes
" Space ftw
let mapleader = " "
let maplocalleader = " "
" No folds
set foldlevelstart=99

" Some easy mappings
nnoremap <c-z> [s1z=``
inoremap <c-z> <Esc>[s1z=``a
" something is causing q: not to be <nop>
nnoremap q: <nop>
nnoremap Q <nop>

" Highlight yank
augroup highlight_yank
autocmd!
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=500, on_visual=true}
augroup END

" Which Key
set timeoutlen=250
lua << EOF
require("which-key").setup{
    plugins = {
        spelling = {
            enabled = true,
            suggestions = 20,
        },
    },
}
-- TODO document mappings
require("which-key").register({
    ["<leader>"] = {
    },
})
EOF
nnoremap  <cmd>WhichKey<cr>
inoremap  <cmd>WhichKey<cr>
vnoremap  <cmd>WhichKey<cr>

" Git Signs
lua << EOF
require('gitsigns').setup{
    signcolumn = false,
    numhl = true,
    on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', '<leader>]', '<cmd>Gitsigns next_hunk<CR>')
        map('n', '<leader>[', '<cmd>Gitsigns prev_hunk<CR>')

        -- Actions
        map('n', '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>')
        map('v', '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>')
        map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
        map('v', '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
        map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>')
        map('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
        map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>')
        map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>')
        map('n', '<leader>gd', '<cmd>Gitsigns diffthis<CR>')
        map('n', '<leader>gD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
        map('n', '<leader>gt', '<cmd>Gitsigns toggle_deleted<CR>')
    end
}
EOF

" Autocomplete 
lua require'coq_config'

" Tree sitter, autopairs and lsp
lua << EOF
local npairs = require("nvim-autopairs") 
local nvim_lsp = require('lspconfig')
local coq = require('coq')

_G.MUtils = {}

-- npairs

npairs.setup({
    check_ts = true,
    map_bs = false,
    disable_filetype = { "TelescopePrompt" , "vim", "rmd" },
})

local Rule = require('nvim-autopairs.rule')
npairs.add_rule(Rule("\\(","\\)","tex"))
npairs.add_rule(Rule("\\[","\\]","tex"))
npairs.add_rule(Rule("\\{","\\}","tex"))
npairs.add_rule(Rule("\\left(","\\right)","tex"))
npairs.add_rule(Rule("\\left[","\\right]","tex"))
npairs.add_rule(Rule("\\left{","\\right}","tex"))
npairs.add_rule(Rule("\\left.","\\right.","tex"))

-- Decide to do either coq or npairs keybinds

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
vim.api.nvim_set_keymap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

-- Tresitter
require('orgmode').setup_ts_grammar()

require'nvim-treesitter.configs'.setup {
    ensure_installed = {"python", "cpp", "lua", "latex", "r", "vim", "java", "gdscript", "godot_resource", "markdown", "org", "rust", "zig"},
    highlight = {
        enable = true,
        disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
        additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
    },
    indent = {
        enable = true,
    },
    autopairs = {
        enable = true,
    },
    refactor = {
        highlight_definitions = { enable = true },
        -- highlight_current_scope = { enable = true }, -- TODO change to some other ui
        -- Maybe work out if treesitter has better rename/goto_definition
    },
    textobjects = {
        -- TODO look at the other options
        -- swap = {
        --     enable = true,
        --     swap_next = {
        --         ["<leader>a"] = "@parameter.inner",
        --     },
        --     swap_previous = {
        --         ["<leader>A"] = "@parameter.inner",
        --     },
        -- },
    },
}

-- Orgmode TODO
require('orgmode').setup{
}


-- lsp

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    -- TODO work out incomming-outgoing calls
    -- Code lens?
    --buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>c', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>n', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    --buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    --buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>l', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)    

    -- TODO Maybe winbar?
    require "lsp_signature".on_attach({
        floating_window = true,
        hint_enable = false,
        max_height = 3,
    })
end

-- C++
local root_pattern = nvim_lsp.util.root_pattern('.git')
local function get_project_dir_lower()
    local filename = vim.fn.getcwd()
    -- Then the directory of the project
    local project_dirname = root_pattern(filename) or nvim_lsp.util.path.dirname(filename)
    -- And finally perform what is essentially a `basename` on this directory
    return string.lower(vim.fn.fnamemodify(nvim_lsp.util.find_git_ancestor(project_dirname), ':t'))
end

-- C++
if (get_project_dir_lower() == "nubots") then
    nvim_lsp.clangd.setup(coq.lsp_ensure_capabilities{
        on_attach = on_attach,
        -- TODO unhardcode
        cmd = {
            "/home/cameron/.config/nvim/docker_start.sh"
        },
    })
else
    nvim_lsp.ccls.setup (coq.lsp_ensure_capabilities{
        on_attach = on_attach,  
        init_options = {
            cache = {
                directory = ".ccls-cache"
            },
            clang = {
                extraArgs = {"-std=c++20"}
            }
        }
    })
end

-- Python
nvim_lsp.jedi_language_server.setup (coq.lsp_ensure_capabilities{
    on_attach = on_attach
})

-- efm Allows for formatters
if (get_project_dir_lower() == "nubots") then
    nvim_lsp.efm.setup (coq.lsp_ensure_capabilities{
        on_attach = on_attach,  
        init_options = {documentFormatting = true},
        filetypes = {"python"},
        settings = {
            languages = {
                python = {
                    {formatCommand = "black --quiet -", formatStdin = true},
                    {formatCommand = "isort --quiet -", formatStdin = true},
                    {lintCommand = "flake8 --max-line-length 120 --stdin-display-name={$INPUT} -", lintStdin = true},
                }
            }
        }
    })
else
    nvim_lsp.efm.setup (coq.lsp_ensure_capabilities{
        on_attach = on_attach,  
        init_options = {documentFormatting = true},
        filetypes = {"python"},
        settings = {
            languages = {
                python = {
                    {formatCommand = "black --quiet -", formatStdin = true},
                    {formatCommand = "isort --quiet -", formatStdin = true},
                    {formatCommand = "doq", formatStdin = true},  
                    {lintCommand = "flake8 --max-line-length 120 --stdin-display-name={$INPUT} -", lintStdin = true},
                    {lintCommand = "mypy --show-column-numbers"},
                }
            }
        }
    })
end

-- R
-- TODO work out why its not working for rmd
nvim_lsp.r_language_server.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- Grammar
require("grammar-guard").init()
nvim_lsp.grammar_guard.setup(coq.lsp_ensure_capabilities{
  cmd = { '/usr/bin/ltex-ls' }, -- add this if you install ltex-ls yourself
	settings = {
		ltex = {
            enabled = {'bibtex', 'html', 'latex', 'markdown', 'org', 'restructuredtext', 'rsweave', 'rmd'},
			language = "en",
			dictionary = {},
			disabledRules = {},
			hiddenFalsePositives = {},
		},
	},
})

-- Vimscript
nvim_lsp.vimls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- gdscript
nvim_lsp.gdscript.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- rust
nvim_lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- zig
nvim_lsp.zls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- lua
nvim_lsp.sumneko_lua.setup(coq.lsp_ensure_capabilities{
    settings = {
    Lua = {
        runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = false,
        },
    },
    },
})

-- Java :vomit:
nvim_lsp.jdtls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
    cmd = {"jdtls"},
})

EOF

" Code action lightbulb
let g:cursorhold_updatetime = 500

" bufferline
lua << EOF
local bufferline = require"bufferline"
local function safe_delete_buffer(num)
    xpcall(
        vim.cmd,
        function(err)
            print(err)
        end,
        string.format("bdelete %d", num)
    )
end
bufferline.setup {
  options = {
    numbers = "none",
    tab_size = 7,
    show_close_icon = false,
    close_command = safe_delete_buffer,
    right_mouse_command = safe_delete_buffer,
  }
}
EOF

" These commands will navigate through buffers in order
nnoremap <leader>} <cmd>BufferLineCycleNext<cr>
nnoremap <leader>{ <cmd>BufferLineCyclePrev<cr>
nnoremap <leader>b <cmd>BufferLinePick<cr>
nnoremap <leader>d <cmd>BufferLinePickClose<cr>

" lualine
lua << EOF
-- vim.opt.laststatus = 3
require('lualine').setup {
    options = {
        theme = 'everforest',
        component_separators = "",
        section_separators = "",
        globalstatus = true,
    },
    sections = {
        lualine_a = {
            {-- mode
                function()
                    local mode_names = {
                        V = 'VL',
                        [''] = 'VB',
                    }
                    if mode_names[vim.fn.mode()] == nil then
                        return string.upper(vim.fn.mode())
                    else
                        return mode_names[vim.fn.mode()]
                    end
                end,
            },
        },
        lualine_b = {{'branch', }},
        lualine_c = {
            {'filename', path = 1},
            {function() return '%=' end},
            { -- Lsp server name .
                function()
                    local msg = 'No Active Lsp'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then return msg end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = ' ',
                color = {gui = 'bold'}
            }
        },
        lualine_x = {
            {'filetype', colored = false}
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', file_status = false}},
        lualine_x = {{'filetype', colored = false}},
        lualine_y = {'location'},
        lualine_z = {}
    },
}
EOF

" UndoTree
" Put it on the right
let g:undotree_WindowLayout = 3
nnoremap <leader>u <cmd>UndotreeToggle<cr>

" Wilder
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     [
      \       wilder#check({_, x -> empty(x)}),
      \       wilder#history(),
      \     ],
      \     wilder#python_file_finder_pipeline({
      \       'file_command': ['find', '.', '-type', 'f', '-printf', '%P\n'],
      \       'dir_command': ['find', '.', '-type', 'd', '-printf', '%P\n'],
      \       'filters': ['fuzzy_filter', 'difflib_sorter'],
      \     }),
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \     }),
      \     wilder#python_search_pipeline({
      \         'pattern': 'fuzzy',
      \     }),
      \   ),
      \ ])
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': [
      \   wilder#pcre2_highlighter(),
      \   wilder#basic_highlighter(),
      \ ],
      \ 'left': [
      \   wilder#popupmenu_devicons(),
      \   wilder#popupmenu_buffer_flags(),
      \ ],
      \ 'right': [
      \   ' ',
      \   wilder#popupmenu_scrollbar(),
      \ ],
      \ }))

" Telescope
" Possible extensions telescope media files, telescope dap
" It'd be cool if undotree
nnoremap <leader>f<space> <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>

nnoremap <leader><leader>r <cmd>Telescope lsp_references<cr>
nnoremap <leader><leader>i <cmd>Telescope lsp_implementations<cr>
nnoremap <leader><leader>d <cmd>Telescope lsp_definitions<cr>
nnoremap <leader><leader>c <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader><leader>s <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader><leader>w <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader><leader>p <cmd>Telescope diagnostics<cr>

nnoremap <leader>fB <cmd>Telescope bibtex cite<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>lua require'telescope.builtin'.man_pages({sections={"2", "3", "3p", "4", "7"}})<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>

nnoremap <leader>fT <cmd>Telescope tags<cr>
nnoremap <leader>ft <cmd>Telescope treesitter<cr>

nnoremap <leader>f<leader> <cmd>Telescope builtin<cr>
nnoremap <leader>fp <cmd>Telescope planets<cr>

nnoremap <leader>g<leader> <cmd>Telescope git_status<cr>
nnoremap <leader>Gi <cmd>Telescope gh issues<cr>
nnoremap <leader>Gp <cmd>Telescope gh pull_request<cr>
nnoremap <leader>Gg <cmd>Telescope gh gist<cr>
nnoremap <leader>Gr <cmd>Telescope gh run<cr>

lua << EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    use_less = false,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil, 
  }
}
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('bibtex')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('gh')
EOF

" Neogen
lua << EOF
require('neogen').setup()
require("which-key").register({
    ["<leader>"] = {
        a = {"<cmd>Neogen<cr>", "Generate annotation"}
    },
})
EOF

" Indent Blankline
lua << EOF
require("indent_blankline").setup {
    buftype_exclude = {"terminal", "nofile"},
    show_current_context = true,
}
EOF

lua << EOF
require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  open_mapping = [[<leader>t]],
  insert_mappings = false,
  hide_numbers = true, -- hide the number column in toggleterm buffers
  start_in_insert = true,
  shade_terminals = false,
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
}

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
end
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
EOF

augroup toggleterm
    au!
    au TermOpen * setlocal nospell
augroup end

" Comment
lua << EOF
require('Comment').setup{
    ignore = "^$",
    toggler = {
        line = "<leader>cc",
        block = "<leader>cb",
    },
    opleader = {
        line = "<leader>cz",
        block = "<leader>cx",
    },
    mappings = {
        basic = true,
        extra = false,
        extended = false,
    },
}
EOF

" gutentags
let g:gutentags_project_root = [".enable_tags"]
let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files',
        \ '.enable_tags' : 'find . -type f',
        \ },
    \ }

" hlslens
nnoremap <silent> n <cmd>execute('normal! ' . v:count1 . 'n')<cr>
            \<cmd>lua require('hlslens').start()<cr>
nnoremap <silent> N <cmd>execute('normal! ' . v:count1 . 'N')<cr>
            \<cmd>lua require('hlslens').start()<cr>
nnoremap * *<cmd>lua require('hlslens').start()<cr>
nnoremap # #<cmd>lua require('hlslens').start()<cr>
nnoremap g* g*<cmd>lua require('hlslens').start()<cr>
nnoremap g# g#<cmd>lua require('hlslens').start()<cr>
nnoremap <leader>h :nohlsearch<cr>

" Scrollbar TODO come back when more developed
lua << EOF
local configuration = vim.fn['everforest#get_configuration']()
local palette = vim.fn['everforest#get_palette'](configuration.background, configuration.colors_override)
require("scrollbar").setup{
    show = true,
    handle = {
        text = " ",
        color = palette.bg0[1],
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    marks = {
        Search = { text = { "-", "=" }, priority = 0, color = palette.green[1] },
        Error  = { text = { "-", "=" }, priority = 1, color = palette.red[1] },
        Warn   = { text = { "-", "=" }, priority = 2, color = palette.orange[1] },
        Info   = { text = { "-", "=" }, priority = 3, color = palette.yellow[1] },
        Hint   = { text = { "-", "=" }, priority = 4, color = palette.blue[1] },
        Misc   = { text = { "-", "=" }, priority = 5, color = palette.purple[1] },
    },
    handlers = {
        diagnostic = true,
        search = true,
    },
}
EOF

" alpha-nvim
lua << EOF
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , "<cmd>ene <bar> startinsert <cr>"),
    dashboard.button( "f", "  > Find file", "<cmd>Telescope find_files<cr>"),
	dashboard.button("t", "  > Find text", "<cmd>Telescope live_grep <cr>"),
    dashboard.button( "r", "  > Recent"   , "<cmd>Telescope oldfiles<cr>"),
    dashboard.button("p", "  > Update plugins", "<cmd>PackerSync<cr>"),
    dashboard.button( "q", "  > Quit NVIM", "<cmd>qa<cr>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
EOF

" Figet
lua << EOF
require"fidget".setup{
  timer = {
    task_decay = 200,        -- how long to keep around completed task, in ms
  },
}
EOF

" Focus
lua << EOF
require"focus".setup{
    --excluded_filetypes = {"toggleterm"},
    number = false,
    cursorline = false,
    signcolumn = auto,
    colorcolumn = {enable = true, width = 120},
}
EOF
nnoremap <leader>m <cmd>FocusMaximise<cr>

" Colourizer
lua require'colorizer'.setup()

" TODO make toggle able
"augroup hover
"    au!
"    autocmd CursorHold *.py lua if vim.fn.pumvisible() then vim.lsp.buf.hover() end
"    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb{sign={enabled=false},virtual_text={enabled=true}}
"augroup END
" Dim
lua require('dim').setup({})

" Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
" TODO help command?
" augroup R_commands
"     au!
"     autocmd FileType rmd map <Leader>ll :!echo<space>"require(rmarkdown);<space>render(<afile>:p:S)"<space>\|<space>R<space>--vanilla<enter>
" augroup END
