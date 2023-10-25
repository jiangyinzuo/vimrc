#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Usage: ppt2pdf.sh <pptx file>"
	exit 1
fi

win_path=$(wslpath -w $(pwd))
ps_path='D://convert-pptx.ps1'

powershell.exe "$ps_path -inputFile '$win_path//$1' -outputType 'pdf'"

