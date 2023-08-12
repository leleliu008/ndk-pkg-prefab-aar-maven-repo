#!/bin/sh

set -x

LIST='
abseil
basis_universal
boost
brotli
c-ares
chinese-calendar
cpu_features
cpuinfo
dav1d
eigen3
expat
flatbuffers
fontconfig
freetype2
freetype2-with-harfbuzz
geographiclib
googletest
grpc
harfbuzz
icu4c
ixwebsocket
jansson
json-c
jsoncpp
libbz2
libcurl
libffi
libiconv
libjpeg-turbo
liblzma
libnghttp2
libphonenumber
libpng
libprotobuf
libsodium
libxml2
libyaml
libzstd
mbedtls
oboe
openssl
pcre2
pjsip
poco
pthreadpool
re2
ruy
sqlite
taglib
xnnpack
zlib
'

TARGET_ANDROID_ABIS='arm64-v8a,armeabi-v7a,x86_64,x86'
TARGET_ANDROID_API='android-21'

for PACKAGE_NAME in $LIST
do
    PACKAGE_SPEC="$PACKAGE_NAME:$TARGET_ANDROID_API:$TARGET_ANDROID_ABIS"

    ndk-pkg install "$PACKAGE_SPEC"

    PACKAGE_XXXX="$PACKAGE_NAME:$TARGET_ANDROID_API:${TARGET_ANDROID_ABIS%%,*}"

    if [ -d "$HOME/.ndk-pkg/installed/$PACKAGE_XXXX/include" ] ; then
        ndk-pkg deploy  "$PACKAGE_SPEC" --local=.
    else
        printf '%s\n' "no dev files in $PACKAGE_XXXX"
    fi
done
