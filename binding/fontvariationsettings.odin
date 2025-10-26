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


//! Font variation settings [C API].
FontVariationSettingsCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Font variation settings [C API Impl].
//!
//! \note This Impl's layout is fully compatible with \ref BLArrayImpl.
FontVariationSettingsImpl :: struct {
	//! Pointer to variation items.
	data: ^FontVariationItem,

	//! Number of variation items in `data`.
	size: c.size_t,

	//! Capacity of `data`.
	capacity: c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	font_variation_settings_init         :: proc(self: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_init_move    :: proc(self: ^FontVariationSettingsCore, other: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_init_weak    :: proc(self: ^FontVariationSettingsCore, other: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_destroy      :: proc(self: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_reset        :: proc(self: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_clear        :: proc(self: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_shrink       :: proc(self: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_assign_move  :: proc(self: ^FontVariationSettingsCore, other: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_assign_weak  :: proc(self: ^FontVariationSettingsCore, other: ^FontVariationSettingsCore) -> Result ---
	font_variation_settings_get_size     :: proc(self: ^FontVariationSettingsCore) -> c.size_t ---
	font_variation_settings_get_capacity :: proc(self: ^FontVariationSettingsCore) -> c.size_t ---
	font_variation_settings_get_view     :: proc(self: ^FontVariationSettingsCore, out: ^FontVariationSettingsView) -> Result ---
	font_variation_settings_has_value    :: proc(self: ^FontVariationSettingsCore, variation_tag: Tag) -> i32 ---
	font_variation_settings_get_value    :: proc(self: ^FontVariationSettingsCore, variation_tag: Tag) -> f32 ---
	font_variation_settings_set_value    :: proc(self: ^FontVariationSettingsCore, variation_tag: Tag, value: f32) -> Result ---
	font_variation_settings_remove_value :: proc(self: ^FontVariationSettingsCore, variation_tag: Tag) -> Result ---
	font_variation_settings_equals       :: proc(a: ^FontVariationSettingsCore, b: ^FontVariationSettingsCore) -> i32 ---
}

//! Associates a font variation tag with a value.
FontVariationItem :: struct {
	//! \name Members
	//! \{
	
	//! Variation tag (32-bit).
	tag: Tag,

	//! Variation value.
	//!
	//! \note values outside of [0, 1] range are invalid.
	value: f32,
}

//! A view unifying the representation of an internal storage used by \ref BLFontVariationSettings.
FontVariationSettingsView :: struct {
	//! Pointer to font variation items, where each item describes a variation tag and its value.
	//!
	//! \note If the container is in SSO mode the `data` member will point to `sso_data`.
	data: ^FontVariationItem,

	//! Count of items in `data.
	size: c.size_t,

	//! Unpacked SSO items into \ref BLFontVariationItem array.
	//!
	//! \note This member won't be initialized or zeroed in case \ref BLFontVariationSettings is not in
	//! SSO mode. And if the container is in SSO mode only the number of items used will be overwritten
	//! by \ref BLFontVariationSettings::get_view().
	sso_data: [3]FontVariationItem,
}

