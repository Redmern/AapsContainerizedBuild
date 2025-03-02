# Use the official OpenJDK 21 image as the base
FROM openjdk:21-jdk-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip git && \
    rm -rf /var/lib/apt/lists/*

# Install Gradle 8.10
RUN wget https://services.gradle.org/distributions/gradle-8.10-bin.zip && \
    unzip gradle-8.10-bin.zip -d /opt && \
    ln -s /opt/gradle-8.10/bin/gradle /usr/bin/gradle && \
    rm gradle-8.10-bin.zip

# Install Android SDK (Command Line Tools)
RUN mkdir -p /opt/android-sdk && \
    cd /opt/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip -d cmdline-tools && \
    mv cmdline-tools/cmdline-tools cmdline-tools/latest && \
    rm commandlinetools-linux-11076708_latest.zip

# Set environment variables for Android SDK
ENV ANDROID_HOME /opt/android-sdk
ENV PATH $ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# Install required Android SDK components (Android 14/UpsideDownCake)
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0"

# Set working directory
WORKDIR /app

# Copy the build script and environment file
COPY build.sh /app/build.sh
COPY build.env /app/build.env
COPY keystorefile.jks /app/output/keystorefile.jks

# Make the build script executable
RUN chmod +x /app/build.sh
RUN chmod +x /app/output/keystorefile.jks

# Run the build script
CMD ["./build.sh"]