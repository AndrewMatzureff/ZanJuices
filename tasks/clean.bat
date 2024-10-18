@echo off
echo:

rem Check if an argument was passed.
if "%1"=="" (
    call:alert Please provide a directory path as an argument.
    exit /b 1
)

rem Store the directory path passed as the first argument.
set "module_root=%~1"

rem Check if the provided directory exists.
if not exist "%module_root%" (
    call:alert The directory "%module_root%" does not exist.
    exit /b 1
)

rem Use FOR to expand the relative paths into absolute paths.
for %%F in ("%module_root%") do set "absolute_module_root_path=%%~fF"
for %%F in ("%module_root%\..\release") do set "absolute_release_path=%%~fF"

call:alert MODULE ROOT: %absolute_module_root_path%
call:alert RELEASE PATH: %absolute_release_path%

rem Use FOR loop to get the module root directory name.
for %%F in ("%absolute_module_root_path%") do (
    set "module_name=%%~nxF"
)

call:alert Removing artifact repository at "%absolute_release_path%\%module_name%" and shortcut at "%absolute_module_root_path%\release.lnk"...
echo: && pause

if exist "%absolute_release_path%\%module_name%" (
	rmdir /s "%absolute_release_path%\%module_name%" && del "%absolute_module_root_path%\release.lnk" && call:alert All artifacts removed. || call:alert Removal terminated with ERRORLEVEL: %ERRORLEVEL%.
	echo:
	exit /b
)

call:alert Specified artifact repository not found; skipping...

del "%absolute_module_root_path%\release.lnk" && call:alert Removal completed as expected. || call:alert Removal terminated with ERRORLEVEL: %ERRORLEVEL%.

echo:
exit /b

rem Alert the caller to some important task-related info (basically an alias for "echo" but with a task label prepended to the message).
:alert
echo [CLEAN] %*
exit /b
