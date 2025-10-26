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

ObjectImpl :: struct {}

//! \cond INTERNAL
//! Defines a start offset of each field or flag in object info - the shift can be then used to get/set value from/to
//! info bits.
ObjectInfoShift :: enum u32 {
	P_SHIFT          = 0,
	Q_SHIFT          = 8,
	C_SHIFT          = 8,
	B_SHIFT          = 12,
	A_SHIFT          = 16,
	TYPE_SHIFT       = 22,
	R_SHIFT          = 29,
	D_SHIFT          = 30,
	M_SHIFT          = 31,
	SHIFT_FORCE_UINT = 4294967295,
}

//! Defines a mask of each field of the object info.
//!
//! \note This is part of the official documentation, however, users should not use these enumerations in any context.
ObjectInfoBits :: enum u32 {
	//! Mask describing 'P' payload (8 bits).
	P_MASK          = 255,        // [........|........|........|pppppppp]

	//! Mask describing 'Q' payload (8 bits aliased with 'bbbbcccc' bits).
	Q_MASK          = 65280,      // [........|........|qqqqqqqq|........]

	//! Mask describing 'C' payload (4 bits).
	C_MASK          = 3840,       // [........|........|....cccc|........]

	//! Mask describing 'B' payload (4 bits).
	B_MASK          = 61440,      // [........|........|bbbb....|........]

	//! Mask describing 'A' payload (6 bits).
	A_MASK          = 4128768,    // [........|..aaaaaa|........|........]

	//! Mask of all payload fields combined, except 'M', 'T', type identification, and 'R' (RefCounted marker).
	FIELDS_MASK     = 4194303,

	//! Mask describing object type (8 bits), see \ref BLObjectType.
	TYPE_MASK       = 532676608,  // [...ttttt|tt......|........|........]

	//! Flag describing a ref-counted object (if set together with 'D' flag)
	//!
	//! \note This flag is free for use by SSO, it has no meaning when 'D' flag is not set).
	R_FLAG          = 536870912,  // [..R.....|........|........|........]

	//! Flag describing a dynamic object - if this flag is not set, it means the object is in SSO mode.
	D_FLAG          = 1073741824, // [.D......|........|........|........]

	//! Flag describing a valid object compatible with \ref BLObjectCore interface (otherwise it's most likely \ref BLRgba).
	M_FLAG          = 2147483648, // [M.......|........|........|........]

	//! A combination of `BL_OBJECT_INFO_M_FLAG` and `BL_OBJECT_INFO_D_FLAG` flags.
	MD_FLAGS        = 3221225472,

	//! A combination of `BL_OBJECT_INFO_M_FLAG`, `BL_OBJECT_INFO_D_FLAG`, `BL_OBJECT_INFO_R_FLAG` flags.
	MDR_FLAGS       = 3758096384,
	BITS_FORCE_UINT = 4294967295,
}

//! Object type identifier.
ObjectType :: enum u32 {
	//! Object represents a \ref BLRgba value stored as four 32-bit floating point components (can be used as Style).
	RGBA                    = 0,

	//! Object represents a \ref BLRgba32 value stored as 32-bit integer in `0xAARRGGBB` form.
	RGBA32                  = 1,

	//! Object represents a \ref BLRgba64 value stored as 64-bit integer in `0xAAAARRRRGGGGBBBB` form.
	RGBA64                  = 2,

	//! Object is `Null` (can be used as style).
	NULL                    = 3,

	//! Object is \ref BLPattern (can be used as style).
	PATTERN                 = 4,

	//! Object is \ref BLGradient (can be used as style).
	GRADIENT                = 5,

	//! Object is \ref BLImage.
	IMAGE                   = 9,

	//! Object is \ref BLPath.
	PATH                    = 10,

	//! Object is \ref BLFont.
	FONT                    = 16,

	//! Object is \ref BLFontFeatureSettings.
	FONT_FEATURE_SETTINGS   = 17,

	//! Object is \ref BLFontVariationSettings.
	FONT_VARIATION_SETTINGS = 18,

	//! Object is \ref BLBitArray.
	BIT_ARRAY               = 25,

	//! Object is \ref BLBitSet.
	BIT_SET                 = 26,

	//! Object represents a boolean value.
	BOOL                    = 28,

	//! Object represents a 64-bit signed integer value.
	INT64                   = 29,

	//! Object represents a 64-bit unsigned integer value.
	UINT64                  = 30,

	//! Object represents a 64-bit floating point value.
	DOUBLE                  = 31,

	//! Object is \ref BLString.
	STRING                  = 32,

	//! Object is \ref BLArray<T> where `T` is a `BLObject` compatible type.
	ARRAY_OBJECT            = 33,

	//! Object is \ref BLArray<T> where `T` matches 8-bit signed integral type.
	ARRAY_INT8              = 34,

	//! Object is \ref BLArray<T> where `T` matches 8-bit unsigned integral type.
	ARRAY_UINT8             = 35,

	//! Object is \ref BLArray<T> where `T` matches 16-bit signed integral type.
	ARRAY_INT16             = 36,

	//! Object is \ref BLArray<T> where `T` matches 16-bit unsigned integral type.
	ARRAY_UINT16            = 37,

	//! Object is \ref BLArray<T> where `T` matches 32-bit signed integral type.
	ARRAY_INT32             = 38,

	//! Object is \ref BLArray<T> where `T` matches 32-bit unsigned integral type.
	ARRAY_UINT32            = 39,

	//! Object is \ref BLArray<T> where `T` matches 64-bit signed integral type.
	ARRAY_INT64             = 40,

	//! Object is \ref BLArray<T> where `T` matches 64-bit unsigned integral type.
	ARRAY_UINT64            = 41,

	//! Object is \ref BLArray<T> where `T` matches 32-bit floating point type.
	ARRAY_FLOAT32           = 42,

	//! Object is \ref BLArray<T> where `T` matches 64-bit floating point type.
	ARRAY_FLOAT64           = 43,

	//! Object is \ref BLArray<T> where `T` is a struct of size 1.
	ARRAY_STRUCT_1          = 44,

	//! Object is \ref BLArray<T> where `T` is a struct of size 2.
	ARRAY_STRUCT_2          = 45,

	//! Object is \ref BLArray<T> where `T` is a struct of size 3.
	ARRAY_STRUCT_3          = 46,

	//! Object is \ref BLArray<T> where `T` is a struct of size 4.
	ARRAY_STRUCT_4          = 47,

	//! Object is \ref BLArray<T> where `T` is a struct of size 6.
	ARRAY_STRUCT_6          = 48,

	//! Object is \ref BLArray<T> where `T` is a struct of size 8.
	ARRAY_STRUCT_8          = 49,

	//! Object is \ref BLArray<T> where `T` is a struct of size 10.
	ARRAY_STRUCT_10         = 50,

	//! Object is \ref BLArray<T> where `T` is a struct of size 12.
	ARRAY_STRUCT_12         = 51,

	//! Object is \ref BLArray<T> where `T` is a struct of size 16.
	ARRAY_STRUCT_16         = 52,

	//! Object is \ref BLArray<T> where `T` is a struct of size 20.
	ARRAY_STRUCT_20         = 53,

	//! Object is \ref BLArray<T> where `T` is a struct of size 24.
	ARRAY_STRUCT_24         = 54,

	//! Object is \ref BLArray<T> where `T` is a struct of size 32.
	ARRAY_STRUCT_32         = 55,

	//! Object is \ref BLContext.
	CONTEXT                 = 100,

	//! Object is \ref BLImageCodec.
	IMAGE_CODEC             = 101,

	//! Object is \ref BLImageDecoder.
	IMAGE_DECODER           = 102,

	//! Object is \ref BLImageEncoder.
	IMAGE_ENCODER           = 103,

	//! Object is \ref BLFontFace.
	FONT_FACE               = 104,

	//! Object is \ref BLFontData.
	FONT_DATA               = 105,

	//! Object is \ref BLFontManager.
	FONT_MANAGER            = 106,

	//! Minimum object type of an array object.
	MIN_ARRAY               = 33,

	//! Maximum object type of an array object.
	MAX_ARRAY               = 55,

	//! Minimum object type identifier that can be used as a style.
	MIN_STYLE               = 0,

	//! Maximum object type identifier that can be used as a style.
	MAX_STYLE               = 5,

	//! Minimum object type of an object with virtual function table.
	MIN_VIRTUAL             = 100,

	//! Maximum object type of an object with virtual function table.
	MAX_VIRTUAL             = 127,

	//! Maximum possible value of an object type, including identifiers reserved for the future.
	MAX_VALUE               = 127,
	FORCE_UINT              = 4294967295,
}

//! Information bits used by \ref BLObjectCore and all Blend2D compatible objects inheriting it.
ObjectInfo :: struct {
	//! \name Members
	//! \{
	
	//! Stores all object info bits.
	bits: u32,
}

//! Defines a BLObject layout that all objects must use.
ObjectDetail :: struct #raw_union {
	impl:      ^ObjectImpl,
	char_data: [16]i8,
	i8_data:   [16]i8,
	u8_data:   [16]u8,
	i16_data:  [8]i16,
	u16_data:  [8]u16,
	i32_data:  [4]i32,
	u32_data:  [4]u32,
	i64_data:  [2]i64,
	u64_data:  [2]u64,
	f32_data:  [4]f32,
	f64_data:  [2]f64,
	rgba:      Rgba,
	rgba32:    Rgba32,
	rgba64:    Rgba64,

	using _: struct {
		u32_data_overlap: [2]u32,
		impl_payload:     u32,
		info:             ObjectInfo,
	},
}

//! A function callback that is called when an Impl that holds external data is going to be destroyed. It's
//! often used as a notification that a data passed to a certain Impl is no longer in use by Blend2D.
DestroyExternalDataFunc :: proc "c" (impl: rawptr, external_data: rawptr, user_data: rawptr)

//! Base members of \ref BLObjectVirt.
//!
//! The reason for this struct is to make C API the same as C++ API in terms of struct members. In C++ mode we use
//! inheritance so `Virt` structs actually inherit from \ref BLObjectVirt, but in every case all base members are
//! provided by `base`.
ObjectVirtBase :: struct {
	destroy:      proc "c" (impl: ^ObjectImpl) -> Result,
	get_property: proc "c" (impl: ^ObjectImpl, name: cstring, name_size: c.size_t, value_out: ^VarCore) -> Result,
	set_property: proc "c" (impl: ^ObjectImpl, name: cstring, name_size: c.size_t, value: ^VarCore) -> Result,
}

//! BLObject [Virtual Function Table].
//!
//! Virtual function table is only present when object type is greater than \ref BL_OBJECT_TYPE_MIN_VIRTUAL.
//! Objects can extend the function table, but it has to always start with members defined by `BLObjectVirt`.
ObjectVirt :: struct {
	base: ObjectVirtBase,
}

//! Base class used by all Blend2D objects.
ObjectCore :: struct {
	_d: ObjectDetail,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	object_alloc_impl          :: proc(self: ^ObjectCore, object_info: u32, impl_size: c.size_t) -> Result ---
	object_alloc_impl_aligned  :: proc(self: ^ObjectCore, object_info: u32, impl_size: c.size_t, impl_alignment: c.size_t) -> Result ---
	object_alloc_impl_external :: proc(self: ^ObjectCore, object_info: u32, impl_size: c.size_t, immutable: i32, destroy_func: DestroyExternalDataFunc, user_data: rawptr) -> Result ---
	object_free_impl           :: proc(impl: ^ObjectImpl) -> Result ---
	object_init_move           :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	object_init_weak           :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	object_reset               :: proc(self: ^Unknown) -> Result ---
	object_assign_move         :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	object_assign_weak         :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	object_get_property        :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^VarCore) -> Result ---
	object_get_property_bool   :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^i32) -> Result ---
	object_get_property_int32  :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^i32) -> Result ---
	object_get_property_int64  :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^i64) -> Result ---
	object_get_property_uint32 :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^u32) -> Result ---
	object_get_property_uint64 :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^u64) -> Result ---
	object_get_property_double :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value_out: ^f64) -> Result ---
	object_set_property        :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: ^Unknown) -> Result ---
	object_set_property_bool   :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: i32) -> Result ---
	object_set_property_int32  :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: i32) -> Result ---
	object_set_property_int64  :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: i64) -> Result ---
	object_set_property_uint32 :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: u32) -> Result ---
	object_set_property_uint64 :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: u64) -> Result ---
	object_set_property_double :: proc(self: ^Unknown, name: cstring, name_size: c.size_t, value: f64) -> Result ---
}

