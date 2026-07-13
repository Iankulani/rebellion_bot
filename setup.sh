#!/bin/bash
# REBELLION_BOT_V2 - Setup Script (Linux/Mac)

set -e

echo "🐋 REBELLION_BOT_V2 Setup Script"
echo "================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check Python version
echo -e "${BLUE}🔍 Checking Python version...${NC}"
python_version=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
if [[ "$(echo "$python_version 3.7" | awk '{print ($1 < $2)}')" == "1" ]]; then
    echo -e "${RED}❌ Python 3.7+ required (found $python_version)${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python $python_version${NC}"

# Check for pip
echo -e "${BLUE}🔍 Checking pip...${NC}"
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}❌ pip3 not found${NC}"
    echo -e "${YELLOW}Installing pip...${NC}"
    python3 -m ensurepip --upgrade
fi
echo -e "${GREEN}✅ pip3 found${NC}"

# Install Python dependencies
echo -e "${BLUE}📦 Installing Python dependencies...${NC}"
pip3 install --upgrade pip
pip3 install -r requirements.txt
pip3 install -r requirements-full.txt || echo -e "${YELLOW}⚠️ Some optional dependencies failed${NC}"

# Check for required system tools
echo -e "${BLUE}🔍 Checking system tools...${NC}"
tools=("nmap" "curl" "nc" "dig" "traceroute" "whois" "ssh" "ping" "netcat")
missing=()
for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        missing+=("$tool")
    fi
done

if [ ${#missing[@]} -ne 0 ]; then
    echo -e "${YELLOW}⚠️ Missing system tools: ${missing[*]}${NC}"
    echo -e "${YELLOW}Install with: sudo apt-get install ${missing[*]}${NC}"
fi

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
mkdir -p .rebellion
mkdir -p rebellion_reports
mkdir -p temp
mkdir -p config
mkdir -p payloads
mkdir -p logs

# Create config file if not exists
if [ ! -f "config/config.json" ]; then
    echo -e "${BLUE}📝 Creating default config...${NC}"
    cat > config/config.json << EOF
{
    "version": "2.0.0",
    "auto_start": false,
    "web": {
        "enabled": true,
        "port": 5000,
        "host": "0.0.0.0"
    },
    "keylogger_enabled": true,
    "keylogger_port": 4444,
    "agent": {
        "enabled": false,
        "port": 5555
    }
}
EOF
fi

# Make scripts executable
chmod +x run.sh

echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "${BLUE}Run with: ./run.sh${NC}"