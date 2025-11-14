FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-8-jdk \
    wget \
    unzip \
    xvfb \
    x11vnc \
    fluxbox

# Download and install Android SDK Command Line Tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O android-sdk.zip
RUN mkdir -p /opt/android-sdk
RUN unzip -q android-sdk.zip -d /opt/android-sdk

# Determine the actual location of sdkmanager
RUN SDK_DIR=$(find /opt/android-sdk -name sdkmanager | xargs dirname) && \
    echo "SDK_DIR is $SDK_DIR" && \
    chmod +x "$SDK_DIR/sdkmanager"

ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Install necessary Android SDK components
RUN yes | /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager --sdk_root=/opt/android-sdk "platform-tools" "platforms;android-28" "system-images;android-28;google_apis;x86" "emulator"

# Create and configure AVD (Android Virtual Device)
RUN yes | /opt/android-sdk/cmdline-tools/tools/bin/avdmanager create avd -n Pixel_API_28 -k "system-images;android-28;google_apis;x86" -f

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900

CMD ["/start.sh"]
