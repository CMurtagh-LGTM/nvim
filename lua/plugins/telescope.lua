return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function(_, opts)
      local fzf = require("fzf-lua")

      fzf.register_ui_select()

      vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', fzf.blines, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>f/', fzf.lines, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>fl',
        function() fzf.live_grep({ cwd = vim.fn.expand("%:p:h") }) end,
        { desc = "Find in buffer directory" })
      vim.keymap.set('n', '<leader>fs', fzf.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>ff', fzf.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>fq', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = '[S]earch [R]esume' })
      -- -- Doesn't work if I'm slow
      vim.keymap.set("n", 'q:', fzf.command_history, { desc = 'Command history' })
    end,
  },

  {
    'echasnovski/mini.files',
    version = '*',
    keys = { { '<leader>fd', function() require("mini.files").open() end, mode = "n", desc = "Browse Files" } },
    opts = {
      windows = {
        preview = true,
        width_preview = 75,
      },
    },
  },
}
