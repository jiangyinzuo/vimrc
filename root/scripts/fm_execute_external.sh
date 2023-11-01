#!/bin/bash

case `file --mime-type -b $1` in
	image/*|application/postscript|application/vnd.openxmlformats-officedocument.presentationml.presentation)
		xdg-open $1 & ;;
	application/pdf)
		SumatraPDF.exe $1 & ;;
	*)
		xdg-open $1 & ;;
esac


