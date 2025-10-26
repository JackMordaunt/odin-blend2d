
package main

import blend2d "../binding"

main :: proc() {

	img: blend2d.ImageCore

	blend2d.image_init(&img)
	blend2d.image_create(&img, 480, 480, .PRGB32)

	ctx: blend2d.ContextCore
	ctx_cfg: blend2d.ContextCreateInfo

	blend2d.context_init(&ctx)
	blend2d.context_begin(&ctx, &img, &ctx_cfg)
	blend2d.context_clear_all(&ctx)

	texture: blend2d.ImageCore
	blend2d.image_init(&texture)
	blend2d.image_read_from_file(&texture, "blend2d/testing/resources/Leaves.jpeg", nil)

	pattern: blend2d.PatternCore
	blend2d.pattern_init(&pattern)
	blend2d.pattern_set_image(&pattern, &texture, nil)

	rect := blend2d.RoundRect {
		x  = 40,
		y  = 40,
		w  = 400,
		h  = 400,
		rx = 45.5,
		ry = 45.5,
	}

	blend2d.context_fill_geometry_ext(&ctx, .ROUND_RECT, &rect, cast(^blend2d.Unknown)(&pattern))
	blend2d.context_end(&ctx)

	codec: blend2d.ImageCodecCore
	codecs: blend2d.ArrayCore
	blend2d.image_codec_array_init_built_in_codecs(&codecs)
	blend2d.image_codec_init_by_name(&codec, "PNG", len("PNG"), nil)
	blend2d.image_write_to_file(&img, "sample_3.png", &codec)
}

