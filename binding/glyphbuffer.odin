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


//! Glyph buffer [Impl].
//!
//! \note This is not a `BLObjectImpl` compatible Impl.
GlyphBufferImpl :: struct {
	using _: struct #raw_union {
		using _: struct {
			//! Text (UCS4 code-points) or glyph content.
			content: ^u32,

			//! Glyph placement data.
			placement_data: ^GlyphPlacement,

			//! Number of either code points or glyph indexes in the glyph-buffer.
			size: c.size_t,

			//! Reserved, used exclusively by BLGlyphRun.
			reserved: u32,

			//! Flags shared between BLGlyphRun and BLGlyphBuffer.
			flags: u32,
		},

		//! Glyph run data that can be passed directly to the rendering context.
		//!
		//! Glyph run shares data with other members like `content`, `placement_data`, `size`, and `flags`. When working
		//! with data it's better to access these members directly as they are typed, whereas \ref BLGlyphRun stores
		//! pointers as `const void*` as it offers more flexibility, which \ref BLGlyphRun doesn't need.
		glyph_run: GlyphRun,
	},

	//! Glyph info data - additional information of each code-point or glyph.
	info_data: ^GlyphInfo,
}

//! Glyph buffer [C API].
GlyphBufferCore :: struct {
	impl:                   ^GlyphBufferImpl,
	BL_DEFINE_OBJECT_DCAST: proc "c" () -> i32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	glyph_buffer_init                   :: proc(self: ^GlyphBufferCore) -> Result ---
	glyph_buffer_init_move              :: proc(self: ^GlyphBufferCore, other: ^GlyphBufferCore) -> Result ---
	glyph_buffer_destroy                :: proc(self: ^GlyphBufferCore) -> Result ---
	glyph_buffer_reset                  :: proc(self: ^GlyphBufferCore) -> Result ---
	glyph_buffer_clear                  :: proc(self: ^GlyphBufferCore) -> Result ---
	glyph_buffer_get_size               :: proc(self: ^GlyphBufferCore) -> c.size_t ---
	glyph_buffer_get_flags              :: proc(self: ^GlyphBufferCore) -> u32 ---
	glyph_buffer_get_glyph_run          :: proc(self: ^GlyphBufferCore) -> ^GlyphRun ---
	glyph_buffer_get_content            :: proc(self: ^GlyphBufferCore) -> ^u32 ---
	glyph_buffer_get_info_data          :: proc(self: ^GlyphBufferCore) -> ^GlyphInfo ---
	glyph_buffer_get_placement_data     :: proc(self: ^GlyphBufferCore) -> ^GlyphPlacement ---
	glyph_buffer_set_text               :: proc(self: ^GlyphBufferCore, text_data: rawptr, size: c.size_t, encoding: TextEncoding) -> Result ---
	glyph_buffer_set_glyphs             :: proc(self: ^GlyphBufferCore, glyph_data: ^u32, size: c.size_t) -> Result ---
	glyph_buffer_set_glyphs_from_struct :: proc(self: ^GlyphBufferCore, glyph_data: rawptr, size: c.size_t, glyph_id_size: c.size_t, glyph_id_advance: c.intptr_t) -> Result ---
	glyph_buffer_set_debug_sink         :: proc(self: ^GlyphBufferCore, sink: DebugMessageSinkFunc, user_data: rawptr) -> Result ---
	glyph_buffer_reset_debug_sink       :: proc(self: ^GlyphBufferCore) -> Result ---
}

