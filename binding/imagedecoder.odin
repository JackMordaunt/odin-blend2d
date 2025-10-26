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


//! Image decoder [C API]
ImageDecoderCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Image decoder [C API Virtual Function Table].
ImageDecoderVirt :: struct {
	base:       ObjectVirtBase,
	restart:    proc "c" (impl: ^ImageDecoderImpl) -> Result,
	read_info:  proc "c" (impl: ^ImageDecoderImpl, info_out: ^ImageInfo, data: ^u8, size: c.size_t) -> Result,
	read_frame: proc "c" (impl: ^ImageDecoderImpl, image_out: ^ImageCore, data: ^u8, size: c.size_t) -> Result,
}

//! Image decoder [C API Impl].
ImageDecoderImpl :: struct {
	//! \name Members
	//! \{
	
	//! Virtual function table.
	virt: ^ImageDecoderVirt,

	//! Image codec that created this decoder.
	codec: ImageCodecCore,

	//! Last faulty result (if failed).
	last_result: Result,

	//! Handle in case that this decoder wraps a third-party library.
	handle: rawptr,

	//! Current frame index.
	frame_index: u64,

	//! Position in source buffer.
	buffer_index: c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	image_decoder_init        :: proc(self: ^ImageDecoderCore) -> Result ---
	image_decoder_init_move   :: proc(self: ^ImageDecoderCore, other: ^ImageDecoderCore) -> Result ---
	image_decoder_init_weak   :: proc(self: ^ImageDecoderCore, other: ^ImageDecoderCore) -> Result ---
	image_decoder_destroy     :: proc(self: ^ImageDecoderCore) -> Result ---
	image_decoder_reset       :: proc(self: ^ImageDecoderCore) -> Result ---
	image_decoder_assign_move :: proc(self: ^ImageDecoderCore, other: ^ImageDecoderCore) -> Result ---
	image_decoder_assign_weak :: proc(self: ^ImageDecoderCore, other: ^ImageDecoderCore) -> Result ---
	image_decoder_restart     :: proc(self: ^ImageDecoderCore) -> Result ---
	image_decoder_read_info   :: proc(self: ^ImageDecoderCore, info_out: ^ImageInfo, data: ^u8, size: c.size_t) -> Result ---
	image_decoder_read_frame  :: proc(self: ^ImageDecoderCore, image_out: ^ImageCore, data: ^u8, size: c.size_t) -> Result ---
}

