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


//! Flags used by `BLImageInfo`.
ImageInfoFlags :: enum u32 {
	//! No flags.
	NO_FLAGS    = 0,

	//! Progressive mode.
	PROGRESSIVE = 1,
	FORCE_UINT  = 4294967295,
}

//! Filter type used by `BLImage::scale()`.
ImageScaleFilter :: enum u32 {
	//! No filter or uninitialized.
	NONE       = 0,

	//! Nearest neighbor filter (radius 1.0).
	NEAREST    = 1,

	//! Bilinear filter (radius 1.0).
	BILINEAR   = 2,

	//! Bicubic filter (radius 2.0).
	BICUBIC    = 3,

	//! Lanczos filter (radius 2.0).
	LANCZOS    = 4,

	//! Maximum value of `BLImageScaleFilter`.
	MAX_VALUE  = 4,
	FORCE_UINT = 4294967295,
}

//! Data that describes a raster image. Used by \ref BLImage.
ImageData :: struct {
	//! Pixel data, starting at the top left corner of the image.
	//!
	//! \note If the stride is negative the image data would start at the bottom.
	pixel_data: rawptr,

	//! Stride (in bytes) of image data (positive when image data starts at top-left, negative when it starts at
	//! bottom-left).
	stride: c.intptr_t,

	//! Size of the image.
	size: SizeI,

	//! Pixel format, see \ref BLFormat.
	format: u32,
	flags:  u32,
}

//! Image information provided by image codecs.
ImageInfo :: struct {
	//! Image size.
	size: SizeI,

	//! Pixel density per one meter, can contain fractions.
	density: Size,

	//! Image flags.
	flags: u32,

	//! Image depth.
	depth: u16,

	//! Number of planes.
	plane_count: u16,

	//! Number of frames (0 = unknown/unspecified).
	frame_count: u64,

	//! Number of animation repeats (0 == infinite).
	repeat_count: u32,

	//! Reserved for future use.
	reserved: [3]u32,

	//! Image format (as understood by codec).
	format: [16]i8,

	//! Image compression (as understood by codec).
	compression: [16]i8,
}

//! 2D raster image [C API].
ImageCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! 2D raster image [C API Impl].
ImageImpl :: struct {
	//! Pixel data.
	pixel_data: rawptr,

	//! Image stride.
	stride: c.intptr_t,

	//! Image size.
	size: SizeI,

	//! Image format.
	format: u8,

	//! Image flags.
	flags: u8,

	//! Image depth (in bits).
	depth: u16,

	//! Reserved for future use, must be zero.
	reserved: [4]u8,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	image_init              :: proc(self: ^ImageCore) -> Result ---
	image_init_move         :: proc(self: ^ImageCore, other: ^ImageCore) -> Result ---
	image_init_weak         :: proc(self: ^ImageCore, other: ^ImageCore) -> Result ---
	image_init_as           :: proc(self: ^ImageCore, w: i32, h: i32, format: Format) -> Result ---
	image_init_as_from_data :: proc(self: ^ImageCore, w: i32, h: i32, format: Format, pixel_data: rawptr, stride: c.intptr_t, access_flags: DataAccessFlags, destroy_func: DestroyExternalDataFunc, user_data: rawptr) -> Result ---
	image_destroy           :: proc(self: ^ImageCore) -> Result ---
	image_reset             :: proc(self: ^ImageCore) -> Result ---
	image_assign_move       :: proc(self: ^ImageCore, other: ^ImageCore) -> Result ---
	image_assign_weak       :: proc(self: ^ImageCore, other: ^ImageCore) -> Result ---
	image_assign_deep       :: proc(self: ^ImageCore, other: ^ImageCore) -> Result ---
	image_create            :: proc(self: ^ImageCore, w: i32, h: i32, format: Format) -> Result ---
	image_create_from_data  :: proc(self: ^ImageCore, w: i32, h: i32, format: Format, pixel_data: rawptr, stride: c.intptr_t, access_flags: DataAccessFlags, destroy_func: DestroyExternalDataFunc, user_data: rawptr) -> Result ---
	image_get_data          :: proc(self: ^ImageCore, data_out: ^ImageData) -> Result ---
	image_make_mutable      :: proc(self: ^ImageCore, data_out: ^ImageData) -> Result ---
	image_convert           :: proc(self: ^ImageCore, format: Format) -> Result ---
	image_equals            :: proc(a: ^ImageCore, b: ^ImageCore) -> i32 ---
	image_scale             :: proc(dst: ^ImageCore, src: ^ImageCore, size: ^SizeI, filter: ImageScaleFilter) -> Result ---
	image_read_from_file    :: proc(self: ^ImageCore, file_name: cstring, codecs: ^ArrayCore) -> Result ---
	image_read_from_data    :: proc(self: ^ImageCore, data: rawptr, size: c.size_t, codecs: ^ArrayCore) -> Result ---
	image_write_to_file     :: proc(self: ^ImageCore, file_name: cstring, codec: ^ImageCodecCore) -> Result ---
	image_write_to_data     :: proc(self: ^ImageCore, dst: ^ArrayCore, codec: ^ImageCodecCore) -> Result ---
}

