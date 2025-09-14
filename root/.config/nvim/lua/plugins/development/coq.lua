if not require("config").load_plugin.development.coq then
	return {}
end

return {
	{ "whonore/Coqtail", cond = vim.g.has_coqtop_executable ~= 0, ft = "coq" },
}
