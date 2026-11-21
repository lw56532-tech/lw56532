@echo off
chcp 65001 >nul
title Add School Home Button - lw56532
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_home_button.ps1"
echo.
if errorlevel 1 (
  echo [FAILED] Check messages above and file locations.
) else (
  echo [DONE] Open GitHub Desktop and commit changes.
)
pause
