return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    event = "VeryLazy",
    config = function()
      -- require('nvim-treesitter.install').compilers = { "/tools/pandora64/.package/gcc-12.2.0/bin/gcc" }
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c', 'cpp', 'lua', 'python', 'cmake', 'vimdoc', 'vim', 'bash', 'markdown', 'markdown_inline', 'regex', 'gdscript', 'godot_resource', 'gdshader', 'qmljs'
        },

        modules = {},
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<leader>v',
            node_incremental = '<leader>v',
            scope_incremental = '<c-s>', -- TODO
            node_decremental = '<leader>V',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['at'] = '@class.outer',
              ['it'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']t'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']T'] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[t'] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[T'] = '@class.outer',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>pf"] = "@function.outer",
              ["<leader>pc"] = "@class.outer",
            },
          },
        },
      }
    end,
  },

  {
    'andersevenrud/nvim_context_vt',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      min_rows = 50,
    },
  },

  {
    'Wansmer/sibling-swap.nvim',
    requires = { 'nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
    },
    keys = {
      { "<leader>,", mode = "n", function() require('sibling-swap').swap_with_left() end,  desc = "Swap treesitter left" },
      { "<leader>.", mode = "n", function() require('sibling-swap').swap_with_right() end, desc = "Swap treesitter right" },
    },
  },
}
