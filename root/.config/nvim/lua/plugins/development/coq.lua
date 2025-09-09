local detect = require("detect")
return {
	{ "whonore/Coqtail", cond = detect.has_coqtop_executable, ft = "coq" },
}
