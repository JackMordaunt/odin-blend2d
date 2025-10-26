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


//! Flags used by \ref BLFontFace (or \ref BLFontFaceCore)
FontFaceFlags :: enum u32 {
	//! No flags.
	NO_FLAGS                   = 0,

	//! Font uses typographic family and subfamily names.
	FLAG_TYPOGRAPHIC_NAMES     = 1,

	//! Font uses typographic metrics.
	FLAG_TYPOGRAPHIC_METRICS   = 2,

	//! Character to glyph mapping is available.
	FLAG_CHAR_TO_GLYPH_MAPPING = 4,

	//! Horizontal glyph metrics (advances, side bearings) is available.
	FLAG_HORIZONTAL_METRICS    = 16,

	//! Vertical glyph metrics (advances, side bearings) is available.
	FLAG_VERTICAL_METRICS      = 32,

	//! Legacy horizontal kerning feature ('kern' table with horizontal kerning data).
	FLAG_HORIZONTAL_KERNING    = 64,

	//! Legacy vertical kerning feature ('kern' table with vertical kerning data).
	FLAG_VERTICAL_KERNING      = 128,

	//! OpenType features (GDEF, GPOS, GSUB) are available.
	FLAG_OPENTYPE_FEATURES     = 256,

	//! Panose classification is available.
	FLAG_PANOSE_INFO           = 512,

	//! Unicode coverage information is available.
	FLAG_COVERAGE_INFO         = 1024,

	//! Baseline for font at `y` equals 0.
	FLAG_BASELINE_Y_EQUALS_0   = 4096,

	//! Left sidebearing point at `x == 0` (TT only).
	FLAG_LSB_POINT_X_EQUALS_0  = 8192,

	//! Unicode variation sequences feature is available.
	FLAG_VARIATION_SEQUENCES   = 268435456,

	//! OpenType Font Variations feature is available.
	FLAG_OPENTYPE_VARIATIONS   = 536870912,

	//! This is a symbol font.
	FLAG_SYMBOL_FONT           = 1073741824,

	//! This is a last resort font.
	FLAG_LAST_RESORT_FONT      = 2147483648,
	FLAG_FORCE_UINT            = 4294967295,
}

//! Diagnostic flags offered by \ref BLFontFace (or \ref BLFontFaceCore).
FontFaceDiagFlags :: enum u32 {
	//! No flags.
	NO_FLAGS          = 0,

	//! Wrong data in 'name' table.
	WRONG_NAME_DATA   = 1,

	//! Fixed data read from 'name' table and possibly fixed font family/subfamily name.
	FIXED_NAME_DATA   = 2,

	//! Wrong data in 'kern' table [kerning disabled].
	WRONG_KERN_DATA   = 4,

	//! Fixed data read from 'kern' table so it can be used.
	FIXED_KERN_DATA   = 8,

	//! Wrong data in 'cmap' table.
	WRONG_CMAP_DATA   = 16,

	//! Wrong format in 'cmap' (sub)table.
	WRONG_CMAP_FORMAT = 32,
	FORCE_UINT        = 4294967295,
}

//! Format of an outline stored in a font.
FontOutlineType :: enum u32 {
	//! None.
	NONE       = 0,

	//! Truetype outlines.
	TRUETYPE   = 1,

	//! OpenType (CFF) outlines.
	CFF        = 2,

	//! OpenType (CFF2) outlines with font variations support.
	CFF2       = 3,

	//! Maximum value of `BLFontOutlineType`.
	MAX_VALUE  = 3,
	FORCE_UINT = 4294967295,
}

//! Information of \ref BLFontFace.
FontFaceInfo :: struct {
	//! \name Members
	//! \{
	
	//! Font face type, see \ref BLFontFaceType.
	face_type: u8,

	//! Type of outlines used by the font face, see \ref BLFontOutlineType.
	outline_type: u8,

	//! Reserved fields.
	reserved8: [2]u8,

	//! Number of glyphs provided by this font face.
	glyph_count: u32,

	//! Revision (read from 'head' table, represented as 16.16 fixed point).
	revision: u32,

	//! Face face index in a TTF/OTF collection or zero if not part of a collection.
	face_index: u32,

	//! Font face flags, see \ref BLFontFaceFlags
	face_flags: u32,

	//! Font face diagnostic flags, see \ref BLFontFaceDiagFlags.
	diag_flags: u32,

	//! Reserved for future use, set to zero.
	reserved: [2]u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \name BLFontFace - C API
	//! \{
	font_face_init                   :: proc(self: ^FontFaceCore) -> Result ---
	font_face_init_move              :: proc(self: ^FontFaceCore, other: ^FontFaceCore) -> Result ---
	font_face_init_weak              :: proc(self: ^FontFaceCore, other: ^FontFaceCore) -> Result ---
	font_face_destroy                :: proc(self: ^FontFaceCore) -> Result ---
	font_face_reset                  :: proc(self: ^FontFaceCore) -> Result ---
	font_face_assign_move            :: proc(self: ^FontFaceCore, other: ^FontFaceCore) -> Result ---
	font_face_assign_weak            :: proc(self: ^FontFaceCore, other: ^FontFaceCore) -> Result ---
	font_face_equals                 :: proc(a: ^FontFaceCore, b: ^FontFaceCore) -> i32 ---
	font_face_create_from_file       :: proc(self: ^FontFaceCore, file_name: cstring, read_flags: FileReadFlags) -> Result ---
	font_face_create_from_data       :: proc(self: ^FontFaceCore, font_data: ^FontDataCore, face_index: u32) -> Result ---
	font_face_get_full_name          :: proc(self: ^FontFaceCore, out: ^StringCore) -> Result ---
	font_face_get_family_name        :: proc(self: ^FontFaceCore, out: ^StringCore) -> Result ---
	font_face_get_subfamily_name     :: proc(self: ^FontFaceCore, out: ^StringCore) -> Result ---
	font_face_get_post_script_name   :: proc(self: ^FontFaceCore, out: ^StringCore) -> Result ---
	font_face_get_face_info          :: proc(self: ^FontFaceCore, out: ^FontFaceInfo) -> Result ---
	font_face_get_design_metrics     :: proc(self: ^FontFaceCore, out: ^FontDesignMetrics) -> Result ---
	font_face_get_coverage_info      :: proc(self: ^FontFaceCore, out: ^FontCoverageInfo) -> Result ---
	font_face_get_panose_info        :: proc(self: ^FontFaceCore, out: ^FontPanoseInfo) -> Result ---
	font_face_get_character_coverage :: proc(self: ^FontFaceCore, out: ^BitSetCore) -> Result ---
	font_face_has_script_tag         :: proc(self: ^FontFaceCore, script_tag: Tag) -> i32 ---
	font_face_has_feature_tag        :: proc(self: ^FontFaceCore, feature_tag: Tag) -> i32 ---
	font_face_has_variation_tag      :: proc(self: ^FontFaceCore, variation_tag: Tag) -> i32 ---
	font_face_get_script_tags        :: proc(self: ^FontFaceCore, out: ^ArrayCore) -> Result ---
	font_face_get_feature_tags       :: proc(self: ^FontFaceCore, out: ^ArrayCore) -> Result ---
	font_face_get_variation_tags     :: proc(self: ^FontFaceCore, out: ^ArrayCore) -> Result ---
}

//! Font face [C API].
FontFaceCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Font face [C API Virtual Function Table].
FontFaceVirt :: struct {
	base: ObjectVirtBase,
}

//! Font face [C API Impl].
FontFaceImpl :: struct {
	//! Virtual function table.
	virt: ^FontFaceVirt,

	//! Font face default weight (1..1000) [0 if font face is not initialized].
	weight: u16,

	//! Font face default stretch (1..9) [0 if font face is not initialized].
	stretch: u8,

	//! Font face default style.
	style: u8,

	//! Font face information.
	face_info: FontFaceInfo,

	//! Unique identifier assigned by Blend2D that can be used for caching.
	unique_id: UniqueId,

	//! Font data.
	data: FontDataCore,

	//! Full name.
	full_name: StringCore,

	//! Family name.
	family_name: StringCore,

	//! Subfamily name.
	subfamily_name: StringCore,

	//! PostScript name.
	post_script_name: StringCore,

	//! Font face metrics in design units.
	design_metrics: FontDesignMetrics,

	//! Font face unicode coverage information as specified in the "OS/2" header.
	coverage_info: FontCoverageInfo,

	//! Font face panose classification.
	panose_info: FontPanoseInfo,
}

