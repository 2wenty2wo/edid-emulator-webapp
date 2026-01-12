#!/bin/bash
set -e

USER_NAME=$(whoami)
HOME_DIR="$HOME"
APP_DIR="$HOME_DIR/edid-emulator-webapp"
BACKEND_DIR="$APP_DIR/backend"
SCRIPT_PATH="$APP_DIR/start_edid_ui.sh"
DESKTOP_FILE="$HOME_DIR/Desktop/EDID-Emulator.desktop"
SYSTEMD_DIR="$HOME_DIR/.config/systemd/user"
SERVICE_FILE="$SYSTEMD_DIR/edid-emulator.service"
URL="http://127.0.0.1:5000"

echo "========================================"
echo " EDID Emulator Kiosk Setup (Portrait DSI)"
echo "========================================"

echo "Installing dependencies..."
sudo apt update
sudo apt install -y epiphany-browser xdotool curl

echo "Creating launcher script with DSI portrait support..."
cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash

APP_DIR="$HOME/edid-emulator-webapp"
BACKEND_DIR="$APP_DIR/backend"
URL="http://127.0.0.1:5000"

export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

# Rotate DSI display to portrait
xrandr --output DSI-1 --rotate right

# Find FT5x06 touchscreen device ID dynamically
TOUCH_ID=$(xinput list | grep -i 'ft5x06' | grep -o 'id=[0-9]*' | cut -d= -f2)

if [ -n "$TOUCH_ID" ]; then
    echo "Mapping touchscreen ID $TOUCH_ID to DSI-1"
    xinput map-to-output "$TOUCH_ID" DSI-1
else
    echo "WARNING: Touchscreen device not found"
fi



cd "$BACKEND_DIR"

# Activate venv if present
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
fi

# Start Flask
python3 app.py &

FLASK_PID=$!

echo "Waiting for Flask to start..."
for i in {1..20}; do
    curl -s "$URL" >/dev/null && break
    sleep 1
done

# Launch browser
epiphany "$URL" &

# Allow window to appear
sleep 5

# Fullscreen browser
xdotool search --onlyvisible --class epiphany windowactivate --sync key F11

wait $FLASK_PID
EOF

chmod +x "$SCRIPT_PATH"

echo "Creating desktop launcher..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Type=Application
Name=EDID Emulator
Comment=Launch EDID Emulator UI
Exec=$SCRIPT_PATH
Icon=utilities-terminal
Terminal=false
Categories=Utility;
StartupNotify=false
EOF

chmod +x "$DESKTOP_FILE"

echo "Creating systemd user service..."
mkdir -p "$SYSTEMD_DIR"

cat > "$SERVICE_FILE" << EOF
[Unit]
Description=EDID Emulator UI (Portrait DSI)
After=graphical-session.target network-online.target

[Service]
Type=simple
ExecStart=$SCRIPT_PATH
Restart=on-failure
Environment=DISPLAY=:0
Environment=XAUTHORITY=$HOME_DIR/.Xauthority

[Install]
WantedBy=default.target
EOF

echo "Enabling systemd user service..."
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable edid-emulator.service

echo "Enabling lingering (allow service at login)..."
sudo loginctl enable-linger "$USER_NAME"

echo
echo "========================================"
echo " Setup complete!"
echo
echo "• DSI-1 display set to PORTRAIT"
echo "• Touchscreen aligned (ft5x06)"
echo "• Desktop icon created"
echo "• Auto-start enabled at login"
echo
echo "You can now:"
echo "• Reboot, or"
echo "• Log out / log back in, or"
echo "• Click the desktop icon"
echo
echo "========================================"
