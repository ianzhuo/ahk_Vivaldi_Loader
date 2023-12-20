; AutoeExecute
#NoEnv
#SingleInstance force
;~ #Warn
SetTitleMatchMode, 3
SetBatchLines, -1
#include %A_ScriptDir%\UIA_Interface.ahk
#include %A_ScriptDir%\UIA_Browser.ahk

;___Run vivaldi.exe if necessary

EnvGet, usrpath, USERPROFILE

vivaldi_exe_path := usrpath . "\Downloads\Vivaldi_portable\Application\vivaldi.exe"
;~ vivaldi_exe_path := A_ScriptDir . "\vivaldi.exe"

if !WinExist("ahk_exe vivaldi.exe") {
	Run, %vivaldi_exe_path%
	;~ Run, %A_ScriptDir%\vivaldi.exe
	WinWait ahk_exe vivaldi.exe
}

ProfileWindowName := "Vivaldi"

return

#If WinActive("Vivaldi")
	Right::
		if pos != ""
		{
			pos := MOD(pos + 1, length)
			x[pos+1].SetFocus()
		}
	return
	Left::
		if pos != ""
		{
			pos := MOD(pos - 1, length)
			if pos < 0
				pos := pos + length
			x[pos+1].SetFocus()
		}
	return

#If WinActive("ahk_exe vivaldi.exe")
	^+e::
		UIA := UIA_Interface() ; Initialize UIA interface
		cEl := UIA.ElementFromHandle("ahk_exe vivaldi.exe") ; Get the element for the Notepad window
		try
		{
			cEl.FindFirst("Name=Raindrop.io AND ControlType=Button").Click() ; Specify both name "Five" and control type "Button"
		}
		catch
		{
			MsgBox, "Not found"
		}
	return
	^+m::
		s := ""
		pos := 0
		x := []
		; force invoke profile manager when only one profile exists by setting profile-directory as Guest Profile
		run, %vivaldi_exe_path% --args --profile-directory="Guest Profile"


		WinWait, %ProfileWindowName%
		cUIA := new UIA_Browser(ProfileWindowName) ; Initialize UIA_Browser, which also initializes UIA_Interface
		cUIA.ElementFromHandle(WinExist(ProfileWindowName))
		for k, v in cUIA.FindAllByType(50000)
		{
			if v.AutomationID == ""
			{
				;~ msgbox % v.name
				x.Push(v)
			}
		}
		length := x.Length()
		x[pos+1].SetFocus()
	return
