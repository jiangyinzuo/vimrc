#!/bin/bash

case `file --mime-type -b $1` in
	inode/directory)
		ls --color=always $1 ;;
	application/pdf)
		pdftotext $1 - ;;
	text/*)
		bat -p --color=always $1 ;;
	application/postscript)
		timg -g 60x80 $1 ;;
	application/vnd.openxmlformats-officedocument.presentationml.presentation)
		extract-pptx.py "$1" ;;
esac
