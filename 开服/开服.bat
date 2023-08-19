@echo off
:loop
echo (%time%) ttf2 server started.
echo n| start /wait NorthstarLauncher.exe -dedicated -multiple
echo (%time%) WARNING: Server closed or crashed, restarting....
timeout 10
goto loop
