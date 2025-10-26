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


//! Path command.
PathCmd :: enum u32 {
	//! Move-to command (starts a new figure).
	MOVE       = 0,

	//! On-path command (interpreted as line-to or the end of a curve).
	ON         = 1,

	//! Quad-to control point.
	QUAD       = 2,

	//! Conic-to control point
	CONIC      = 3,

	//! Cubic-to control point (always used as a pair of commands).
	CUBIC      = 4,

	//! Close path.
	CLOSE      = 5,

	//! Conic weight.
	//!
	//! \note This is not a point. This is a pair of values from which only the first (x) is used to represent weight
	//! as used by conic curve. The other value (y) is always set to NaN by Blend2D, but can be arbitrary as it has
	//! no meaning.
	WEIGHT     = 6,

	//! Maximum value of `BLPathCmd`.
	MAX_VALUE  = 6,
	FORCE_UINT = 4294967295,
}

//! Path command (never stored in path).
PathCmdExtra :: enum u32 {
	//! Used by `BLPath::set_vertex_at` to preserve the current command value.
	BL_PATH_CMD_PRESERVE = 4294967295,
}

//! Path flags.
PathFlags :: enum u32 {
	//! No flags.
	NO_FLAGS        = 0,

	//! Path is empty (no commands or close commands only).
	FLAG_EMPTY      = 1,

	//! Path contains multiple figures.
	FLAG_MULTIPLE   = 2,

	//! Path contains one or more quad curves.
	FLAG_QUADS      = 4,

	//! Path contains one or more conic curves.
	FLAG_CONICS     = 8,

	//! Path contains one or more cubic curves.
	FLAG_CUBICS     = 16,

	//! Path is invalid.
	FLAG_INVALID    = 1073741824,

	//! Flags are dirty (not reflecting the current status).
	FLAG_DIRTY      = 2147483648,
	FLAG_FORCE_UINT = 4294967295,
}

//! Path reversal mode.
PathReverseMode :: enum u32 {
	//! Reverse each figure and their order as well (default).
	COMPLETE   = 0,

	//! Reverse each figure separately (keeps their order).
	SEPARATE   = 1,

	//! Maximum value of `BLPathReverseMode`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Stroke join type.
StrokeJoin :: enum u32 {
	//! Miter-join possibly clipped at `miter_limit` [default].
	MITER_CLIP  = 0,

	//! Miter-join or bevel-join depending on miter_limit condition.
	MITER_BEVEL = 1,

	//! Miter-join or round-join depending on miter_limit condition.
	MITER_ROUND = 2,

	//! Bevel-join.
	BEVEL       = 3,

	//! Round-join.
	ROUND       = 4,

	//! Maximum value of `BLStrokeJoin`.
	MAX_VALUE   = 4,
	FORCE_UINT  = 4294967295,
}

//! Position of a stroke-cap.
StrokeCapPosition :: enum u32 {
	//! Start of the path.
	START      = 0,

	//! End of the path.
	END        = 1,

	//! Maximum value of `BLStrokeCapPosition`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! A presentation attribute defining the shape to be used at the end of open sub-paths.
StrokeCap :: enum u32 {
	//! Butt cap [default].
	BUTT         = 0,

	//! Square cap.
	SQUARE       = 1,

	//! Round cap.
	ROUND        = 2,

	//! Round cap reversed.
	ROUND_REV    = 3,

	//! Triangle cap.
	TRIANGLE     = 4,

	//! Triangle cap reversed.
	TRIANGLE_REV = 5,

	//! Maximum value of `BLStrokeCap`.
	MAX_VALUE    = 5,
	FORCE_UINT   = 4294967295,
}

//! Stroke transform order.
StrokeTransformOrder :: enum u32 {
	//! Transform after stroke  => `Transform(Stroke(Input))` [default].
	AFTER      = 0,

	//! Transform before stroke => `Stroke(Transform(Input))`.
	BEFORE     = 1,

	//! Maximum value of `BLStrokeTransformOrder`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Mode that specifies how curves are approximated to line segments.
FlattenMode :: enum u32 {
	//! Use default mode (decided by Blend2D).
	DEFAULT    = 0,

	//! Recursive subdivision flattening.
	RECURSIVE  = 1,

	//! Maximum value of `BLFlattenMode`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Mode that specifies how to construct offset curves.
OffsetMode :: enum u32 {
	//! Use default mode (decided by Blend2D).
	DEFAULT    = 0,

	//! Iterative offset construction.
	ITERATIVE  = 1,

	//! Maximum value of `BLOffsetMode`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Options used to describe how geometry is approximated.
//!
//! This struct cannot be simply zeroed and then passed to functions that accept approximation options.
//! Use `bl_default_approximation_options` to setup defaults and then alter values you want to change.
//!
//! Example of using `BLApproximationOptions`:
//!
//! ```
//! // Initialize with defaults first.
//! BLApproximationOptions approx = bl_default_approximation_options;
//!
//! // Override values you want to change.
//! approx.simplify_tolerance = 0.02;
//!
//! // ... now safely use approximation options in your code ...
//! ```
ApproximationOptions :: struct {
	//! Specifies how curves are flattened, see \ref BLFlattenMode.
	flatten_mode: u8,

	//! Specifies how curves are offsetted (used by stroking), see \ref BLOffsetMode.
	offset_mode: u8,

	//! Reserved for future use, must be zero.
	reserved_flags: [6]u8,

	//! Tolerance used to flatten curves.
	flatten_tolerance: f64,

	//! Tolerance used to approximate cubic curves with quadratic curves.
	simplify_tolerance: f64,

	//! Curve offsetting parameter, exact meaning depends on `offset_mode`.
	offset_parameter: f64,
}

//! 2D vector path view provides pointers to vertex and command data along with their size.
PathView :: struct {
	command_data: ^u8,
	vertex_data:  ^Point,
	size:         c.size_t,
}

//! Optional callback that can be used to consume a path data.
PathSinkFunc :: proc "c" (path: ^PathCore, info: rawptr, user_data: rawptr) -> Result

//! This is a sink that is used by path offsetting. This sink consumes both `a` and `b` offsets of the path. The sink
//! will be called for each figure and is responsible for joining these paths. If the paths are not closed then the
//! sink must insert start cap, then join `b`, and then insert end cap.
//!
//! The sink must also clean up the paths as this is not done by the offsetter. The reason is that in case the `a` path
//! is the output path you can just keep it and insert `b` path into it (clearing only `b` path after each call).
PathStrokeSinkFunc :: proc "c" (a: ^PathCore, b: ^PathCore, _c: ^PathCore, input_start: c.size_t, input_end: c.size_t, user_data: rawptr) -> Result

//! 2D vector path [C API].
PathCore :: struct {
	_d: ObjectDetail,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	path_init                 :: proc(self: ^PathCore) -> Result ---
	path_init_move            :: proc(self: ^PathCore, other: ^PathCore) -> Result ---
	path_init_weak            :: proc(self: ^PathCore, other: ^PathCore) -> Result ---
	path_destroy              :: proc(self: ^PathCore) -> Result ---
	path_reset                :: proc(self: ^PathCore) -> Result ---
	path_get_size             :: proc(self: ^PathCore) -> c.size_t ---
	path_get_capacity         :: proc(self: ^PathCore) -> c.size_t ---
	path_get_command_data     :: proc(self: ^PathCore) -> ^u8 ---
	path_get_vertex_data      :: proc(self: ^PathCore) -> ^Point ---
	path_clear                :: proc(self: ^PathCore) -> Result ---
	path_shrink               :: proc(self: ^PathCore) -> Result ---
	path_reserve              :: proc(self: ^PathCore, n: c.size_t) -> Result ---
	path_modify_op            :: proc(self: ^PathCore, op: ModifyOp, n: c.size_t, cmd_data_out: ^^u8, vtx_data_out: ^^Point) -> Result ---
	path_assign_move          :: proc(self: ^PathCore, other: ^PathCore) -> Result ---
	path_assign_weak          :: proc(self: ^PathCore, other: ^PathCore) -> Result ---
	path_assign_deep          :: proc(self: ^PathCore, other: ^PathCore) -> Result ---
	path_set_vertex_at        :: proc(self: ^PathCore, index: c.size_t, cmd: u32, x: f64, y: f64) -> Result ---
	path_move_to              :: proc(self: ^PathCore, x0: f64, y0: f64) -> Result ---
	path_line_to              :: proc(self: ^PathCore, x1: f64, y1: f64) -> Result ---
	path_poly_to              :: proc(self: ^PathCore, poly: ^Point, count: c.size_t) -> Result ---
	path_quad_to              :: proc(self: ^PathCore, x1: f64, y1: f64, x2: f64, y2: f64) -> Result ---
	path_conic_to             :: proc(self: ^PathCore, x1: f64, y1: f64, x2: f64, y2: f64, w: f64) -> Result ---
	path_cubic_to             :: proc(self: ^PathCore, x1: f64, y1: f64, x2: f64, y2: f64, x3: f64, y3: f64) -> Result ---
	path_smooth_quad_to       :: proc(self: ^PathCore, x2: f64, y2: f64) -> Result ---
	path_smooth_cubic_to      :: proc(self: ^PathCore, x2: f64, y2: f64, x3: f64, y3: f64) -> Result ---
	path_arc_to               :: proc(self: ^PathCore, x: f64, y: f64, rx: f64, ry: f64, start: f64, sweep: f64, force_move_to: i32) -> Result ---
	path_arc_quadrant_to      :: proc(self: ^PathCore, x1: f64, y1: f64, x2: f64, y2: f64) -> Result ---
	path_elliptic_arc_to      :: proc(self: ^PathCore, rx: f64, ry: f64, xAxisRotation: f64, large_arc_flag: i32, sweep_flag: i32, x1: f64, y1: f64) -> Result ---
	path_close                :: proc(self: ^PathCore) -> Result ---
	path_add_geometry         :: proc(self: ^PathCore, geometry_type: GeometryType, geometry_data: rawptr, m: ^Matrix2D, dir: GeometryDirection) -> Result ---
	path_add_box_i            :: proc(self: ^PathCore, box: ^BoxI, dir: GeometryDirection) -> Result ---
	path_add_box_d            :: proc(self: ^PathCore, box: ^Box, dir: GeometryDirection) -> Result ---
	path_add_rect_i           :: proc(self: ^PathCore, rect: ^RectI, dir: GeometryDirection) -> Result ---
	path_add_rect_d           :: proc(self: ^PathCore, rect: ^Rect, dir: GeometryDirection) -> Result ---
	path_add_path             :: proc(self: ^PathCore, other: ^PathCore, range: ^Range) -> Result ---
	path_add_translated_path  :: proc(self: ^PathCore, other: ^PathCore, range: ^Range, p: ^Point) -> Result ---
	path_add_transformed_path :: proc(self: ^PathCore, other: ^PathCore, range: ^Range, m: ^Matrix2D) -> Result ---
	path_add_reversed_path    :: proc(self: ^PathCore, other: ^PathCore, range: ^Range, reverse_mode: PathReverseMode) -> Result ---
	path_add_stroked_path     :: proc(self: ^PathCore, other: ^PathCore, range: ^Range, options: ^StrokeOptionsCore, approx: ^ApproximationOptions) -> Result ---
	path_remove_range         :: proc(self: ^PathCore, range: ^Range) -> Result ---
	path_translate            :: proc(self: ^PathCore, range: ^Range, p: ^Point) -> Result ---
	path_transform            :: proc(self: ^PathCore, range: ^Range, m: ^Matrix2D) -> Result ---
	path_fit_to               :: proc(self: ^PathCore, range: ^Range, rect: ^Rect, fit_flags: u32) -> Result ---
	path_equals               :: proc(a: ^PathCore, b: ^PathCore) -> i32 ---
	path_get_info_flags       :: proc(self: ^PathCore, flags_out: ^u32) -> Result ---
	path_get_control_box      :: proc(self: ^PathCore, box_out: ^Box) -> Result ---
	path_get_bounding_box     :: proc(self: ^PathCore, box_out: ^Box) -> Result ---
	path_get_figure_range     :: proc(self: ^PathCore, index: c.size_t, range_out: ^Range) -> Result ---
	path_get_last_vertex      :: proc(self: ^PathCore, vtx_out: ^Point) -> Result ---
	path_get_closest_vertex   :: proc(self: ^PathCore, p: ^Point, max_distance: f64, index_out: ^c.size_t, distance_out: ^f64) -> Result ---
	path_hit_test             :: proc(self: ^PathCore, p: ^Point, fill_rule: FillRule) -> HitTest ---
}

//! Stroke options [C API].
StrokeOptionsCore :: struct {
	using _: struct #raw_union {
		using _: struct {
			start_cap:       u8,
			end_cap:         u8,
			join:            u8,
			transform_order: u8,
			reserved:        [4]u8,
		},

		caps:  [2]u8,
		hints: u64,
	},

	width:       f64,
	miter_limit: f64,
	dash_offset: f64,
	dash_array:  ArrayCore,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	stroke_options_init        :: proc(self: ^StrokeOptionsCore) -> Result ---
	stroke_options_init_move   :: proc(self: ^StrokeOptionsCore, other: ^StrokeOptionsCore) -> Result ---
	stroke_options_init_weak   :: proc(self: ^StrokeOptionsCore, other: ^StrokeOptionsCore) -> Result ---
	stroke_options_destroy     :: proc(self: ^StrokeOptionsCore) -> Result ---
	stroke_options_reset       :: proc(self: ^StrokeOptionsCore) -> Result ---
	stroke_options_equals      :: proc(a: ^StrokeOptionsCore, b: ^StrokeOptionsCore) -> i32 ---
	stroke_options_assign_move :: proc(self: ^StrokeOptionsCore, other: ^StrokeOptionsCore) -> Result ---
	stroke_options_assign_weak :: proc(self: ^StrokeOptionsCore, other: ^StrokeOptionsCore) -> Result ---
	path_stroke_to_sink        :: proc(self: ^PathCore, range: ^Range, stroke_options: ^StrokeOptionsCore, approximation_options: ^ApproximationOptions, a: ^PathCore, b: ^PathCore, _c: ^PathCore, sink: PathStrokeSinkFunc, user_data: rawptr) -> Result ---
}

//! 2D vector path [Impl].
PathImpl :: struct {
	//! Union of either raw path-data or their `view`.
	using _: struct #raw_union {
		using _: struct {
			//! Command data
			command_data: ^u8,

			//! Vertex data.
			vertex_data: ^Point,

			//! Vertex/command count.
			size: c.size_t,
		},

		//! Path data as view.
		view: PathView,
	},

	//! Path vertex/command capacity.
	capacity: c.size_t,

	//! Path flags related to caching.
	flags: u32,
}

