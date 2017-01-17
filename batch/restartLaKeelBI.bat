@ECHO OFF

REM **************************************************
REM Restart LaKeel BI Server with ELB Health Check
REM
REM USAGE :
REM   permanentGcMonitoring.bat <Timeout>
REM DEFINITIONS :
REM   <Timeout> Timeout[sec] if client is down.
REM EXAMPLE :
REM   .\permanentGcMonitoring.bat 3600
REM
REM **************************************************

ECHO Start Restart LaKeel BI Server at %DATE% %TIME%

REM check parametar
IF "%1"=="" (
    ECHO Please specify an argument.
    GOTO ERROR
)

REM environment
CALL .\environment.bat

REM Rename %HEALTH_CHECK_ACTIVE_FILE%
RENAME %HEALTH_CHECK_ROOT%\%HEALTH_CHECK_ACTIVE_FILE% %HEALTH_CHECK_INACTIVE_FILE%

REM Timeout %1 sec
TIMEOUT %1 /NOBREAK

REM Restart LaKeel BI Server
NET STOP "%SERVICE%"
NET START "%SERVICE%"

REM Rename %HEALTH_CHECK_INACTIVE_FILE%
RENAME %HEALTH_CHECK_ROOT%\%HEALTH_CHECK_INACTIVE_FILE% %HEALTH_CHECK_ACTIVE_FILE%

ECHO End   Restart LaKeel BI Server at %DATE% %TIME%
EXIT 0

:ERROR
ECHO End   Restart LaKeel BI Server at %DATE% %TIME%
EXIT 1
