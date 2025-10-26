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


//! Transformation matrix type that can be obtained by calling `BLMatrix2D::type()`.
//!
//! ```
//!  Identity  Transl.  Scale     Swap    Affine
//!   [1  0]   [1  0]   [.  0]   [0  .]   [.  .]
//!   [0  1]   [0  1]   [0  .]   [.  0]   [.  .]
//!   [0  0]   [.  .]   [.  .]   [.  .]   [.  .]
//! ```
TransformType :: enum u32 {
	//! Identity matrix.
	TRANSFORM_TYPE_IDENTITY  = 0,

	//! Has translation part (the rest is like identity).
	TRANSFORM_TYPE_TRANSLATE = 1,

	//! Has translation and scaling parts.
	TRANSFORM_TYPE_SCALE     = 2,

	//! Has translation and scaling parts, however scaling swaps X/Y.
	TRANSFORM_TYPE_SWAP      = 3,

	//! Generic affine matrix.
	TRANSFORM_TYPE_AFFINE    = 4,

	//! Invalid/degenerate matrix not useful for transformations.
	TRANSFORM_TYPE_INVALID   = 5,

	//! Maximum value of `BLTransformType`.
	TRANSFORM_TYPE_MAX_VALUE = 5,
	MATRIX2D_TYPE_FORCE_UINT = 4294967295,
}

//! Transformation matrix operation type.
TransformOp :: enum u32 {
	//! Reset matrix to identity (argument ignored, should be nullptr).
	RESET          = 0,

	//! Assign (copy) the other matrix.
	ASSIGN         = 1,

	//! Translate the matrix by [x, y].
	TRANSLATE      = 2,

	//! Scale the matrix by [x, y].
	SCALE          = 3,

	//! Skew the matrix by [x, y].
	SKEW           = 4,

	//! Rotate the matrix by the given angle about [0, 0].
	ROTATE         = 5,

	//! Rotate the matrix by the given angle about [x, y].
	ROTATE_PT      = 6,

	//! Transform this matrix by other \ref BLMatrix2D.
	TRANSFORM      = 7,

	//! Post-translate the matrix by [x, y].
	POST_TRANSLATE = 8,

	//! Post-scale the matrix by [x, y].
	POST_SCALE     = 9,

	//! Post-skew the matrix by [x, y].
	POST_SKEW      = 10,

	//! Post-rotate the matrix about [0, 0].
	POST_ROTATE    = 11,

	//! Post-rotate the matrix about a reference BLPoint.
	POST_ROTATE_PT = 12,

	//! Post-transform this matrix by other \ref BLMatrix2D.
	POST_TRANSFORM = 13,

	//! Maximum value of `BLTransformOp`.
	MAX_VALUE      = 13,
	FORCE_UINT     = 4294967295,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \name BLMatrix2D - C API
	//!
	//! Functions that initialize and manipulate \ref BLMatrix2D content.
	//!
	//! \{
	matrix2d_set_identity     :: proc(self: ^Matrix2D) -> Result ---
	matrix2d_set_translation  :: proc(self: ^Matrix2D, x: f64, y: f64) -> Result ---
	matrix2d_set_scaling      :: proc(self: ^Matrix2D, x: f64, y: f64) -> Result ---
	matrix2d_set_skewing      :: proc(self: ^Matrix2D, x: f64, y: f64) -> Result ---
	matrix2d_set_rotation     :: proc(self: ^Matrix2D, angle: f64, cx: f64, cy: f64) -> Result ---
	matrix2d_apply_op         :: proc(self: ^Matrix2D, op_type: TransformOp, op_data: rawptr) -> Result ---
	matrix2d_invert           :: proc(dst: ^Matrix2D, src: ^Matrix2D) -> Result ---
	matrix2d_get_type         :: proc(self: ^Matrix2D) -> TransformType ---
	matrix2d_map_pointd_array :: proc(self: ^Matrix2D, dst: ^Point, src: ^Point, count: c.size_t) -> Result ---
}

//! 2D matrix represents an affine transformation matrix that can be used to transform geometry and images.
Matrix2D :: struct {
	// TODO: Remove the union, keep only m[] array.
	using _: struct #raw_union {
		//! Matrix values stored in array.
		m: [6]f64,

		//! Matrix values that map `m` to named values that can be used directly.
		using _: struct {
			m00: f64,
			m01: f64,
			m10: f64,
			m11: f64,
			m20: f64,
			m21: f64,
		},
	},
}

