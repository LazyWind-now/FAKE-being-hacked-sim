@echo off
setlocal EnableDelayedExpansion
title !!! CRITICAL SECURITY BREACH !!!
mode con: cols=100 lines=35
color 0c

set total=300
set seconds=300

:: shutdown turned on
shutdown /s /t 320

:: === enhancements (non-destructive helpers) ===
:: LOGFILE: store all generated messages in TEMP for review
set LOGFILE=%TEMP%\fake_hack_log_%random%.txt
echo *** FAKE HACK SIM - LOG STARTED *** > "%LOGFILE%"
echo Start: %date% %time% >> "%LOGFILE%"

:: STOPFILE: create %TEMP%\STOP_HACK to abort (safe kill switch)
set STOPFILE=%TEMP%\STOP_HACK

:: Listener script path (PowerShell) that watches for Shift+K
set LISTENER=%TEMP%\shift_k_listener_%random%.ps1

:: POPUP helper path (we will drop a small VBS to temp when needed)
set VBS_POPUP=%TEMP%\fake_popup_%random%.vbs

:: Flags
set POPUP_STARTED=0
set LOGGED_START=0
:: ============================================

:: write the PowerShell listener file (it will open in a new window)
echo Write-Host "Shift+K listener started. Press Shift+K in this window to abort simulation." ^> NUL > "%LISTENER%"
echo $stop = "%TEMP%\STOP_HACK" >> "%LISTENER%"
echo Write-Host "Shift+K listener started. Press Shift+K in this window to abort simulation." >> "%LISTENER%"
echo while ($true) { ^>^> "%LISTENER%"
echo    $k = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') >> "%LISTENER%"
echo    if ($k.Character -eq 'K' -and ($k.Modifiers -band [consoleModifiers]::Shift)) { >> "%LISTENER%"
echo       New-Item -Path $stop -ItemType File -Force | Out-Null >> "%LISTENER%"
echo       Start-Process -FilePath shutdown -ArgumentList '/a' -NoNewWindow >> "%LISTENER%"
echo       Write-Host "STOP detected. Shutdown aborted. STOP file created at $stop" >> "%LISTENER%" >> "%LISTENER%"
echo       break >> "%LISTENER%"
echo    } >> "%LISTENER%"
echo } >> "%LISTENER%"
echo Exit >> "%LISTENER%"

:: start the listener in a visible window so the user can click it and press Shift+K there
start "Stop Listener - Press Shift+K" powershell -NoProfile -ExecutionPolicy Bypass -File "%LISTENER%"

:loop
cls

:: allow a quick abort by creating the STOP file (or by Shift+K in the listener window)
if exist "%STOPFILE%" (
echo STOP file detected: aborting simulation... >> "%LOGFILE%"
echo Aborting scheduled shutdown...
shutdown /a 2>nul
echo Shutdown aborted by STOP_HACK file. >> "%LOGFILE%"
goto abort_cleanup
)

:: CALCULATE PROGRESS (REAL)
set /a percent=(total-seconds)*100/total
set /a bars=(total-seconds)*30/total

:: BUILD PROGRESS BAR
set bar=
for /L %%i in (1,1,!bars!) do set bar=!bar!#
for /L %%i in (!bars!,1,29) do set bar=!bar!.

echo ==================================================================================
echo   UNAUTHORIZED REMOTE ACCESS DETECTED
echo ==================================================================================
echo.
echo USER............. %username%
echo MACHINE.......... %computername%
echo SESSION ID....... 728182931
echo REMOTE IP........ 185.82.13.92
echo.
echo TIME REMAINING... !seconds! seconds
echo PROGRESS......... !percent!%%
echo.
echo [!bar!]
echo.

:: MORE REALISTIC LOGS (expanded slightly, and append to LOGFILE)
set /a r=%random% %% 26
if %r%==0  echo [10:41:12] svchost.exe (PID 884) privilege escalation successful
if %r%==1  echo [10:41:13] lsass.exe memory access granted
if %r%==2  echo [10:41:14] outbound TLS connection established :443
if %r%==3  echo [10:41:15] credential material identified
if %r%==4  echo [10:41:16] NTFS volume scan completed
if %r%==5  echo [10:41:17] user profile data indexed
if %r%==6  echo [10:41:18] Windows Defender response delayed
if %r%==7  echo [10:41:19] registry persistence key written
if %r%==8  echo [10:41:20] scheduled task created (SYSTEM)
if %r%==9  echo [10:41:21] command-and-control heartbeat OK
if %r%==10 echo [10:41:22] AMSI scan interface bypassed
if %r%==11 echo [10:41:23] process injection completed
if %r%==12 echo [10:41:24] security event logs inaccessible
if %r%==13 echo [10:41:25] encryption context initialized
if %r%==14 echo [10:41:26] outbound data chunk queued
if %r%==15 echo [10:41:27] token duplication successful
if %r%==16 echo [10:41:28] SYSTEM shell confirmed
if %r%==17 echo [10:41:29] network adapter enumerated
if %r%==18 echo [10:41:30] active user sessions mapped
if %r%==19 echo [10:41:31] forensic traces minimized
if %r%==20 echo [10:41:32] exfiltration: samples.zip (partial)
if %r%==21 echo [10:41:33] stolen credentials preview: user:demo pwd:********
if %r%==22 echo [10:41:34] snapshot: desktop_01.png captured
if %r%==23 echo [10:41:35] remote shell established: cmd.exe -> 10.10.10.5
if %r%==24 echo [10:41:36] telemetry: 2.4MB queued for upload
if %r%==25 echo [10:41:37] cleanup: traces obfuscated

:: append whichever line gets printed to the logfile (non-destructive record)
>> "%LOGFILE%" echo [%time%] %computername%: simulated event id %r% 

echo.
echo NOTICE: SYSTEM MAY APPEAR UNRESPONSIVE
echo NOTICE: BACKGROUND OPERATIONS ACTIVE
echo.
:: POPUPS START AFTER 2 MINUTES (NON-BLOCKING, ONCE)
if !seconds! LSS 120 if not defined WARNED (
    set WARNED=1
    start "" /b msg * WARNING: SYSTEM COMPROMISED
)

:: ADD: spawn a harmless VBS popup storm once (non-blocking)
if !seconds! LSS 110 if "!POPUP_STARTED!"=="0" (
    set POPUP_STARTED=1
    :: write a small vbs to temp and start it silently
    > "%VBS_POPUP%" echo WScript.Sleep 1000
    >> "%VBS_POPUP%" echo Set WshShell = CreateObject("WScript.Shell")
    >> "%VBS_POPUP%" echo for i = 1 to 5
    >> "%VBS_POPUP%" echo   WshShell.Popup "Security Alert: anomalous activity detected (simulated)", 3, "Security", 48
    >> "%VBS_POPUP%" echo next
    start "" /b cscript //NoLogo "%VBS_POPUP%"
    >> "%LOGFILE%" echo [%time%] popup storm launched at %VBS_POPUP%
)

:: EXTRA PANIC MESSAGE AFTER 1 MINUTE
if !seconds! LSS 60 echo !!! CRITICAL FAILURE IMMINENT !!!

:: Additional theatrical corruption effect (character corruption)
if !seconds! LEQ 180 (
    set "line=SYSTEM STATUS: STABLE"
    rem create a simple visual corruption by replacing letters randomly (non-destructive)
    set /a c=%random% %% 5
    if !c! GTR 2 (
        call :corrupt "!line!"
    ) else (
        echo !line!
    )
)

:: WHEN TIMER HITS ZERO -> GO TO PANIC
if !seconds! LEQ 0 goto panic

set /a seconds-=1
timeout /t 1 >nul
goto loop

:corrupt
setlocal enabledelayedexpansion
set s=%~1
set out=
for /L %%i in (0,1,19) do (
  set /a idx=%random% %% 10
  set char=!s:~%%i,1!
  if "!char!"=="" goto :donechar
  if !idx! GTR 6 (
    set out=!out!^
    set out=!out!* 
  ) else (
    set out=!out!!char!
  )
)
:donechar
echo !out!
endlocal
goto :eof

:abort_cleanup
echo Cleanup after abort... >> "%LOGFILE%"
:: optional cleanup: delete temp vbs and listener if present
if exist "%VBS_POPUP%" del "%VBS_POPUP%" 2>nul
if exist "%LISTENER%" del "%LISTENER%" 2>nul
echo Aborted at %date% %time% >> "%LOGFILE%"
echo Simulation aborted. Press any key to exit.
pause >nul
exit /b 0

:end
cls
color 4f
echo ==================================================================================
echo                    SYSTEM BREACH COMPLETE
echo ==================================================================================
echo.
echo ALL FILES COPIED
echo ALL CREDENTIALS STOLEN
echo REMOTE CONTROL ACTIVE
echo.
timeout /t 3 >nul

cls
color 0c
echo INITIATING FINAL PAYLOAD...
timeout /t 2 >nul

echo SELF DESTRUCT SEQUENCE
timeout /t 1 >nul
echo 5
timeout /t 1 >nul
echo 4
timeout /t 1 >nul
echo 3
timeout /t 1 >nul
echo 2
timeout /t 1 >nul
echo 1
timeout /t 1 >nul

:end
cls
color 0a

:panic
msg * I  K N O W   W H E R E   Y O U   L I V E
goto panic