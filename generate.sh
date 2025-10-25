#!/usr/bin/env bash

set -xeu

odin build ./odin-c-bindgen/src -out:bindgen.bin

mkdir -p binding

cp ./blend2d/src/blend2d.h ./binding/
cp -r ./blend2d/src/blend2d ./binding/

./bindgen.bin ./binding

cat ./binding/binding/blend2d.odin
