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


//! Direction of a geometry used by geometric primitives and paths.
GeometryDirection :: enum u32 {
	//! No direction specified.
	NONE       = 0,

	//! Clockwise direction.
	CW         = 1,

	//! Counter-clockwise direction.
	CCW        = 2,
	FORCE_UINT = 4294967295,
}

//! Geometry type.
//!
//! Geometry describes a shape or path that can be either rendered or added to a BLPath container. Both \ref BLPath
//! and \ref BLContext provide functionality to work with all geometry types. Please note that each type provided
//! here requires to pass a matching struct or class to the function that consumes a `geometry_type` and `geometry_data`
//! arguments.
//!
//! \cond INTERNAL
//! \note Always modify `BL_GEOMETRY_TYPE_SIMPLE_LAST` and related functions when adding a new type to `BLGeometryType`
//! enum. Some functions just pass the geometry type and data to another function, but the rendering context must copy
//! simple types to a render job, which means that it must know which type is simple and also sizes of all simple
//! types, see `geometry_p.h` for more details about handling simple types.
//! \endcond
GeometryType :: enum u32 {
	//! No geometry provided.
	NONE             = 0,

	//! BLBoxI struct.
	BOXI             = 1,

	//! BLBox struct.
	BOXD             = 2,

	//! BLRectI struct.
	RECTI            = 3,

	//! BLRect struct.
	RECTD            = 4,

	//! BLCircle struct.
	CIRCLE           = 5,

	//! BLEllipse struct.
	ELLIPSE          = 6,

	//! BLRoundRect struct.
	ROUND_RECT       = 7,

	//! BLArc struct.
	ARC              = 8,

	//! BLArc struct representing chord.
	CHORD            = 9,

	//! BLArc struct representing pie.
	PIE              = 10,

	//! BLLine struct.
	LINE             = 11,

	//! BLTriangle struct.
	TRIANGLE         = 12,

	//! BLArrayView<BLPointI> representing a polyline.
	POLYLINEI        = 13,

	//! BLArrayView<BLPoint> representing a polyline.
	POLYLINED        = 14,

	//! BLArrayView<BLPointI> representing a polygon.
	POLYGONI         = 15,

	//! BLArrayView<BLPoint> representing a polygon.
	POLYGOND         = 16,

	//! BLArrayView<BLBoxI> struct.
	ARRAY_VIEW_BOXI  = 17,

	//! BLArrayView<BLBox> struct.
	ARRAY_VIEW_BOXD  = 18,

	//! BLArrayView<BLRectI> struct.
	ARRAY_VIEW_RECTI = 19,

	//! BLArrayView<BLRect> struct.
	ARRAY_VIEW_RECTD = 20,

	//! BLPath (or BLPathCore).
	PATH             = 21,

	//! Maximum value of `BLGeometryType`.
	MAX_VALUE        = 21,

	//! \cond INTERNAL
	
	//! The last simple type.
	SIMPLE_LAST      = 12,

	//! \endcond
	FORCE_UINT       = 4294967295,
}

//! Fill rule.
FillRule :: enum u32 {
	//! Non-zero fill-rule.
	NON_ZERO   = 0,

	//! Even-odd fill-rule.
	EVEN_ODD   = 1,

	//! Maximum value of `BLFillRule`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Hit-test result.
HitTest :: enum u32 {
	//! Fully in.
	IN         = 0,

	//! Partially in/out.
	PART       = 1,

	//! Fully out.
	OUT        = 2,

	//! Hit test failed (invalid argument, NaNs, etc).
	INVALID    = 4294967295,
	FORCE_UINT = 4294967295,
}

//! Point specified as [x, y] using `int` as a storage type.
PointI :: struct {
	x: i32,
	y: i32,
}

//! Size specified as [w, h] using `int` as a storage type.
SizeI :: struct {
	w: i32,
	h: i32,
}

//! Box specified as [x0, y0, x1, y1] using `int` as a storage type.
BoxI :: struct {
	x0: i32,
	y0: i32,
	x1: i32,
	y1: i32,
}

//! Rectangle specified as [x, y, w, h] using `int` as a storage type.
RectI :: struct {
	x: i32,
	y: i32,
	w: i32,
	h: i32,
}

//! Point specified as [x, y] using `double` as a storage type.
Point :: struct {
	x: f64,
	y: f64,
}

//! Size specified as [w, h] using `double` as a storage type.
Size :: struct {
	w: f64,
	h: f64,
}

//! Box specified as [x0, y0, x1, y1] using `double` as a storage type.
Box :: struct {
	x0: f64,
	y0: f64,
	x1: f64,
	y1: f64,
}

//! Rectangle specified as [x, y, w, h] using `double` as a storage type.
Rect :: struct {
	x: f64,
	y: f64,
	w: f64,
	h: f64,
}

//! Line specified as [x0, y0, x1, y1] using `double` as a storage type.
Line :: struct {
	x0, y0: f64,
	x1, y1: f64,
}

//! Triangle data specified as [x0, y0, x1, y1, x2, y2] using `double` as a storage type.
Triangle :: struct {
	x0, y0: f64,
	x1, y1: f64,
	x2, y2: f64,
}

//! Rounded rectangle specified as [x, y, w, h, rx, ry] using `double` as a storage type.
RoundRect :: struct {
	x, y, w, h: f64,
	rx, ry:     f64,
}

//! Circle specified as [cx, cy, r] using `double` as a storage type.
Circle :: struct {
	cx, cy: f64,
	r:      f64,
}

//! Ellipse specified as [cx, cy, rx, ry] using `double` as a storage type.
Ellipse :: struct {
	cx, cy: f64,
	rx, ry: f64,
}

//! Arc specified as [cx, cy, rx, ry, start, sweep] using `double` as a storage type.
Arc :: struct {
	cx, cy: f64,
	rx, ry: f64,
	start:  f64,
	sweep:  f64,
}

