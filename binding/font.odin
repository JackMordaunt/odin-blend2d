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


//! Font [C API].
FontCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Font [C API Impl].
FontImpl :: struct {
	//! Font face used by this font.
	face: FontFaceCore,

	//! Font width (1..1000) [0 if the font is not initialized].
	weight: u16,

	//! Font stretch (1..9) [0 if the font is not initialized].
	stretch: u8,

	//! Font style.
	style: u8,

	//! Reserved for future use.
	reserved: u32,

	//! Font metrics.
	metrics: FontMetrics,

	//! Font matrix.
	_matrix: FontMatrix,

	//! Assigned font features (key/value pairs).
	feature_settings: FontFeatureSettingsCore,

	//! Assigned font variations (key/value pairs).
	variation_settings: FontVariationSettingsCore,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	font_init                           :: proc(self: ^FontCore) -> Result ---
	font_init_move                      :: proc(self: ^FontCore, other: ^FontCore) -> Result ---
	font_init_weak                      :: proc(self: ^FontCore, other: ^FontCore) -> Result ---
	font_destroy                        :: proc(self: ^FontCore) -> Result ---
	font_reset                          :: proc(self: ^FontCore) -> Result ---
	font_assign_move                    :: proc(self: ^FontCore, other: ^FontCore) -> Result ---
	font_assign_weak                    :: proc(self: ^FontCore, other: ^FontCore) -> Result ---
	font_equals                         :: proc(a: ^FontCore, b: ^FontCore) -> i32 ---
	font_create_from_face               :: proc(self: ^FontCore, face: ^FontFaceCore, size: f32) -> Result ---
	font_create_from_face_with_settings :: proc(self: ^FontCore, face: ^FontFaceCore, size: f32, feature_settings: ^FontFeatureSettingsCore, variation_settings: ^FontVariationSettingsCore) -> Result ---
	font_get_face                       :: proc(self: ^FontCore, out: ^FontFaceCore) -> Result ---
	font_get_size                       :: proc(self: ^FontCore) -> f32 ---
	font_set_size                       :: proc(self: ^FontCore, size: f32) -> Result ---
	font_get_metrics                    :: proc(self: ^FontCore, out: ^FontMetrics) -> Result ---
	font_get_matrix                     :: proc(self: ^FontCore, out: ^FontMatrix) -> Result ---
	font_get_design_metrics             :: proc(self: ^FontCore, out: ^FontDesignMetrics) -> Result ---
	font_get_feature_settings           :: proc(self: ^FontCore, out: ^FontFeatureSettingsCore) -> Result ---
	font_set_feature_settings           :: proc(self: ^FontCore, feature_settings: ^FontFeatureSettingsCore) -> Result ---
	font_reset_feature_settings         :: proc(self: ^FontCore) -> Result ---
	font_get_variation_settings         :: proc(self: ^FontCore, out: ^FontVariationSettingsCore) -> Result ---
	font_set_variation_settings         :: proc(self: ^FontCore, variation_settings: ^FontVariationSettingsCore) -> Result ---
	font_reset_variation_settings       :: proc(self: ^FontCore) -> Result ---
	font_shape                          :: proc(self: ^FontCore, gb: ^GlyphBufferCore) -> Result ---
	font_map_text_to_glyphs             :: proc(self: ^FontCore, gb: ^GlyphBufferCore, state_out: ^GlyphMappingState) -> Result ---
	font_position_glyphs                :: proc(self: ^FontCore, gb: ^GlyphBufferCore) -> Result ---
	font_apply_kerning                  :: proc(self: ^FontCore, gb: ^GlyphBufferCore) -> Result ---
	font_apply_gsub                     :: proc(self: ^FontCore, gb: ^GlyphBufferCore, lookups: ^BitArrayCore) -> Result ---
	font_apply_gpos                     :: proc(self: ^FontCore, gb: ^GlyphBufferCore, lookups: ^BitArrayCore) -> Result ---
	font_get_text_metrics               :: proc(self: ^FontCore, gb: ^GlyphBufferCore, out: ^TextMetrics) -> Result ---
	font_get_glyph_bounds               :: proc(self: ^FontCore, glyph_data: ^u32, glyph_advance: c.intptr_t, out: ^BoxI, count: c.size_t) -> Result ---
	font_get_glyph_advances             :: proc(self: ^FontCore, glyph_data: ^u32, glyph_advance: c.intptr_t, out: ^GlyphPlacement, count: c.size_t) -> Result ---
	font_get_glyph_outlines             :: proc(self: ^FontCore, glyph_id: GlyphId, user_transform: ^Matrix2D, out: ^PathCore, sink: PathSinkFunc, user_data: rawptr) -> Result ---
	font_get_glyph_run_outlines         :: proc(self: ^FontCore, glyph_run: ^GlyphRun, user_transform: ^Matrix2D, out: ^PathCore, sink: PathSinkFunc, user_data: rawptr) -> Result ---
}

