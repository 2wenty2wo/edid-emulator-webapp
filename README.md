# edid-emulator-webapp
Web-based EDID emulator management for Raspberry Pi
do this if you installed setup_kiosk.sh with epiphany browser
# Stop and disable old user service
systemctl --user stop edid-emulator.service
systemctl --user disable edid-emulator.service
systemctl --user daemon-reload

# Optional: remove old files
rm -f ~/edid-emulator-webapp/start_edid_ui.sh
rm -f ~/.config/systemd/user/edid-emulator.service
🔹 This guarantees Epiphany will never launch again
🔹 Prevents double Flask servers
🔹 Prevents race conditions

After this, your system is clean.
