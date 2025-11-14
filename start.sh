#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1280x720x16 &

# Start VNC server
x11vnc -display :1 -nopw -listen localhost &

# Start Android Emulator
emulator -avd Pixel_API_28 -no-window -no-audio -no-boot-anim &

# Keep the container running
tail -f /dev/null
