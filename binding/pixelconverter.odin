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


//! Pixel converter function.
PixelConverterFunc :: proc "c" (self: ^PixelConverterCore, dst_data: ^u8, dst_stride: c.intptr_t, src_data: ^u8, src_stride: c.intptr_t, w: u32, h: u32, options: ^PixelConverterOptions) -> Result

//! Flags used by `BLPixelConverter::create()` function.
PixelConverterCreateFlags :: enum u32 {
	//! No flags.
	NO_FLAGS               = 0,

	//! Specifies that the source palette in `BLFormatInfo` doesn't have to by copied by `BLPixelConverter`. The caller
	//! must ensure that the palette would stay valid until the pixel converter is destroyed.
	FLAG_DONT_COPY_PALETTE = 1,

	//! Specifies that the source palette in `BLFormatInfo` is alterable and the pixel converter can modify it when
	//! preparing the conversion. The modification can be irreversible so only use this flag when you are sure that
	//! the palette passed to `BLPixelConverter::create()` won't be needed outside of pixel conversion.
	//!
	//! \note The flag `BL_PIXEL_CONVERTER_CREATE_FLAG_DONT_COPY_PALETTE` must be set as well, otherwise this flag would
	//! be ignored.
	FLAG_ALTERABLE_PALETTE = 2,

	//! When there is no built-in conversion between the given pixel formats it's possible to use an intermediate format
	//! that is used during conversion. In such case the base pixel converter creates two more converters that are then
	//! used internally.
	//!
	//! This option disables such feature - creating a pixel converter would fail with `BL_ERROR_NOT_IMPLEMENTED` error
	//! if direct conversion is not possible.
	FLAG_NO_MULTI_STEP     = 4,
	FLAG_FORCE_UINT        = 4294967295,
}

//! Pixel conversion options.
PixelConverterOptions :: struct {
	origin: PointI,
	gap:    c.size_t,
}

//! Pixel converter [C API].
PixelConverterCore :: struct {
	using _: struct #raw_union {
		using _: struct {
			//! Converter function.
			convert_func: PixelConverterFunc,

			//! Internal flags used by the converter - non-zero value means initialized.
			internal_flags: u8,
		},

		//! Internal data not exposed to users, aligned to sizeof(void*).
		data: [80]u8,
	},
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	pixel_converter_init      :: proc(self: ^PixelConverterCore) -> Result ---
	pixel_converter_init_weak :: proc(self: ^PixelConverterCore, other: ^PixelConverterCore) -> Result ---
	pixel_converter_destroy   :: proc(self: ^PixelConverterCore) -> Result ---
	pixel_converter_reset     :: proc(self: ^PixelConverterCore) -> Result ---
	pixel_converter_assign    :: proc(self: ^PixelConverterCore, other: ^PixelConverterCore) -> Result ---
	pixel_converter_create    :: proc(self: ^PixelConverterCore, dst_info: ^FormatInfo, src_info: ^FormatInfo, create_flags: PixelConverterCreateFlags) -> Result ---
	pixel_converter_convert   :: proc(self: ^PixelConverterCore, dst_data: rawptr, dst_stride: c.intptr_t, src_data: rawptr, src_stride: c.intptr_t, w: u32, h: u32, options: ^PixelConverterOptions) -> Result ---
}

