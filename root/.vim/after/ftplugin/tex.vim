" 选中想格式化的段落后，可以用gq格式化
" 设置textwidth，可以让文本格式化时自动换行
" 内置的format会考虑virtual text，如果需要忽略virtual
" text，可以使用外部命令行工具，比如
" set formatprg=par\ 80
" set formatprg=fmt\ -w81\ -g81
" See: https://github.com/vim/vim/issues/14276
setlocal textwidth=80
setlocal tabstop=2 shiftwidth=2 softtabstop=2
if exists('$WSLENV')
	" [[palette]]打开当前tex文件中PDF对应的pptx文件			:OpenPPTX
	command -buffer -nargs=0 OpenPPTX call latex#OpenPPTX()
endif
