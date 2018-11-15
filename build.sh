#!/usr/bin/env sh
mkdir cmake-build-release
cd cmake-build-release

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ASV_ENV_DIR
cmake --build . --config Release --target barcode
