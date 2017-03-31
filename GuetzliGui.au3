#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=res\GuetzliBG.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#pragma compile(Out, GuetzliBG.exe)
#pragma compile(Icon, res\GuetzliBG.ico)
#pragma compile(ExecLevel, asInvoker)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Guetzli Batch Gui)
#pragma compile(ProductName, GuetzliBG)
#pragma compile(ProductVersion, 1.1)
#pragma compile(FileVersion, 1.1)
#pragma compile(LegalCopyright, © Francesco Gerratana)
#pragma compile(CompanyName, 'Nextechnics')
#pragma compile(Compression, 3)
#pragma compile(OriginalFilename, GuetzliBG.exe)
 #NoTrayIcon

#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <GuiEdit.au3>
#include <FontConstants.au3>

DirCreate(@ScriptDir & "\img")
DirCreate(@ScriptDir & "\res")

Local $bFileInstall = True
If $bFileInstall Then
	FileInstall("E:\DEVREPO\GuetzliBG\res\GuetzliBG.bmp", @ScriptDir & "\res\GuetzliBG.bmp")
	FileInstall("E:\DEVREPO\GuetzliBG\res\GuetzliBG.ico", @ScriptDir & "\res\GuetzliBG.ico")
EndIf

Global $icon = @ScriptDir&"\res\GuetzliBG.ico"
Global $pic = @ScriptDir&"\res\GuetzliBG.bmp"
Global $FilePath, $msg=""
Global $tipo = "*.jpg;*.png"
Global $trasp = 0x2C3459
Global $guetzli = @ScriptDir&"\guetzli.exe"
Global $ini = @ScriptDir&"\cfg.ini"
		If Not FileExists($ini) Then
			IniWrite($ini,"SETTINGS","quality","84")
		EndIf
Global $qini = IniRead($ini,"SETTINGS","quality","")
Global $mpathl = @ScriptDir&"\mpath.txt"

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("GuetzliBG | Guetzli Batch Gui | www.nextechnics.com", 640, 420, -1, -1)
$Pic1 = GUICtrlCreatePic($pic, 505, 30, 100, 101)
GUISetBkColor(0x2C3459)
GUICtrlSetDefColor(0xFFFFFF)
GUICtrlSetDefBkColor(0x000000)
If Not @Compiled Then GUISetIcon($icon)
GUISetIcon($icon, -1)

$Sel = GUICtrlCreateButton("Select Folder", 16, 50, 107, 25)
$RebuildQ = GUICtrlCreateButton("Rebuild Quality", 133, 50, 107, 25)
$prlog= GUICtrlCreateButton("Read Log", 16, 80, 107, 25)

Local $idSlider1 = GUICtrlCreateSlider(250, 50, 200, 24)
GUICtrlSetData($idSlider1, $qini)
GUICtrlSetLimit(-1, 100, 0) ; change min/max value
$hSlider_Handle = GUICtrlGetHandle(-1)
GUICtrlSetBkColor($idSlider1,0x2C3459)


$Label5 = GUICtrlCreateLabel("Quality "&$qini&"%", 255, 30, 89, 17)
GUICtrlSetBkColor(-1,$trasp)
$Label6 = GUICtrlCreateLabel("About Guetzli Batch Gui", 490, 10, 140, 17)
GUICtrlSetFont(-1, 9, 400,4)
GUICtrlSetBkColor(-1,$trasp)
GUICtrlSetTip(-1, "About Guetzli Batch Gui")
$msg = GUICtrlCreateLabel($msg, 16,5, 435, 17)
GUICtrlSetBkColor(-1,$trasp)
$msg2 = GUICtrlCreateLabel("Status:", 16,130, 40, 17)
GUICtrlSetBkColor(-1,$trasp)
$msg3 = GUICtrlCreateLabel("", 60,130, 555, 17)
GUICtrlSetBkColor(-1,$trasp)

$Edit1 = GUICtrlCreateEdit("" & @CRLF, 16, 150,600,240, $ES_MULTILINE+$ES_AUTOVSCROLL+$WS_VSCROLL )
GUICtrlSetData($Edit1, "")

$StatusBar = _GUICtrlStatusBar_Create($Form1)
Local $StatusBar_PartsWidth[2] = [520, 120]
_GUICtrlStatusBar_SetParts($StatusBar, $StatusBar_PartsWidth)
_GUICtrlStatusBar_SetText($StatusBar, "Ready", 0)
_GUICtrlStatusBar_SetText($StatusBar, "Francesco Gerratana ", 1)

GUISetState(@SW_SHOW)


_GUICtrlEdit_SetLimitText($Edit1, 10^10)
GUIRegisterMsg($WM_HSCROLL, "WM_H_Slider")
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_EVENT_PRIMARYUP
            ToolTip("")
		Case $prlog
			$inputString = GUICtrlRead($Edit1)
			$string = StringSplit($inputString,'\n', $STR_ENTIRESPLIT)
			$log = @ScriptDir&"\log.txt"
			FileOpen($log,2)
				For $i = 1 To $string[0]
					FileWriteLine($log,$string[$i])
				Next
			FileClose($log)
			If FileExists($log) Then
				ShellExecute($log,"",@ScriptDir,"Open")
			EndIf
		Case $Sel
		;	$folder = FileSelectFolder("Select the images folder",@ScriptDir)
		;	If @error Then
		;		GUICtrlSetData($msg,"Invalid path")
		;		$FilePath = ""
		;	Else
		;		GUICtrlSetData($msg,$folder)
		;		$FilePath = $folder
		;	EndIf
			$folder = FileSelectFolder("Select the images folder",@ScriptDir)
			If @error Then
				GUICtrlSetData($msg,"Invalid path")
				$FilePath = ""
			Else
				GUICtrlSetData($Edit1,$folder&@CRLF,1)
				FileWriteLine($mpathl,$folder)
			EndIf
		Case $RebuildQ

				If FileExists($mpathl) Then
				$flipath = FileReadToArray($mpathl)
				$t = UBound($flipath)-1
				If $t = -1 Then
					GUICtrlSetData($msg,"Error!!! File mpath is empty")
				ElseIf $t = 0 Then
					RebuildQ($flipath[0])
				Else
					_multipath($flipath)
				EndIf
			EndIf


		;	If $FilePath <> "" Then
		;		If FileExists($guetzli) Then
		;			$chkimg = _FileListToArrayRec($FilePath, "*.jpg;*.png",1,1,1,2)
		;			If UBound($chkimg) <> 0 Then
		;				RebuildQ($FilePath)
		;			Else
		;				GUICtrlSetData($msg,"The folder does not contain any img files")
		;			EndIf
		;		Else
		;			GUICtrlSetData($msg,"Error guetzli.exe not found! Copy it and restart the app.")
		;		EndIf
		;	Else
		;		GUICtrlSetData($msg,"Please select images folder")
		;	EndIf

		Case $Label6
			ShellExecute("http://www.nextechnics.com")

	EndSwitch
WEnd

Func _multipath($mfile)
		$t = UBound($mfile)-1
		For $s = 1 to $t
			RebuildQ($mfile[$s])
			ConsoleWrite($mfile[$s]&@CRLF)
		Next
EndFunc



; Reduce quality
Func RebuildQ($FilePath)
GUICtrlSetData($Edit1,'')

$files = _FileListToArrayRec($FilePath,$tipo,1,1,1,2)

If UBound($files)-1 <> -1 Then
	GUICtrlSetData($msg3,'Wait reduction image quality process...')
	_ArrayDisplay($files)
	$count = 0

	Local $hTimer = TimerInit()

		Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $copy = "Copy\"

		For $q = 1 to UBound($files)-1
			$Ps = _PathSplit($files[$q], $sDrive, $sDir, $sFileName, $sExtension)
			If Not FileExists($Ps[1]&$Ps[2]&$copy) Then DirCreate($Ps[1]&$Ps[2]&$copy)
				$run = Run($guetzli &" --quality "&$qini&" --verbose "&'"'&$files[$q]&'"'&" "&'"'&$Ps[1]&$Ps[2]&$copy&$Ps[3]&$Ps[4]&'"',@ScriptDir,@SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			ConsoleWrite($guetzli &" --quality "&$qini&" --verbose "&'"'&$files[$q]&'"'&" "&'"'&$Ps[1]&$Ps[2]&$copy&$Ps[3]&$Ps[4]&'"'&@CRLF)
			$count+=1
			GUICtrlSetData($Edit1,$files[$q]&@CRLF,1)
			StdinWrite($run)

			Local $sOutput = ""

			While 1
				$sOutput &= StdoutRead($run)
				If @error Then
					ExitLoop
				EndIf
				Local $Diff = TimerDiff($hTimer)
				Local $Tc = _Time($Diff)
				GUICtrlSetData($msg,$Tc[0] & " Hours " & $Tc[1] & " Minutes " & $Tc[2] & " Seconds")
			WEnd
			If $sOutput <> "" Then
				GUICtrlSetData($Edit1,$sOutput&@CRLF,1)
			EndIf
			While 1
			$sOutput = StderrRead($run)
			If @error Then
				ExitLoop
			EndIf
			If $sOutput <> "" Then
				GUICtrlSetData($Edit1,$sOutput&@CRLF,1)
			EndIf
			WEnd
		Next
		ProcessWaitClose($run)
		GUICtrlSetData($msg3,"Finish reduction image quality process. Tot:"&$count)

	Else

		GUICtrlSetData($msg,"The folder does not contain any img files")

	EndIf
EndFunc

; React to slider movement
Func WM_H_Slider($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg, $wParam
    If $lParam = $hSlider_Handle Then
		$iValue = GUICtrlRead($idSlider1)
        ToolTip($iValue&"%")
			GUICtrlSetData($Label5,"Quality: "&$iValue&"%")
			IniWrite($ini,"SETTINGS","quality",$iValue)
    EndIf
    Return $GUI_RUNDEFMSG

EndFunc

Func exitscript()
    Exit 0
EndFunc

Func RestartScript()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc

func _Time($TimerDiff)

    dim $ORS[3]

    $ORS[2] = Int($TimerDiff / 1000)
    $ORS[1] = $ORS[2] - Mod($ORS[2], 60)
    $ORS[2] -= $ORS[1]
    $ORS[1] /= 60
    $ORS[0] = $ORS[1] - Mod($ORS[1], 60)
    $ORS[1] -= $ORS[0]
    $ORS[0] /= 60
    return $ORS
endfunc; _Diff2Time