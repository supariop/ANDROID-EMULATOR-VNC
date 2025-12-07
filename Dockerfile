FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

# Install required packages
RUN apt-get update && apt-get install -y \
    wget unzip curl sudo \
    lib32stdc++6 lib32z1 \
    x11vnc xvfb \
    fluxbox net-tools \
    qemu-kvm \
    && rm -rf /var/lib/apt/lists/*

# Create SDK folder
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools

WORKDIR /opt/android-sdk/cmdline-tools

# Download Android Command-line tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip \
    && mkdir -p latest \
    && unzip tools.zip -d latest \
    && rm tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install required Android components
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-25" \
    "system-images;android-25;google_apis;x86" \
    "system-images;android-25;google_apis;arm64-v8a" \
    "emulator"

# Create AVDs
RUN echo no | avdmanager create avd \
    --name android7_x86 \
    --package "system-images;android-25;google_apis;x86" \
    --device "Nexus 5" \
    --sdcard 512M

RUN echo no | avdmanager create avd \
    --name android7_arm \
    --package "system-images;android-25;google_apis;arm64-v8a" \
    --device "Nexus 5" \
    --sdcard 512M

# Copy start script
COPY start-emulator.sh /start-emulator.sh
RUN chmod +x /start-emulator.sh

EXPOSE 5900 5555

CMD ["/start-emulator.sh"]
