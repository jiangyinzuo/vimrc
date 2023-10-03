#!/bin/bash

case `file --mime-type -b $1` in
	text/*)
		$EDITOR $1 ;;
	image/*|application/postscript)
		xdg-open $1 & ;;
	application/pdf)
		SumatraPDF.exe $1 & ;;
esac

