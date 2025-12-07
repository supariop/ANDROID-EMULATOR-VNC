FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools

# Install required packages
RUN apt-get update && apt-get install -y \
    wget unzip curl sudo \
    lib32stdc++6 lib32z1 \
    x11vnc xvfb \
    fluxbox net-tools \
    qemu-kvm \
    && rm -rf /var/lib/apt/lists/*

# Install Android Commandline Tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
WORKDIR /opt/android-sdk/cmdline-tools

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip \
    && unzip tools.zip -d tools \
    && rm tools.zip

# Accept SDK licenses
RUN yes | sdkmanager --licenses

# Install Android 7 images (x86 + ARM)
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-25" \
    "system-images;android-25;google_apis;x86" \
    "system-images;android-25;google_apis;arm64-v8a" \
    "emulator"

# Create both AVD profiles
RUN echo no | avdmanager create avd \
    --name android7_x86 \
    --package "system-images;android-25;google_apis;x86" \
    --device "Nexus 5"

RUN echo no | avdmanager create avd \
    --name android7_arm \
    --package "system-images;android-25;google_apis;arm64-v8a" \
    --device "Nexus 5"

# Copy start script
COPY start-emulator.sh /start-emulator.sh
RUN chmod +x /start-emulator.sh

# VNC Port
EXPOSE 5900
EXPOSE 5555

CMD ["/start-emulator.sh"]
