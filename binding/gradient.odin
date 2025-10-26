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


//! Gradient type.
GradientType :: enum u32 {
	//! Linear gradient type.
	LINEAR     = 0,

	//! Radial gradient type.
	RADIAL     = 1,

	//! Conic gradient type.
	CONIC      = 2,

	//! Maximum value of `BLGradientType`.
	MAX_VALUE  = 2,
	FORCE_UINT = 4294967295,
}

//! Gradient data index.
GradientValue :: enum u32 {
	//! x0 - start 'x' for a Linear gradient and `x` center for both Radial and Conic gradients.
	COMMON_X0    = 0,

	//! y0 - start 'y' for a Linear gradient and `y` center for both Radial and Conic gradients.
	COMMON_Y0    = 1,

	//! x1 - end 'x' for a Linear gradient and focal point `x` for a Radial gradient.
	COMMON_X1    = 2,

	//! y1 - end 'y' for a Linear/gradient and focal point `y` for a Radial gradient.
	COMMON_Y1    = 3,

	//! Radial gradient center radius.
	RADIAL_R0    = 4,

	//! Radial gradient focal radius.
	RADIAL_R1    = 5,

	//! Conic gradient angle.
	CONIC_ANGLE  = 2,

	//! Conic gradient angle.
	CONIC_REPEAT = 3,

	//! Maximum value of `BLGradientValue`.
	MAX_VALUE    = 5,
	FORCE_UINT   = 4294967295,
}

//! Gradient rendering quality.
GradientQuality :: enum u32 {
	//! Nearest neighbor.
	NEAREST    = 0,

	//! Use smoothing, if available (currently never available).
	SMOOTH     = 1,

	//! The renderer will use an implementation-specific dithering algorithm to prevent banding.
	DITHER     = 2,

	//! Maximum value of `BLGradientQuality`.
	MAX_VALUE  = 2,
	FORCE_UINT = 4294967295,
}

//! Defines an `offset` and `rgba` color that us used by \ref BLGradient to define a linear transition between colors.
GradientStop :: struct {
	offset: f64,
	rgba:   Rgba64,
}

//! Linear gradient values packed into a structure.
LinearGradientValues :: struct {
	x0: f64,
	y0: f64,
	x1: f64,
	y1: f64,
}

//! Radial gradient values packed into a structure.
RadialGradientValues :: struct {
	x0: f64,
	y0: f64,
	x1: f64,
	y1: f64,
	r0: f64,
	r1: f64,
}

//! Conic gradient values packed into a structure.
ConicGradientValues :: struct {
	x0:     f64,
	y0:     f64,
	angle:  f64,
	repeat: f64,
}

//! Gradient [C API].
GradientCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Gradient [C API Impl].
GradientImpl :: struct {
	//! Gradient stop data.
	stops: ^GradientStop,

	//! Gradient stop count.
	size: c.size_t,

	//! Stop capacity.
	capacity: c.size_t,

	//! Gradient transformation matrix.
	transform: Matrix2D,

	using _: struct #raw_union {
		//! Gradient values (coordinates, radius, angle).
		values: [6]f64,

		//! Linear parameters.
		linear: LinearGradientValues,

		//! Radial parameters.
		radial: RadialGradientValues,

		//! Conic parameters.
		conic: ConicGradientValues,
	},
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	gradient_init                   :: proc(self: ^GradientCore) -> Result ---
	gradient_init_move              :: proc(self: ^GradientCore, other: ^GradientCore) -> Result ---
	gradient_init_weak              :: proc(self: ^GradientCore, other: ^GradientCore) -> Result ---
	gradient_init_as                :: proc(self: ^GradientCore, type: GradientType, values: rawptr, extend_mode: ExtendMode, stops: ^GradientStop, n: c.size_t, transform: ^Matrix2D) -> Result ---
	gradient_destroy                :: proc(self: ^GradientCore) -> Result ---
	gradient_reset                  :: proc(self: ^GradientCore) -> Result ---
	gradient_assign_move            :: proc(self: ^GradientCore, other: ^GradientCore) -> Result ---
	gradient_assign_weak            :: proc(self: ^GradientCore, other: ^GradientCore) -> Result ---
	gradient_create                 :: proc(self: ^GradientCore, type: GradientType, values: rawptr, extend_mode: ExtendMode, stops: ^GradientStop, n: c.size_t, transform: ^Matrix2D) -> Result ---
	gradient_shrink                 :: proc(self: ^GradientCore) -> Result ---
	gradient_reserve                :: proc(self: ^GradientCore, n: c.size_t) -> Result ---
	gradient_get_type               :: proc(self: ^GradientCore) -> GradientType ---
	gradient_set_type               :: proc(self: ^GradientCore, type: GradientType) -> Result ---
	gradient_get_extend_mode        :: proc(self: ^GradientCore) -> ExtendMode ---
	gradient_set_extend_mode        :: proc(self: ^GradientCore, extend_mode: ExtendMode) -> Result ---
	gradient_get_value              :: proc(self: ^GradientCore, index: c.size_t) -> f64 ---
	gradient_set_value              :: proc(self: ^GradientCore, index: c.size_t, value: f64) -> Result ---
	gradient_set_values             :: proc(self: ^GradientCore, index: c.size_t, values: ^f64, n: c.size_t) -> Result ---
	gradient_get_size               :: proc(self: ^GradientCore) -> c.size_t ---
	gradient_get_capacity           :: proc(self: ^GradientCore) -> c.size_t ---
	gradient_get_stops              :: proc(self: ^GradientCore) -> ^GradientStop ---
	gradient_reset_stops            :: proc(self: ^GradientCore) -> Result ---
	gradient_assign_stops           :: proc(self: ^GradientCore, stops: ^GradientStop, n: c.size_t) -> Result ---
	gradient_add_stop_rgba32        :: proc(self: ^GradientCore, offset: f64, argb32: u32) -> Result ---
	gradient_add_stop_rgba64        :: proc(self: ^GradientCore, offset: f64, argb64: u64) -> Result ---
	gradient_remove_stop            :: proc(self: ^GradientCore, index: c.size_t) -> Result ---
	gradient_remove_stop_by_offset  :: proc(self: ^GradientCore, offset: f64, all: u32) -> Result ---
	gradient_remove_stops_by_index  :: proc(self: ^GradientCore, r_start: c.size_t, r_end: c.size_t) -> Result ---
	gradient_remove_stops_by_offset :: proc(self: ^GradientCore, offset_min: f64, offset_max: f64) -> Result ---
	gradient_replace_stop_rgba32    :: proc(self: ^GradientCore, index: c.size_t, offset: f64, rgba32: u32) -> Result ---
	gradient_replace_stop_rgba64    :: proc(self: ^GradientCore, index: c.size_t, offset: f64, rgba64: u64) -> Result ---
	gradient_index_of_stop          :: proc(self: ^GradientCore, offset: f64) -> c.size_t ---
	gradient_get_transform          :: proc(self: ^GradientCore, transform_out: ^Matrix2D) -> Result ---
	gradient_get_transform_type     :: proc(self: ^GradientCore) -> TransformType ---
	gradient_apply_transform_op     :: proc(self: ^GradientCore, op_type: TransformOp, op_data: rawptr) -> Result ---
	gradient_equals                 :: proc(a: ^GradientCore, b: ^GradientCore) -> i32 ---
}

