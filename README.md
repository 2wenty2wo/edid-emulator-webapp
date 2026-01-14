# edid-emulator-webapp
Web-based EDID emulator management for Raspberry Pi


# Install

## Update OS
```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```

## Install Dependencies:
```
sudo apt-get install git python3 python3-smbus edid-decode
sudo reboot
```

## Download EDID Manager:
```
git clone https://github.com/padge81/edid-emulator-webapp.git
```

## Run Setup:
```
cd edid-emulator-webapp
chmod +x setup_kiosk.sh
./setup_kiosk.sh
sudo reboot
```
