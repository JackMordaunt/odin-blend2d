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


@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \name BLRandom - C API
	//! \{
	random_reset       :: proc(self: ^Random, seed: u64) -> Result ---
	random_next_uint32 :: proc(self: ^Random) -> u32 ---
	random_next_uint64 :: proc(self: ^Random) -> u64 ---
	random_next_double :: proc(self: ^Random) -> f64 ---
}

//! Simple pseudo random number generator based on `XORSHIFT+`, which has 64-bit seed, 128 bits of state, and full
//! period `2^128 - 1`.
//!
//! Based on a paper by Sebastiano Vigna:
//!   http://vigna.di.unimi.it/ftp/papers/xorshiftplus.pdf
Random :: struct {
	//! PRNG state.
	data: [2]u64,
}

