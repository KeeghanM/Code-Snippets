@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
REM CREATE A FOLDER TO HOLD ANY FILES THAT WILL GET CHECKED LATER
	IF NOT EXIST "C:\DONT-DELETE" MKDIR C:\DONT-DELETE

REM MAP A DRIVE WITH SHOPRTCUS TO NAS LOCATIONS FOR EACH AD GROUP
IF EXIST C:\DONT-DELETE\NASshortcuts.txt GOTO ENDONE
REM Map drive using %username% as folder
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##192.168.0.1#USERS#%USERNAME% /v _LabelFromReg /t REG_SZ /f /d "%USERNAME%"
START /wait NET USE A: \\192.168.0.1\USERS\%USERNAME% /persistent:yes

REM Loop through a file with all the groups that have folders
FOR /F "tokens=*" %%K IN (\\192.168.0.1\NETLOGON\groups.txt) DO (
	REM Check if they are a member
	\\192.168.0.1\NETLOGON\IsMember.exe %%K
	IF ERRORLEVEL 1 (
		REM If they are a member, create a shortcut in their "A" drive. 
		\\192.168.0.1\NETLOGON\shortcut.exe /F:\\192.168.0.1\USERS\%USERNAME%\%%K.LNK /A:C /T:\\192.168.0.1\%%K\
	)
)

REM Create new file to indicate script has been run.
IF NOT EXIST "C:\DONT-DELETE" MKDIR C:\DONT-DELETE
ECHO File Created When NAS Drives Mapped. Used To Check If Mapping Required. > C:\DONT-DELETE\NASshortcuts.txt
:ENDONE
CLS