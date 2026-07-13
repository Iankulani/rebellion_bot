@echo off
echo 🐋 REBELLION_BOT_V2 Full Installation (Windows)
echo ===============================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Please run as Administrator
    echo    Right-click install.bat and select "Run as administrator"
    pause
    exit /b 1
)

REM Check Python
echo 🔍 Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python not found! Please install Python 3.7+
    echo    Download from: https://python.org/downloads/
    pause
    exit /b 1
)

REM Check pip
echo 📦 Checking pip...
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo 📦 Installing pip...
    python -m ensurepip --upgrade
)

REM Upgrade pip
echo 📦 Upgrading pip...
python -m pip install --upgrade pip

REM Install dependencies
echo 📦 Installing Python dependencies...
python -m pip install -r requirements.txt
python -m pip install -r requirements-full.txt 2>nul || echo ⚠️ Some optional dependencies failed

REM Install Nmap
echo 📦 Installing Nmap...
if not exist "%ProgramFiles%\Nmap\nmap.exe" (
    echo    Downloading Nmap...
    powershell -Command "Invoke-WebRequest -Uri 'https://nmap.org/dist/nmap-7.94-setup.exe' -OutFile '%TEMP%\nmap-setup.exe'"
    echo    Installing Nmap...
    %TEMP%\nmap-setup.exe /S
    del %TEMP%\nmap-setup.exe
)

REM Create directories
echo 📁 Creating directories...
if not exist .rebellion mkdir .rebellion
if not exist rebellion_reports mkdir rebellion_reports
if not exist temp mkdir temp
if not exist config mkdir config
if not exist payloads mkdir payloads
if not exist logs mkdir logs

REM Create config
if not exist config\config.json (
    echo 📝 Creating default config...
    (
        echo {
        echo     "version": "2.0.0",
        echo     "auto_start": false,
        echo     "web": {
        echo         "enabled": true,
        echo         "port": 5000,
        echo         "host": "0.0.0.0"
        echo     },
        echo     "keylogger_enabled": true,
        echo     "keylogger_port": 4444,
        echo     "agent": {
        echo         "enabled": false,
        echo         "port": 5555
        echo     }
        echo }
    ) > config\config.json
)

echo.
echo ✅ Installation complete!
echo Run with: run.bat
pause