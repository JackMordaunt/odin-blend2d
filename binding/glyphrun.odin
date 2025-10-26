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


//! Flags used by \ref BLGlyphRun.
GlyphRunFlags :: enum u32 {
	//! No flags.
	NO_FLAGS               = 0,

	//! Glyph-run contains UCS-4 string and not glyphs (glyph-buffer only).
	FLAG_UCS4_CONTENT      = 268435456,

	//! Glyph-run was created from text that was not a valid unicode.
	FLAG_INVALID_TEXT      = 536870912,

	//! Not the whole text was mapped to glyphs (contains undefined glyphs).
	FLAG_UNDEFINED_GLYPHS  = 1073741824,

	//! Encountered invalid font data during text / glyph processing.
	FLAG_INVALID_FONT_DATA = 2147483648,
	FLAG_FORCE_UINT        = 4294967295,
}

//! Placement of glyphs stored in a \ref BLGlyphRun.
GlyphPlacementType :: enum u32 {
	//! No placement (custom handling by \ref BLPathSinkFunc).
	NONE           = 0,

	//! Each glyph has a BLGlyphPlacement (advance + offset).
	ADVANCE_OFFSET = 1,

	//! Each glyph has a BLPoint offset in design-space units.
	DESIGN_UNITS   = 2,

	//! Each glyph has a BLPoint offset in user-space units.
	USER_UNITS     = 3,

	//! Each glyph has a BLPoint offset in absolute units.
	ABSOLUTE_UNITS = 4,

	//! Maximum value of `BLGlyphPlacementType`.
	MAX_VALUE      = 4,
	FORCE_UINT     = 4294967295,
}

//! BLGlyphRun describes a set of consecutive glyphs and their placements.
//!
//! BLGlyphRun should only be used to pass glyph IDs and their placements to the rendering context. The purpose of
//! BLGlyphRun is to allow rendering glyphs, which could be shaped by various shaping engines (Blend2D, Harfbuzz, etc).
//!
//! BLGlyphRun allows to render glyphs that are stored as uint32_t[] array or part of a bigger structure (for example
//! `hb_glyph_info_t` used by HarfBuzz). Glyph placements at the moment use Blend2D's \ref BLGlyphPlacement or \ref
//! BLPoint, but it's possible to extend the data type in the future.
//!
//! See `BLGlyphRunPlacement` for placement modes provided by Blend2D.
GlyphRun :: struct {
	//! \name Members
	//! \{
	
	//! Glyph id data (abstract, incremented by `glyph_advance`).
	glyph_data: rawptr,

	//! Glyph placement data (abstract, incremented by `placement_advance`).
	placement_data: rawptr,

	//! Size of the glyph-run in glyph units.
	size: c.size_t,

	//! Reserved for future use, muse be zero.
	reserved: u8,

	//! Type of placement, see \ref BLGlyphPlacementType.
	placement_type: u8,

	//! Advance of `glyph_data` array.
	glyph_advance: i8,

	//! Advance of `placement_data` array.
	placement_advance: i8,

	//! Glyph-run flags.
	flags: u32,
}

