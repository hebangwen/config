#SingleInstance  ; 只允许一个此脚本运行

Menu, tray, add
Menu, tray, add, 中文模式
Menu, tray, add, 西文模式
Menu, tray, add, 关闭功能

; 默认模式
global mode := 0
Menu, tray, Check, 中文模式

return

中文模式:
    mode := 0
    Menu, %A_ThisMenu%, Check, %A_ThisMenuItem%
    Menu, %A_ThisMenu%, UnCheck, 西文模式
    Menu, %A_ThisMenu%, UnCheck, 关闭功能
return

西文模式:
    mode := 1
    Menu, %A_ThisMenu%, Check, %A_ThisMenuItem%
    Menu, %A_ThisMenu%, UnCheck, 中文模式
    Menu, %A_ThisMenu%, UnCheck, 关闭功能
return

关闭功能:
    mode := 2
    Menu, %A_ThisMenu%, Check, %A_ThisMenuItem%
    Menu, %A_ThisMenu%, UnCheck, 中文模式
    Menu, %A_ThisMenu%, UnCheck, 西文模式
return

#IfWinActive ahk_exe SumatraPDF.exe  ; 检测 SumatraPDF.exe 是否活动
^c::  ; 按下 Ctrl+C 组合键时
    ; 进行常规复制命令
    clipboard := ""   ; 清空剪贴板（配合 ClipWait 提高脚本健壮性）
    Send ^c           ; 发送 Ctrl+C 组合键（#IfWinActive 使此处自动恢复为复制功能）
    ClipWait          ; 等待剪贴板不为空

    ; 中文模式：删除换行、删除空格
    if (mode = 0)
    {
        clipboard := StrReplace(clipboard, "`r`n", "")
        clipboard := StrReplace(clipboard, " ", "")
    }
    ; 西文模式：将换行替换为空格、删除行尾连字符
    else if (mode = 1)
    {
        clipboard := StrReplace(clipboard, "`r`n", " ")
        clipboard := StrReplace(clipboard, "- ", "")
    }
return

