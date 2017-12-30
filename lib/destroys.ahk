NotifyDestroy:
SetTimer, NotifyDestroy, Off
WinFade("ahk_id " NOT_hwnd,0,25)
Gui, Notify: Destroy
return

CrosshairDestroy:
WinFade("ahk_id " CSV_hwnd,0,3)
WinFade("ahk_id " CSH_hwnd,0,3)
return