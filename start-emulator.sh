#!/bin/bash

# Clean leftover X lock
rm -f /tmp/.X0-lock

# Start Xvfb
Xvfb :0 -screen 0 1280x720x24 &
export DISPLAY=:0

# Start VNC server with password "1234"
x11vnc -forever -passwd 1234 -display :0 &
fluxbox &

echo "Starting Android 7 ARM emulator (no KVM)..."

emulator -avd android7_arm \
    -gpu swiftshader_indirect \
    -no-boot-anim \
    -no-snapshot \
    -qemu -m 2048
