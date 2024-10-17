@echo off
echo:

rem Check if an argument was passed.
if "%1"=="" (
    call:alert Please provide a directory path as an argument.
    exit /b 1
)

rem Store the directory path passed as the first argument.
set "base_dir=%~1"
set "src_dir=%base_dir%\src"

rem Check if the provided directory exists.
if not exist "%base_dir%" (
    call :alert The directory "%base_dir%" does not exist.
    exit /b 1
)

call:alert Compiling archive(s) from "%base_dir%"...

rem Path to archiving application executable.
set archiver_exe="C:\Program Files\7-Zip\7z"

call:alert Generating artifacts...

rem Retrieve directory name of the provided path.
for %%F in ("%base_dir%") do (
    set "dir_name=%%~nxF"
)

rem Set package-common output path relative to the parent of the provided directory.
set output=%base_dir%\..\release\%dir_name%

rem Check if the output directory exists.
if not exist "%output%" (
    mkdir "%output%" && call:alert Created output directory, "%output%".
)

rem For each subfolder in the src directory, compile a corresponding pk3.
for /d %%G in ("%src_dir%\*") do (
    %archiver_exe% a -tzip "%output%\%%~nxG.pk3" "%src_dir%\%%~nxG\*" && call:alert Finished compiling archive to %%~nxG.pk3!
)

echo:

rem Alert the caller to some important task-related info (basically an alias for "echo" but with a task label prepended to the message).
:alert
echo [RELEASE] %*
exit /b