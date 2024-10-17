@echo off

set "task_name=%~1"
set task_args=%*
call set task_args=%%task_args:*%1=%%
echo: && echo [BUILD] INITIATING TASK "%task_name%" WITH ARGUMENTS "%task_args%"...
call .\tasks\%task_name%.bat . %task_args%

if %ERRORLEVEL%==0 (
    echo [BUILD] TASK "%task_name%" SUCCESSFUL!
) else (
    echo [BUILD] TASK "%task_name%" FAILED! Task corresponding to "%task_name%.bat" failed with error level: %ERRORLEVEL%. Is there a valid script defined in ".\tasks\%task_name%.bat"?
)

echo: && pause