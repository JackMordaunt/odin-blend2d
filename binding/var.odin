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


//! Variant [C API].
VarCore :: struct {
	_d: ObjectDetail,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	var_init_type     :: proc(self: ^Unknown, type: ObjectType) -> Result ---
	var_init_null     :: proc(self: ^Unknown) -> Result ---
	var_init_bool     :: proc(self: ^Unknown, value: i32) -> Result ---
	var_init_int32    :: proc(self: ^Unknown, value: i32) -> Result ---
	var_init_int64    :: proc(self: ^Unknown, value: i64) -> Result ---
	var_init_uint32   :: proc(self: ^Unknown, value: u32) -> Result ---
	var_init_uint64   :: proc(self: ^Unknown, value: u64) -> Result ---
	var_init_double   :: proc(self: ^Unknown, value: f64) -> Result ---
	var_init_rgba     :: proc(self: ^Unknown, rgba: ^Rgba) -> Result ---
	var_init_rgba32   :: proc(self: ^Unknown, rgba32: u32) -> Result ---
	var_init_rgba64   :: proc(self: ^Unknown, rgba64: u64) -> Result ---
	var_init_move     :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	var_init_weak     :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	var_destroy       :: proc(self: ^Unknown) -> Result ---
	var_reset         :: proc(self: ^Unknown) -> Result ---
	var_assign_null   :: proc(self: ^Unknown) -> Result ---
	var_assign_bool   :: proc(self: ^Unknown, value: i32) -> Result ---
	var_assign_int32  :: proc(self: ^Unknown, value: i32) -> Result ---
	var_assign_int64  :: proc(self: ^Unknown, value: i64) -> Result ---
	var_assign_uint32 :: proc(self: ^Unknown, value: u32) -> Result ---
	var_assign_uint64 :: proc(self: ^Unknown, value: u64) -> Result ---
	var_assign_double :: proc(self: ^Unknown, value: f64) -> Result ---
	var_assign_rgba   :: proc(self: ^Unknown, rgba: ^Rgba) -> Result ---
	var_assign_rgba32 :: proc(self: ^Unknown, rgba32: u32) -> Result ---
	var_assign_rgba64 :: proc(self: ^Unknown, rgba64: u64) -> Result ---
	var_assign_move   :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	var_assign_weak   :: proc(self: ^Unknown, other: ^Unknown) -> Result ---
	var_get_type      :: proc(self: ^Unknown) -> ObjectType ---
	var_to_bool       :: proc(self: ^Unknown, out: ^i32) -> Result ---
	var_to_int32      :: proc(self: ^Unknown, out: ^i32) -> Result ---
	var_to_int64      :: proc(self: ^Unknown, out: ^i64) -> Result ---
	var_to_uint32     :: proc(self: ^Unknown, out: ^u32) -> Result ---
	var_to_uint64     :: proc(self: ^Unknown, out: ^u64) -> Result ---
	var_to_double     :: proc(self: ^Unknown, out: ^f64) -> Result ---
	var_to_rgba       :: proc(self: ^Unknown, out: ^Rgba) -> Result ---
	var_to_rgba32     :: proc(self: ^Unknown, out: ^u32) -> Result ---
	var_to_rgba64     :: proc(self: ^Unknown, out: ^u64) -> Result ---
	var_equals        :: proc(a: ^Unknown, b: ^Unknown) -> i32 ---
	var_equals_null   :: proc(self: ^Unknown) -> i32 ---
	var_equals_bool   :: proc(self: ^Unknown, value: i32) -> i32 ---
	var_equals_int64  :: proc(self: ^Unknown, value: i64) -> i32 ---
	var_equals_uint64 :: proc(self: ^Unknown, value: u64) -> i32 ---
	var_equals_double :: proc(self: ^Unknown, value: f64) -> i32 ---
	var_equals_rgba   :: proc(self: ^Unknown, rgba: ^Rgba) -> i32 ---
	var_equals_rgba32 :: proc(self: ^Unknown, rgba32: u32) -> i32 ---
	var_equals_rgba64 :: proc(self: ^Unknown, rgba64: u64) -> i32 ---
	var_strict_equals :: proc(a: ^Unknown, b: ^Unknown) -> i32 ---
}

