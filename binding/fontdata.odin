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


//! Flags used by \ref BLFontData (or \ref BLFontDataCore).
FontDataFlags :: enum u32 {
	//! No flags.
	NO_FLAGS        = 0,

	//!< Font data references a font-collection.
	FLAG_COLLECTION = 1,
	FLAG_FORCE_UINT = 4294967295,
}

//! A read only data that represents a font table or its sub-table.
FontTable :: struct {
	//! \name Members
	//! \{
	
	//! Pointer to the beginning of the data interpreted as `uint8_t*`.
	data: ^u8,

	//! Size of `data` in bytes.
	size: c.size_t,
}

//! Font data [C API].
FontDataCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Font data [C API Virtual Function Table].
FontDataVirt :: struct {
	base:           ObjectVirtBase,
	get_table_tags: proc "c" (impl: ^FontDataImpl, face_index: u32, out: ^ArrayCore) -> Result,
	get_tables:     proc "c" (impl: ^FontDataImpl, face_index: u32, dst: ^FontTable, tags: ^Tag, n: c.size_t) -> c.size_t,
}

//! Font data [C API Impl].
FontDataImpl :: struct {
	//! Virtual function table.
	virt: ^FontDataVirt,

	//! Type of the face that would be created with this font data.
	face_type: u8,

	//! Number of font faces stored in this font data instance.
	face_count: u32,

	//! Font data flags.
	flags: u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	font_data_init                   :: proc(self: ^FontDataCore) -> Result ---
	font_data_init_move              :: proc(self: ^FontDataCore, other: ^FontDataCore) -> Result ---
	font_data_init_weak              :: proc(self: ^FontDataCore, other: ^FontDataCore) -> Result ---
	font_data_destroy                :: proc(self: ^FontDataCore) -> Result ---
	font_data_reset                  :: proc(self: ^FontDataCore) -> Result ---
	font_data_assign_move            :: proc(self: ^FontDataCore, other: ^FontDataCore) -> Result ---
	font_data_assign_weak            :: proc(self: ^FontDataCore, other: ^FontDataCore) -> Result ---
	font_data_create_from_file       :: proc(self: ^FontDataCore, file_name: cstring, read_flags: FileReadFlags) -> Result ---
	font_data_create_from_data_array :: proc(self: ^FontDataCore, data_array: ^ArrayCore) -> Result ---
	font_data_create_from_data       :: proc(self: ^FontDataCore, data: rawptr, data_size: c.size_t, destroy_func: DestroyExternalDataFunc, user_data: rawptr) -> Result ---
	font_data_equals                 :: proc(a: ^FontDataCore, b: ^FontDataCore) -> i32 ---
	font_data_get_face_count         :: proc(self: ^FontDataCore) -> u32 ---
	font_data_get_face_type          :: proc(self: ^FontDataCore) -> FontFaceType ---
	font_data_get_flags              :: proc(self: ^FontDataCore) -> FontDataFlags ---
	font_data_get_table_tags         :: proc(self: ^FontDataCore, face_index: u32, dst: ^ArrayCore) -> Result ---
	font_data_get_tables             :: proc(self: ^FontDataCore, face_index: u32, dst: ^FontTable, tags: ^Tag, count: c.size_t) -> c.size_t ---
}

