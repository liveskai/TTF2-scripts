@echo off
:server
echo [%date%]  -  [%time%]   Server Start
echo n| start /wait NorthstarLauncher.exe -dedicated -multiple
echo [%date%]  -  [%time%] WARNING: Server closed or crashed, restarting....
timeout 9
goto server