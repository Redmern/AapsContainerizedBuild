#!/bin/bash

source /app/build.env

git clone --branch 3.3.1.3 https://github.com/nightscout/AndroidAPS.git /app/AndroidAPS
cd /app/AndroidAPS

# if [ -f "/app/$KEYSTORE_FILE" ]; then
#     cp "/app/$KEYSTORE_FILE" /app/AndroidAPS/app/
# fi

./gradlew assembleRelease \
    -PkeystoreFile="$KEYSTORE_FILE" \
    -PkeystorePassword="$KEYSTORE_PASSWORD" \
    -PkeyAlias="$KEY_ALIAS" \
    -PkeyPassword="$KEY_PASSWORD" 

mkdir -p /app/output
cp /app/AndroidAPS/app/build/outputs/apk/full/release/*.apk /app/output/