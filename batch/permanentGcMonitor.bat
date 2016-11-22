@ECHO OFF

REM **************************************************
REM Permanent GC Monitoring
REM
REM USAGE :
REM   permanentGcMonitoring.bat <Threshold> <Timeout>
REM DEFINITIONS :
REM   <Threshold> Threshold Permanent GC Rate[%].
REM   <Timeout> Timeout[sec] if client is down.
REM EXAMPLE :
REM   .\permanentGcMonitoring.bat 50 3600
REM
REM **************************************************

ECHO Start Permanent GC Monitoring at %DATE% %TIME%

REM check parametar
IF "%1"=="" (
    ECHO Please specify an argument.
    GOTO ERROR
)
IF "%2"=="" (
    ECHO Please specify an argument.
    GOTO ERROR
)

REM get Tomcat PID
FOR /F "tokens=1,2" %%A IN ('tasklist /fi "imagename eq tomcat7.exe"') DO @SET TOMCAT_PID=%%B
ECHO Tomcat PID = %TOMCAT_PID%
SET /A CHECK_PID=%TOMCAT_PID%*1
IF NOT "%CHECK_PID%"=="%TOMCAT_PID%" (
    ECHO LaKeel BI Server is not activated.
    GOTO ERROR
)

REM get Permanent GC Use Rate
FOR /F "tokens=1-5" %%I IN ('PsExec.exe -s jstat -gcutil %TOMCAT_PID%') DO @SET /A PGC=%%M

:BEGIN
SET /A CHECK = %PGC:.=%
IF %CHECK% == %PGC% GOTO END
SET /A PGC = %PGC:~0,-1%
SET /A CHECK = %CHECK:~0,-1%
GOTO BEGIN
:END

ECHO Permanent GC Use Rate = %PGC%
ECHO Threshold = %1

SET /A CHECK_PGC=%PGC%*1
IF NOT "%CHECK_PGC%"=="%PGC%" (
    ECHO ERROR : Permanent GC Use Rate is not number.
    GOTO ERROR
)

REM evaluate
IF %PGC% GTR %1 (
    REM restart LaKeel BI Server
    ECHO Restart LaKeel BI Server ^(%COMPUTERNAME%^)
    CALL .\restartLaKeelBI %2
    GOTO AFTER
)

:AFTER
ECHO End  Permanent GC Monitoring at %DATE% %TIME%
EXIT 0

:ERROR
ECHO End  Permanent GC Monitoring at %DATE% %TIME%
EXIT 1

