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


//! Font feature settings [C API].
FontFeatureSettingsCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Font feature settings [C API Impl].
//!
//! \note This Impl's layout is fully compatible with \ref BLArrayImpl.
FontFeatureSettingsImpl :: struct {
	//! Pointer to feature items.
	data: ^FontFeatureItem,

	//! Number of feature items in `data`.
	size: c.size_t,

	//! Capacity of `data`.
	capacity: c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	font_feature_settings_init         :: proc(self: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_init_move    :: proc(self: ^FontFeatureSettingsCore, other: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_init_weak    :: proc(self: ^FontFeatureSettingsCore, other: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_destroy      :: proc(self: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_reset        :: proc(self: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_clear        :: proc(self: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_shrink       :: proc(self: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_assign_move  :: proc(self: ^FontFeatureSettingsCore, other: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_assign_weak  :: proc(self: ^FontFeatureSettingsCore, other: ^FontFeatureSettingsCore) -> Result ---
	font_feature_settings_get_size     :: proc(self: ^FontFeatureSettingsCore) -> c.size_t ---
	font_feature_settings_get_capacity :: proc(self: ^FontFeatureSettingsCore) -> c.size_t ---
	font_feature_settings_get_view     :: proc(self: ^FontFeatureSettingsCore, out: ^FontFeatureSettingsView) -> Result ---
	font_feature_settings_has_value    :: proc(self: ^FontFeatureSettingsCore, feature_tag: Tag) -> i32 ---
	font_feature_settings_get_value    :: proc(self: ^FontFeatureSettingsCore, feature_tag: Tag) -> u32 ---
	font_feature_settings_set_value    :: proc(self: ^FontFeatureSettingsCore, feature_tag: Tag, value: u32) -> Result ---
	font_feature_settings_remove_value :: proc(self: ^FontFeatureSettingsCore, feature_tag: Tag) -> Result ---
	font_feature_settings_equals       :: proc(a: ^FontFeatureSettingsCore, b: ^FontFeatureSettingsCore) -> i32 ---
}

//! Associates a font feature tag with a value. Tag describes the feature (as provided by the font) and `value`
//! describes its value. Some features only allow boolean values 0 and 1 and some allow values up to 65535.
//! Values above 65535 are invalid, however, only \ref BL_FONT_FEATURE_INVALID_VALUE should be used as invalid
//! value in general.
//!
//! Registered OpenType features:
//!   - https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags
//!   - https://helpx.adobe.com/typekit/using/open-type-syntax.html
FontFeatureItem :: struct {
	//! \name Members
	//! \{
	
	//! Feature tag (32-bit).
	tag: Tag,

	//! Feature value.
	//!
	//! \note values greater than 65535 are invalid.
	value: u32,
}

//! A view unifying the representation of an internal storage used by \ref BLFontFeatureSettings.
FontFeatureSettingsView :: struct {
	//! \name Members
	//! \{
	
	//! Pointer to font feature items, where each item describes a tag and its value.
	//!
	//! \note If the container is in SSO mode the `data` member will point to `sso_data`.
	data: ^FontFeatureItem,

	//! Count of items in `data.
	size: c.size_t,

	//! Unpacked SSO items into \ref BLFontFeatureItem array.
	//!
	//! \note This member won't be initialized or zeroed in case \ref BLFontFeatureSettings is not in SSO mode. And if the
	//! container is in SSO mode only the number of items used will be overwritten by \ref BLFontFeatureSettings::get_view().
	sso_data: [36]FontFeatureItem,
}

