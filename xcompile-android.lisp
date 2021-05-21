#!/usr/bin/env sl-sh

(mkdir -p NDK)
(/opt/android-ndk/build/tools/make_standalone_toolchain.py --api 28 --arch arm64 --install-dir NDK/arm64)
