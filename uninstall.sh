#!/usr/bin/env bash
if [ -f $ASV_BUILD_DIR/cmake-build-release/install_manifest.txt ]; then
    xargs rm < $ASV_BUILD_DIR/cmake-build-release/install_manifest.txt
fi