-- See: https://github.com/mfussenegger/nvim-jdtls
local config = {
	cmd = { "jdtls" },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	init_options = {
		bundles = {
			vim.fn.glob(
				vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin*.jar"
			),
		},
	},
}
require("jdtls").start_or_attach(config)
