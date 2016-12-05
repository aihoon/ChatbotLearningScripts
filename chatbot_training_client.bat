@echo off

:: Check input arguments...
IF "%3"=="" (
    echo.
    echo.  # USAGE
    echo.    $ chatbot_training_client.bat COMMAND PROJECT_NAME SERVER_NUMBER
    echo.      where COMMAND is start, check, stop, remove, or update.
    echo.
    goto :eof
)

:: Define variables...
set CMD_TYPE=%1
set PROJ_NAME=%2
set SERVER_NUM=%3
set TEST_FILE=%PROJ_NAME%.test.txt
set TRAIN_FILE=%PROJ_NAME%.train.txt 
set SERVER_IP=10.122.64.%SERVER_NUM%
set BASE_DIR=/data1/MindsBot/data
set SCR_DIR=/data1/MindsBot/script
set SERVER_SH=chatbot_training_server.sh

goto :next0
echo %CMD_TYPE%
echo %PROJ_NAME%
echo %SERVER_NUM%
echo %TEST_FILE%
echo %TRAIN_FILE%
echo %SERVER_IP%
echo %BASE_DIR%
echo %SCR_DIR%
echo %SERVER_SH%
:next0

IF "%CMD_TYPE%"=="start" (

    echo.
    echo. # Check if test file exists...
    IF NOT EXIST %TEST_FILE% (
        echo. @ Error: file not found, %TEST_FILE%
        echo.
        goto :eof
    )

    echo.
    echo. # Check if test file exists...
    IF NOT EXIST %TRAIN_FILE% (
        echo. @ Error: file not found, %TRAIN_FILE%
        echo.
        goto :eof
    )

    echo.
    echo. # Copy test and train files to server.
    scp %PROJ_NAME%.*.txt msl@%SERVER_IP%:%BASE_DIR%

    echo.
    echo. # Copy scriptfile to server.
    scp %SERVER_SH% msl@%SERVER_IP%:%SCR_DIR%
)

IF "%CMD_TYPE%"=="start"  goto :cond
IF "%CMD_TYPE%"=="check"  goto :cond
IF "%CMD_TYPE%"=="stop"   goto :cond
IF "%CMD_TYPE%"=="remove" goto :cond
IF "%CMD_TYPE%"=="update" goto :cond

echo.
echo. @ Error: command not defined, %CMD_THYPE%.
echo.          Try again with start, check, stop, or remove.
echo.
goto :eof

:cond
    set SERVER_CMD="cd %SCR_DIR%;chmod u+x %SERVER_SH%; ./%SERVER_SH% %CMD_TYPE% %PROJ_NAME%"
    ssh msl@%SERVER_IP% %SERVER_CMD%
    goto :eof

:eof

