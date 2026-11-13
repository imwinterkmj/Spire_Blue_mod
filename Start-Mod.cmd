@echo off
powershell.exe -NoProfile -File "%~dp0Start-Mod.ps1"
if errorlevel 1 pause
