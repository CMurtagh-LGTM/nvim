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
        command = "/tool/pandora64/.package/gdb-16.2/bin/gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
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
    end
  },
}
