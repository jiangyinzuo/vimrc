local root_markers = {
	"mvnw",
	"pom.xml",
	"gradlew",
	"build.gradle",
	"build.gradle.kts",
	"settings.gradle",
	"settings.gradle.kts",
	".git",
}

return {
	cmd = { vim.g.jdtls_exe, "--java-executable", vim.g.jdtls_java_exe },
	root_markers = root_markers,
	init_options = {
		bundles = {
			vim.fn.glob(
				vim.fn.stdpath("data")
					.. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin*.jar"
			),
		},
	},
	settings = {
		java = {
			configuration = {
				runtimes = vim.g.jdtls_java_runtimes,
			},
		},
	},
}
