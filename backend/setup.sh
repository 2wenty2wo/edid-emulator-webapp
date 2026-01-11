#!/bin/bash

# Clone the edid-rw repository from GitHub
git clone https://github.com/bulletmark/edid-rw

# Change to the edid-rw directory
cd edid-rw

# Run a test read
echo "Running test read..."
sudo ./edid-rw 2 | edid-decode
echo "Test read completed."
