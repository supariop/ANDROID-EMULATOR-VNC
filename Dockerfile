FROM ubuntu:16.04

ENV ANDROID_VERSION=7.1.2
ENV ANDROID_SERIAL=emulator-5554
ENV VNC_PASSWORD="Clown80990@"

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    x11vnc \
    adb \
    openjdk-8-jdk \
    --no-install-recommends

# Download and install Android SDK Command Line Tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O android-commandline-tools.zip
RUN mkdir -p /opt/android-sdk && unzip android-commandline-tools.zip -d /opt/android-sdk && rm android-commandline-tools.zip
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# Install necessary SDK components
RUN yes | sdkmanager "platform-tools" "platforms;android-${ANDROID_VERSION##*.}" "system-images;android-${ANDROID_VERSION##*.};google_apis;x86" "emulator"

# Create AVD
RUN echo "no" | avdmanager create avd -n Pixel_API${ANDROID_VERSION##*.} -k "system-images;android-${ANDROID_VERSION##*.};google_apis;x86" -f

# VNC setup
RUN apt-get install -y x11vnc
RUN mkdir /root/.vnc
RUN echo "$VNC_PASSWORD" > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900

CMD ["/start.sh"]
