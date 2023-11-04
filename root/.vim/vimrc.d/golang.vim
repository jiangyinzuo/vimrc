" 1. `godef`：godef 是 Go 语言的一个老工具，可以快速找到定义的位置。它的优点是简单快捷，但缺点是功能相对单一，不支持如代码提示、重构和诊断等功能。
" 
" 2. `guru`：guru 提供了更多高级功能，如查找所有引用、查找接口实现等。然而，它的使用相对更复杂，也需要更多的计算资源。
" 
" 3. `gopls`：gopls 是 Go 团队发布的官方语言服务器，功能最为全面，包括代码自动完成、查找定义、重构、诊断等。由于是官方工具，与最新的 Go 语言特性和改动的兼容性也最好。然而，它可能会比较消耗计算资源。
" 
" 现在来看，`gopls`可能是最全面且最实用的选择。作为官方的 Go 语言服务器，它可以提供全面的 IDE 功能，并且可以完全兼容最新的 Go 语言特性。然而，如果你只需要一些简单的功能，比如快速查找定义，那么`godef`可能就足够了。而`guru`则介于两者之间，提供了一些更高级的功能，但也更复杂一些。
" 

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
"  rg -oIN Go[a-zA-Z]+ commands.vim
Plug 'fatih/vim-go', { 'on': ['GoRename', 'GoGuruScope',  'GoPointsTo',  'GoWhicherrs',  'GoCallees',  'GoDescribe',  'GoCallstack', 'GoFreevars',  'GoChannelPeers',  'GoImplements',  'GoReferrers',  'GoSameIds',  'GoSameIdsClear',  'GoSameIdsToggle',  'GoSameIdsAutoToggle',  'GoCallers',  'GoAddTags',  'GoRemoveTags',  'GoModFmt',  'GoFiles',  'GoDeps',  'GoInfo',  'GoAutoTypeInfoToggle',  'GoBuild',  'GoBuildTags',  'GoGenerate',  'GoRun',  'GoInstall',  'GoTest',  'GoTestCompile',  'GoTestFile',  'GoTestFunc',  'GoCoverage',  'GoCoverageClear',  'GoCoverageToggle',  'GoCoverageBrowser',  'GoCoverageOverlay',  'GoPlay',  'GoDef',  'GoDefType',  'GoDefPop',  'GoDefStack',  'GoDefStackClear',  'GoDoc',  'GoDocBrowser',  'GoFmt',  'GoFmtAutoSaveToggle',  'GoImports',  'GoAsmFmtAutoSaveToggle',  'GoDrop',  'GoImport',  'GoImportAs',  'GoMetaLinter',  'Gometa',  'GoMetaLinterAutoSaveToggle',  'GoLint',  'Golint',  'GoVet',  'GoErrCheck',  'GoAlternate',  'GoDecls',  'GoDeclsDir',  'GoImpl',  'GoTemplateAutoCreateToggle',  'GoKeyify',  'GoFillStruct',  'GoDebugStart',  'GoDebugStart',  'GoDebugTest',  'GoDebugTestFunc',  'GoDebugAttach',  'GoDebugConnect',  'GoDebugBreakpoint',  'GoReportGitHubIssue',  'GoIfErr',  'GoAddWorkspace',  'GoLSPDebugBrowser',  'GoDiagnostics',  'GoModReload',  'GoToggleTermCloseOnExit',  'GoExtract']}
if v:version >= 801
  Plug 'sebdah/vim-delve', { 'for': 'go' }
endif
" 禁用vim-go的lsp功能，使用coc.nvim的lsp
let g:go_gopls_enabled = 0
let g:go_auto_type_info = 0
let g:go_code_completion_enabled = 0
let g:go_auto_sameids = 0
let g:go_fmt_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_diagnostics_enabled = 0
let g:go_echo_go_info = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = 'goimports'
let g:go_snippet_engine = "ultisnips" "optional neosnippet
let g:go_list_type = "quickfix"

let g:go_highlight_functions = 1
let g:go_highlight_function_closures = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_build_constraints = 1

" nmap <silent> gr :GoReferrers<CR>
"
let g:go_debug = []
let g:go_test_timeout = '10s'

" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_enabled = 0
let g:go_metalinter_deadline = "5s"
let g:go_metalinter_autosave = 0

