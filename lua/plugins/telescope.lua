return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        opts = {
          hint = 'floating-big-letter',
          filter_rules = {
            include_current_win = true,
          },
        },
      },
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
          sorting_strategy = "ascending",
          path_display = { shorten = 3, truncate = 0 },
          dynamic_preview_title = true,
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ["D"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top
              },
            },
          },
          lsp_references = {
            get_selection_window = require('window-picker').pick_window,
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      require 'telescope'.load_extension('undo')
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("ui-select")

      -- See `:help telescope.builtin`
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>f/',
        function()
          require('telescope.builtin').live_grep({ grep_open_files = true, prompt_title = 'Live Grep in Open Files', })
        end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>fl',
        function() require('telescope.builtin').live_grep({ cwd = require('telescope.utils').buffer_dir() }) end,
        { desc = "Find in buffer directory" })
      vim.keymap.set('n', '<leader>fs', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>fq', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set("n", "<leader>fu", require("telescope").extensions.undo.undo, { desc = '[U]ndo Tree' })
      vim.keymap.set('n', '<leader>fd', require('telescope').extensions.file_browser.file_browser,
        { desc = 'Browse files' })
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Browse Buffers' })
      -- Doesn't work if I'm slow
      vim.keymap.set("n", 'q:', require('telescope.builtin').command_history, { desc = 'Command history' })
    end,
  },
}
