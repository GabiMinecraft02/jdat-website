@echo off
title JDAT Setup
echo =========================
echo JDAT Installer
echo =========================
echo.

:: === ADMIN CHECK ===
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run this setup as Administrator.
    pause
    exit /b
)

:: === CONFIG ===
set JDAT_DIR=C:\Jdat
set SYSTEM32=%WINDIR%\System32
set BASE_URL=https://jdat.onrender.com/download
set TOKEN=JDAT_INSTALLER_2026

:: === CREATE JDAT DIR ===
echo Creating C:\Jdat ...
if not exist %JDAT_DIR% (
    mkdir %JDAT_DIR%
)

:: === DOWNLOAD FILES ===
echo Downloading files...

curl -L "%BASE_URL%/jdat.exe?token=%TOKEN%" -o "%JDAT_DIR%\jdat.exe"
curl -L "%BASE_URL%/jdat-shell.exe?token=%TOKEN%" -o "%JDAT_DIR%\jdat-shell.exe"
curl -L "%BASE_URL%/version.txt?token=%TOKEN%" -o "%JDAT_DIR%\version.txt"

:: === CREATE jdat-shell.bat ===
echo Creating jdat-shell.bat ...

echo @echo off > "%SYSTEM32%\jdat-shell.bat"
echo "%JDAT_DIR%\jdat-shell.exe" %%* >> "%SYSTEM32%\jdat-shell.bat"

:: === COPY FILES TO SYSTEM32 ===
echo Copying shell launcher to System32...

if exist "%SYSTEM32%\jdat-shell.bat" (
    echo Shell installed successfully.
) else (
    echo Failed to install shell.
)

:: === FINAL ===
echo.
echo =========================
echo JDAT installed successfully
echo Location: C:\Jdat
echo You can now use:
echo   jdat-shell
echo =========================
echo.

pause
