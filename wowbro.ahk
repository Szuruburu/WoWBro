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
#MaxThreadsBuffer, On
#MaxHotkeysPerInterval, 500 ; Prevents hotkey limit reached warning
#MaxThreadsPerHotkey, 4
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
global MountUp_Key := "z"
global DeselectMacro_Key := "^!+U"

global RMB_LMB_SwitchInterval := 40
global UseButton_Interval := 100
global RMB_locked := false
global LMB_locked := false
global Mounted := false

global move := false

Hotkey, IfWinActive, ahk_class GxWindowClass
Hotkey, %MountUp_Key%, ToggleFlyingMode
Hotkey, !LButton, ToggleLMB
Hotkey, !LButton, off
;Hotkey, a, TurnLeft_RidingMode

ClOff()
return

;==============  THE END OF...
;==============----------------------------------------------------------------------------==============;
;==============----------------------------------------------------------------------------==============;
;==============--  A  --  U  --  T  --  O  --  E  --  X  --  E  --  C  -- U  -- T  -- E  --==============;
;==============----------------------------------------------------------------------------==============;
;==============----------------------------------------------------------------------------==============;

; REMARKS
; *** AlywaysOnTop & NoActivate GUI option?
; 	* to change cursor placing after changing a spec e.g.
;	* in order to do the above mentioned, LockdownMB() function must get the second param
;	  which shall be a user-defined hotkey; chosen in the GUI
; *** Investigate why the alt+mbutton /useitem/ function refuses to work

; Restart app
!+Esc::
reload
return

; Some keys are blocked to prvent their accidental pressing during the game
!Esc::return
^Esc::return
^+Esc::return
LWin::return

#IfWinActive, ahk_class GxWindowClass
	
ClOff() {
	SetCapsLockState, AlwaysOff
}

*`::
if (RMB_locked == true) {
	Click, Up, Right
	RMB_locked := false
}
Sleep, % RMB_LMB_SwitchInterval
LockdownMB("Left")
return

CapsLock::
if (LMB_locked == true) {
	Click, Up, Left
	LMB_locked := false
}
Sleep, % RMB_LMB_SwitchInterval
; LockDown Mouse Button function:
; params: LockDownMB([which button: "Right", "Left", "Middle"], [where should be cursor moved?: "center", "dontmove"])
LockdownMB("Right")
return

LockdownMB(which, where := "center") {
	global
	butpref := (which == "Right") || (which == "right") ? "RMB_"
	: (which == "Left") || (which == "left") ? "LMB_"
	: (which == "Middle") || (which == "middle") ? "MMB_"
	: "error: incorrect button"
	
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
		BlockInput, MouseMoveOff
		move := false
		
	} else {
		move := true
	}
	Click, Down, %which%
	%butpref%locked := true
	%butpref%_up := false
}

LockdownMB_OFF(which) {
	global
	butpref := (which == "Right") || (which == "right") ? "RMB_"
	: (which == "Left") || (which == "left") ? "LMB_"
	: (which == "Middle") || (which == "middle") ? "MMB_"
	: "error: incorrect button"
	
	Click, Up, %which%
	if (%butpref%locked == true)
		%butpref%locked := false
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
/*
if (RMB_locked == false) && (LMB_locked == false) {
	Sleep, 1000
	SendInput, %DeselectMacro_Key%
}
*/
return

UseItem:
; add || LMB locked == true
if (RMB_locked == true) || (LMB_locked == true) {
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
	Sleep, 500
	SendInput, %DeselectMacro_Key%
} else {
	Click, Down, Middle
}
return

MButton::
GoSub, UseItem
return

MButton up::
Click, Up, Middle
return

ToggleLMB:
return

ToggleFlyingMode:
;Settimer, DontMove, 50
LockdownMB_OFF("Left")
LockdownMB_OFF("Right")
SendInput, %MountUp_Key%
LockdownMB("Left")
Sleep, 1000
SendInput, {%ModKey% down}
SendInput, !{WheelDown 20}
Mounted := true
SetTimer, LookForZ, 12
return

LookForZ:
GetKeyState, MountOff, %MountUp_Key%
if (MountOff == "D") {
	SendInput, %MountUp_Key%
	SendInput, {%ModKey% up}
	LockdownMB_OFF("Left")
	SetTimer, LookForZ, off
	Mounted := false
	LockdownMB("Right")
}
return

$capslock up::
ClOff()
return

