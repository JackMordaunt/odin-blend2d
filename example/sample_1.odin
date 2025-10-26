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

	path: blend2d.PathCore
	blend2d.path_init(&path)
	blend2d.path_move_to(&path, 26, 31)
	blend2d.path_cubic_to(&path, 642, 132, 587, -136, 25, 464)
	blend2d.path_cubic_to(&path, 882, 404, 144, 267, 27, 31)

	origin: blend2d.Point

	blend2d.context_fill_path_d_rgba32(&ctx, &origin, &path, 0xFFFFFFFF)
	blend2d.context_end(&ctx)

	codec: blend2d.ImageCodecCore
	codecs: blend2d.ArrayCore

	blend2d.image_codec_array_init_built_in_codecs(&codecs)
	blend2d.image_codec_init_by_name(&codec, "PNG", len("PNG"), nil)
	blend2d.image_write_to_file(&img, "sample_1.png", &codec)
}

