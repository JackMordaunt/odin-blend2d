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


//! Array container [C API].
ArrayCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Array container [C API Impl].
ArrayImpl :: struct {
	//! Pointer to array data.
	data: rawptr,

	//! Array size [in items].
	size: c.size_t,

	//! Array capacity [in items].
	capacity: c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	array_init                 :: proc(self: ^ArrayCore, array_type: ObjectType) -> Result ---
	array_init_move            :: proc(self: ^ArrayCore, other: ^ArrayCore) -> Result ---
	array_init_weak            :: proc(self: ^ArrayCore, other: ^ArrayCore) -> Result ---
	array_destroy              :: proc(self: ^ArrayCore) -> Result ---
	array_reset                :: proc(self: ^ArrayCore) -> Result ---
	array_get_size             :: proc(self: ^ArrayCore) -> c.size_t ---
	array_get_capacity         :: proc(self: ^ArrayCore) -> c.size_t ---
	array_get_item_size        :: proc(self: ^ArrayCore) -> c.size_t ---
	array_get_data             :: proc(self: ^ArrayCore) -> rawptr ---
	array_clear                :: proc(self: ^ArrayCore) -> Result ---
	array_shrink               :: proc(self: ^ArrayCore) -> Result ---
	array_reserve              :: proc(self: ^ArrayCore, n: c.size_t) -> Result ---
	array_resize               :: proc(self: ^ArrayCore, n: c.size_t, fill: rawptr) -> Result ---
	array_make_mutable         :: proc(self: ^ArrayCore, data_out: ^rawptr) -> Result ---
	array_modify_op            :: proc(self: ^ArrayCore, op: ModifyOp, n: c.size_t, data_out: ^rawptr) -> Result ---
	array_insert_op            :: proc(self: ^ArrayCore, index: c.size_t, n: c.size_t, data_out: ^rawptr) -> Result ---
	array_assign_move          :: proc(self: ^ArrayCore, other: ^ArrayCore) -> Result ---
	array_assign_weak          :: proc(self: ^ArrayCore, other: ^ArrayCore) -> Result ---
	array_assign_deep          :: proc(self: ^ArrayCore, other: ^ArrayCore) -> Result ---
	array_assign_data          :: proc(self: ^ArrayCore, data: rawptr, n: c.size_t) -> Result ---
	array_assign_external_data :: proc(self: ^ArrayCore, data: rawptr, size: c.size_t, capacity: c.size_t, data_access_flags: DataAccessFlags, destroy_func: DestroyExternalDataFunc, user_data: rawptr) -> Result ---
	array_append_u8            :: proc(self: ^ArrayCore, value: u8) -> Result ---
	array_append_u16           :: proc(self: ^ArrayCore, value: u16) -> Result ---
	array_append_u32           :: proc(self: ^ArrayCore, value: u32) -> Result ---
	array_append_u64           :: proc(self: ^ArrayCore, value: u64) -> Result ---
	array_append_f32           :: proc(self: ^ArrayCore, value: f32) -> Result ---
	array_append_f64           :: proc(self: ^ArrayCore, value: f64) -> Result ---
	array_append_item          :: proc(self: ^ArrayCore, item: rawptr) -> Result ---
	array_append_data          :: proc(self: ^ArrayCore, data: rawptr, n: c.size_t) -> Result ---
	array_insert_u8            :: proc(self: ^ArrayCore, index: c.size_t, value: u8) -> Result ---
	array_insert_u16           :: proc(self: ^ArrayCore, index: c.size_t, value: u16) -> Result ---
	array_insert_u32           :: proc(self: ^ArrayCore, index: c.size_t, value: u32) -> Result ---
	array_insert_u64           :: proc(self: ^ArrayCore, index: c.size_t, value: u64) -> Result ---
	array_insert_f32           :: proc(self: ^ArrayCore, index: c.size_t, value: f32) -> Result ---
	array_insert_f64           :: proc(self: ^ArrayCore, index: c.size_t, value: f64) -> Result ---
	array_insert_item          :: proc(self: ^ArrayCore, index: c.size_t, item: rawptr) -> Result ---
	array_insert_data          :: proc(self: ^ArrayCore, index: c.size_t, data: rawptr, n: c.size_t) -> Result ---
	array_replace_u8           :: proc(self: ^ArrayCore, index: c.size_t, value: u8) -> Result ---
	array_replace_u16          :: proc(self: ^ArrayCore, index: c.size_t, value: u16) -> Result ---
	array_replace_u32          :: proc(self: ^ArrayCore, index: c.size_t, value: u32) -> Result ---
	array_replace_u64          :: proc(self: ^ArrayCore, index: c.size_t, value: u64) -> Result ---
	array_replace_f32          :: proc(self: ^ArrayCore, index: c.size_t, value: f32) -> Result ---
	array_replace_f64          :: proc(self: ^ArrayCore, index: c.size_t, value: f64) -> Result ---
	array_replace_item         :: proc(self: ^ArrayCore, index: c.size_t, item: rawptr) -> Result ---
	array_replace_data         :: proc(self: ^ArrayCore, r_start: c.size_t, r_end: c.size_t, data: rawptr, n: c.size_t) -> Result ---
	array_remove_index         :: proc(self: ^ArrayCore, index: c.size_t) -> Result ---
	array_remove_range         :: proc(self: ^ArrayCore, r_start: c.size_t, r_end: c.size_t) -> Result ---
	array_equals               :: proc(a: ^ArrayCore, b: ^ArrayCore) -> i32 ---
}

