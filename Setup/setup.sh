#!/bin/bash

echo "Starting setup..."

# Check for required commands
command -v python3 >/dev/null 2>&1 || { echo >&2 "Python3 is not installed. Aborting."; exit 1; }
command -v pip3 >/dev/null 2>&1 || { echo >&2 "pip3 is not installed. Aborting."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "git is not installed. Aborting."; exit 1; }

# Install Python dependencies
echo "Installing Python packages..."
pip3 install --upgrade pip
pip3 install flask

# Check for edid-decode
command -v edid-decode >/dev/null 2>&1 || { echo >&2 "edid-decode not found, installing..."; sudo apt-get install -y edid-decode; }

# Clone edid-rw if not present
if [ ! -d "edid-rw" ]; then
    echo "Cloning edid-rw..."
    git clone https://github.com/bulletmark/edid-rw.git
else
    echo "edid-rw already exists."
fi

# Make sure edid-rw is executable
chmod +x edid-rw/edid-rw

# Copy edid-rw to project directory
cp edid-rw/edid-rw ./  # Adjust if needed

echo "Setup completed."