start.sh:

 
#!/bin/bash

# Start VNC server
x11vnc -display :1 -rfbauth /root/.vnc/passwd -forever -shared &

# Start emulator
emulator -avd Pixel_API${ANDROID_VERSION##*.} -no-audio -no-window -verbose -writable-system &

# Wait for emulator to boot
sleep 60

# Connect to ADB
adb connect localhost:5555

# Keep the container running
tail -f /dev/null
