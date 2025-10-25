#!/usr/bin/env bash

set -xeu

echo "updating dependencies: odin-c-bindgen, blend2d, asmjit"

git subtree pull --prefix=odin-c-bindgen          https://github.com/karl-zylinski/odin-c-bindgen.git main --squash --message "update"
git subtree pull --prefix=blend2d/3rdparty/asmjit https://github.com/asmjit/asmjit master                  --squash --message "update"
git subtree pull --prefix=blend2d                 https://github.com/blend2d/blend2d master                --squash --message "update"
