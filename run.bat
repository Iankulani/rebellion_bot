@echo off
echo 🤖 Starting REBELLION_BOT_V2...
echo ================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python not found!
    echo Please install Python 3.7+
    pause
    exit /b 1
)

REM Check dependencies
echo 🔍 Checking dependencies...
python -c "import flask" 2>nul
if errorlevel 1 (
    echo ⚠️ Missing dependencies. Running setup...
    call setup.bat
)

REM Run the bot
echo 🚀 Starting REBELLION_BOT_V2...
python rebellion_bot.py
pause