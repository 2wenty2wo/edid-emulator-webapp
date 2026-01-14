# edid-emulator-webapp
Web-based EDID emulator management for Raspberry Pi.

## Requirements

### System packages / tools
- `edid-rw` (built from https://github.com/bulletmark/edid-rw and placed under `backend/edid-rw`).
- `edid-decode` (provides human-readable EDID decoding for reads).
- `python3` + `pip` (to run the Flask API and UI).

### Python dependencies
Install the Flask runtime dependencies:
- `Flask`

> Note: `backend/requirements.txt` is currently empty. If you prefer, add the packages above there and install with `pip3 install -r requirements.txt`.

## Hardware assumptions
- Raspberry Pi (or similar Linux device) with access to the EDID emulator hardware.
- EDID emulator connected such that `edid-rw` can read/write EDID on a numbered port (see `backend/app.py` for available ports).
- Optional USB storage mounted under `/media/mint` if you want to import/export EDID files from USB.

## Running the app

### Development / manual
From the repo root:

```bash
cd backend
python3 app.py
```

Then open `http://<pi-ip>:5000` in a browser.

### As a systemd service
A sample unit file is provided in `systemd/edid-webapp.service`. Adjust paths as needed, then:

```bash
sudo cp systemd/edid-webapp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now edid-webapp.service
```

## Security considerations
- The `/update_repo`, `/shutdown`, and `/reboot` endpoints perform privileged operations. **Require authentication** before exposing these endpoints.
- Avoid exposing the service directly to the public internet. Prefer a local network, VPN, or a reverse proxy with authentication/allowlists.
- If you must expose the service, restrict access by IP and ensure TLS is enabled on the reverse proxy.
