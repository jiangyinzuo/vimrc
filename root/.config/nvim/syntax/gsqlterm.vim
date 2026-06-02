" ------------------------------------------------------------
" Output messages
" ------------------------------------------------------------

syntax match gsqlFatal   /^\s*\zsFATAL\ze:/
syntax match gsqlError   /^\s*\zsERROR\ze:/
syntax match gsqlWarning /^\s*\zsWARNING\ze:/
syntax match gsqlInfo    /^\s*\zsINFO\ze:/
syntax match gsqlNotice  /^\s*\zsNOTICE\ze:/
syntax match gsqlLog     /^\s*\zsLOG\ze:/
syntax match gsqlDebug   /^\s*\zsDEBUG[1-5]\?\ze:/

syntax match gsqlDetail  /^\s*\zsDETAIL\ze:/
syntax match gsqlHint    /^\s*\zsHINT\ze:/
syntax match gsqlContext /^\s*\zsCONTEXT\ze:/

" ------------------------------------------------------------
" SQL input lines only
"
" Matches:
"   gaussdb=# select 1;
"   gaussdb-# from t;
"   dbname=> \d
" ------------------------------------------------------------

syntax case ignore

syntax keyword gsqlDml contained
      \ select insert update delete merge replace copy

syntax keyword gsqlDdl contained
      \ create alter drop truncate rename comment grant revoke vacuum

syntax keyword gsqlTxn contained
      \ begin start commit rollback savepoint release transaction

syntax keyword gsqlClause contained
      \ from where group by having order limit offset table
      \ into values set returning
      \ join inner left right full outer cross on using
      \ union intersect except all distinct
      \ as and or not is in exists between like ilike
      \ case when then else end with recursive

syntax keyword gsqlType contained
      \ int integer bigint smallint serial bigserial
      \ text varchar char character numeric decimal float double real
      \ boolean bool date time timestamp interval
      \ json jsonb bytea uuid oid

syntax keyword gsqlBuiltin contained
      \ count sum avg min max coalesce nullif
      \ generate_series repeat now clock_timestamp
      \ substring split_part length lower upper

syntax case match

" 字符串：内部不再允许其它 contained 语法项生效
syntax region gsqlString contained start=/'/ skip=/''/ end=/'/ contains=NONE
syntax region gsqlQuotedIdent contained start=/"/ skip=/""/ end=/"/ contains=NONE

syntax match  gsqlLineComment contained /--.*$/
syntax region gsqlBlockComment contained start="/\*" end="\*/"
syntax match  gsqlMetaCommand contained /\v\\[A-Za-z?!.][A-Za-z0-9_?!.]*/

syntax cluster gsqlSql contains=
      \ gsqlDml,
      \ gsqlDdl,
      \ gsqlTxn,
      \ gsqlClause,
      \ gsqlType,
      \ gsqlBuiltin,
      \ gsqlString,
      \ gsqlQuotedIdent,
      \ gsqlLineComment,
      \ gsqlBlockComment,
      \ gsqlMetaCommand

syntax region gsqlInputLine
      \ matchgroup=gsqlPrompt
      \ start=/^\S\+\s*[-=][#>]\s*/
      \ end=/$/
      \ contains=@gsqlSql
      \ keepend

" ------------------------------------------------------------
" Highlight links
" ------------------------------------------------------------


highlight default link gsqlFatal WarningMsg
highlight default link gsqlError WarningMsg
highlight default link gsqlWarning WarningMsg
highlight default link gsqlInfo MoreMsg
highlight default link gsqlNotice MoreMsg
highlight default link gsqlLog MoreMsg
highlight default link gsqlDebug MoreMsg

highlight default link gsqlDetail Identifier
highlight default link gsqlHint Identifier
highlight default link gsqlContext Identifier

highlight default link gsqlDml Keyword
highlight default link gsqlDdl PreProc
highlight default link gsqlTxn Special
highlight default link gsqlClause Conditional
highlight default link gsqlType Type
highlight default link gsqlBuiltin Function
highlight default link gsqlString String
highlight default link gsqlQuotedIdent Identifier
highlight default link gsqlLineComment Comment
highlight default link gsqlBlockComment Comment
highlight default link gsqlMetaCommand PreProc
