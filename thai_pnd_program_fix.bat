@echo off

REM check Administrator privileges
	net session >nul 2>&1
	if %ERRORLEVEL% EQU 0 (
		echo ----- Administrator PRIVILEGES Detected! ----- 
		goto :start
	) else (
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

REM set path
	set len=8
	set prg[0]=Pexport
	set prg[1]=PP30
	set prg[2]=PND1
	set prg[3]=PND1_TRN
	set prg[4]=PND3
	set prg[5]=PND3_TRN
	set prg[6]=PND53
	set prg[7]=PND53_TRN
	
	set i=0
		:loop_set_path
		if %i% equ %len% (
			echo ERROR : PND program not found install 
			pause
			goto :eof
		)
		for /f "usebackq delims== tokens=2" %%p in (`set prg[%i%]`) do (
			if %OS%==64BIT (
				if exist "%ProgramFiles(x86)%\Rdinet\%%p" (
					set pndPath="%ProgramFiles(x86)%\Rdinet\%%p"
					set systemPath="C:\Windows\SysWOW64"
					echo ----- Using 64bit operating system, %%p has been install ----- 
					goto :copyosx
				)
			)
			if %OS%==32BIT (
				if exist "%ProgramFiles%\Rdinet\%%p" (
					set pndPath="%ProgramFiles%\Rdinet\%%p"
					set systemPath="C:\windows\System32"
					echo ----- Using 32bit operating system, %%p has been install ----- 
					goto :copyosx
				)
			)
		)
	set /a i=%i%+1
	goto loop_set_path
	
REM copy and register file
	:copyosx
	set len=5
	set ocx[0]=comdlg32.ocx
	set ocx[1]=crystl32.ocx
	set ocx[2]=MSFLXGRD.OCX
	set ocx[3]=msmask32.ocx
	set ocx[4]=tabctl32.ocx

	set j=0
		:loop_copy_file
		if %j% equ %len% (
			pause
			goto :eof
		)
		for /f "usebackq delims== tokens=2" %%j in (`set ocx[%j%]`) do (
			echo ----- Copy %%j to system -----
			echo N | xcopy "%pndPath:"=%\%%j" %systemPath%
			echo ----- Register %%j to system -----
			regsvr32 %systemPath:"=%\%%j"
		)
	set /a j=%j%+1
	goto :loop_copy_file


