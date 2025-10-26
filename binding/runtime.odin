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


//! Blend2D runtime limits.
//!
//! \note These constants are used across Blend2D, but they are not designed to be ABI stable. New versions of Blend2D
//! can increase certain limits without notice. Use runtime to query the limits dynamically, see \ref BLRuntimeBuildInfo.
RuntimeLimits :: enum u32 {
	//! Maximum width and height of an image.
	IMAGE_SIZE   = 65535,

	//! Maximum number of threads for asynchronous operations (including rendering).
	THREAD_COUNT = 32,
}

//! Type of runtime information that can be queried through \ref bl_runtime_query_info().
RuntimeInfoType :: enum u32 {
	//! Blend2D build information.
	BUILD      = 0,

	//! System information (includes CPU architecture, features, core count, etc...).
	SYSTEM     = 1,

	//! Resources information (includes Blend2D memory consumption)
	RESOURCE   = 2,

	//! Count of runtime information types.
	MAX_VALUE  = 2,
	FORCE_UINT = 4294967295,
}

//! Blend2D runtime build type.
RuntimeBuildType :: enum u32 {
	//! Describes a Blend2D debug build.
	DEBUG      = 0,

	//! Describes a Blend2D release build.
	RELEASE    = 1,
	FORCE_UINT = 4294967295,
}

//! CPU architecture that can be queried by `BLRuntime::query_system_info()`.
RuntimeCpuArch :: enum u32 {
	//! Unknown architecture.
	UNKNOWN    = 0,

	//! 32-bit or 64-bit X86 architecture.
	X86        = 1,

	//! 32-bit or 64-bit ARM architecture.
	ARM        = 2,

	//! 32-bit or 64-bit MIPS architecture.
	MIPS       = 3,
	FORCE_UINT = 4294967295,
}

//! CPU features Blend2D supports.
RuntimeCpuFeatures :: enum u32 {
	X86_SSE2   = 1,
	X86_SSE3   = 2,
	X86_SSSE3  = 4,
	X86_SSE4_1 = 8,
	X86_SSE4_2 = 16,
	X86_AVX    = 32,
	X86_AVX2   = 64,
	X86_AVX512 = 128,
	ARM_ASIMD  = 1,
	ARM_CRC32  = 2,
	ARM_PMULL  = 4,
	FORCE_UINT = 4294967295,
}

//! Runtime cleanup flags that can be used through `BLRuntime::cleanup()`.
RuntimeCleanupFlags :: enum u32 {
	//! No flags.
	NO_FLAGS        = 0,

	//! Cleanup object memory pool.
	OBJECT_POOL     = 1,

	//! Cleanup zeroed memory pool.
	ZEROED_POOL     = 2,

	//! Cleanup thread pool (would join unused threads).
	THREAD_POOL     = 16,

	//! Cleanup everything.
	EVERYTHING      = 4294967295,
	FLAG_FORCE_UINT = 4294967295,
}

//! Blend2D build information.
RuntimeBuildInfo :: struct {
	//! Major version number.
	major_version: u32,

	//! Minor version number.
	minor_version: u32,

	//! Patch version number.
	patch_version: u32,

	//! Blend2D build type, see \ref BLRuntimeBuildType.
	build_type: u32,

	//! Baseline CPU features, see \ref BLRuntimeCpuFeatures.
	//!
	//! These features describe CPU features that were detected at compile-time. Baseline features are used to compile
	//! all source files so they represent the minimum feature-set the target CPU must support to run Blend2D.
	//!
	//! Official Blend2D builds set baseline at SSE2 on X86 target and NEON on ARM target. Custom builds can set use
	//! a different baseline, which can be read through `BLRuntimeBuildInfo`.
	baseline_cpu_features: u32,

	//! Supported CPU features, see \ref BLRuntimeCpuFeatures.
	//!
	//! These features do not represent the features that the host CPU must support, instead, they represent all features
	//! that Blend2D can take advantage of in C++ code that uses instruction intrinsics. For example if AVX2 is part of
	//! `supported_cpu_features` it means that Blend2D can take advantage of it if there is a specialized code-path.
	supported_cpu_features: u32,

	//! Maximum size of an image (both width and height).
	max_image_size: u32,

	//! Maximum number of threads for asynchronous operations, including rendering.
	max_thread_count: u32,

	//! Reserved, must be zero.
	reserved: [2]u32,

	//! Identification of the C++ compiler used to build Blend2D.
	compiler_info: [32]i8,
}

//! System information queried by the runtime.
RuntimeSystemInfo :: struct {
	//! Host CPU architecture, see \ref BLRuntimeCpuArch.
	cpu_arch: u32,

	//! Host CPU features, see \ref BLRuntimeCpuFeatures.
	cpu_features: u32,

	//! Number of cores of the host CPU/CPUs.
	core_count: u32,

	//! Number of threads of the host CPU/CPUs.
	thread_count: u32,

	//! Minimum stack size of a worker thread used by Blend2D.
	thread_stack_size: u32,

	//! Removed field.
	removed: u32,

	//! Allocation granularity of virtual memory (includes thread's stack).
	allocation_granularity: u32,

	//! Reserved for future use.
	reserved: [5]u32,

	//! Host CPU vendor string such "AMD", "APPLE", "INTEL", "SAMSUNG", etc...
	cpu_vendor: [16]i8,

	//! Host CPU brand string or empty string if not detected properly.
	cpu_brand: [64]i8,
}

//! Provides information about resources allocated by Blend2D.
RuntimeResourceInfo :: struct {
	//! Virtual memory used at this time.
	vm_used: c.size_t,

	//! Virtual memory reserved (allocated internally).
	vm_reserved: c.size_t,

	//! Overhead required to manage virtual memory allocations.
	vm_overhead: c.size_t,

	//! Number of blocks of virtual memory allocated.
	vm_block_count: c.size_t,

	//! Zeroed memory used at this time.
	zm_used: c.size_t,

	//! Zeroed memory reserved (allocated internally).
	zm_reserved: c.size_t,

	//! Overhead required to manage zeroed memory allocations.
	zm_overhead: c.size_t,

	//! Number of blocks of zeroed memory allocated.
	zm_block_count: c.size_t,

	//! Count of dynamic pipelines created and cached.
	dynamic_pipeline_count: c.size_t,

	//! Reserved for future use.
	reserved: [7]c.size_t,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! Initialized Blend2D runtime
	runtime_init :: proc() -> Result ---

	//! Shuts down Blend2D runtime
	runtime_shutdown        :: proc() -> Result ---
	runtime_cleanup         :: proc(cleanup_flags: RuntimeCleanupFlags) -> Result ---
	runtime_query_info      :: proc(info_type: RuntimeInfoType, info_out: rawptr) -> Result ---
	runtime_message_out     :: proc(msg: cstring) -> Result ---
	runtime_message_fmt     :: proc(fmt: cstring, #c_vararg _: ..any) -> Result ---
	runtime_message_vfmt    :: proc(fmt: cstring, ap: i32) -> Result ---
	result_from_posix_error :: proc(e: i32) -> Result ---
}

