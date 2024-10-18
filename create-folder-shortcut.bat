@echo off
setlocal

rem Define the target folder, the physical path to the shortcut and the shortcut name excluding the extension.
set "target_folder_path=%~1"
set "destination_folder_path=%~2"
set "shortcut_name=%~3"

rem Build physical path to shortcut.
set "shortcut_path=%destination_folder_path%\%shortcut_name%.lnk"

rem Use FOR to expand the relative paths into absolute paths.
for %%F in ("%shortcut_path%") do set "absolute_shortcut_path=%%~fF"
for %%F in ("%target_folder_path%") do set "absolute_target_folder_path=%%~fF"

rem Call the VBScript to create the shortcut.
call :create_shortcut "%absolute_target_folder_path%" "%absolute_shortcut_path%"
exit /b

:create_shortcut
rem Write the VBScript to a temporary file.
set "vbs_file=%TEMP%\CreateShortcut.vbs"
echo Set WshShell = WScript.CreateObject("WScript.Shell") > "%vbs_file%"
echo Set Shortcut = WshShell.CreateShortcut(WScript.Arguments(1)) >> "%vbs_file%"
echo Shortcut.TargetPath = WScript.Arguments(0) >> "%vbs_file%"
echo Shortcut.Save >> "%vbs_file%"

rem Execute the VBScript, passing the arguments.
cscript //nologo "%vbs_file%" "%~1" "%~2"

rem Clean up the temporary VBScript file.
del "%vbs_file%"
exit /b
