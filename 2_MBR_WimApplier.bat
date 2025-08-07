@echo off
:: ----------------------------------------------------------------------------
::  Script: 2_MBR_WimApplier.bat
::  Purpose:  1) Ask for WIM path and index
::            2) Apply image to Windows partition (W:)
::            3) Configure MBR (BIOS/Legacy) boot on system partition (S:)
::            4) Rewrite the MBR using bootsect
:: ----------------------------------------------------------------------------

echo ==========================================================================
echo  Apply WIM Image and Configure Boot (MBR - BIOS)
echo ==========================================================================
echo.

:: 1) Ask for the WIM file path
set /p WIMPATH=Full path to the WIM file (e.g. D:\install.wim): 

:: 2) Ask for the image index
set /p WIMINDEX=Image index to apply (e.g. 1): 

:: 3) Ask for the Windows partition letter (e.g. W)
set /p WINLETTER=Windows partition letter (without colon, e.g. W): 

:: 4) Ask for the system partition letter (e.g. S)
set /p SYSLETTER=System partition letter (without colon, e.g. S): 

echo.
echo ==========================================================================
echo  Settings Summary:
echo    - WIM File:      %WIMPATH%
echo    - WIM Index:     %WIMINDEX%
echo    - Windows Part.: %WINLETTER%:
echo    - System Part.:  %SYSLETTER%:
echo ==========================================================================
pause

:: 5) Apply WIM image using DISM
echo.
echo [DISM] Applying WIM image to %WINLETTER%: ...
dism /Apply-Image /ImageFile:%WIMPATH% /Index:%WIMINDEX% /ApplyDir:%WINLETTER%:\

if %errorlevel% neq 0 (
    echo [ERROR] DISM returned an error. Check the path and index.
    pause
    exit /b 1
)

:: 6) Configure MBR (BIOS) boot with BCDBoot
echo.
echo [BCDBOOT] Configuring boot on %SYSLETTER%: ...
bcdboot %WINLETTER%:\Windows /l en-US /s %SYSLETTER%: /f BIOS

if %errorlevel% neq 0 (
    echo [ERROR] bcdboot returned an error. Check the system partition.
    pause
    exit /b 1
)

:: 7) Rewrite MBR boot code (optional but recommended to "fix" MBR)
echo.
echo [BOOTSECT] Rewriting MBR code on the disk containing %SYSLETTER%: ...
bootsect /nt60 %SYSLETTER%: /force /mbr

if %errorlevel% neq 0 (
    echo [ERROR] bootsect returned an error.
    pause
    exit /b 1
)

echo.
echo ==========================================================================
echo  OPERATION COMPLETED SUCCESSFULLY!
echo  - The WIM image was applied to %WINLETTER%:.
echo  - Boot files were placed on %SYSLETTER%: (active MBR).
echo  - MBR was rewritten using bootsect.
echo ==========================================================================
pause
