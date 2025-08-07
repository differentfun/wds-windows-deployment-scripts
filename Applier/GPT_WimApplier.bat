@echo off
:: ----------------------------------------------------------------------------
::  Script: 2_GPT_WimApplier.bat
::  Purpose:  1) Ask for the path to the WIM file (input)
::            2) Ask for the WIM index
::            3) Ask for the Windows and EFI partition letters
::            4) Execute DISM and BCDBoot
:: ----------------------------------------------------------------------------

echo ==========================================================================
echo  APPLY WIM IMAGE AND CONFIGURE UEFI BOOT
echo ==========================================================================
echo.

:: 1) Ask for the WIM file path
echo Enter the FULL PATH to the WIM file (e.g. D:\install.wim):
set /p WIMPATH=
echo.

:: 2) Ask for the image index to apply
echo Enter the IMAGE INDEX to apply (e.g. 1, 2, etc.):
set /p WIMINDEX=
echo.

:: 3) Ask for the Windows partition letter (e.g. W)
echo Enter the Windows partition letter (without colon, e.g. W):
set /p WINLETTER=
echo.

:: 4) Ask for the EFI partition letter (e.g. S)
echo Enter the EFI partition letter (without colon, e.g. S):
set /p EFILETTERA=
echo.

echo ==========================================================================
echo  Summary of provided data:
echo     WIM File: %WIMPATH%
echo     Index:    %WIMINDEX%
echo     Windows:  %WINLETTER%:
echo     EFI:      %EFILETTERA%:
echo ==========================================================================
echo.
pause

:: --- Apply image with DISM ---
echo Running: DISM /Apply-Image /ImageFile:%WIMPATH% /Index:%WIMINDEX% /ApplyDir:%WINLETTER%:\ 
dism /Apply-Image /ImageFile:%WIMPATH% /Index:%WIMINDEX% /ApplyDir:%WINLETTER%:\

:: Error check
if %errorlevel% neq 0 (
    echo ERROR applying WIM image!
    pause
    exit /b 1
)

:: --- Configure EFI boot with BCDBoot ---
echo.
echo Running: bcdboot %WINLETTER%:\Windows /l en-US /s %EFILETTERA%: /f UEFI
bcdboot %WINLETTER%:\Windows /l en-US /s %EFILETTERA%: /f UEFI

if %errorlevel% neq 0 (
    echo ERROR during boot configuration with bcdboot!
    pause
    exit /b 1
)

echo.
echo ==========================================================================
echo  OPERATION COMPLETED SUCCESSFULLY!
echo  - The image was applied to %WINLETTER%:\
echo  - Boot files were created on %EFILETTERA%: (EFI)
echo ==========================================================================
pause
