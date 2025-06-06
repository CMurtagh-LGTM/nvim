return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = {
          winbar = {
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
            default_section = "repl",
            controls = {
              enabled = true,
            },
          },
          windows = {
            terminal = {
              start_hidden = true,
            },
          },
        }
      },
    },
    config = function()
      local dap = require("dap")
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }
      dap.adapters.godot = {
        type = "server",
        host = '127.0.0.1',
        port = 6006,
      }

      dap.configurations = require('dap_launch')

      local dap_view = require("dap-view")
      dap.listeners.before.attach["dap-view-config"] = function()
        dap_view.open()
      end
      dap.listeners.before.launch["dap-view-config"] = function()
        dap_view.open()
      end
      dap.listeners.before.event_terminated["dap-view-config"] = function()
        dap_view.close()
      end
      dap.listeners.before.event_exited["dap-view-config"] = function()
        dap_view.close()
      end

      vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
      vim.api.nvim_create_user_command("DapRunLast", function() dap.run_last() end,
        { nargs = 0, desc = "Run last debug config" })
      vim.api.nvim_create_user_command("DapSetBreakpoint", function(args) dap.set_breakpoint(args.fargs[1]) end,
        { nargs = "?", desc = "Set breakpoint with condition" })

      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = '', linehl = '', numhl = '' })
    end
  },
}
