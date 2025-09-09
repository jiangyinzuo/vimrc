if not require("config").load_plugin.development.coq then
	return {}
end

local detect = require("detect")
return {
	{ "whonore/Coqtail", cond = detect.has_coqtop_executable, ft = "coq" },
}
