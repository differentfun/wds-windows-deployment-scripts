@echo off
:: ----------------------------------------------------------------------------
::  Script: 1_GPT_WimCapture.bat
::  Purpose: Capture a full partition into a WIM file using DISM
:: ----------------------------------------------------------------------------

:: --- Check for Administrator privileges ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ============================================================
    echo  ERROR: This script must be run as Administrator!
    echo ============================================================
    pause
    exit /b 1
)

echo ============================================================
echo  CAPTURE PARTITION TO WIM IMAGE
echo ============================================================
echo.

:: 1) Ask for drive letter to capture
echo Enter the DRIVE LETTER to capture (without colon, e.g. C):
set /p SRCDRIVE=
set SRCDIR=%SRCDRIVE%:\

:: 2) Ask for destination path of the WIM file
echo.
echo Enter the FULL PATH where the WIM should be saved (e.g. D:\Captured.wim):
set /p DESTWIM=

:: 3) Ask for image name
echo.
echo Enter a NAME for the image (e.g. WindowsCapture):
set /p IMGNAME=

:: 4) Ask for image description
echo.
echo Enter a DESCRIPTION for the image:
set /p IMGDESC=

echo.
echo ============================================================
echo  Summary:
echo     Source:       %SRCDIR%
echo     Destination:  %DESTWIM%
echo     Image Name:   %IMGNAME%
echo     Description:  %IMGDESC%
echo ============================================================
pause

:: --- Capture the image ---
echo.
echo Running: DISM /Capture-Image /ImageFile:"%DESTWIM%" /CaptureDir:"%SRCDIR%" /Name:"%IMGNAME%" /Description:"%IMGDESC%" /Compress:max /CheckIntegrity
dism /Capture-Image /ImageFile:"%DESTWIM%" /CaptureDir:"%SRCDIR%" /Name:"%IMGNAME%" /Description:"%IMGDESC%" /Compress:max /CheckIntegrity

:: Check for DISM success
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to capture image!
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  IMAGE CAPTURE COMPLETED SUCCESSFULLY!
echo  Saved to: %DESTWIM%
echo ============================================================
pause
