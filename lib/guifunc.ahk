; One-liners ;)

GUIHeaderFont(guiname,color:=313131) {
	Gui, %guiname%: Font, c0%color% s13 w500 q5, Franklin Gothic Medium Cond
}

GUIRegularFont(guiname,color:=111111) {
	Gui, %guiname%: Font, c0%color% s10 w500 q5, Franklin Gothic Medium Cond
}

GUISmallFont(guiname,color:="656565") {
	Gui, %guiname%: Font, c0%color% s8 w500 q5, Franklin Gothic Medium Cond
}
GUIKeyBigFont(guiname,color:=111111) {
	Gui, %guiname%: Font, c%color% s24 w800 q5, Franklin Gothic Medium Cond
}

GuiBigPixelFont(guiname,color:=111111) {
	Gui, %guiname%: Font, c0%color% s18 w400 q5, Terminal
}

GuiMediumFont(guiname,color:=111111) {
	Gui, %guiname%: Font, c0%color% s11 w400, Helvetica
}

GuiCodeFont(guiname,color:=111111) {
	Gui, %guiname%: Font, c0%color% s11 w400, Consolas
}

GuiCodeSmallFont(guiname,color:=111111) {
	Gui, %guiname%: Font, c0%color% s9 w400, Consolas
}

DrawLine(char,length) {
	loop % length {
		draw_line .= char
	}
return draw_line
}

Notify(message) {
	global notify_text_handler, NOT_hwnd
	if !(WinExist("ahk_id " NOT_hwnd)) {
		background_color := "a6aeb7"
		backdrop_color := "5d8195"
		notify_position := "vc hc"
		Gui, Notify: +AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
		NOT_hwnd := WinExist()
		WinSet, ExStyle, +0x20
		WinSet, Transparent, 0
		Gui, Notify: Color, 0x%background_color%
		GUIHeaderFont("Notify")
		Gui, Notify: Add, Text, vnotify_text_handler, % message
		Gui, Notify: Show, Hide Autosize
		WinMoveFunc(NOT_hwnd,notify_position,200)
		Gui, Notify: Show, NoActivate NA
		WinFade("ahk_id " NOT_hwnd,255,8)
		SetTimer, NotifyDestroy, 1000
	}
}



rgb2hex(R, G, B, H := 1) {
	H := ((H = 1) ? "#" : ((H = 2) ? "0x" : ""))
	VarSetCapacity(Hex, 17 << !!A_IsUnicode, 0)
	DllCall("Shlwapi.dll\wnsprintf", "Str", Hex, "Int", 17, "Str", "%016I64X", "UInt64", (R << 16) + (G << 8) + B, "Int")
	return H SubStr(Hex, StrLen(Hex) - 6 + 1)
}

; Overkill a bit, but meh
FontEmbosser(text_to_emboss, guiName, fontColor, fontSize, fontFace, x, y, y_offset:=2, r_lighten:=170, g_lighten:=170, b_lighten:=170) {
	r_h2d := "0x" SubStr(fontColor,1,2)
	rRgb := r_h2d + 0
	g_h2d := "0x" SubStr(fontColor,3,2)
	gRgb := g_h2d + 0
	b_h2d := "0x" SubStr(fontColor,5,2)
	bRgb := b_h2d + 0
	fontColor_light := SubStr(rgb2hex(rRgb + r_lighten, gRgb + g_lighten, bRgb + b_lighten),2,8)
	
	Gui, %guiName%: Font, % " c0" fontColor_light " s"fontSize " w500 q1", % fontFace
	Gui, %guiName%: Add, Text, % " x"x " y"y-y_offset " +BackgroundTrans", % text_to_emboss ; light emboss
	Gui, %guiName%: Font,% " c0" fontColor " s"fontSize " w500 q1", % fontFace
	Gui, %guiName%: Add, Text, % " x"x " y"y " +BackgroundTrans", % text_to_emboss
}
 
WinMoveFunc(hwnd, position:="b r", move_up:=0, move_right:=0, move_down:=0, move_left:=0) {
	global x, y
	SysGet, Mon, MonitorWorkArea
	WinGetPos,ix,iy,w,h, ahk_id %hwnd%
	x := InStr(position,"l") ? MonLeft + move_right - move_left
	: InStr(position,"hc") ? ((MonRight-w)/2) + move_right - move_left
	: InStr(position,"r") ? MonRight - w + move_right - move_left
	: ix

	y := InStr(position,"t") ? MonTop + move_down - move_up
	: InStr(position,"vc") ? (MonBottom-h)/2 + move_down - move_up
	: InStr(position,"b") ? MonBottom - h + move_down - move_up
	: iy
		
	WinMove, ahk_id %hwnd%,,x,y
}

/*
Arguments
w : wintitle
t : final transparency
i : increment
d : delay (between each increment)
Behaviour
if : t > current, increases current transparency [i+]
if : t < current, decreases current transparency [i-]
*/

WinFade(w_title:="", transparency:=128, increment:=255, ex_enable:=false, delay:=1,ex_off:=false) {
	;Tip(A_ThisHotkey)
	
	if (ex_off == false) {
		WinGet s, ExStyle, %w_title%
		WinSet ExStyle, +0x20, %w_title%
	}
	
	w_title := (w_title = "") ? ("ahk_id " WinActive("A")) 
	: w_title
	
	transparency := (transparency > 255) ? 255 
	: ( transparency<0 ) ? 0 
	: transparency
	
	WinGet s, Transparent, %w_title%
	s := ( s = "") ? 255 
	: s ;prevent trans unset bug
	
	WinSet Transparent, %s%, %w_title%
	increment := (s < transparency) ? abs(increment)
	: -1 * abs(increment)
	
	while (k:=(increment < 0) ? (s > transparency) : (s < transparency) && WinExist(w_title)) {
		/*
		if (getkeystate(A_ThisHotkey,"P") = 1) {
			WinSet, Transparent, % transparency
			break
		}
		*/
		
		WinGet s, Transparent, %w_title%
		s+=increment
		WinSet Transparent, %s%, %w_title%
		Sleep, %delay%
	}
		
	if (ex_enable == true)
		WinSet ExStyle, -0x20, %w_title%
}

