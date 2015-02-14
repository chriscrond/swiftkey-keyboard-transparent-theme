#!/bin/sh

case "$1" in
"quick")
;;
"full")
;;
*)
echo $"Usage: ./install {quick|full} <password>"
exit 1
esac

KEYSTORE_PATH=~/Projects/keystore
KEYSTORE_ALIAS=drevlyanin
KEYSTORE_PASSWORD=$2
APKTOOL_JAR_PATH=~/Tools/apktool/apktool_2.0.0rc4.jar
ANDROID_SDK_PATH=~/Tools/android-sdk-linux

cp -f original.apk dirty.apk

case "$1" in
"quick")
zip -d dirty.apk assets/themes/*
cd ..
zip -r tools/dirty.apk assets/*
cd tools
;;
"full")
java -jar $APKTOOL_JAR_PATH d -f dirty.apk
rm -fr dirty/assets/themes/*
cp -fr ../assets/themes/* dirty/assets/themes/
java -jar $APKTOOL_JAR_PATH b -f -o dirty.apk dirty
rm -fr dirty
;;
esac

jarsigner -keystore $KEYSTORE_PATH -storepass $KEYSTORE_PASSWORD -sigalg MD5withRSA -digestalg SHA1 -sigfile CERT -signedjar dist.apk dirty.apk $KEYSTORE_ALIAS
rm -fr dirty.apk

# $ANDROID_SDK_PATH/tools/emulator -avd Nexus_S_API_17
$ANDROID_SDK_PATH/platform-tools/adb -d install -r dist.apk