command -nargs=0 DiffBufferSaveTempFile call diffbuffer#SaveTempFile()

command -nargs=0 DiffBuffer call diffbuffer#Diff()
" diff, delta, ...
command -nargs=1 -complete=custom,diffbuffer#ExternalToolsComplete DiffBufferExternal call diffbuffer#DiffExternal(<f-args>)
