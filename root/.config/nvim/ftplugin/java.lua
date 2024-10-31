-- See: https://github.com/mfussenegger/nvim-jdtls

local root_dir = vim.env.PWD

local config = {
	cmd = { vim.g.jdtls_exe, "--java-executable", vim.g.jdtls_java_exe },
	root_dir = root_dir,
	init_options = {
		bundles = {
			-- vscode java debug
			vim.fn.glob(
				vim.fn.stdpath("data")
					.. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin*.jar"
			),
		},
	},
	settings = {
		java = {
			configuration = {
				-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				-- And search for `interface RuntimeOption`
				-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
				runtimes = vim.g.jdtls_java_runtimes,
			},
		},
	},
}
require("jdtls").start_or_attach(config)
