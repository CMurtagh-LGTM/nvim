return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },

    config = function()
      -- TODO call hierarchy
      local call_hierarchy_handler = function(direction)
        return function(_, result)
          if not result then
            return
          end
          local items = {}
          for _, call_hierarchy_call in pairs(result) do
            local call_hierarchy_item = call_hierarchy_call[direction]
            for _, range in pairs(call_hierarchy_call.fromRanges) do
              table.insert(items, {
                filename = assert(vim.uri_to_fname(call_hierarchy_item.uri)),
                text = call_hierarchy_item.name,
                lnum = range.start.line + 1,
                col = range.start.character + 1,
              })
              vim.print(call_hierarchy_item.uri)
            end
          end
          --vim.fn.setqflist({}, ' ', { title = 'LSP call hierarchy', items = items })
          --api.nvim_command('botright copen')
        end
      end

      vim.lsp.handlers["callHierarchy/incomingCalls"] = call_hierarchy_handler('from')
      vim.lsp.handlers["callHierarchy/outgoingCalls"] = call_hierarchy_handler('to')
      vim.lsp.handlers["textDocument/definition"] = require('telescope.builtin').lsp_definitions
      vim.lsp.handlers["textDocument/references"] = require('telescope.builtin').lsp_references
      vim.lsp.handlers["textDocument/typeDefinition"] = require('telescope.builtin').lsp_type_definitions
      vim.lsp.handlers["textDocument/implementation"] = require('telescope.builtin').lsp_implementations
      vim.lsp.handlers["textDocument/documentSymbol"] = require('telescope.builtin').lsp_document_symbols
      vim.lsp.handlers["textDocument/workspaceSymbol"] = require('telescope.builtin').lsp_workspace_symbols

      -- Clang TODO move to on_attach
      vim.keymap.set('n', '<leader>dH', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = "Switch source header" })

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        local _ = client
        -- client.server_capabilities TODO gaurd binds by capabilities
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
        nmap('gr', vim.lsp.buf.references, 'Goto References')
        nmap('gD', vim.lsp.buf.type_definition, 'Type Definition')
        nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        nmap('<leader>ds', vim.lsp.buf.document_symbol, 'Document Symbols') -- Ariel?
        nmap('<leader>ws', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')

        nmap(
          '<leader>sd',
          function()
            vim.cmd.vsplit()
            vim.cmd.wincmd("l")
            vim.lsp.buf.definitions()
          end,
          'Split goto definition')

        nmap('<leader>k', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Documentation" })

        nmap('<leader>3', vim.lsp.buf.document_highlight, 'Document highlight')
        nmap('<leader>#', vim.lsp.buf.clear_references, 'Document unhighlight')
        nmap('<leader>Co', vim.lsp.buf.outgoing_calls, 'Outgoing calls')
        nmap('<leader>Ci', vim.lsp.buf.incoming_calls, 'Incoming calls')

        -- Lesser used LSP functionality
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

      end

      -- mason-lspconfig requires that these setup functions are called in this order
      -- before setting up the servers.
      require('mason').setup()
      require('mason-lspconfig').setup()

      local servers = {
        clangd = {},
        pyright = {},
        cmake = {},

        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- Setup neovim lua configuration
      require('neodev').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      {
        'hrsh7th/cmp-nvim-lsp',
        dependencies = { 'neovim/nvim-lspconfig' },
      },
      'FelipeLema/cmp-async-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Command line
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menuone,noselect,preview',
        },
        mapping = cmp.mapping {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<Down>'] = {
            i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          },
          ['<Up>'] = {
            i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          },
        },
        sources = {
          { name = 'nvim_lsp',   group_index = 1 },
          { name = 'luasnip',    group_index = 1 },
          { name = 'doxygen',    group_index = 2 },
          { name = 'async_path', group_index = 2 },
          { name = 'buffer',     group_index = 3 },
        },
      }
    end,
  },


  {
    'stevearc/conform.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    opts = {},
    keys = {
      { "<leader>df", mode = "n", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format" },
    },
    cmd = { "Format" },
    config = function(_, opts)
      local conform = require("conform")
      conform.setup(opts)

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        conform.format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    "aznhe21/actions-preview.nvim",
    opts = {},
    keys = {
      -- Should set up a lsp handler instead
      { "<leader>da", mode = "n", function() require("actions-preview").code_actions() end, desc = 'Code Action' },
    },
  },

  {
    'rmagatti/goto-preview',
    opts = {},
    keys = {
      { "<leader>pd", mode = "n", function() require("goto-preview").goto_preview_definition() end, desc = "Peek Definition" },
      { "<leader>pr", mode = "n", function() require("goto-preview").goto_preview_references() end, desc = "Peek References" },
    },
    -- TODO
    -- post_open_hook = function(buf, win)
    --         local orig_state = vim.api.nvim_buf_get_option(buf, 'modifiable')
    --         vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    --         vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    --             buffer = buf,
    --             callback = function()
    --                 vim.api.nvim_win_close(win, false)
    --                 vim.api.nvim_buf_set_option(buf, 'modifiable', orig_state)
    --                 return true
    --             end,
    --         })
    --     end
  },

  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      lsp = {
        auto_attach = true,
      },
      highlight = true,
    },
  },
}
