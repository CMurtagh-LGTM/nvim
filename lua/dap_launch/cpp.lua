return {
	cpp = {
		{
			name = "Launch GDB",
			type = "gdb",
			request = "launch",
			program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = true,
		},
	},
}
