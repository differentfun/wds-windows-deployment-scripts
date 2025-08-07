@echo off
:: ----------------------------------------------------------------------------
::  Script: 1_MBR_Partitioner.bat
::  Purpose: Partition a disk using MBR (BIOS/Legacy)
::           - Clean the disk
::           - Convert to MBR
::           - Create system partition (S:) 100MB
::           - Create Windows partition (W:) with remaining space
::  Note:    - This will erase all data on the selected disk!
:: ----------------------------------------------------------------------------

echo ==========================================================================
echo  MBR Partitioning (BIOS/Legacy)
echo  WARNING: this procedure WILL ERASE ALL DATA on the selected disk!
echo ==========================================================================
echo.

:: Show list of disks using diskpart
echo [INFO] Available disks:
(echo list disk) | diskpart
echo.

:: Ask for the disk number
set /p DISKNUM=Enter the number of the disk to partition (e.g. 0, 1): 
echo.

:: Confirmation
echo You have selected disk no. %DISKNUM%.
echo This operation will COMPLETELY erase disk no. %DISKNUM%.
set /p CONFERMA=Do you want to proceed? (Y/N): 
if /I "%CONFERMA%" neq "Y" (
    echo Operation cancelled.
    pause
    exit /b 0
)

:: Create a temporary file with DiskPart commands
>  MbrTemp.txt echo select disk %DISKNUM%
>> MbrTemp.txt echo clean
>> MbrTemp.txt echo convert mbr

:: System partition (500 MB)
>> MbrTemp.txt echo create partition primary size=500
>> MbrTemp.txt echo format fs=ntfs quick label="System Reserved"
>> MbrTemp.txt echo assign letter=S
>> MbrTemp.txt echo active

:: Primary partition (rest of the space)
>> MbrTemp.txt echo create partition primary
>> MbrTemp.txt echo format fs=ntfs quick label="Windows"
>> MbrTemp.txt echo assign letter=W

:: Run the commands in DiskPart
diskpart /s MbrTemp.txt

:: Delete the temporary file
del MbrTemp.txt

echo.
echo ==========================================================================
echo Partitioning completed successfully (MBR).
echo   - System Reserved (S:) --> 100 MB, set as "active"
echo   - Windows (W:)        --> remaining space
echo ==========================================================================
pause
