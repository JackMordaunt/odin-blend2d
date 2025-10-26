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


//! Blend2D runtime scope [C API].
RuntimeScopeCore :: struct {
	data: [2]u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	runtime_scope_begin     :: proc(self: ^RuntimeScopeCore) -> Result ---
	runtime_scope_end       :: proc(self: ^RuntimeScopeCore) -> Result ---
	runtime_scope_is_active :: proc(self: ^RuntimeScopeCore) -> i32 ---
}

