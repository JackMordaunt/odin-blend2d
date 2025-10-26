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


//! Font manager [C API].
FontManagerCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Font manager [C API Virtual Function Table].
FontManagerVirt :: struct {
	base: ObjectVirtBase,
}

//! Font manager [C API Impl].
FontManagerImpl :: struct {
	//! Virtual function table.
	virt: ^FontManagerVirt,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	font_manager_init                       :: proc(self: ^FontManagerCore) -> Result ---
	font_manager_init_move                  :: proc(self: ^FontManagerCore, other: ^FontManagerCore) -> Result ---
	font_manager_init_weak                  :: proc(self: ^FontManagerCore, other: ^FontManagerCore) -> Result ---
	font_manager_init_new                   :: proc(self: ^FontManagerCore) -> Result ---
	font_manager_destroy                    :: proc(self: ^FontManagerCore) -> Result ---
	font_manager_reset                      :: proc(self: ^FontManagerCore) -> Result ---
	font_manager_assign_move                :: proc(self: ^FontManagerCore, other: ^FontManagerCore) -> Result ---
	font_manager_assign_weak                :: proc(self: ^FontManagerCore, other: ^FontManagerCore) -> Result ---
	font_manager_create                     :: proc(self: ^FontManagerCore) -> Result ---
	font_manager_get_face_count             :: proc(self: ^FontManagerCore) -> c.size_t ---
	font_manager_get_family_count           :: proc(self: ^FontManagerCore) -> c.size_t ---
	font_manager_has_face                   :: proc(self: ^FontManagerCore, face: ^FontFaceCore) -> i32 ---
	font_manager_add_face                   :: proc(self: ^FontManagerCore, face: ^FontFaceCore) -> Result ---
	font_manager_query_face                 :: proc(self: ^FontManagerCore, name: cstring, name_size: c.size_t, properties: ^FontQueryProperties, out: ^FontFaceCore) -> Result ---
	font_manager_query_faces_by_family_name :: proc(self: ^FontManagerCore, name: cstring, name_size: c.size_t, out: ^ArrayCore) -> Result ---
	font_manager_equals                     :: proc(a: ^FontManagerCore, b: ^FontManagerCore) -> i32 ---
}

//! Properties that can be used to query \ref BLFont and \ref BLFontFace.
//!
//! \sa BLFontManager.
FontQueryProperties :: struct {
	//! \name Members
	//! \{
	
	//! Font style.
	style: u32,

	//! Font weight.
	weight: u32,

	//! Font stretch.
	stretch: u32,
}

