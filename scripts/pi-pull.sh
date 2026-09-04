#!/usr/bin/env bash
# Update and rebuild Trolley-X on the Pi.
#
# One-time setup on the Pi:
#   cd ~
#   git clone --recurse-submodules git@github.com:cruisemaniac/dissertation-trolley-x.git
#   cd ~/dissertation-trolley-x/ros2_ws && colcon build --symlink-install
#   # in ~/.bashrc: source ~/dissertation-trolley-x/ros2_ws/install/setup.bash
#
# After that, sync with a single command:
#   ~/dissertation-trolley-x/scripts/pi-pull.sh
set -euo pipefail
REPO="$HOME/dissertation-trolley-x"
cd "$REPO"
git pull --ff-only
git submodule update --init --recursive
cd "$REPO/ros2_ws"
colcon build --symlink-install
echo "Done. Run: source $REPO/ros2_ws/install/setup.bash"
