#!/bin/bash

echo "Checking for KVM support..."
if [[ -e /dev/kvm ]]; then
    echo "✔ KVM detected — using FAST x86 emulator"
    AVD="android7_x86"
    GPU="auto"
else
    echo "❌ No KVM — using SLOW ARM emulator"
    AVD="android7_arm"
    GPU="swiftshader_indirect"
fi

# Start virtual display
Xvfb :0 -screen 0 1280x720x24 &
export DISPLAY=:0

# Start VNC server
x11vnc -forever -usepw -display :0 &

# Start window manager
fluxbox &

# Start emulator
emulator -avd $AVD \
    -gpu $GPU \
    -no-boot-anim \
    -verbose \
    -qemu -m 2048
