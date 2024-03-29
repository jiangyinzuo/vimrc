; https://github.com/alacritty/alacritty/issues/2324
#Requires AutoHotkey v2

#HotIf WinActive("ahk_exe Alacritty-v0.12.2-portable.exe")

; Ctrl+Shift+V -- change line endings
^+v::
{
    A_Clipboard := StrReplace(A_Clipboard, "`r`n", "`n")
    Send("^+v")
}
return

#HotIf

