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


//! BitArray container [C API].
BitArrayCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! BitArray container [C API Impl].
BitArrayImpl :: struct {
	//! Size in bit units.
	size: u32,

	//! Capacity in bit-word units.
	capacity: u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	bit_array_init                     :: proc(self: ^BitArrayCore) -> Result ---
	bit_array_init_move                :: proc(self: ^BitArrayCore, other: ^BitArrayCore) -> Result ---
	bit_array_init_weak                :: proc(self: ^BitArrayCore, other: ^BitArrayCore) -> Result ---
	bit_array_destroy                  :: proc(self: ^BitArrayCore) -> Result ---
	bit_array_reset                    :: proc(self: ^BitArrayCore) -> Result ---
	bit_array_assign_move              :: proc(self: ^BitArrayCore, other: ^BitArrayCore) -> Result ---
	bit_array_assign_weak              :: proc(self: ^BitArrayCore, other: ^BitArrayCore) -> Result ---
	bit_array_assign_words             :: proc(self: ^BitArrayCore, word_data: ^u32, word_count: u32) -> Result ---
	bit_array_is_empty                 :: proc(self: ^BitArrayCore) -> i32 ---
	bit_array_get_size                 :: proc(self: ^BitArrayCore) -> u32 ---
	bit_array_get_word_count           :: proc(self: ^BitArrayCore) -> u32 ---
	bit_array_get_capacity             :: proc(self: ^BitArrayCore) -> u32 ---
	bit_array_get_data                 :: proc(self: ^BitArrayCore) -> ^u32 ---
	bit_array_get_cardinality          :: proc(self: ^BitArrayCore) -> u32 ---
	bit_array_get_cardinality_in_range :: proc(self: ^BitArrayCore, start_bit: u32, end_bit: u32) -> u32 ---
	bit_array_has_bit                  :: proc(self: ^BitArrayCore, bit_index: u32) -> i32 ---
	bit_array_has_bits_in_range        :: proc(self: ^BitArrayCore, start_bit: u32, end_bit: u32) -> i32 ---
	bit_array_subsumes                 :: proc(a: ^BitArrayCore, b: ^BitArrayCore) -> i32 ---
	bit_array_intersects               :: proc(a: ^BitArrayCore, b: ^BitArrayCore) -> i32 ---
	bit_array_get_range                :: proc(self: ^BitArrayCore, start_out: ^u32, end_out: ^u32) -> i32 ---
	bit_array_equals                   :: proc(a: ^BitArrayCore, b: ^BitArrayCore) -> i32 ---
	bit_array_compare                  :: proc(a: ^BitArrayCore, b: ^BitArrayCore) -> i32 ---
	bit_array_clear                    :: proc(self: ^BitArrayCore) -> Result ---
	bit_array_resize                   :: proc(self: ^BitArrayCore, n_bits: u32) -> Result ---
	bit_array_reserve                  :: proc(self: ^BitArrayCore, n_bits: u32) -> Result ---
	bit_array_shrink                   :: proc(self: ^BitArrayCore) -> Result ---
	bit_array_set_bit                  :: proc(self: ^BitArrayCore, bit_index: u32) -> Result ---
	bit_array_fill_range               :: proc(self: ^BitArrayCore, start_bit: u32, end_bit: u32) -> Result ---
	bit_array_fill_words               :: proc(self: ^BitArrayCore, bit_index: u32, word_data: ^u32, word_count: u32) -> Result ---
	bit_array_clear_bit                :: proc(self: ^BitArrayCore, bit_index: u32) -> Result ---
	bit_array_clear_range              :: proc(self: ^BitArrayCore, start_bit: u32, end_bit: u32) -> Result ---
	bit_array_clear_word               :: proc(self: ^BitArrayCore, bit_index: u32, word_value: u32) -> Result ---
	bit_array_clear_words              :: proc(self: ^BitArrayCore, bit_index: u32, word_data: ^u32, word_count: u32) -> Result ---
	bit_array_replace_op               :: proc(self: ^BitArrayCore, n_bits: u32, data_out: ^^u32) -> Result ---
	bit_array_replace_bit              :: proc(self: ^BitArrayCore, bit_index: u32, bit_value: i32) -> Result ---
	bit_array_replace_word             :: proc(self: ^BitArrayCore, bit_index: u32, word_value: u32) -> Result ---
	bit_array_replace_words            :: proc(self: ^BitArrayCore, bit_index: u32, word_data: ^u32, word_count: u32) -> Result ---
	bit_array_append_bit               :: proc(self: ^BitArrayCore, bit_value: i32) -> Result ---
	bit_array_append_word              :: proc(self: ^BitArrayCore, word_value: u32) -> Result ---
	bit_array_append_words             :: proc(self: ^BitArrayCore, word_data: ^u32, word_count: u32) -> Result ---
}

