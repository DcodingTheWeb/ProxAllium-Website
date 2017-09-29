#include <Debug.au3>
#include <FileConstants.au3>

Global $BUILD_INI = @ScriptDir & '\build.ini'

Local $sProxAlliumSrcDir = IniRead($BUILD_INI, "settings", "proxallium_src_dir", "")
If Not FileExists($sProxAlliumSrcDir) Then
	$sProxAlliumSrcDir = FileSelectFolder("Select ProxAllum's source folder", "")
	If @error Then Exit
	IniWrite($BUILD_INI, "settings", "proxallium_src_dir", $sProxAlliumSrcDir)
EndIf

_DebugSetup("Building Website")

_DebugOut("Checking for Hugo")
RunWait("hugo version", @ScriptDir, @SW_HIDE)
If @error Then
	_DebugOut("Cannot find Hugo! Please download it and make sure that it is in %PATH%")
	Exit
EndIf

_DebugOut("Found Hugo! Starting to build the website...")

FileCopy($sProxAlliumSrcDir & '\CHANGELOG.adoc', @ScriptDir & '\content\changelog.adoc', $FC_OVERWRITE)

Local $iExitCode = RunWait("hugo", @ScriptDir)
If Not $iExitCode = 0 Then
	_DebugOut("Error! Hugo exited with exit code " & $iExitCode)
	Exit
EndIf
_DebugOut("Successfully built website")

_DebugOut("Checking for AsciiDoctor")
RunWait("cmd /c asciidoctor -V", @ScriptDir, @SW_HIDE)
If @error Then
	_DebugOut("Cannot find AsciiDoctor! Please download it and make sure that it is in %PATH%")
	Exit
EndIf

_DebugOut("Found AsciiDoctor! Starting to build the documentation...")
Local $iExitCode = RunWait('cmd /c asciidoctor --out-file "' & (@ScriptDir & '\public\doc\index.html') & '" "' & ($sProxAlliumSrcDir & '\help.adoc') & '"', @ScriptDir)
If Not $iExitCode = 0 Then
	_DebugOut("Error! AsciiDoctor exited with exit code " & $iExitCode)
	Exit
EndIf
_DebugOut("Successfully built documentation")
