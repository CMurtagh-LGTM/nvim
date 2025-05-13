return {
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colours = {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }

      local TablineUpdateCallback = vim.schedule_wrap(function()
        vim.cmd.redrawtabline()
      end)

      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1) -- :h mode()
        end,
        static = {
          mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "N",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
        },
        provider = function(self)
          return self.mode_names[self.mode]
        end,
        update = {
          "ModeChanged",
          callback = TablineUpdateCallback,
        },
      }    

      -- local Diagnostics = {

      --   condition = conditions.has_diagnostics,

      --   static = {
      --     error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      --     warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      --     info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      --     hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
      --   },

      --   init = function(self)
      --     self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      --     self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      --     self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      --     self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      --   end,

      --   update = { "DiagnosticChanged", "BufEnter" },

      --   {
      --     provider = "![",
      --   },
      --   {
      --     provider = function(self)
      --       -- 0 is just another output, we can decide to print it or not!
      --       return self.errors > 0 and (self.error_icon .. self.errors .. " ")
      --     end,
      --     hl = { fg = "diag_error" },
      --   },
      --   {
      --     provider = function(self)
      --       return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
      --     end,
      --     hl = { fg = "diag_warn" },
      --   },
      --   {
      --     provider = function(self)
      --       return self.info > 0 and (self.info_icon .. self.info .. " ")
      --     end,
      --     hl = { fg = "diag_info" },
      --   },
      --   {
      --     provider = function(self)
      --       return self.hints > 0 and (self.hint_icon .. self.hints)
      --     end,
      --     hl = { fg = "diag_hint" },
      --   },
      --   {
      --     provider = "]",
      --   },
      -- }

      local MacroRec = {
        condition = function()
          return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        provider = " ",
        hl = { fg = "orange", bold = true },
        utils.surround({ "[", "]" }, nil, {
          provider = function()
            return vim.fn.reg_recording()
          end,
          hl = { fg = "green", bold = true },
        }),
        update = {
          "RecordingEnter",
          "RecordingLeave",
          callback = TablineUpdateCallback,
        }
      }

      -- local SearchCount = {
      --   condition = function()
      --     return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
      --   end,
      --   init = function(self)
      --     local ok, search = pcall(vim.fn.searchcount)
      --     if ok and search.total then
      --       self.search = search
      --     end
      --   end,
      --   provider = function(self)
      --     local search = self.search
      --     return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
      --   end,
      -- }

      local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }
      -- We can now define some children separately and add them later

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
            { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end
      }

      local FileName = {
        provider = function(self)
          -- first, trim the pattern relative to the current directory. For other
          -- options, see :h filename-modifers
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then return "[No Name]" end
          -- now, if the filename would occupy more than 1/4th of the available
          -- space, we trim the file path to its initials
          -- See Flexible Components section below for dynamic truncation
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = "green" },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "",
          hl = { fg = "orange" },
        },
      }

      -- Now, let's say that we want the filename color to change if the buffer is
      -- modified. Of course, we could do that directly using the FileName.hl field,
      -- but we'll see how easy it is to alter existing components using a "modifier"
      -- component

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force = true }
          end
        end,
      }

      -- let's add the children to our FileNameBlock component
      FileNameBlock = utils.insert(FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = '%<' }                      -- this means that the statusline is cut here when there's not enough space
      )

      local Navic = {
        condition = function() return require("nvim-navic").is_available() and conditions.is_active() end,
        provider = function()
          return require("nvim-navic").get_location({ highlight = true })
        end,
        update = 'CursorMoved'
      }

      local Tabpage = {
        provider = function(self)
          return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
        end,
        hl = function(self)
          if not self.is_active then
            return "TabLine"
          else
            return "TabLineSel"
          end
        end,
      }

      local TabPages = {
        -- only show this component if there's 2 or more tabpages
        condition = function()
          return #vim.api.nvim_list_tabpages() >= 2
        end,
        { provider = "%=" },
        utils.make_tablist(Tabpage),
      }

      local Ruler = {
        provider = "%3l:%2c",
        update = {
          'CursorMoved',
          'CursorMovedI',
          callback = TablineUpdateCallback,
        }
      }

      local Align = { provider = "%=" }
      local Space = { provider = " " }

      local StatusLines = {
        utils.surround({ "", "" }, function(self) return self:mode_color() end, { ViMode, hl = { fg = 'black' } }),
        --Diagnostics,
        Align,
        MacroRec,
        SearchCount,
        TabPages,
        Space,
        utils.surround({ "", "" }, function(self) return self:mode_color() end, { Ruler, hl = { fg = 'black' } }),
        static = {
          mode_colors_map = {
            n = "green",
            i = "white",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "purple",
          },
          mode_color = function(self)
            local mode = conditions.is_active() and vim.fn.mode() or "n"
            return self.mode_colors_map[mode]
          end,
        },
      }
      vim.opt.showtabline = 2

      require("heirline").setup({
        tabline = StatusLines,
        winbar = { FileNameBlock, Align, Navic },
        opts = {
          disable_winbar_cb = function(args)
            return conditions.buffer_matches({
              buftype = { "nofile", "prompt", "help", "quickfix" },
              filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
            }, args.buf)
          end,
          colors = colours,
        }
      })
    end,
  },
}
