#!/usr/bin/env bash
# Flash the Trolley-X Arduino firmware from the Pi, over the existing USB cable.
# No unplugging: the Uno auto-resets via DTR when arduino-cli uploads, so the
# board drops into its bootloader and back on its own.
#
# ONE-TIME setup on the Pi:
#   curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh \
#     | BINDIR=$HOME/.local/bin sh
#   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
#   arduino-cli core update-index
#   arduino-cli core install arduino:avr
#   arduino-cli lib install "Adafruit MPU6050"   # pulls Adafruit Unified Sensor + BusIO
#   # serial access: the 'navigator' user must be in the dialout group
#   sudo usermod -aG dialout "$USER"   # then log out/in once
#
# Then flash any time with:
#   ~/dissertation-trolley-x/scripts/flash-arduino.sh
#
# IMPORTANT: stop anything holding the port first (the ROS base node). If a
# bringup/follow launch is running, Ctrl+C it, or the upload fails with the port
# busy.
set -euo pipefail

REPO="$HOME/dissertation-trolley-x"
SKETCH="${1:-$REPO/firmware/Trolley-X-unified-Spinal-setup}"
FQBN="arduino:avr:uno"
PORT="${PORT:-/dev/arduino}"

if ! command -v arduino-cli >/dev/null 2>&1; then
  echo "arduino-cli not found. Run the one-time setup in this script's header." >&2
  exit 1
fi
if [ ! -e "$PORT" ]; then
  echo "Port $PORT not found. Is the Arduino connected and the udev rule in place?" >&2
  exit 1
fi
if command -v fuser >/dev/null 2>&1 && fuser "$PORT" >/dev/null 2>&1; then
  echo "WARNING: $PORT is in use (a ROS node?). Stop it before flashing." >&2
  exit 1
fi

echo "Compiling $SKETCH ..."
arduino-cli compile --fqbn "$FQBN" "$SKETCH"

echo "Uploading to $PORT (auto-reset, no unplug needed) ..."
arduino-cli upload -p "$PORT" --fqbn "$FQBN" "$SKETCH"

echo "Done. The Arduino restarts into the new firmware."
