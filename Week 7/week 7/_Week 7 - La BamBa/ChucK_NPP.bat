	@echo off

rem need to have 'audio' in the same repertory when we launch this batch

rem set a variable env.
set CHUCK_AUDIO_PATH=%CD%\__MEDIAS__
echo -- ChucK path audio set to: %CHUCK_AUDIO_PATH%

SET CHUCK_CURRENT_PATH=%CD%

rem - start /b :  Start application without creating a new window. The
rem             application has ^C handling ignored. Unless the application
rem	            enables ^C processing, ^Break is the only way to interrupt
rem             the application
rem - cmd /c : Carries out the command specified by string and then terminates
rem -> Launch the text editor (NPP)
@start /b cmd /c "C:\Program Files (x86)\Notepad++\notepad++.exe"

rem Run the ChucK Virtual Machine on the LocalHost
rem --verbose2 : (SYSTEM) info debugs on
chuck --verbose2 --loop

