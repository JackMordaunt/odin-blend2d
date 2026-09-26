#!/usr/bin/env bash

set -xeu

cmake_flags=(-DCMAKE_BUILD_TYPE=Release -DBLEND2D_STATIC=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON)

# On Windows, build with clang-cl since MSVC hits an internal compiler error on
# the AVX2 deflate decoder. Link the static CRT to match what Odin links.
# Use ninja.exe explicitly, as some ninja wrappers on PATH (e.g. depot_tools)
# can't be run by CMake.
if [[ "$(uname)" == MINGW* || "$(uname)" == MSYS* ]]; then
  cmake_flags+=(
    -G Ninja
    -DCMAKE_MAKE_PROGRAM="$(command -v ninja.exe)"
    -DCMAKE_C_COMPILER=clang-cl
    -DCMAKE_CXX_COMPILER=clang-cl
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
  )
fi

# Build blend2d static lib.
cmake -S blend2d -B .build "${cmake_flags[@]}"
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
