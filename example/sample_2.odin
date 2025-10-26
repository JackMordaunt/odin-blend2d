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

	grad: blend2d.GradientCore
	grad_values := [4]f64{0, 0, 0, 480}

	blend2d.gradient_init(&grad)
	blend2d.gradient_set_values(&grad, 0, &grad_values[0], 4)
	blend2d.gradient_add_stop_rgba32(&grad, 0.0, 0xFFFFFFFF)
	blend2d.gradient_add_stop_rgba32(&grad, 0.5, 0xFF5FAFDF)
	blend2d.gradient_add_stop_rgba32(&grad, 1.0, 0xFF2F5FDF)

	blend2d.context_set_fill_style(&ctx, cast(^blend2d.Unknown)(&grad))

	rect := blend2d.RoundRect {
		x  = 40,
		y  = 40,
		w  = 400,
		h  = 400,
		rx = 45.5,
		ry = 45.5,
	}

	blend2d.context_fill_geometry(&ctx, .ROUND_RECT, &rect)

	codec: blend2d.ImageCodecCore
	codecs: blend2d.ArrayCore

	blend2d.image_codec_array_init_built_in_codecs(&codecs)
	blend2d.image_codec_init_by_name(&codec, "PNG", len("PNG"), nil)
	blend2d.image_write_to_file(&img, "sample_2.png", &codec)
}

