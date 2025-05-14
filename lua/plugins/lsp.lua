return {
    {
        -- LSP Configuration & Plugins
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim',       opts = {} },

            "ibhagwan/fzf-lua",
            "neovim/nvim-lspconfig",
        },

        config = function()
            local fzf = require("fzf-lua")
            local function switch_source_header(bufnr)
                local method_name = 'textDocument/switchSourceHeader'
                -- bufnr = util.validate_bufnr(bufnr)
                local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
                if not client then
                    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(
                        method_name))
                end
                local params = vim.lsp.util.make_text_document_params(bufnr)
                client.request(method_name, params, function(err, result)
                    if err then
                        error(tostring(err))
                    end
                    if not result then
                        vim.notify('corresponding file cannot be determined')
                        return
                    end
                    vim.cmd.edit(vim.uri_to_fname(result))
                end, bufnr)
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('my.lsp', {}),
                callback = function(args)
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

                    local nmap = function(keys, func, desc)
                        if desc then
                            desc = 'LSP: ' .. desc
                        end

                        vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
                    end


                    if client:supports_method("textDocument/references") then
                        nmap('grr', fzf.lsp_references, 'Goto References')
                    end
                    if client:supports_method("textDocument/implementation") then
                        nmap('gri', fzf.lsp_implementations, 'Goto Implementation')
                    end
                    if client:supports_method('textDocument/definition') then
                        nmap('grd', fzf.lsp_definitions, 'Goto Definition')
                        nmap(
                            '<leader>sd',
                            function()
                                vim.cmd.vsplit()
                                vim.cmd.wincmd("l")
                                vim.lsp.buf.definitions()
                            end,
                            'Split goto definition')
                    end
                    if client:supports_method('textDocument/typeDefinition') then
                        nmap('grD', fzf.lsp_typedefs, 'Type Definition')
                    end
                    -- if client:supports_method('textDocument/declaration') then
                    --   nmap('grs', fzf.lsp_declaration 'Type Declaration')
                    -- end
                    if client:supports_method('textDocument/documentSymbol') then
                        nmap('<leader>ds', vim.lsp.buf.document_symbol, 'Document Symbols') -- Ariel?
                    end
                    if client:supports_method('textDocument/workspaceSymbol') then
                        nmap('<leader>ws', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')
                    end

                    -- if client:supports_method('textDocument/signatureHelp') then
                    --   nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
                    --   -- insert mode is default
                    -- end

                    if client:supports_method('textDocument/documentHighlight') then
                        nmap('<leader>3', vim.lsp.buf.document_highlight, 'Document highlight')
                        nmap('<leader>#', vim.lsp.buf.clear_references, 'Document unhighlight')
                    end
                    if client:supports_method('callHierarchy/outgoingCalls') then
                        nmap('<leader>Co', vim.lsp.buf.outgoing_calls, 'Outgoing calls')
                    end
                    if client:supports_method('callHierarchy/incomingCalls') then
                        nmap('<leader>Ci', vim.lsp.buf.incoming_calls, 'Incoming calls')
                    end

                    if client:supports_method('textDocument/switchSourceHeader') then
                        nmap('<leader>dH', switch_source_header, "Switch source header")
                    end
                end,
            })

            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = {
                                'vim',
                                'require',
                            },
                        },
                    },
                },
            })

            vim.lsp.config('clangd', {
                root_markers = { '.clang-format', 'compile_commands.json' },
                capabilities = {
                    textDocument = {
                        completion = {
                            completionItem = {
                                snippetSupport = true,
                            }
                        }
                    }
                },
            })

            vim.lsp.config('godot', {
                cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
                root_markers = { 'project.godot', '.git' },
                filetypes = { "gdscript", "godot_resource", "gdshader" },
            })

            require('mason').setup()
            require('mason-lspconfig').setup {
                automatic_enable = false,
                ensure_installed = { "lua_ls", "cmake" },
            }

            vim.lsp.enable({ "lua_ls", "cmake", "clangd", "godot" })

            vim.lsp.handlers["textDocument/documentSymbol"] = fzf.lsp_document_symbols
            vim.lsp.handlers["textDocument/workspaceSymbol"] = fzf.lsp_workspace_symbols
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        -- Autocompletion
        'saghen/blink.cmp',
        dependencies = {
            "xzbdmw/colorful-menu.nvim",
        },
        version = '1.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'super-tab' },

            appearance = {
                nerd_font_variant = 'mono'
            },

            completion = {
                keyword = { range = 'full' },
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                menu = {
                    draw = {
                        -- We don't need label_description now because label and label_description are already
                        -- combined together in label by colorful-menu.nvim.
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                }
            },

            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },

            signature = { enabled = true },

            cmdline = {
                enabled = false, -- crashes
            },
        },
        opts_extend = { "sources.default" }
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

    {
        "zbirenbaum/neodim",
        event = "LspAttach",
        opts = {
            refresh_delay = 75,
            alpha = 0.75,
            blend_color = "#2D353B", -- TODO make this background colour from plugin
            hide = {
                underline = true,
                virtual_text = true,
                signs = true,
            },
            regex = {
                "[uU]nused",
                "[nN]ever [rR]ead",
                "[nN]ot [rR]ead",
            },
            priority = 128,
            disable = {},
        }
    },
}
