REM @ECHO OFF

REM **************************************************
REM Archive LaKeel BI Server Log
REM
REM USAGE :
REM   logArchive.bat <Archive Period>
REM DEFINITIONS :
REM   <Archive Period> Archive Period[day(s)].
REM EXAMPLE :
REM   .\logArchive.bat 7
REM
REM **************************************************

ECHO Start Archive LaKeel BI Server Log at %DATE% %TIME%

REM check parametar
IF "%1"=="" (
    ECHO Please specify an argument.
    GOTO ERROR
)

REM environment
CALL .\environment.bat

REM archive logs
IF EXIST "%TOMCAT_LOGS%\" (
    ECHO Archive logs.
    XCOPY %TOMCAT_LOGS% %TOMCAT_ARCHIVE_LOGS%\%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2% /I/Y
)

REM TODO delete Archive log

ECHO End   Archive LaKeel BI Server Log at %DATE% %TIME%
EXIT 0

:ERROR
ECHO End   Archive LaKeel BI Server Log at %DATE% %TIME%
EXIT 1