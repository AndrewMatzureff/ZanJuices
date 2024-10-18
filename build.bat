@echo off

rem Check if a task name argument was passed; if not then default to "release".
if "%1"=="" (
    set "task_name=release"
) else (
    set "task_name=%~1"
)

rem Isolate arguments to pass into the desired task script.
set "task_args=%*"
call set "task_args=%%task_args:*%1=%%"

rem Initiate desired task script.
echo: && echo [BUILD] INITIATING TASK "%task_name%" WITH ARGUMENTS "%task_args%"...
call ".\tasks\%task_name%.bat" "." "%task_args%"

rem Alert the caller to whether the task succeeded or failed.
if %ERRORLEVEL%==0 (
    call:alert TASK "%task_name%" SUCCEEDED!
) else (
    call:alert TASK "%task_name%" FAILED! Task corresponding to "%task_name%.bat" failed with error level: %ERRORLEVEL%. Is there a valid script defined in ".\tasks\%task_name%.bat"?
)

echo:
pause
exit /b

rem Alert the caller to some important build-related info (basically an alias for "echo" but with a build label prepended to the message).
:alert
echo [BUILD] %*
exit /b