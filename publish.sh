#!/bin/sh

set -ex

TARGET_ANDROID_ABIS='arm64-v8a,armeabi-v7a,x86_64,x86'
TARGET_ANDROID_API='21'

PACKAGE_NAMES="$(cat packages-large.txt)"

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
            ndk-pkg deploy  "$PACKAGE_SPEC" --local=large
        fi
    else
        printf '%s\n' "no dev files in $PACKAGE_XXXX"
    fi
done

VERSION="$(date +%Y.%m.%d.%H.%M)"

BUNDLE_DIR_NAME="ndk-pkg-prefab-aar-maven-local-repo-bundle-$VERSION"

mv large "$BUNDLE_DIR_NAME"

BUNDLE_FILENAME="$BUNDLE_DIR_NAME.tar.xz"

tar cJvf "$BUNDLE_FILENAME" "$BUNDLE_DIR_NAME"

BUNDLE_FILE_SHA256="$(sha256sum "$BUNDLE_FILENAME")"

cat > notes.md <<EOF
## bundle contains packages:

\`\`\`
$PACKAGE_NAMES
\`\`\`

## bundle sha256sum:

\`\`\`
$BUNDLE_FILE_SHA256
\`\`\`

## how to use

\`\`\`bash
curl -LO https://github.com/leleliu008/ndk-pkg-prefab-aar-maven-repo/releases/download/$VERSION/$BUNDLE_FILENAME
tar vxf $BUNDLE_FILENAME --strip-components=1 -C ~/.m2/repository
\`\`\`
EOF

gh release create "$VERSION" "$BUNDLE_FILENAME" --title "$VERSION" --notes-file notes.md
