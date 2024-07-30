-- See: https://github.com/mfussenegger/nvim-jdtls

local root_dir = vim.env.PWD

local config = {
	cmd = { "jdtls", "--java-executable", vim.g.java_exe_for_jdtls },
	root_dir = root_dir,
	init_options = {
		bundles = {
			vim.fn.glob(
				vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin*.jar"
			),
		},
	},
	settings = {
		java = {
			configuration = {
				-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				-- And search for `interface RuntimeOption`
				-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
				runtimes = {
					-- Ubuntu
					{
						name = "JavaSE-11",
						path = "/lib/jvm/java-11-openjdk-amd64/",
					},
					{
						name = "JavaSE-17",
						path = "/lib/jvm/java-17-openjdk-amd64/",
					},
				}
			}
		}
	}
}
require("jdtls").start_or_attach(config)
