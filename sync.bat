@echo off
setlocal enabledelayedexpansion
echo:

rem Check if an argument was passed.
if "%1"=="" (
    call:alert Please provide a directory path as an argument.
    exit /b 1
)

rem Store the directory path passed as the first argument.
set "module_root=%~1"
set "src_dir=%module_root%\src"

rem Retrieve directory name of the provided path.
for %%F in ("%module_root%") do (
    set "dir_name=%%~nxF"
)

rem Check if the provided directory exists.
if not exist "%module_root%" (
    call:alert The directory "%module_root%" does not exist.
    exit /b 1
)

rem Isolate arguments to pass into the desired task script.
set "source_archives=%*"
call set "source_archives=%%source_archives:*%1=%%"

rem If no source archives are specified then attempt to extract any .pk3 found in ../release/<module name>/ by default.
if "%source_archives%"=="" (

	rem Use FOR to expand the relative path into an absolute path.
	for %%F in ("%module_root%\..\release\!dir_name!") do set "source_archives_dir=%%~fF"
	
	call:alert No source archives specified; searching for sources in "!source_archives_dir!" by default...

	rem If any archives (not necessarily all) are resolved at all then proceed to the happy path.
	for %%F in ("!source_archives_dir!\*.pk3") do (
		goto :matched_archives
	)
	
	rem If no archives are resolved at all then alert and exit immediately.
	call:alert Found no archives matching "!source_archives_dir!\*.pk3"!
	exit /b 1
	
	:matched_archives
	set "source_archives=!source_archives_dir!\*.pk3"
	
	rem Apparently the else() block is still evaluated after triggering the previous goto...?
	goto :exit_if_else_block
) else (
	call set "source_archives=%source_archives:~1%"
)

:exit_if_else_block
call:alert Source archive(s) resolved in "%source_archives%"; verifying all archives exist...

rem Verify that ALL resolved archives exist.
for %%F in (%source_archives%) do (

	rem Check if the archive exists.
	if not exist "%%~fF" (
		call:alert Archive "%%~fF" not found!
		exit /b
	)
	
	call:alert Found archive: "%%F".
)

call:alert Attempting to extract sources to "%src_dir%"...

rem Extract all resolved archives.
for %%F in (%source_archives%) do (

	rem TODO: backup existing sources before removing.
	if exist "%src_dir%\%%~nF" (
		rmdir /s "%src_dir%\%%~nF"
	)

	(call:extract "%%F" "%src_dir%") || (call:alert Could not extract sources from "%%F"!) || exit /b 1
)

call:alert Finished syncing sources from "%source_archives%" to "%src_dir%"!

echo:
exit /b

rem Helper to process each source archive.
:extract
set div================================================================================

rem Path to archiving application executable.
set "archiver_exe=C:\Program Files\7-Zip\7z"
call:alert [%~1]
echo %div%
"%archiver_exe%" x "%~1" -o"%~2\%~n1" && echo: && echo %div% && call:alert Finished extracting sources from "%~1"! && exit /b 0
exit /b 1

rem Alert the caller to some important task-related info (basically an alias for "echo" but with a task label prepended to the message).
:alert
echo [SYNC] %*
exit /b