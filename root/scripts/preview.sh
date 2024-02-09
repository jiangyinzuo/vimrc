#!/bin/bash
# Used by `fzf.vim`, `fm`

# Run
# `xdg-mime query filetype <filename>` or
# `file --mime-type -b <filename>`
# to get mime type
case `file --mime-type -b $1` in
	inode/directory)
		ls --color=always $1 ;;
	application/pdf)
		pdftotext $1 - ;;
	text/*)
		if command -v batcat >/dev/null 2>&1; then
			catcmd="batcat -p --color=always"
		else
			catcmd=cat
		fi
		$catcmd $1 ;;
	application/postscript)
		timg -g 60x80 "$1" ;;
	application/vnd.openxmlformats-officedocument.presentationml.presentation)
		extract-pptx.py "$1" ;;
	image/*)
		# img2sixel "$1" ;;
		# chafa "$1" ;;
		timg -g 60x80 "$1" ;;
esac
