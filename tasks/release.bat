@echo off
echo:

rem Check if an argument was passed.
if "%1"=="" (
    call:alert Please provide a directory path as an argument.
    exit /b 1
)

rem Store the directory path passed as the first argument.
set "module_root=%~1"
set "src_dir=%module_root%\src"

rem Check if the provided directory exists.
if not exist "%module_root%" (
    call:alert The directory "%module_root%" does not exist.
    exit /b 1
)

call:alert Compiling archive(s) from "%module_root%"...

rem Path to archiving application executable.
set "archiver_exe=C:\Program Files\7-Zip\7z"

call:alert Generating artifacts...

rem Retrieve directory name of the provided path.
for %%F in ("%module_root%") do (
    set "dir_name=%%~nxF"
)

rem Set package-common output path relative to the parent of the provided directory.
set "output=%module_root%\..\release\%dir_name%"

rem Check if the output directory exists.
if not exist "%output%" (
    mkdir "%output%" && call:alert Created output directory, "%output%".
)

rem Create shortcut to release-artifacts from module root.
call "%module_root%\create-folder-shortcut" "%output%" "%module_root%" "release"

set div================================================================================

rem For each subfolder in the src directory, compile a corresponding pk3.
for /d %%G in ("%src_dir%\*") do (
	call:alert [%%~nxG.pk3]
	echo %div%
    "%archiver_exe%" a -tzip "%output%\%%~nxG.pk3" "%src_dir%\%%~nxG\*" && echo: && echo %div% && call:alert Finished compiling archive to "%%~nxG.pk3"!
)

echo:
exit /b

rem Alert the caller to some important task-related info (basically an alias for "echo" but with a task label prepended to the message).
:alert
echo [RELEASE] %*
exit /b