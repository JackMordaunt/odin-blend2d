// This file is part of Blend2D project <https://blend2d.com>
//
// See blend2d.h or LICENSE.md for license and copyright information
// SPDX-License-Identifier: Zlib
package blend2d

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "blend2d.lib"
} else when ODIN_OS == .Darwin {
	foreign import lib "libblend2d.a"
} else when ODIN_OS == .Linux {
	foreign import lib "libblend2d.a"
}


//! Image codec [C API].
ImageCodecCore :: struct {
	_d: ObjectDetail,
}

//! \cond
//! Image codec [C API Virtual Function Table].
ImageCodecVirt :: struct {
	base:           ObjectVirtBase,
	inspect_data:   proc "c" (impl: ^ImageCodecImpl, data: ^u8, size: c.size_t) -> u32,
	create_decoder: proc "c" (impl: ^ImageCodecImpl, dst: ^ImageDecoderCore) -> Result,
	create_encoder: proc "c" (impl: ^ImageCodecImpl, dst: ^ImageEncoderCore) -> Result,
}

//! Image codec [C API Impl].
ImageCodecImpl :: struct {
	//! \name Members
	//! \{
	
	//! Virtual function table.
	virt: ^ImageCodecVirt,

	//! Image codec name like "PNG", "JPEG", etc...
	name: StringCore,

	//! Image codec vendor string, built-in codecs use "Blend2D" as a vendor string.
	vendor: StringCore,

	//! Mime types.
	mime_type: StringCore,

	//! Known file extensions used by this image codec separated by "|".
	extensions: StringCore,

	//! Image codec features.
	features: u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	image_codec_init                         :: proc(self: ^ImageCodecCore) -> Result ---
	image_codec_init_move                    :: proc(self: ^ImageCodecCore, other: ^ImageCodecCore) -> Result ---
	image_codec_init_weak                    :: proc(self: ^ImageCodecCore, other: ^ImageCodecCore) -> Result ---
	image_codec_init_by_name                 :: proc(self: ^ImageCodecCore, name: cstring, size: c.size_t, codecs: ^ArrayCore) -> Result ---
	image_codec_destroy                      :: proc(self: ^ImageCodecCore) -> Result ---
	image_codec_reset                        :: proc(self: ^ImageCodecCore) -> Result ---
	image_codec_assign_move                  :: proc(self: ^ImageCodecCore, other: ^ImageCodecCore) -> Result ---
	image_codec_assign_weak                  :: proc(self: ^ImageCodecCore, other: ^ImageCodecCore) -> Result ---
	image_codec_find_by_name                 :: proc(self: ^ImageCodecCore, name: cstring, size: c.size_t, codecs: ^ArrayCore) -> Result ---
	image_codec_find_by_extension            :: proc(self: ^ImageCodecCore, name: cstring, size: c.size_t, codecs: ^ArrayCore) -> Result ---
	image_codec_find_by_data                 :: proc(self: ^ImageCodecCore, data: rawptr, size: c.size_t, codecs: ^ArrayCore) -> Result ---
	image_codec_inspect_data                 :: proc(self: ^ImageCodecCore, data: rawptr, size: c.size_t) -> u32 ---
	image_codec_create_decoder               :: proc(self: ^ImageCodecCore, dst: ^ImageDecoderCore) -> Result ---
	image_codec_create_encoder               :: proc(self: ^ImageCodecCore, dst: ^ImageEncoderCore) -> Result ---
	image_codec_array_init_built_in_codecs   :: proc(self: ^ArrayCore) -> Result ---
	image_codec_array_assign_built_in_codecs :: proc(self: ^ArrayCore) -> Result ---
	image_codec_add_to_built_in              :: proc(codec: ^ImageCodecCore) -> Result ---
	image_codec_remove_from_built_in         :: proc(codec: ^ImageCodecCore) -> Result ---
}

//! Image codec feature bits.
ImageCodecFeatures :: enum u32 {
	//! No features.
	NO_FEATURES         = 0,

	//! Image codec supports reading images (can create BLImageDecoder).
	FEATURE_READ        = 1,

	//! Image codec supports writing images (can create BLImageEncoder).
	FEATURE_WRITE       = 2,

	//! Image codec supports lossless compression.
	FEATURE_LOSSLESS    = 4,

	//! Image codec supports loosy compression.
	FEATURE_LOSSY       = 8,

	//! Image codec supports writing multiple frames (GIF).
	FEATURE_MULTI_FRAME = 16,

	//! Image codec supports IPTC metadata.
	FEATURE_IPTC        = 268435456,

	//! Image codec supports EXIF metadata.
	FEATURE_EXIF        = 536870912,

	//! Image codec supports XMP metadata.
	FEATURE_XMP         = 1073741824,
	FEATURE_FORCE_UINT  = 4294967295,
}

