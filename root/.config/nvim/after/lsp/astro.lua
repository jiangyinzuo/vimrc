return {
	before_init = function(_, config)
		local root = config.root_dir or vim.fn.getcwd()
		local function has_typescript_runtime(tsdk)
			return vim.fn.filereadable(vim.fs.joinpath(tsdk, "typescript.js")) == 1
				or vim.fn.filereadable(vim.fs.joinpath(tsdk, "tsserverlibrary.js")) == 1
		end

		local local_tsdk = vim.fs.joinpath(root, "node_modules", "typescript", "lib")
		local global_root = vim.fn.systemlist({ "npm", "root", "-g" })[1]
		local global_tsdk = global_root and vim.fs.joinpath(global_root, "typescript", "lib")
		local tsdk = has_typescript_runtime(local_tsdk) and local_tsdk
			or (global_tsdk and has_typescript_runtime(global_tsdk) and global_tsdk)

		if tsdk then
			config.init_options = config.init_options or {}
			config.init_options.typescript = config.init_options.typescript or {}
			config.init_options.typescript.tsdk = tsdk
		end
	end,
}
