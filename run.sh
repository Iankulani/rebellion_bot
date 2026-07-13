#!/bin/bash
# REBELLION_BOT_V2 - Run Script

echo "🤖 Starting REBELLION_BOT_V2..."
echo "================================"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found!"
    echo "Please install Python 3.7+"
    exit 1
fi

# Check for dependencies
echo "🔍 Checking dependencies..."
python3 -c "import flask" 2>/dev/null || {
    echo "⚠️ Missing dependencies. Running setup..."
    ./setup.sh
}

# Run the bot
echo "🚀 Starting REBELLION_BOT_V2..."
python3 rebellion_bot.py