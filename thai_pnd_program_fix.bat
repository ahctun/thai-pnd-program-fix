@echo off
setlocal enableDelayedExpansion

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
			set pndPath="%ProgramFiles(x86)%\Rdinet"
			echo ----- Using 64bit operating system ----- 
	)
	if %OS%==32BIT (
			set systemPath="C:\Windows\System32"
			set pndPath="%ProgramFiles%\Rdinet"
			echo ----- Using 32bit operating system ----- 
	)

	REM get install PND program list
	set /a pndLen=0

	for /f %%G in ('dir %pndPath% /b') do (
		set pnd[!pndLen!]=%%~G
		set /a pndLen+=1
	)
	
	REM loop through install PND program
	set k=0
		:loop_PND_program
		if %k% equ %pndLen% (
			goto :finish
		)
		for /f "usebackq delims== tokens=2" %%k in (`set pnd[%k%]`) do (
				echo ----- %%k Program -----
					REM get file DLL and OSX from PND program 
					cd "%pndPath:"=%\%%k"
					set /a count=0

					for /f %%G in ('dir *.ocx  *.dll /b') do (
						
						REM loop through file found in PND program
						if exist "%systemPath:"=%\%%~G" (
							echo %%~G already exist
						) else (
							echo --- Copy %%~G to system
							echo N | xcopy "%pndPath:"=%\%%k\%%~G" %systemPath%
							echo --- Register %%~G to system
							regsvr32 %systemPath:"=%\%%~G"
						)
						
						set /a count+=1
						set fileName[!count!]=%%~G
						
					)
		)
	set /a k=%k%+1
	goto :loop_PND_program
	
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