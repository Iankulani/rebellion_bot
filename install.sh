#!/bin/bash
# REBELLION_BOT_V2 - Full Installation Script

set -e

echo "🐋 REBELLION_BOT_V2 Full Installation"
echo "===================================="

# Detect OS
OS="$(uname -s)"
echo -e "📡 Detected OS: $OS"

# Install system dependencies based on OS
if [[ "$OS" == "Linux" ]]; then
    echo -e "📦 Installing system dependencies..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y \
            python3 python3-pip python3-dev \
            nmap netcat-openbsd curl iputils-ping \
            dnsutils traceroute whois openssh-client \
            tcpdump libpcap-dev \
            git wget unzip \
            build-essential libssl-dev libffi-dev
    elif command -v yum &> /dev/null; then
        sudo yum install -y \
            python3 python3-pip python3-devel \
            nmap nc curl iputils \
            bind-utils traceroute whois openssh-clients \
            tcpdump libpcap-devel \
            git wget unzip \
            gcc openssl-devel libffi-devel
    elif command -v apk &> /dev/null; then
        sudo apk add \
            python3 python3-dev py3-pip \
            nmap netcat-openbsd curl iputils \
            bind-tools traceroute whois openssh-client \
            tcpdump libpcap-dev \
            git wget unzip \
            gcc musl-dev libffi-dev openssl-dev
    fi
elif [[ "$OS" == "Darwin" ]]; then
    echo -e "📦 Installing Homebrew dependencies..."
    if command -v brew &> /dev/null; then
        brew install \
            python3 \
            nmap netcat curl \
            bind traceroute whois openssh \
            tcpdump libpcap \
            git wget unzip
    else
        echo -e "⚠️ Homebrew not found. Install from: https://brew.sh/"
    fi
fi

# Install Python dependencies
echo -e "📦 Installing Python dependencies..."
pip3 install --upgrade pip
pip3 install -r requirements.txt
pip3 install -r requirements-full.txt || echo -e "⚠️ Some optional dependencies failed"

# Install Nikto
echo -e "📦 Installing Nikto..."
if ! command -v nikto &> /dev/null; then
    if [[ -d /opt/nikto ]]; then
        sudo rm -rf /opt/nikto
    fi
    sudo git clone https://github.com/sullo/nikto.git /opt/nikto
    sudo ln -sf /opt/nikto/program/nikto.pl /usr/local/bin/nikto
    sudo chmod +x /usr/local/bin/nikto
fi

# Create directories
mkdir -p .rebellion rebellion_reports temp config payloads logs

# Make scripts executable
chmod +x setup.sh run.sh

echo -e "✅ Installation complete!"
echo -e "Run with: ./run.sh"