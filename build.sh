#!/bin/sh

set -ex

TARGET_ANDROID_ABIS='arm64-v8a,armeabi-v7a,x86_64,x86'
TARGET_ANDROID_API='21'

PACKAGE_NAMES="$(cat packages.txt)"

for PACKAGE_NAME in $PACKAGE_NAMES
do
    PACKAGE_SPEC="$PACKAGE_NAME:android-$TARGET_ANDROID_API:$TARGET_ANDROID_ABIS"

    ndk-pkg install "$PACKAGE_SPEC"

    PACKAGE_XXXX="$PACKAGE_NAME:android-$TARGET_ANDROID_API:${TARGET_ANDROID_ABIS%%,*}"

    if [ -d "$HOME/.ndk-pkg/installed/$PACKAGE_XXXX/include" ] ; then
        PACKAGE_VERSION="$(ndk-pkg receipt "$PACKAGE_XXXX" version)"

        if [ -d "com/fpliu/ndk/pkg/prefab/android/$TARGET_ANDROID_API/$PACKAGE_NAME/$PACKAGE_VERSION" ] ; then
            :
        else
            ndk-pkg deploy  "$PACKAGE_SPEC" --local=.
        fi
    else
        printf '%s\n' "no dev files in $PACKAGE_XXXX"
    fi
done

find com/fpliu/ndk/pkg/prefab/android/21 -name '_remote.repositories' -exec rm '{}' \;

for item in $(find com/fpliu/ndk/pkg/prefab/android/21 -name 'maven-metadata-local.xml')
do
    mv "$item" "${item%/*}/maven-metadata.xml"
done
