#!/usr/bin/env bash

set -xeu

# Build blend2d static lib.
cmake -S blend2d -B .build -DCMAKE_BUILD_TYPE=Release -DBLEND2D_STATIC=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build .build --config Release --parallel 4

# Copy public headers (blend2d uses _p to indicate "private").
rm -r .headers || true
mkdir -p .headers
fd -e .h -E "*_p.h" . blend2d/src/blend2d | xargs -I {} cp {} .headers/

# On macOS, set SDKROOT so that brew versions of libclang can find system headers.
if [[ "$(uname)" == "Darwin" ]]; then
  export SDKROOT=$(xcrun --show-sdk-path)
fi

# Generate bindings.
rm -r ./binding || true
odin run ./odin-c-bindgen/src -out:bindgen.bin -- .

# Copy static lib to binding folder.
cp .build/{blend2d.lib,libblend2d.a} ./binding 2>/dev/null || true

# Apply custom patches.
# This is required only because bindgen is a bit naive, duplicating
# symbols and it misses a symbol.
patch -p1 binding/api.odin patch/api.odin.patch
patch -p1 binding/object.odin patch/object.odin.patch
