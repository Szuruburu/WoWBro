NotifyDestroy:
SetTimer, NotifyDestroy, Off
WinFade("ahk_id " NOT_hwnd,0,25)
Gui, Notify: Destroy
return

CrosshairDestroy:
Gui, CS_Horizontal: Destroy
Gui, CS_Vertical: Destroy
return