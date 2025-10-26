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


//! \name BLBitSet - Constants
//! \{
BitSetConstants :: enum u32 {
	//! Invalid bit-index.
	//!
	//! This is the only index that cannot be stored in `BLBitSet`.
	INVALID_INDEX      = 4294967295,

	//! Range mask used by `BLBitsetSegment::start` value - if set the segment is a range of all ones.
	RANGE_MASK         = 2147483648,

	//! Number of words in a BLBitSetSegment.
	SEGMENT_WORD_COUNT = 4,
}

//! BitSet segment.
//!
//! Segment provides either a dense set of bits starting at `start` or a range of bits all set to one. The start of
//! the segment is always aligned to segment size, which can be calculated as `32 * BL_BIT_SET_SEGMENT_WORD_COUNT`.
//! Even ranges are aligned to this value, thus up to 3 segments are used to describe a range that doesn't start/end
//! at the segment boundary.
//!
//! When the segment describes dense bits its size is always fixed and represents `32 * BL_BIT_SET_SEGMENT_WORD_COUNT`
//! bits, which is currently 128 bits. However, when the segment describes all ones, the first value in data `data[0]`
//! describes the last bit of the range, which means that an arbitrary range can be encoded within a single segment.
BitSetSegment :: struct {
	_start_word: u32,
	_data:       [4]u32,
}

//! BitSet data view.
BitSetData :: struct {
	segment_data:  ^BitSetSegment,
	segment_count: u32,
	sso_segments:  [3]BitSetSegment,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \name BLBitSet - C API
	//! \{
	bit_set_init                     :: proc(self: ^BitSetCore) -> Result ---
	bit_set_init_move                :: proc(self: ^BitSetCore, other: ^BitSetCore) -> Result ---
	bit_set_init_weak                :: proc(self: ^BitSetCore, other: ^BitSetCore) -> Result ---
	bit_set_init_range               :: proc(self: ^BitSetCore, start_bit: u32, end_bit: u32) -> Result ---
	bit_set_destroy                  :: proc(self: ^BitSetCore) -> Result ---
	bit_set_reset                    :: proc(self: ^BitSetCore) -> Result ---
	bit_set_assign_move              :: proc(self: ^BitSetCore, other: ^BitSetCore) -> Result ---
	bit_set_assign_weak              :: proc(self: ^BitSetCore, other: ^BitSetCore) -> Result ---
	bit_set_assign_deep              :: proc(self: ^BitSetCore, other: ^BitSetCore) -> Result ---
	bit_set_assign_range             :: proc(self: ^BitSetCore, start_bit: u32, end_bit: u32) -> Result ---
	bit_set_assign_words             :: proc(self: ^BitSetCore, start_word: u32, word_data: ^u32, word_count: u32) -> Result ---
	bit_set_is_empty                 :: proc(self: ^BitSetCore) -> i32 ---
	bit_set_get_data                 :: proc(self: ^BitSetCore, out: ^BitSetData) -> Result ---
	bit_set_get_segment_count        :: proc(self: ^BitSetCore) -> u32 ---
	bit_set_get_segment_capacity     :: proc(self: ^BitSetCore) -> u32 ---
	bit_set_get_cardinality          :: proc(self: ^BitSetCore) -> u32 ---
	bit_set_get_cardinality_in_range :: proc(self: ^BitSetCore, start_bit: u32, end_bit: u32) -> u32 ---
	bit_set_has_bit                  :: proc(self: ^BitSetCore, bit_index: u32) -> i32 ---
	bit_set_has_bits_in_range        :: proc(self: ^BitSetCore, start_bit: u32, end_bit: u32) -> i32 ---
	bit_set_subsumes                 :: proc(a: ^BitSetCore, b: ^BitSetCore) -> i32 ---
	bit_set_intersects               :: proc(a: ^BitSetCore, b: ^BitSetCore) -> i32 ---
	bit_set_get_range                :: proc(self: ^BitSetCore, start_out: ^u32, end_out: ^u32) -> i32 ---
	bit_set_equals                   :: proc(a: ^BitSetCore, b: ^BitSetCore) -> i32 ---
	bit_set_compare                  :: proc(a: ^BitSetCore, b: ^BitSetCore) -> i32 ---
	bit_set_clear                    :: proc(self: ^BitSetCore) -> Result ---
	bit_set_shrink                   :: proc(self: ^BitSetCore) -> Result ---
	bit_set_optimize                 :: proc(self: ^BitSetCore) -> Result ---
	bit_set_chop                     :: proc(self: ^BitSetCore, start_bit: u32, end_bit: u32) -> Result ---
	bit_set_add_bit                  :: proc(self: ^BitSetCore, bit_index: u32) -> Result ---
	bit_set_add_range                :: proc(self: ^BitSetCore, range_start_bit: u32, range_end_bit: u32) -> Result ---
	bit_set_add_words                :: proc(self: ^BitSetCore, start_word: u32, word_data: ^u32, word_count: u32) -> Result ---
	bit_set_clear_bit                :: proc(self: ^BitSetCore, bit_index: u32) -> Result ---
	bit_set_clear_range              :: proc(self: ^BitSetCore, range_start_bit: u32, range_end_bit: u32) -> Result ---

	// TODO: Future API (BitSet).
	/*
	BL_API BLResult BL_CDECL bl_bit_set_combine(BLBitSetCore* dst, const BLBitSetCore* a, const BLBitSetCore* b, BLBooleanOp boolean_op) BL_NOEXCEPT_C;
	*/
	bit_set_builder_commit    :: proc(self: ^BitSetCore, builder: ^BitSetBuilderCore, new_area_index: u32) -> Result ---
	bit_set_builder_add_range :: proc(self: ^BitSetCore, builder: ^BitSetBuilderCore, start_bit: u32, end_bit: u32) -> Result ---
}

//! BitSet container [C API].
BitSetCore :: struct {
	_d: ObjectDetail,
}

//! BitSet builder [C API].
BitSetBuilderCore :: struct {
	//! Shift to get `_area_index` from bit index, equals to `log2(kBitCount)`.
	_area_shift: u32,

	//! Area index - index from 0...N where each index represents `kBitCount` bits.
	_area_index: u32,
}

//! BitSet container [Impl].
BitSetImpl :: struct {
	//! Count of used segments in `segment_data`.
	segment_count: u32,

	//! Count of allocated segments in `segment_data`.
	segment_capacity: u32,
}

