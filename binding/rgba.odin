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


//! 32-bit RGBA color (8-bit per component) stored as `0xAARRGGBB`.
Rgba32 :: struct {
	//! Packed 32-bit RGBA value.
	value: u32,
}

//! 64-bit RGBA color (16-bit per component) stored as `0xAAAARRRRGGGGBBBB`.
Rgba64 :: struct {
	//! Packed 64-bit RGBA value.
	value: u64,
}

//! 128-bit RGBA color stored as 4 32-bit floating point values in [RGBA] order.
Rgba :: struct {
	//! Red component.
	r: f32,

	//! Green component.
	g: f32,

	//! Blur component.
	b: f32,

	//! Alpha component.
	a: f32,
}

