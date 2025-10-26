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


//! Pattern quality.
PatternQuality :: enum u32 {
	//! Nearest neighbor interpolation.
	NEAREST    = 0,

	//! Bilinear interpolation.
	BILINEAR   = 1,

	//! Maximum value of `BLPatternQuality`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Pattern [C API].
PatternCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Pattern [C API Impl].
//!
//! The following properties are stored in BLObjectInfo:
//!
//!   - Pattern extend mode is stored in BLObjectInfo's 'b' field.
//!   - Pattern matrix type is stored in BLObjectInfo's 'c' field.
PatternImpl :: struct {
	//! Image used by the pattern.
	image: ImageCore,

	//! Image area to use.
	area: RectI,

	//! Pattern transformation matrix.
	transform: Matrix2D,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	pattern_init               :: proc(self: ^PatternCore) -> Result ---
	pattern_init_move          :: proc(self: ^PatternCore, other: ^PatternCore) -> Result ---
	pattern_init_weak          :: proc(self: ^PatternCore, other: ^PatternCore) -> Result ---
	pattern_init_as            :: proc(self: ^PatternCore, image: ^ImageCore, area: ^RectI, extend_mode: ExtendMode, transform: ^Matrix2D) -> Result ---
	pattern_destroy            :: proc(self: ^PatternCore) -> Result ---
	pattern_reset              :: proc(self: ^PatternCore) -> Result ---
	pattern_assign_move        :: proc(self: ^PatternCore, other: ^PatternCore) -> Result ---
	pattern_assign_weak        :: proc(self: ^PatternCore, other: ^PatternCore) -> Result ---
	pattern_assign_deep        :: proc(self: ^PatternCore, other: ^PatternCore) -> Result ---
	pattern_create             :: proc(self: ^PatternCore, image: ^ImageCore, area: ^RectI, extend_mode: ExtendMode, transform: ^Matrix2D) -> Result ---
	pattern_get_image          :: proc(self: ^PatternCore, image: ^ImageCore) -> Result ---
	pattern_set_image          :: proc(self: ^PatternCore, image: ^ImageCore, area: ^RectI) -> Result ---
	pattern_reset_image        :: proc(self: ^PatternCore) -> Result ---
	pattern_get_area           :: proc(self: ^PatternCore, area_out: ^RectI) -> Result ---
	pattern_set_area           :: proc(self: ^PatternCore, area: ^RectI) -> Result ---
	pattern_reset_area         :: proc(self: ^PatternCore) -> Result ---
	pattern_get_extend_mode    :: proc(self: ^PatternCore) -> ExtendMode ---
	pattern_set_extend_mode    :: proc(self: ^PatternCore, extend_mode: ExtendMode) -> Result ---
	pattern_get_transform      :: proc(self: ^PatternCore, transform_out: ^Matrix2D) -> Result ---
	pattern_get_transform_type :: proc(self: ^PatternCore) -> TransformType ---
	pattern_apply_transform_op :: proc(self: ^PatternCore, op_type: TransformOp, op_data: rawptr) -> Result ---
	pattern_equals             :: proc(a: ^PatternCore, b: ^PatternCore) -> i32 ---
}

