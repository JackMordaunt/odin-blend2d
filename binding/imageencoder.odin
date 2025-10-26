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


//! Image encoder [C API].
ImageEncoderCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Image encoder [Virtual Function Table].
ImageEncoderVirt :: struct {
	base:        ObjectVirtBase,
	restart:     proc "c" (impl: ^ImageEncoderImpl) -> Result,
	write_frame: proc "c" (impl: ^ImageEncoderImpl, dst: ^ArrayCore, image: ^ImageCore) -> Result,
}

//! Image encoder [Impl].
ImageEncoderImpl :: struct {
	//! \name Members
	//! \{
	
	//! Virtual function table.
	virt: ^ImageEncoderVirt,

	//! Image codec that created this encoder.
	codec: ImageCodecCore,

	//! Last faulty result (if failed).
	last_result: Result,

	//! Handle in case that this encoder wraps a third-party library.
	handle: rawptr,

	//! Current frame index.
	frame_index: u64,

	//! Position in source buffer.
	buffer_index: c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	image_encoder_init        :: proc(self: ^ImageEncoderCore) -> Result ---
	image_encoder_init_move   :: proc(self: ^ImageEncoderCore, other: ^ImageEncoderCore) -> Result ---
	image_encoder_init_weak   :: proc(self: ^ImageEncoderCore, other: ^ImageEncoderCore) -> Result ---
	image_encoder_destroy     :: proc(self: ^ImageEncoderCore) -> Result ---
	image_encoder_reset       :: proc(self: ^ImageEncoderCore) -> Result ---
	image_encoder_assign_move :: proc(self: ^ImageEncoderCore, other: ^ImageEncoderCore) -> Result ---
	image_encoder_assign_weak :: proc(self: ^ImageEncoderCore, other: ^ImageEncoderCore) -> Result ---
	image_encoder_restart     :: proc(self: ^ImageEncoderCore) -> Result ---
	image_encoder_write_frame :: proc(self: ^ImageEncoderCore, dst: ^ArrayCore, image: ^ImageCore) -> Result ---
}

