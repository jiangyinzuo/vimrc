return {
	settings = {
		texlab = {
			latexFormatter = "latexindent",
			latexindent = {
				["local"] = os.getenv("HOME") .. "/vimrc/root/latexindent.yaml",
				modifyLineBreaks = false,
			},
			bibtexFormatter = "texlab",
			formatterLineLength = 80,
		},
	},
}
