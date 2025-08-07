@echo off
:: ----------------------------------------------------------------------------
::  Script: 1_GPT_Partitioner.bat
::  Purpose:  1) Display list of disks
::            2) Ask user which disk to operate on
::            3) Clean and convert to GPT
::            4) Create EFI/MSR/Primary partitions and assign letters S and W
:: ----------------------------------------------------------------------------

echo ==========================================================================
echo  GPT Partitioning (UEFI) - WARNING: THIS WILL ERASE ALL DATA ON THE DISK!
echo ==========================================================================
echo.

:: Show list of disks using DiskPart
echo [INFO] List of available disks:
(echo list disk) | diskpart
echo.

:: Ask for disk number
set /p DISKNUM=Enter the number of the disk to partition (e.g. 0, 1, etc.): 
echo.

:: Confirmation
echo You have selected disk no. %DISKNUM%.
echo This operation will COMPLETELY erase disk no. %DISKNUM%.
echo.
set /p CONFIRMA=Do you want to proceed? (Y/N): 
if /I "%CONFIRMA%" neq "Y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

:: Create a temporary file with DiskPart commands
>  PartTemp.txt echo select disk %DISKNUM%
>> PartTemp.txt echo clean
>> PartTemp.txt echo convert gpt

>> PartTemp.txt echo create partition efi size=500
>> PartTemp.txt echo format fs=fat32 quick label="EFI"
>> PartTemp.txt echo assign letter=S

>> PartTemp.txt echo create partition msr size=16

>> PartTemp.txt echo create partition primary
>> PartTemp.txt echo format fs=ntfs quick label="Windows"
>> PartTemp.txt echo assign letter=W

:: Run the script with DiskPart
diskpart /s PartTemp.txt

:: Delete the temporary file
del PartTemp.txt

echo.
echo ==========================================================================
echo Partitioning completed successfully.
echo   - EFI (S:)
echo   - MSR (no letter)
echo   - Windows (W:)
echo ==========================================================================
pause
