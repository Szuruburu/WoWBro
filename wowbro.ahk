; WoWBro 0.5
; Released under the MIT licence
; Author: Michał Szulecki
; E-mail: szuru.buru@hotmail.com

;==============----------------------------------------------------------------------------==============;
;==============----------------------------------------------------------------------------==============;
;==============--  A  --  U  --  T  --  O  --  E  --  X  --  E  --  C  -- U  -- T  -- E  --==============;
;==============----------------------------------------------------------------------------==============;
;==============----------------------------------------------------------------------------==============;

#UseHook
;#Warn All
#NoEnv
#SingleInstance, force
#InstallMouseHook
#Persistent
SetControlDelay -1
DetectHiddenWindows On
SetWorkingDir % A_ScriptDir
SetMouseDelay, 10
SetWinDelay -1
SetTitleMatchMode 2

;infoBox("Nice And Fluffly! ver. 1.0",480,100,,"3")
;SplashScreen("WorkFlo v 1.14", "Wciśnij WIN + H aby wyświetlić pomoc`nby szuruburu", 483, 103,, "2")
global ModKey := "LAlt"
global MountUp_Key := "!z"
global DeselectMacro_Key := "^!+U"

global RMB_LMB_SwitchInterval := 40
global UseButton_Interval := 100
global RMB_locked := false
global LMB_locked := false
global Mounted := false

global move := false
global cs_shown := false

; User Settings
global SettingsMoveCursor := true

Hotkey, IfWinActive, ahk_class GxWindowClass
Hotkey, %MountUp_Key%, ToggleFlyingMode
Hotkey, !LButton, ToggleLMB
Hotkey, !LButton, off
; Hotkey, Delete, DeleteItemUnderCursor
;Hotkey, a, TurnLeft_RidingMode

Send, {%ModKey% up}
ClOff()
GoSub, DestroysAtStartup
Menu, Tray, Icon, icon.ico
return

;==============  THE END OF...
;==============----------------------------------------------------------------------------==============;
;==============----------------------------------------------------------------------------==============;
;==============--  A  --  U  --  T  --  O  --  E  --  X  --  E  --  C  -- U  -- T  -- E  --==============;
;==============----------------------------------------------------------------------------==============;
;==============----------------------------------------------------------------------------==============;

; Libraries
#Include lib/guifunc.ahk
#Include lib/tip.ahk
#Include lib/destroys.ahk

DestroysAtStartup:
GoSub, CrossHairDestroy
return

; REMARKS
; *** AlywaysOnTop & NoActivate GUI option?
; 	* to change cursor placing after changing a spec e.g.
;	* in order to do the above mentioned, LockdownMB() function must get the second param
;	  which shall be a user-defined hotkey; chosen in the GUI
; *** Investigate why the alt+mbutton /useitem/ function refuses to work

; Restart app
!F1::
SettingsMoveCursor := (SettingsMoveCursor == true) ? false : true
return

!+Esc::
reload
return

; Some keys are blocked to prvent their accidental pressing during the game
/*
!Esc::return
^Esc::return
^+Esc::return
LWin::return
*/

; WOW window class
#IfWinActive, ahk_class GxWindowClass
;#IfWinActive, ahk_class Turbine Device Class


ShowCrosshair:
csC := "ffff26"
CrosshairGUIParams := "-SysMenu -Caption +LastFound +ToolWindow +AlwaysOnTop"
Gui, CS_Horizontal: %CrosshairGUIParams%
CSH_hwnd := WinExist()
Gui, CS_Vertical: %CrosshairGUIParams%
CSV_hwnd := WinExist()
WinSet, Transparent, 0, ahk_id %CSH_hwnd%
WinSet, Transparent, 0, ahk_id %CSV_hwnd%
WinSet, ExStyle, +0x20, ahk_id %CSH_hwnd%
WinSet, ExStyle, +0x20, ahk_id %CSV_hwnd%
Gui, CS_Horizontal: Color, % "0x" csC
Gui, CS_Vertical: Color, % "0x" csC
cshW := 12
csvW := 2
cshH := csvW
csvH := cshW
cshX := (A_ScreenWidth/2)-(cshW/2)
csvX := (A_ScreenWidth/2)-(csvW/2)
cshY := (A_ScreenHeight/2)-(cshH/2)
csvY := (A_ScreenHeight/2)-(csvH/2)
Gui, CS_Horizontal: Show, w%cshW% h%cshH% x%cshX% y%cshY% NoActivate
Gui, CS_Vertical: Show, w%csvW% h%csvH% x%csvX% y%csvY% NoActivate
WinFade("ahk_id " CSH_hwnd,60,30)
WinFade("ahk_id " CSV_hwnd,60,30)
return

/*
A::
	if (Mounted == true) {
		if !(RMB_locked == false)
			LockDownMB("Right")
		SimulateLeft("A")
	} else {
		SimulateLeft("A")
	}
return

SimulateLeft(TurnLeft_Key) {
	While GetKeyState(TurnLeft_Key, "P") {
		SendInput, {%TurnLeft_Key% down}
	}
	SendInput {%TurnLeft_Key% up}
}
*/

; pn = portrait number
; xy = x or y
GetMouseCoords(pn,xy) {
	MouseGetPos, %pn%pX, %pn%pY
	if (xy == "x")
		return %pn%pX
	else if (xy == "y")
		return %pn%pY
}

SetMouseCoords(pn) {
	global NOT_hwnd
	if WinExist("ahk_id " NOT_hwnd)
		GoSub, NotifyDestroy
	nt := "Portrait " pn " hotkey position [x,y]: " %pn%pX ", " %pn%pY
	Notify(nt)
}

DeleteItemUnderCursor:
	MouseGetPos, iX, iY
	mdX := A_ScreenWidth/2
	mdY := A_ScreenHeight/2
	Click, Down, Left
	MouseMove, mdX,mdY
	Click, Up, Left
	;Click
	Sleep, 300
	ImageSearch, YesX, YesY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, lib\yes.bmp
	Sleep, 50
	MouseMove, YesX,YesY
	Click
	Sleep, 10
	Click
	Sleep, 10
	Click
	MouseMove, iX,iY
return

^+!1::
global 1pX := GetMouseCoords("1", "x")
global 1pY := GetMouseCoords("1", "y")
SetMouseCoords("1")
return

^+!2::
global 2pX := GetMouseCoords("2", "x")
global 2pY := GetMouseCoords("2", "y")
SetMouseCoords("2")
return

^+!3::
global 3pX := GetMouseCoords("3", "x")
global 3pY := GetMouseCoords("3", "y")
SetMouseCoords("3")
return

^+!4::
global 4pX := GetMouseCoords("4", "x")
global 4pY := GetMouseCoords("4", "y")
SetMouseCoords("4")
return

^+!5::
global 5pX := GetMouseCoords("5", "x")
global 5pY := GetMouseCoords("5", "y")
SetMouseCoords("")
return

RestoreMouseCoords(pn) {
	pX := %pn%pX
	BlockInput, MouseMove
	LockdownMB_OFF("Left")
	LockdownMB_OFF("Right")
	MouseMove, %pn%pX, %pn%pY
	BlockInput, MouseMoveOff
}

!1::
RestoreMouseCoords("1")
return

!2::
RestoreMouseCoords("2")
return

!3::
RestoreMouseCoords("3")
return

!4::
RestoreMouseCoords("4")
return

!5::
RestoreMouseCoords("5")
return

ClOff() {
	SetCapsLockState, AlwaysOff
}

*`::
if (RMB_locked == true) {
	Click, Up, Right
	RMB_locked := false
} else if (LMB_locked == true) {
	Click, Up, Left
	RMB_locked := false
	Sleep, % RMB_LMB_SwitchInterval	
	LockdownMB("Left")
}
LockdownMB("Left")
return

CapsLock::
if (LMB_locked == true) {
	Click, Up, Left
	LMB_locked := false
	Sleep, % RMB_LMB_SwitchInterval	
} else if (RMB_locked == true) {
	Click, Up, Right
	Sleep, % RMB_LMB_SwitchInterval	
	LockdownMB("Right")
}

; LockDown Mouse Button function:
; params: LockDownMB([which button: "Right", "Left", "Middle"], [where should be cursor moved?: "center", "dontmove"])
if (SettingsMoveCursor == true)
	LockdownMB("Right")
else
	LockdownMB("Right","dontmove")
return

LockdownMB(which, where := "center") {
	global
	butpref := (which == "Right") || (which == "right") ? "RMB_"
	: (which == "Left") || (which == "left") ? "LMB_"
	: (which == "Middle") || (which == "middle") ? "MMB_"
	: "error: incorrect button"
	
	if (which == "Right")
		SendInput, %DeselectMacro_Key%
	posX := InStr(where,"center") ? A_ScreenWidth / 2
	: InStr(where, "dontmove") ? "asis"
	posY := InStr(where,"center") ? A_ScreenHeight / 2
	: InStr(where, "dontmove") ? "asis"
	if (posX <> "asis") || (posY <> "asis") {
		%butpref%_mx := posX
		%butpref%_my := posY
		BlockInput, MouseMove
		MouseMove, %butpref%_mx, %butpref%_my
		if (which == "Right")
			GoSub, ShowCrosshair
		move := false
		
	} else {
		move := true
	}
	Click, Down, %which%
	%butpref%locked := true
	%butpref%_up := false
	BlockInput, MouseMoveOff
}

LockdownMB_OFF(which) {
	global
	butpref := (which == "Right") || (which == "right") ? "RMB_"
	: (which == "Left") || (which == "left") ? "LMB_"
	: (which == "Middle") || (which == "middle") ? "MMB_"
	: "error: incorrect button"
	
	Click, Up, %which%
	if (%butpref%locked == true) {
		%butpref%locked := false
		GoSub, CrossHairDestroy
	}
}

LButton::
Click, Down, Left
return

LButton up::
LockdownMB_OFF("Left")
Sleep, % RMB_LMB_SwitchInterval
LockdownMB_OFF("Right")
return

RButton::
Click, Down, Right
return

RButton up::
LockdownMB_OFF("Right")
return

MButton::
if (RMB_locked == true) || (LMB_locked == true) {
	GoSub, UseItem
} else {
	Click, Down, Middle
}
return

MButton up::
Click, Up, Middle
return

UseItem:
BlockInput, MouseMove
LockdownMB_OFF("Right")
MouseGetPos, initX, initY
CposX := A_ScreenWidth / 2
CposY := A_ScreenHeight / 2
MouseMove, CposX, CposY	
Sleep, % UseButton_Interval
SendInput, {RButton}
Sleep, % UseButton_Interval
if (move == false) {
	MouseMove, %initX%, %initY%
	LockdownMB("Right","dontmove")
} else {
	LockdownMB("Right")
}
BlockInput, MouseMoveOff
Sleep, 20
SendInput, %DeselectMacro_Key%
return

ToggleLMB:
return

CheckForModKey:
	akd := GetKeyState(ModKey)
	if (akd == 0)
		SendInput, {%ModKey% down}
return

ToggleFlyingMode:
if (Mounted == true) {
	SetTimer, CheckForModKey, off
	Send, {%ModKey% up}
	SendInput, %MountUp_Key%
	LockdownMB_OFF("Left")
	LockdownMB("Right")
	Mounted := false
	Notify("Dismount!")
} else {
	LockdownMB_OFF("Left")
	LockdownMB_OFF("Right")
	SendInput, %MountUp_Key%
	Notify("Mount up!")
	LockdownMB("Left")
	Sleep, 1000
	SendInput, {%ModKey% down}
	;SendInput, !{WheelDown 20}
	Mounted := true
	SetTimer, CheckForModKey, 2000
}
return

LookForZ:
GetKeyState, MountOff, %MountUp_Key%
if (MountOff == "D") {
	SendInput, %MountUp_Key%
	Send, {%ModKey% up}
	LockdownMB_OFF("Left")
	SetTimer, LookForZ, off
	Mounted := false
	LockdownMB("Right")
}
return

$capslock up::
ClOff()
return

