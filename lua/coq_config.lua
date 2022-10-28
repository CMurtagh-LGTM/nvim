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
local coq_utils = require("coq_3p.utils")
COQsources = COQsources or {}
COQsources[coq_utils.new_uid(COQsources)] = {
    name = "Sage",
    fn = (function(spec)
        local sage_path = vim.fn.exepath("sage")
        local locked = false
        return function(args, callback)
            local _, col = unpack(args.pos)
            local before_cursor = coq_utils.split_line(args.line, col)
            local match = coq_utils.match_tail("=", before_cursor)

            if (#sage_path <= 0) or locked or (#match <= 0) then
                callback(nil)
            else
                locked = true
                local stdout = {}
                local _, c_off = coq_utils.comment()
                local math = vim.trim(c_off(match))

                local fin = function()
                    local ans = table.concat(stdout, "")

                    if #ans <= 0 then
                        callback(nil)
                    else
                        local filter_text = (function()
                            local spaces = vim.fn.matchstr(before_cursor, [[\v\s+$]])
                            if #spaces > 0 then
                                return spaces
                            else
                                return vim.fn.matchstr(before_cursor, [[\v\=\s*$]])
                            end
                        end)()

                        callback {
                            isIncomplete = true,
                            items = {
                                {
                                    label = "= " .. ans,
                                    insertText = ans,
                                    detail = vim.trim(match) .. " = " .. ans,
                                    filterText = filter_text,
                                    kind = vim.lsp.protocol.CompletionItemKind.Value
                                }
                            }
                        }
                    end
                end

                local chan = vim.fn.jobstart(
                    {sage_path, "-c", string.format("print(n(%s))", math)},
                    {
                        stderr_buffered = true,
                        on_exit = function(_, code)
                            locked = false
                            if code == 0 then
                                fin()
                            else
                                callback(nil)
                            end
                        end,
                        on_stderr = function(_, msg)
                            coq_utils.debug_err(unpack(msg))
                        end,
                        on_stdout = function(_, lines)
                            vim.list_extend(stdout, lines)
                        end
                    }
                )

                if chan <= 0 then
                    locked = false
                    callback(nil)
                else
                    return function()
                        vim.fn.jobstop(chan)
                    end
                end
            end
        end
    end)({})
}
require("coq_3p") {
    { src = "nvimlua", short_name = "nLUA", conf_only = true },
    { src = "vimtex", short_name = "vTEX" },
    { src = "orgmode", short_name = "ORG" },
    { src = "figlet", short_name = "BIG", trigger = "!big", fonts = {"/usr/share/figlet/fonts/standard.flf"}},
}
