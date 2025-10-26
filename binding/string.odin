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


//! Byte string [C API].
StringCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Byte string [Impl].
StringImpl :: struct {
	//! String size [in bytes].
	size: c.size_t,

	//! String data capacity [in bytes].
	capacity: c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	string_init              :: proc(self: ^StringCore) -> Result ---
	string_init_move         :: proc(self: ^StringCore, other: ^StringCore) -> Result ---
	string_init_weak         :: proc(self: ^StringCore, other: ^StringCore) -> Result ---
	string_init_with_data    :: proc(self: ^StringCore, str: cstring, size: c.size_t) -> Result ---
	string_destroy           :: proc(self: ^StringCore) -> Result ---
	string_reset             :: proc(self: ^StringCore) -> Result ---
	string_get_data          :: proc(self: ^StringCore) -> cstring ---
	string_get_size          :: proc(self: ^StringCore) -> c.size_t ---
	string_get_capacity      :: proc(self: ^StringCore) -> c.size_t ---
	string_clear             :: proc(self: ^StringCore) -> Result ---
	string_shrink            :: proc(self: ^StringCore) -> Result ---
	string_reserve           :: proc(self: ^StringCore, n: c.size_t) -> Result ---
	string_resize            :: proc(self: ^StringCore, n: c.size_t, fill: i8) -> Result ---
	string_make_mutable      :: proc(self: ^StringCore, data_out: ^cstring) -> Result ---
	string_modify_op         :: proc(self: ^StringCore, op: ModifyOp, n: c.size_t, data_out: ^cstring) -> Result ---
	string_insert_op         :: proc(self: ^StringCore, index: c.size_t, n: c.size_t, data_out: ^cstring) -> Result ---
	string_assign_move       :: proc(self: ^StringCore, other: ^StringCore) -> Result ---
	string_assign_weak       :: proc(self: ^StringCore, other: ^StringCore) -> Result ---
	string_assign_deep       :: proc(self: ^StringCore, other: ^StringCore) -> Result ---
	string_assign_data       :: proc(self: ^StringCore, str: cstring, n: c.size_t) -> Result ---
	string_apply_op_char     :: proc(self: ^StringCore, op: ModifyOp, _c: i8, n: c.size_t) -> Result ---
	string_apply_op_data     :: proc(self: ^StringCore, op: ModifyOp, str: cstring, n: c.size_t) -> Result ---
	string_apply_op_string   :: proc(self: ^StringCore, op: ModifyOp, other: ^StringCore) -> Result ---
	string_apply_op_format   :: proc(self: ^StringCore, op: ModifyOp, fmt: cstring, #c_vararg _: ..any) -> Result ---
	string_apply_op_format_v :: proc(self: ^StringCore, op: ModifyOp, fmt: cstring, ap: i32) -> Result ---
	string_insert_char       :: proc(self: ^StringCore, index: c.size_t, _c: i8, n: c.size_t) -> Result ---
	string_insert_data       :: proc(self: ^StringCore, index: c.size_t, str: cstring, n: c.size_t) -> Result ---
	string_insert_string     :: proc(self: ^StringCore, index: c.size_t, other: ^StringCore) -> Result ---
	string_remove_index      :: proc(self: ^StringCore, index: c.size_t) -> Result ---
	string_remove_range      :: proc(self: ^StringCore, r_start: c.size_t, r_end: c.size_t) -> Result ---
	string_equals            :: proc(a: ^StringCore, b: ^StringCore) -> i32 ---
	string_equals_data       :: proc(self: ^StringCore, str: cstring, n: c.size_t) -> i32 ---
	string_compare           :: proc(a: ^StringCore, b: ^StringCore) -> i32 ---
	string_compare_data      :: proc(self: ^StringCore, str: cstring, n: c.size_t) -> i32 ---
}

