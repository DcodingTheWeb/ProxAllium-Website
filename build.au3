#include <Debug.au3>
#include <FileConstants.au3>

Global $BUILD_INI = @ScriptDir & '\build.ini'

_DebugSetup("Building Website")

_DebugOut("Checking for Hugo")
RunWait("hugo version", @ScriptDir, @SW_HIDE)
If @error Then
	_DebugOut("Cannot find Hugo! Please download it and make sure that it is in %PATH%")
	Exit
EndIf

_DebugOut("Found Hugo! Starting to build the website...")
Local $iExitCode = RunWait("hugo", @ScriptDir)
If Not $iExitCode = 0 Then
	_DebugOut("Error! Hugo exited with exit code " & $iExitCode)
	Exit
EndIf
_DebugOut("Successfully built website")

Local $sDocPath = IniRead($BUILD_INI, "settings", "doc_path", "")
If Not FileExists($sDocPath) Then
	$sDocPath = FileOpenDialog("Select documentation file", @ScriptDir, 'AsciiDoc (*.adoc)', $FD_FILEMUSTEXIST, "help.adoc")
	IniWrite($BUILD_INI, "settings", "doc_path", $sDocPath)
EndIf

_DebugOut("Checking for AsciiDoctor")
RunWait("cmd /c asciidoctor -V", @ScriptDir, @SW_HIDE)
If @error Then
	_DebugOut("Cannot find AsciiDoctor! Please download it and make sure that it is in %PATH%")
	Exit
EndIf

_DebugOut("Found AsciiDoctor! Starting to build the documentation...")
Local $iExitCode = RunWait('cmd /c asciidoctor --out-file "' & (@ScriptDir & '\public\doc\index.html') & '" "' & $sDocPath & '"', @ScriptDir)
If Not $iExitCode = 0 Then
	_DebugOut("Error! AsciiDoctor exited with exit code " & $iExitCode)
	Exit
EndIf
_DebugOut("Successfully built documentation")
