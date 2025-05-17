local function safeRequire(module)
	local success, loadedModule = pcall(require, module)
	if success then return loadedModule end
	return {}
end

return vim.tbl_deep_extend('error', {}, safeRequire("dap_launch.amd"), safeRequire("dap_launch.cpp"), safeRequire("dap_launch.godot"))
