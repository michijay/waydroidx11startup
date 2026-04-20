#!/bin/bash

# Waydroid X11 Manager
# Author: Michael Janssen <m.janssen@lyrah.net>
# License: GPLv3 (See README.md for details)

VERSION="1.0-0"

echo ""
echo "▗▖ ▗▖ ▗▄▖▗▖  ▗▖▗▄▄▄ ▗▄▄▖  ▗▄▖ ▗▄▄▄▖▗▄▄▄     ▗▖  ▗▖     ▗▄▄▖▗▄▄▄▖▗▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▖ "
echo "▐▌ ▐▌▐▌ ▐▌▝▚▞▘ ▐▌  █▐▌ ▐▌▐▌ ▐▌  █  ▐▌  █     ▝▚▞▘     ▐▌     █ ▐▌ ▐▌▐▌ ▐▌ █  ▐▌   ▐▌ ▐▌"
echo "▐▌ ▐▌▐▛▀▜▌ ▐▌  ▐▌  █▐▛▀▚▖▐▌ ▐▌  █  ▐▌  █      ▐▌       ▝▀▚▖  █ ▐▛▀▜▌▐▛▀▚▖ █  ▐▛▀▀▘▐▛▀▚▖"
echo "▐▙█▟▌▐▌ ▐▌ ▐▌  ▐▙▄▄▀▐▌ ▐▌▝▚▄▞▘▗▄█▄▖▐▙▄▄▀    ▗▞▘▝▚▖    ▗▄▄▞▘  █ ▐▌ ▐▌▐▌ ▐▌ █  ▐▙▄▄▖▐▌ ▐▌"
echo ""
echo " +-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+ +-+-+-+-+-+-+-+ +-+-+-+-+-+"
echo " |W|a|y|d|r|o|i|d| |X|1|1| |S|t|a|r|t|u|p| |S|c|r|i|p|t| |-| |V|e|r|s|i|o|n| "
#|1|.|0|-|0|"
echo -n "|"
echo "$VERSION" | sed 's/./&|/g'
echo " +-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+ +-+-+-+-+-+-+-+ +-+-+-+-+-+"
echo ""
sleep 2

# Fix for NVIDIA/Weston cursor visibility
export WLR_NO_HARDWARE_CURSORS=1

# Check if waydroid container is running
if ! systemctl is-active --quiet waydroid-container
then
    echo "Container is not active."
    read -p "Do you want to start it now via sudo (y/n)? : " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]
    then
        sudo systemctl start waydroid-container
    else
        echo "Aborting: Waydroid requires the container service to run."
        exit 1
    fi
fi

# Check for running waydroid-session
if waydroid session status | grep -q "RUNNING"
then
    echo "Waydroid-Session is already running."
else
    echo "Starting a new session..."
fi

# Startup Weston and the UI
echo "Starting Weston window (X11-Nested)..."
# Using 1280x720 as requested
weston --width=1280 --height=720 &
WESTON_PID=$!

# Wait for the compositor to initialize
sleep 2

# Start Waydroid UI inside the Weston window
echo "Loading Android UI..."
WAYLAND_DISPLAY=wayland-1 waydroid show-full-ui &
UI_PID=$!

echo "--------------------------------------------"
echo "Waydroid is active."
echo "Close the Weston window or press [CTRL+C] here to quit."
echo "--------------------------------------------"

# Robust cleanup on interrupt
trap "echo 'Closing...'; kill $UI_PID $WESTON_PID; waydroid session stop; exit" SIGINT SIGTERM

# Wait for Weston to be closed by the user
wait $WESTON_PID

# Post-closure cleanup
echo "Weston was closed. Stopping Waydroid-Session..."
waydroid session stop

# Brief pause to ensure session processes have detached
sleep 1

# Optional: stop container
read -p "Should the system-container be stopped as well (y/n)? : " stop_all
if [[ "$stop_all" == "y" || "$stop_all" == "Y" ]]
then
    sudo systemctl stop waydroid-container
    echo "Container stopped."
fi

echo "Goodbye!"

