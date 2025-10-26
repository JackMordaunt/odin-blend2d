// This file is part of Blend2D project <https://blend2d.com>
//
// See blend2d.h or LICENSE.md for license and copyright information
// SPDX-License-Identifier: Zlib
package blend2d

when ODIN_OS == .Windows {
	foreign import lib "blend2d.lib"
} else when ODIN_OS == .Darwin {
	foreign import lib "libblend2d.a"
} else when ODIN_OS == .Linux {
	foreign import lib "libblend2d.a"
}


//! Pixel format.
//!
//! Compatibility Table
//! -------------------
//!
//! ```
//! +---------------------+---------------------+-----------------------------+
//! | Blend2D Format      | Cairo Format        | QImage::Format              |
//! +---------------------+---------------------+-----------------------------+
//! | BL_FORMAT_PRGB32    | CAIRO_FORMAT_ARGB32 | Format_ARGB32_Premultiplied |
//! | BL_FORMAT_XRGB32    | CAIRO_FORMAT_RGB24  | Format_RGB32                |
//! | BL_FORMAT_A8        | CAIRO_FORMAT_A8     | n/a                         |
//! +---------------------+---------------------+-----------------------------+
//! ```
Format :: enum u32 {
	//! None or invalid pixel format.
	NONE       = 0,

	//! 32-bit premultiplied ARGB pixel format (8-bit components).
	PRGB32     = 1,

	//! 32-bit (X)RGB pixel format (8-bit components, alpha ignored).
	XRGB32     = 2,

	//! 8-bit alpha-only pixel format.
	A8         = 3,

	// Maximum value of `BLFormat`.
	MAX_VALUE  = 3,
	FORCE_UINT = 4294967295,
}

//! Pixel format flags.
FormatFlags :: enum u32 {
	//! No flags.
	NO_FLAGS            = 0,

	//! Pixel format provides RGB components.
	FLAG_RGB            = 1,

	//! Pixel format provides only alpha component.
	FLAG_ALPHA          = 2,

	//! A combination of `BL_FORMAT_FLAG_RGB | BL_FORMAT_FLAG_ALPHA`.
	FLAG_RGBA           = 3,

	//! Pixel format provides LUM component (and not RGB components).
	FLAG_LUM            = 4,

	//! A combination of `BL_FORMAT_FLAG_LUM | BL_FORMAT_FLAG_ALPHA`.
	FLAG_LUMA           = 6,

	//! Indexed pixel format the requires a palette (I/O only).
	FLAG_INDEXED        = 16,

	//! RGB components are premultiplied by alpha component.
	FLAG_PREMULTIPLIED  = 256,

	//! Pixel format doesn't use native byte-order (I/O only).
	FLAG_BYTE_SWAP      = 512,

	// The following flags are only informative. They are part of `bl_format_info[]`, but don't have to be passed to
	// `BLPixelConverter` as they will always be calculated automatically.
	
	//! Pixel components are byte aligned (all 8bpp).
	FLAG_BYTE_ALIGNED   = 65536,

	//! Pixel has some undefined bits that represent no information.
	//!
	//! For example a 32-bit XRGB pixel has 8 undefined bits that are usually set to all ones so the format can be
	//! interpreted as premultiplied RGB as well. There are other formats like 16_0555 where the bit has no information
	//! and is usually set to zero. Blend2D doesn't rely on the content of such bits.
	FLAG_UNDEFINED_BITS = 131072,

	//! Convenience flag that contains either zero or `BL_FORMAT_FLAG_BYTE_SWAP` depending on host byte order. Little
	//! endian hosts have this flag set to zero and big endian hosts to `BL_FORMAT_FLAG_BYTE_SWAP`.
	//!
	//! \note This is not a real flag that you can test, it's only provided for convenience to define little endian
	//! pixel formats.
	FLAG_LE             = 0,

	//! Convenience flag that contains either zero or `BL_FORMAT_FLAG_BYTE_SWAP` depending on host byte order. Big
	//! endian hosts have this flag set to zero and little endian hosts to `BL_FORMAT_FLAG_BYTE_SWAP`.
	//!
	//! \note This is not a real flag that you can test, it's only provided for convenience to define big endian
	//! pixel formats.
	FLAG_BE             = 512,
	FLAG_FORCE_UINT     = 4294967295,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \name BLFormat - C API
	//! \{
	format_info_query    :: proc(self: ^FormatInfo, format: Format) -> Result ---
	format_info_sanitize :: proc(self: ^FormatInfo) -> Result ---
}

//! Provides a detailed information about a pixel format. Use \ref bl_format_info array to get an information of Blend2D
//! native pixel formats.
FormatInfo :: struct {
	depth: u32,
	flags: FormatFlags,

	using _: struct #raw_union {
		using _: struct {
			sizes:  [4]u8,
			shifts: [4]u8,
		},

		using _: struct {
			r_size:  u8,
			g_size:  u8,
			b_size:  u8,
			a_size:  u8,
			r_shift: u8,
			g_shift: u8,
			b_shift: u8,
			a_shift: u8,
		},

		palette: ^Rgba32,
	},
}

