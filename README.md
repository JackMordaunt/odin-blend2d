# `odin-blend2d`

> Bindings for [Blend2D](https://blend2d.com) vector graphics library.

Bindings are generated with [bindgen](https://github.com/karl-zylinski/odin-c-bindgen),
with custom patches applied to fix some naive output.

## Generate

Blend2D source (and asmjit) is wholly included as a subtree.

The file `./script/generate.sh` will compile a static library from source for
your system, and generate the bindings from the headers.

You will need to run `./script/generate.sh` to acquire the static library compatible
with your system, or follow Blend2D's [build instructions](https://blend2d.com/doc/build-instructions.html) yourself.

## Examples

The examples folder contains some samples directly ported from Blend2D.
Run the samples like so:

```sh
odin run ./example/sample_1.odin -file -extra-linker-flags:"-lstdc++"
```

While Blend2D offers a C api, we still need to link stdc++ the static lib uses C++.
