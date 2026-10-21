@echo off
title Hermes Stack Manager
start "" powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0HermesManager.ps1"
exit
