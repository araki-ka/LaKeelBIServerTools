@ECHO OFF

REM **************************************************
REM Class Monitoring
REM
REM USAGE : classMonitoring.bat <Threshold>
REM DEFINITIONS :
REM   <Threshold> Threshold number of classes.
REM
REM **************************************************

REM check parametar
IF "%1"=="" (
    EXIT 1
)

REM get Tomcat PID
FOR /F "tokens=1,2" %%A IN ('tasklist /fi "imagename eq tomcat7.exe"') DO @SET TOMCAT_PID=%%B
ECHO Tomcat PID = %TOMCAT_PID%
SET /A CHECK_PID=%TOMCAT_PID%*1
IF NOT "%CHECK_PID%"=="%TOMCAT_PID%" (
    ECHO Tomcat is not activated.
    EXIT 1
)

REM get number of Class Loader
REM FOR /F "tokens=1 delims=" %%A IN ('PsExec.exe -s jstat -class %TOMCAT_PID%') DO @SET CLASSES=%%A
FOR /F "delims=" %%A IN ('at hh:mm "cmd.exe" /c jstat -class %TOMCAT_PID%') DO @SET CLASSES=%%A
ECHO Number of Class Loader = %CLASSES%
PAUSE
SET /A CHECK_CLASSES=%CLASSES%*1
IF NOT "%CHECK_CLASSES%"=="%CLASSES%" (
    ECHO ERROR : Class is not number.
    EXIT 1
)

REM evaluate Class Loader
IF %CLASSES% GTR %1 (
    ECHO Stop Tomcat
    CALL SC STOP "LaKeelBI"
    EXIT 0
)
ECHO Tomcat OK!
EXIT 0
