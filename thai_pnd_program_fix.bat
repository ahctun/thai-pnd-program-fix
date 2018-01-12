@echo off

REM check Administrator privileges
	net session >nul 2>&1
	if %ERRORLEVEL% EQU 0 (
		echo ----- Administrator PRIVILEGES Detected! ----- 
		goto :start
	) else (
		echo ##########################################################
		echo.
		echo.
		echo ######## ########  ########   #######  ########  
		echo ##       ##     ## ##     ## ##     ## ##     ## 
		echo ##       ##     ## ##     ## ##     ## ##     ## 
		echo ######   ########  ########  ##     ## ########  
		echo ##       ##   ##   ##   ##   ##     ## ##   ##   
		echo ##       ##    ##  ##    ##  ##     ## ##    ##  
		echo ######## ##     ## ##     ##  #######  ##     ## 
		echo.
		echo.
		echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
		echo This script must be run as administrator to work properly!  
		echo If you're seeing this after clicking on a start menu icon, 
		echo then right click on the shortcut and select "Run As Administrator".
		echo ##########################################################
		echo.
		pause
		goto :eof
	)

:start
	REM set OS variables
	reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > nul && set OS=32BIT || set OS=64BIT

	if %OS%==64BIT (
			set systemPath="C:\Windows\SysWOW64"
			echo ----- Using 64bit operating system ----- 
	)
	if %OS%==32BIT (
			set systemPath="C:\windows\System32"
			echo ----- Using 32bit operating system ----- 
	)

	REM get file name array form register 
	SET curpath=%~dp0
	setlocal enableDelayedExpansion
	set /a len=0

	for /f %%G in ('dir %curpath%register /b') do (
		set fileName[!len!]=%%~G
		set /a len+=1
	)

	REM copy and register file
	set j=0
		:loop_copy_file
		if %j% equ %len% (
			goto :finish
		)
		for /f "usebackq delims== tokens=2" %%j in (`set fileName[%j%]`) do (
			if exist "%systemPath:"=%\%%j" (
				echo ----- %%j already exist -----
			) else (
				echo ----- Copy %%j to system -----
				echo N | xcopy "%curpath%register\%%j" %systemPath%
				echo ----- Register %%j to system -----
				regsvr32 %systemPath:"=%\%%j"
			)
		)
	set /a j=%j%+1
	goto :loop_copy_file
	
:finish
	echo ##########################################################
	echo.
	echo.
	echo ########   #######  ##    ## ######## 
	echo ##     ## ##     ## ###   ## ##       
	echo ##     ## ##     ## ####  ## ##       
	echo ##     ## ##     ## ## ## ## ######   
	echo ##     ## ##     ## ##  #### ##       
	echo ##     ## ##     ## ##   ### ##       
	echo ########   #######  ##    ## ######## 
	echo.
	echo.
	echo ##########################################################
	echo.
	pause
	goto :eof