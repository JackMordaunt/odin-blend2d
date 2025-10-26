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


//! Rendering context type.
ContextType :: enum u32 {
	//! No rendering context.
	NONE       = 0,

	//! Dummy rendering context.
	DUMMY      = 1,

	/*
	//! Proxy rendering context.
	BL_CONTEXT_TYPE_PROXY = 2,
	*/
	
	//! Software-accelerated rendering context.
	RASTER     = 3,

	//! Maximum value of `BLContextType`.
	MAX_VALUE  = 3,
	FORCE_UINT = 4294967295,
}

//! Rendering context hint.
ContextHint :: enum u32 {
	//! Rendering quality.
	RENDERING_QUALITY = 0,

	//! Gradient quality.
	GRADIENT_QUALITY  = 1,

	//! Pattern quality.
	PATTERN_QUALITY   = 2,

	//! Maximum value of `BLContextHint`.
	MAX_VALUE         = 7,
	FORCE_UINT        = 4294967295,
}

//! Describes a rendering context style slot - fill or stroke.
ContextStyleSlot :: enum u32 {
	//! Fill operation style slot.
	FILL       = 0,

	//! Stroke operation style slot.
	STROKE     = 1,

	//! Maximum value of `BLContextStyleSlot`
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! The type of a text rendering operation.
//!
//! This value specifies the type of the parameter passed to the text rendering API.
//!
//! \note In most cases this should not be required to use by Blend2D users. The C API provides functions that
//! wrap all of the text operations and C++ API provides functions that use `BLContextRenderTextOp` internally.
ContextRenderTextOp :: enum u32 {
	//! UTF-8 text rendering operation - UTF-8 string passed as \ref BLStringView or \ref BLArrayView<uint8_t>.
	UTF8            = 0,

	//! UTF-16 text rendering operation - UTF-16 string passed as \ref BLArrayView<uint16_t>.
	UTF16           = 1,

	//! UTF-32 text rendering operation - UTF-32 string passed as \ref BLArrayView<uint32_t>.
	UTF32           = 2,

	//! LATIN1 text rendering operation - LATIN1 string is passed as \ref BLStringView or \ref BLArrayView<uint8_t>.
	LATIN1          = 3,

	//! `wchar_t` text rendering operation - wchar_t string is passed as \ref BLArrayView<wchar_t>.
	WCHAR           = 2,

	//! Glyph run text rendering operation - the \ref BLGlyphRun parameter is passed.
	GLYPH_RUN       = 4,

	//! Maximum value of `BLContextRenderTextInputType`
	MAX_VALUE       = 4,
	TYPE_FORCE_UINT = 4294967295,
}

//! Rendering context flush flags, used by \ref BLContext::flush().
ContextFlushFlags :: enum u32 {
	NO_FLAGS   = 0,

	//! Flushes the command queue and waits for its completion (will block until done).
	SYNC       = 2147483648,
	FORCE_UINT = 4294967295,
}

//! Rendering context creation flags.
ContextCreateFlags :: enum u32 {
	//! No flags.
	NO_FLAGS                   = 0,

	//! Disables JIT pipeline generator.
	FLAG_DISABLE_JIT           = 1,

	//! Fallbacks to a synchronous rendering in case that the rendering engine wasn't able to acquire threads. This
	//! flag only makes sense when the asynchronous mode was specified by having `thread_count` greater than 0. If the
	//! rendering context fails to acquire at least one thread it would fallback to synchronous mode with no worker
	//! threads.
	//!
	//! \note If this flag is specified with `thread_count == 1` it means to immediately fallback to synchronous
	//! rendering. It's only practical to use this flag with 2 or more requested threads.
	FLAG_FALLBACK_TO_SYNC      = 1048576,

	//! If this flag is specified and asynchronous rendering is enabled then the context would create its own isolated
	//! thread-pool, which is useful for debugging purposes.
	//!
	//! Do not use this flag in production as rendering contexts with isolated thread-pool have to create and destroy all
	//! threads they use. This flag is only useful for testing, debugging, and isolated benchmarking.
	FLAG_ISOLATED_THREAD_POOL  = 16777216,

	//! If this flag is specified and JIT pipeline generation enabled then the rendering context would create its own
	//! isolated JIT runtime. which is useful for debugging purposes. This flag will be ignored if JIT pipeline
	//! compilation is either not supported or was disabled by other flags.
	//!
	//! Do not use this flag in production as rendering contexts with isolated JIT runtime do not use global pipeline
	//! cache, that's it, after the rendering context is destroyed the JIT runtime is destroyed with it with all
	//! compiled pipelines. This flag is only useful for testing, debugging, and isolated benchmarking.
	FLAG_ISOLATED_JIT_RUNTIME  = 33554432,

	//! Enables logging to stderr of isolated runtime.
	//!
	//! \note Must be used with \ref BL_CONTEXT_CREATE_FLAG_ISOLATED_JIT_RUNTIME otherwise it would have no effect.
	FLAG_ISOLATED_JIT_LOGGING  = 67108864,

	//! Override CPU features when creating isolated context.
	FLAG_OVERRIDE_CPU_FEATURES = 134217728,
	FLAG_FORCE_UINT            = 4294967295,
}

//! Error flags that are accumulated during the rendering context lifetime and that can be queried through
//! \ref BLContext::accumulated_error_flags(). The reason why these flags exist is that errors can happen during
//! asynchronous rendering, and there is no way the user can catch these errors.
ContextErrorFlags :: enum u32 {
	//! No flags.
	NO_FLAGS                   = 0,

	//! The rendering context returned or encountered \ref BL_ERROR_INVALID_VALUE, which is mostly related to
	//! the function argument handling. It's very likely some argument was wrong when calling \ref BLContext API.
	FLAG_INVALID_VALUE         = 1,

	//! Invalid state describes something wrong, for example a pipeline compilation error.
	FLAG_INVALID_STATE         = 2,

	//! The rendering context has encountered invalid geometry.
	FLAG_INVALID_GEOMETRY      = 4,

	//! The rendering context has encountered invalid glyph.
	FLAG_INVALID_GLYPH         = 8,

	//! The rendering context has encountered invalid or uninitialized font.
	FLAG_INVALID_FONT          = 16,

	//! Thread pool was exhausted and couldn't acquire the requested number of threads.
	FLAG_THREAD_POOL_EXHAUSTED = 536870912,

	//! Out of memory condition.
	FLAG_OUT_OF_MEMORY         = 1073741824,

	//! Unknown error, which we don't have flag for.
	FLAG_UNKNOWN_ERROR         = 2147483648,
	FLAG_FORCE_UINT            = 4294967295,
}

//! Specifies the behavior of \ref BLContext::swap_styles() operation.
ContextStyleSwapMode :: enum u32 {
	//! Swap only fill and stroke styles without affecting fill and stroke alpha.
	STYLES            = 0,

	//! Swap both fill and stroke styles and their alpha values.
	STYLES_WITH_ALPHA = 1,

	//! Maximum value of `BLContextStyleSwapMode`.
	MAX_VALUE         = 1,
	FORCE_UINT        = 4294967295,
}

//! Specifies how style transformation matrix is combined with the rendering context transformation matrix, used by
//! \ref BLContext::set_style() function.
ContextStyleTransformMode :: enum u32 {
	//! Style transformation matrix should be transformed with the rendering context user and meta matrix (default).
	//!
	//! \note This transformation mode is identical to how user geometry is transformed and it's the default
	//! transformation and most likely the behavior expected in most cases.
	USER       = 0,

	//! Style transformation matrix should be transformed with the rendering context meta matrix.
	META       = 1,

	//! Style transformation matrix is considered absolute, and is not combined with a rendering context transform.
	NONE       = 2,

	//! Maximum value of `BLContextStyleTransformMode`.
	MAX_VALUE  = 2,
	FORCE_UINT = 4294967295,
}

//! Clip mode.
ClipMode :: enum u32 {
	//! Clipping to a rectangle that is aligned to the pixel grid.
	ALIGNED_RECT   = 0,

	//! Clipping to a rectangle that is not aligned to pixel grid.
	UNALIGNED_RECT = 1,

	//! Clipping to a non-rectangular area that is defined by using mask.
	MASK           = 2,

	//! Count of clip modes.
	COUNT          = 3,
	FORCE_UINT     = 4294967295,
}

//! Composition & blending operator.
CompOp :: enum u32 {
	//! Source-over [default].
	SRC_OVER     = 0,

	//! Source-copy.
	SRC_COPY     = 1,

	//! Source-in.
	SRC_IN       = 2,

	//! Source-out.
	SRC_OUT      = 3,

	//! Source-atop.
	SRC_ATOP     = 4,

	//! Destination-over.
	DST_OVER     = 5,

	//! Destination-copy [nop].
	DST_COPY     = 6,

	//! Destination-in.
	DST_IN       = 7,

	//! Destination-out.
	DST_OUT      = 8,

	//! Destination-atop.
	DST_ATOP     = 9,

	//! Xor.
	XOR          = 10,

	//! Clear.
	CLEAR        = 11,

	//! Plus.
	PLUS         = 12,

	//! Minus.
	MINUS        = 13,

	//! Modulate.
	MODULATE     = 14,

	//! Multiply.
	MULTIPLY     = 15,

	//! Screen.
	SCREEN       = 16,

	//! Overlay.
	OVERLAY      = 17,

	//! Darken.
	DARKEN       = 18,

	//! Lighten.
	LIGHTEN      = 19,

	//! Color dodge.
	COLOR_DODGE  = 20,

	//! Color burn.
	COLOR_BURN   = 21,

	//! Linear burn.
	LINEAR_BURN  = 22,

	//! Linear light.
	LINEAR_LIGHT = 23,

	//! Pin light.
	PIN_LIGHT    = 24,

	//! Hard-light.
	HARD_LIGHT   = 25,

	//! Soft-light.
	SOFT_LIGHT   = 26,

	//! Difference.
	DIFFERENCE   = 27,

	//! Exclusion.
	EXCLUSION    = 28,

	//! Count of composition & blending operators.
	MAX_VALUE    = 28,
	FORCE_UINT   = 4294967295,
}

//! Rendering quality.
RenderingQuality :: enum u32 {
	//! Render using anti-aliasing.
	ANTIALIAS  = 0,

	//! Maximum value of `BLRenderingQuality`.
	MAX_VALUE  = 0,
	FORCE_UINT = 4294967295,
}

//! Information that can be used to customize the rendering context.
ContextCreateInfo :: struct {
	//! Create flags, see \ref BLContextCreateFlags.
	flags: u32,

	//! Number of worker threads to use for asynchronous rendering, if non-zero.
	//!
	//! If `thread_count` is zero it means to initialize the context for synchronous rendering. This means that every
	//! operation will take effect immediately. If `thread_count` is `1` it means that the rendering will be asynchronous,
	//! but no thread would be acquired from a thread-pool, because the user thread will be used as a worker. And
	//! finally, if `thread_count` is greater than `1` then total of `thread_count - 1` threads will be acquired from
	//! thread-pool and used as additional workers.
	thread_count: u32,

	//! CPU features to use in isolated JIT runtime (if supported), only used when `flags` contains
	//! \ref BL_CONTEXT_CREATE_FLAG_OVERRIDE_CPU_FEATURES.
	cpu_features: u32,

	//! Maximum number of commands to be queued.
	//!
	//! If this parameter is zero the queue size will be determined automatically.
	//!
	//! TODO: To be documented, has no effect at the moment.
	command_queue_limit: u32,

	//! Maximum number of saved states.
	//!
	//! \note Zero value tells the rendering engine to use the default saved state limit, which currently defaults
	//! to 4096 states. This option allows to even increase or decrease the limit, depending on the use case.
	saved_state_limit: u32,

	//! Pixel origin.
	//!
	//! Pixel origin is an offset in pixel units that can be used as an origin for fetchers and effects that use a pixel
	//! X/Y coordinate in the calculation. One example of using pixel origin is dithering, where it's used to shift the
	//! dithering matrix.
	pixel_origin: PointI,

	//! Reserved for future use, must be zero.
	reserved: [1]u32,
}

//! Holds an arbitrary 128-bit value (cookie) that can be used to match other cookies. Blend2D uses cookies in places
//! where it allows to "lock" some state that can only be unlocked by a matching cookie. Please don't confuse cookies
//! with a security of any kind, it's just an arbitrary data that must match to proceed with a certain operation.
//!
//! Cookies can be used with \ref BLContext::save() and \ref BLContext::restore() operations.
ContextCookie :: struct {
	data: [2]u64,
}

//! Rendering context hints.
ContextHints :: struct {
	using _: struct #raw_union {
		using _: struct {
			rendering_quality: u8,
			gradient_quality:  u8,
			pattern_quality:   u8,
		},

		hints: [8]u8,
	},
}

//! Rendering context [C API].
ContextCore :: struct {
	_d: ObjectDetail,
}

//! \cond INTERNAL
//! Rendering context [Virtual Function Table].
ContextVirt :: struct {
	base: ObjectVirtBase,

	// Interface - Most Used Functions
	// -------------------------------
	
	// NOTE 1: These functions are called directly by the BLContext C++ API (the dispatch is inlined). So in general
	// on x86 targets the compiler will generate something like `call [base + offset]` instruction to perform the call.
	// We want to have the most used functions first as these would use 8-bit offset instead of 32-bit offset. We have
	// space for 12 functions as 8-bit offset is signed (from -128 to 127) and the BLObjectVirt already uses 3 functions.
	//
	// NOTE 2: On non-X86 platforms such as AArch64 we don't have to worry about offsets as the instruction would be
	// encoded in 32-bits regardless of the offset.
	apply_transform_op:  proc "c" (impl: ^ContextImpl, op_type: TransformOp, op_data: rawptr) -> Result,
	fill_rect_i:         proc "c" (impl: ^ContextImpl, rect: ^RectI) -> Result,
	fill_rect_i_rgba32:  proc "c" (impl: ^ContextImpl, rect: ^RectI, rgba32: u32) -> Result,
	fill_rect_i_ext:     proc "c" (impl: ^ContextImpl, rect: ^RectI, style: ^ObjectCore) -> Result,
	fill_rect_d:         proc "c" (impl: ^ContextImpl, rect: ^Rect) -> Result,
	fill_rect_d_rgba32:  proc "c" (impl: ^ContextImpl, rect: ^Rect, rgba32: u32) -> Result,
	fill_rect_d_ext:     proc "c" (impl: ^ContextImpl, rect: ^Rect, style: ^ObjectCore) -> Result,
	fill_path_d:         proc "c" (impl: ^ContextImpl, origin: ^Point, path: ^PathCore) -> Result,
	fill_path_d_rgba32:  proc "c" (impl: ^ContextImpl, origin: ^Point, path: ^PathCore, rgba32: u32) -> Result,
	fill_path_d_ext:     proc "c" (impl: ^ContextImpl, origin: ^Point, path: ^PathCore, style: ^ObjectCore) -> Result,
	blit_image_i:        proc "c" (impl: ^ContextImpl, origin: ^PointI, img: ^ImageCore, img_area: ^RectI) -> Result,
	blit_scaled_image_i: proc "c" (impl: ^ContextImpl, rect: ^RectI, img: ^ImageCore, img_area: ^RectI) -> Result,

	// Interface
	// ---------
	flush:                      proc "c" (impl: ^ContextImpl, flags: ContextFlushFlags) -> Result,
	save:                       proc "c" (impl: ^ContextImpl, cookie: ^ContextCookie) -> Result,
	restore:                    proc "c" (impl: ^ContextImpl, cookie: ^ContextCookie) -> Result,
	user_to_meta:               proc "c" (impl: ^ContextImpl) -> Result,
	set_hint:                   proc "c" (impl: ^ContextImpl, hint_type: ContextHint, value: u32) -> Result,
	set_hints:                  proc "c" (impl: ^ContextImpl, hints: ^ContextHints) -> Result,
	set_flatten_mode:           proc "c" (impl: ^ContextImpl, mode: FlattenMode) -> Result,
	set_flatten_tolerance:      proc "c" (impl: ^ContextImpl, tolerance: f64) -> Result,
	set_approximation_options:  proc "c" (impl: ^ContextImpl, options: ^ApproximationOptions) -> Result,
	get_style:                  proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot, transformed: i32, style_out: ^VarCore) -> Result,
	set_style:                  proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot, style: ^ObjectCore, transform_mode: ContextStyleTransformMode) -> Result,
	set_style_rgba:             proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot, rgba: ^Rgba) -> Result,
	set_style_rgba32:           proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot, rgba32: u32) -> Result,
	set_style_rgba64:           proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot, rgba64: u64) -> Result,
	disable_style:              proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot) -> Result,
	set_style_alpha:            proc "c" (impl: ^ContextImpl, slot: ContextStyleSlot, alpha: f64) -> Result,
	swap_styles:                proc "c" (impl: ^ContextImpl, mode: ContextStyleSwapMode) -> Result,
	set_global_alpha:           proc "c" (impl: ^ContextImpl, alpha: f64) -> Result,
	set_comp_op:                proc "c" (impl: ^ContextImpl, comp_op: CompOp) -> Result,
	set_fill_rule:              proc "c" (impl: ^ContextImpl, fill_rule: FillRule) -> Result,
	set_stroke_width:           proc "c" (impl: ^ContextImpl, width: f64) -> Result,
	set_stroke_miter_limit:     proc "c" (impl: ^ContextImpl, miter_limit: f64) -> Result,
	set_stroke_cap:             proc "c" (impl: ^ContextImpl, position: StrokeCapPosition, stroke_cap: StrokeCap) -> Result,
	set_stroke_caps:            proc "c" (impl: ^ContextImpl, stroke_cap: StrokeCap) -> Result,
	set_stroke_join:            proc "c" (impl: ^ContextImpl, stroke_join: StrokeJoin) -> Result,
	set_stroke_dash_offset:     proc "c" (impl: ^ContextImpl, dash_offset: f64) -> Result,
	set_stroke_dash_array:      proc "c" (impl: ^ContextImpl, dash_array: ^ArrayCore) -> Result,
	set_stroke_transform_order: proc "c" (impl: ^ContextImpl, transform_order: StrokeTransformOrder) -> Result,
	set_stroke_options:         proc "c" (impl: ^ContextImpl, options: ^StrokeOptionsCore) -> Result,
	clip_to_rect_i:             proc "c" (impl: ^ContextImpl, rect: ^RectI) -> Result,
	clip_to_rect_d:             proc "c" (impl: ^ContextImpl, rect: ^Rect) -> Result,
	restore_clipping:           proc "c" (impl: ^ContextImpl) -> Result,
	clear_all:                  proc "c" (impl: ^ContextImpl) -> Result,
	clear_recti:                proc "c" (impl: ^ContextImpl, rect: ^RectI) -> Result,
	clear_rectd:                proc "c" (impl: ^ContextImpl, rect: ^Rect) -> Result,
	fill_all:                   proc "c" (impl: ^ContextImpl) -> Result,
	fill_all_rgba32:            proc "c" (impl: ^ContextImpl, rgba32: u32) -> Result,
	fill_all_ext:               proc "c" (impl: ^ContextImpl, style: ^ObjectCore) -> Result,
	fill_geometry:              proc "c" (impl: ^ContextImpl, type: GeometryType, data: rawptr) -> Result,
	fill_geometry_rgba32:       proc "c" (impl: ^ContextImpl, type: GeometryType, data: rawptr, rgba32: u32) -> Result,
	fill_geometry_ext:          proc "c" (impl: ^ContextImpl, type: GeometryType, data: rawptr, style: ^ObjectCore) -> Result,
	fill_text_op_i:             proc "c" (self: ^ContextImpl, origin: ^PointI, font: ^FontCore, op: ContextRenderTextOp, data: rawptr) -> Result,
	fill_text_op_i_rgba32:      proc "c" (self: ^ContextImpl, origin: ^PointI, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, rgba32: u32) -> Result,
	fill_text_op_i_ext:         proc "c" (self: ^ContextImpl, origin: ^PointI, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, style: ^ObjectCore) -> Result,
	fill_text_op_d:             proc "c" (self: ^ContextImpl, origin: ^Point, font: ^FontCore, op: ContextRenderTextOp, data: rawptr) -> Result,
	fill_text_op_d_rgba32:      proc "c" (self: ^ContextImpl, origin: ^Point, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, rgba32: u32) -> Result,
	fill_text_op_d_ext:         proc "c" (self: ^ContextImpl, origin: ^Point, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, style: ^ObjectCore) -> Result,
	fill_mask_i:                proc "c" (impl: ^ContextImpl, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI) -> Result,
	fill_mask_i_rgba32:         proc "c" (impl: ^ContextImpl, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI, rgba32: u32) -> Result,
	fill_mask_i_ext:            proc "c" (impl: ^ContextImpl, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI, style: ^ObjectCore) -> Result,
	fill_mask_d:                proc "c" (impl: ^ContextImpl, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI) -> Result,
	fill_mask_d_Rgba32:         proc "c" (impl: ^ContextImpl, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI, rgba32: u32) -> Result,
	fill_mask_d_ext:            proc "c" (impl: ^ContextImpl, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI, style: ^ObjectCore) -> Result,
	stroke_path_d:              proc "c" (impl: ^ContextImpl, origin: ^Point, path: ^PathCore) -> Result,
	stroke_path_d_rgba32:       proc "c" (impl: ^ContextImpl, origin: ^Point, path: ^PathCore, rgba32: u32) -> Result,
	stroke_path_d_ext:          proc "c" (impl: ^ContextImpl, origin: ^Point, path: ^PathCore, style: ^ObjectCore) -> Result,
	stroke_geometry:            proc "c" (impl: ^ContextImpl, type: GeometryType, data: rawptr) -> Result,
	stroke_geometry_rgba32:     proc "c" (impl: ^ContextImpl, type: GeometryType, data: rawptr, rgba32: u32) -> Result,
	stroke_geometry_ext:        proc "c" (impl: ^ContextImpl, type: GeometryType, data: rawptr, style: ^ObjectCore) -> Result,
	stroke_text_op_i:           proc "c" (self: ^ContextImpl, origin: ^PointI, font: ^FontCore, op: ContextRenderTextOp, data: rawptr) -> Result,
	stroke_text_op_i_rgba32:    proc "c" (self: ^ContextImpl, origin: ^PointI, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, rgba32: u32) -> Result,
	stroke_text_op_i_ext:       proc "c" (self: ^ContextImpl, origin: ^PointI, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, style: ^ObjectCore) -> Result,
	stroke_text_op_d:           proc "c" (self: ^ContextImpl, origin: ^Point, font: ^FontCore, op: ContextRenderTextOp, data: rawptr) -> Result,
	stroke_text_op_d_rgba32:    proc "c" (self: ^ContextImpl, origin: ^Point, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, rgba32: u32) -> Result,
	stroke_text_op_d_ext:       proc "c" (self: ^ContextImpl, origin: ^Point, font: ^FontCore, op: ContextRenderTextOp, data: rawptr, style: ^ObjectCore) -> Result,
	blit_image_d:               proc "c" (impl: ^ContextImpl, origin: ^Point, img: ^ImageCore, img_area: ^RectI) -> Result,
	blit_scaled_image_d:        proc "c" (impl: ^ContextImpl, rect: ^Rect, img: ^ImageCore, img_area: ^RectI) -> Result,
}

//! Rendering context state.
//!
//! This state is not meant to be created by users, it's only provided for users that want to introspect
//! the rendering context state and for C++ API that accesses it directly for performance reasons.
ContextState :: struct {
	//! Target image or image object with nullptr impl in case that the rendering context doesn't render to an image.
	target_image: ^ImageCore,

	//! Current size of the target in abstract units, pixels if rendering to \ref BLImage.
	target_size: Size,

	//! Current rendering context hints.
	hints: ContextHints,

	//! Current composition operator.
	comp_op: u8,

	//! Current fill rule.
	fill_rule: u8,

	//! Current type of a style object of fill and stroke operations indexed by \ref BLContextStyleSlot.
	style_type: [2]u8,

	//! Count of saved states in the context.
	saved_state_count: u32,

	//! Current global alpha value [0, 1].
	global_alpha: f64,

	//! Current fill or stroke alpha indexed by style slot, see \ref BLContextStyleSlot.
	style_alpha: [2]f64,

	//! Current stroke options.
	stroke_options: StrokeOptionsCore,

	//! Current approximation options.
	approximation_options: ApproximationOptions,

	//! Current meta transformation matrix.
	meta_transform: Matrix2D,

	//! Current user transformation matrix.
	user_transform: Matrix2D,

	//! Current final transformation matrix, which combines all transformation matrices.
	final_transform: Matrix2D,
}

//! Rendering context [C API Impl].
ContextImpl :: struct {
	//! Virtual function table.
	virt: ^ContextVirt,

	//! Current state of the context.
	state: ^ContextState,

	//! Type of the rendering context, see \ref BLContextType.
	context_type: u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \endcond
	context_init                         :: proc(self: ^ContextCore) -> Result ---
	context_init_move                    :: proc(self: ^ContextCore, other: ^ContextCore) -> Result ---
	context_init_weak                    :: proc(self: ^ContextCore, other: ^ContextCore) -> Result ---
	context_init_as                      :: proc(self: ^ContextCore, image: ^ImageCore, cci: ^ContextCreateInfo) -> Result ---
	context_destroy                      :: proc(self: ^ContextCore) -> Result ---
	context_reset                        :: proc(self: ^ContextCore) -> Result ---
	context_assign_move                  :: proc(self: ^ContextCore, other: ^ContextCore) -> Result ---
	context_assign_weak                  :: proc(self: ^ContextCore, other: ^ContextCore) -> Result ---
	context_get_type                     :: proc(self: ^ContextCore) -> ContextType ---
	context_get_target_size              :: proc(self: ^ContextCore, target_size_out: ^Size) -> Result ---
	context_get_target_image             :: proc(self: ^ContextCore) -> ^ImageCore ---
	context_begin                        :: proc(self: ^ContextCore, image: ^ImageCore, cci: ^ContextCreateInfo) -> Result ---
	context_end                          :: proc(self: ^ContextCore) -> Result ---
	context_flush                        :: proc(self: ^ContextCore, flags: ContextFlushFlags) -> Result ---
	context_save                         :: proc(self: ^ContextCore, cookie: ^ContextCookie) -> Result ---
	context_restore                      :: proc(self: ^ContextCore, cookie: ^ContextCookie) -> Result ---
	context_get_meta_transform           :: proc(self: ^ContextCore, transform_out: ^Matrix2D) -> Result ---
	context_get_user_transform           :: proc(self: ^ContextCore, transform_out: ^Matrix2D) -> Result ---
	context_get_final_transform          :: proc(self: ^ContextCore, transform_out: ^Matrix2D) -> Result ---
	context_user_to_meta                 :: proc(self: ^ContextCore) -> Result ---
	context_apply_transform_op           :: proc(self: ^ContextCore, op_type: TransformOp, op_data: rawptr) -> Result ---
	context_get_hint                     :: proc(self: ^ContextCore, hint_type: ContextHint) -> u32 ---
	context_set_hint                     :: proc(self: ^ContextCore, hint_type: ContextHint, value: u32) -> Result ---
	context_get_hints                    :: proc(self: ^ContextCore, hints_out: ^ContextHints) -> Result ---
	context_set_hints                    :: proc(self: ^ContextCore, hints: ^ContextHints) -> Result ---
	context_set_flatten_mode             :: proc(self: ^ContextCore, mode: FlattenMode) -> Result ---
	context_set_flatten_tolerance        :: proc(self: ^ContextCore, tolerance: f64) -> Result ---
	context_set_approximation_options    :: proc(self: ^ContextCore, options: ^ApproximationOptions) -> Result ---
	context_get_fill_style               :: proc(self: ^ContextCore, style_out: ^VarCore) -> Result ---
	context_get_transformed_fill_style   :: proc(self: ^ContextCore, style_out: ^VarCore) -> Result ---
	context_set_fill_style               :: proc(self: ^ContextCore, style: ^Unknown) -> Result ---
	context_set_fill_style_with_mode     :: proc(self: ^ContextCore, style: ^Unknown, transform_mode: ContextStyleTransformMode) -> Result ---
	context_set_fill_style_rgba          :: proc(self: ^ContextCore, rgba: ^Rgba) -> Result ---
	context_set_fill_style_rgba32        :: proc(self: ^ContextCore, rgba32: u32) -> Result ---
	context_set_fill_style_rgba64        :: proc(self: ^ContextCore, rgba64: u64) -> Result ---
	context_disable_fill_style           :: proc(self: ^ContextCore) -> Result ---
	context_get_fill_alpha               :: proc(self: ^ContextCore) -> f64 ---
	context_set_fill_alpha               :: proc(self: ^ContextCore, alpha: f64) -> Result ---
	context_get_stroke_style             :: proc(self: ^ContextCore, style_out: ^VarCore) -> Result ---
	context_get_transformed_stroke_style :: proc(self: ^ContextCore, style_out: ^VarCore) -> Result ---
	context_set_stroke_style             :: proc(self: ^ContextCore, style: ^Unknown) -> Result ---
	context_set_stroke_style_with_mode   :: proc(self: ^ContextCore, style: ^Unknown, transform_mode: ContextStyleTransformMode) -> Result ---
	context_set_stroke_style_rgba        :: proc(self: ^ContextCore, rgba: ^Rgba) -> Result ---
	context_set_stroke_style_rgba32      :: proc(self: ^ContextCore, rgba32: u32) -> Result ---
	context_set_stroke_style_rgba64      :: proc(self: ^ContextCore, rgba64: u64) -> Result ---
	context_disable_stroke_style         :: proc(self: ^ContextCore) -> Result ---
	context_get_stroke_alpha             :: proc(self: ^ContextCore) -> f64 ---
	context_set_stroke_alpha             :: proc(self: ^ContextCore, alpha: f64) -> Result ---
	context_swap_styles                  :: proc(self: ^ContextCore, mode: ContextStyleSwapMode) -> Result ---
	context_get_global_alpha             :: proc(self: ^ContextCore) -> f64 ---
	context_set_global_alpha             :: proc(self: ^ContextCore, alpha: f64) -> Result ---
	context_get_comp_op                  :: proc(self: ^ContextCore) -> CompOp ---
	context_set_comp_op                  :: proc(self: ^ContextCore, comp_op: CompOp) -> Result ---
	context_get_fill_rule                :: proc(self: ^ContextCore) -> FillRule ---
	context_set_fill_rule                :: proc(self: ^ContextCore, fill_rule: FillRule) -> Result ---
	context_get_stroke_width             :: proc(self: ^ContextCore) -> f64 ---
	context_set_stroke_width             :: proc(self: ^ContextCore, width: f64) -> Result ---
	context_get_stroke_miter_limit       :: proc(self: ^ContextCore) -> f64 ---
	context_set_stroke_miter_limit       :: proc(self: ^ContextCore, miter_limit: f64) -> Result ---
	context_get_stroke_cap               :: proc(self: ^ContextCore, position: StrokeCapPosition) -> StrokeCap ---
	context_set_stroke_cap               :: proc(self: ^ContextCore, position: StrokeCapPosition, stroke_cap: StrokeCap) -> Result ---
	context_set_stroke_caps              :: proc(self: ^ContextCore, stroke_cap: StrokeCap) -> Result ---
	context_get_stroke_join              :: proc(self: ^ContextCore) -> StrokeJoin ---
	context_set_stroke_join              :: proc(self: ^ContextCore, stroke_join: StrokeJoin) -> Result ---
	context_get_stroke_transform_order   :: proc(self: ^ContextCore) -> StrokeTransformOrder ---
	context_set_stroke_transform_order   :: proc(self: ^ContextCore, transform_order: StrokeTransformOrder) -> Result ---
	context_get_stroke_dash_offset       :: proc(self: ^ContextCore) -> f64 ---
	context_set_stroke_dash_offset       :: proc(self: ^ContextCore, dash_offset: f64) -> Result ---
	context_get_stroke_dash_array        :: proc(self: ^ContextCore, dash_array_out: ^ArrayCore) -> Result ---
	context_set_stroke_dash_array        :: proc(self: ^ContextCore, dash_array: ^ArrayCore) -> Result ---
	context_get_stroke_options           :: proc(self: ^ContextCore, options: ^StrokeOptionsCore) -> Result ---
	context_set_stroke_options           :: proc(self: ^ContextCore, options: ^StrokeOptionsCore) -> Result ---
	context_clip_to_rect_i               :: proc(self: ^ContextCore, rect: ^RectI) -> Result ---
	context_clip_to_rect_d               :: proc(self: ^ContextCore, rect: ^Rect) -> Result ---
	context_restore_clipping             :: proc(self: ^ContextCore) -> Result ---
	context_clear_all                    :: proc(self: ^ContextCore) -> Result ---
	context_clear_rect_i                 :: proc(self: ^ContextCore, rect: ^RectI) -> Result ---
	context_clear_rect_d                 :: proc(self: ^ContextCore, rect: ^Rect) -> Result ---
	context_fill_all                     :: proc(self: ^ContextCore) -> Result ---
	context_fill_all_rgba32              :: proc(self: ^ContextCore, rgba32: u32) -> Result ---
	context_fill_all_rgba64              :: proc(self: ^ContextCore, rgba64: u64) -> Result ---
	context_fill_all_ext                 :: proc(self: ^ContextCore, style: ^Unknown) -> Result ---
	context_fill_rect_i                  :: proc(self: ^ContextCore, rect: ^RectI) -> Result ---
	context_fill_rect_i_rgba32           :: proc(self: ^ContextCore, rect: ^RectI, rgba32: u32) -> Result ---
	context_fill_rect_i_rgba64           :: proc(self: ^ContextCore, rect: ^RectI, rgba64: u64) -> Result ---
	context_fill_rect_i_ext              :: proc(self: ^ContextCore, rect: ^RectI, style: ^Unknown) -> Result ---
	context_fill_rect_d                  :: proc(self: ^ContextCore, rect: ^Rect) -> Result ---
	context_fill_rect_d_rgba32           :: proc(self: ^ContextCore, rect: ^Rect, rgba32: u32) -> Result ---
	context_fill_rect_d_rgba64           :: proc(self: ^ContextCore, rect: ^Rect, rgba64: u64) -> Result ---
	context_fill_rect_d_ext              :: proc(self: ^ContextCore, rect: ^Rect, style: ^Unknown) -> Result ---
	context_fill_path_d                  :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore) -> Result ---
	context_fill_path_d_rgba32           :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore, rgba32: u32) -> Result ---
	context_fill_path_d_rgba64           :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore, rgba64: u64) -> Result ---
	context_fill_path_d_ext              :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore, style: ^Unknown) -> Result ---
	context_fill_geometry                :: proc(self: ^ContextCore, type: GeometryType, data: rawptr) -> Result ---
	context_fill_geometry_rgba32         :: proc(self: ^ContextCore, type: GeometryType, data: rawptr, rgba32: u32) -> Result ---
	context_fill_geometry_rgba64         :: proc(self: ^ContextCore, type: GeometryType, data: rawptr, rgba64: u64) -> Result ---
	context_fill_geometry_ext            :: proc(self: ^ContextCore, type: GeometryType, data: rawptr, style: ^Unknown) -> Result ---
	context_fill_utf8_text_i             :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t) -> Result ---
	context_fill_utf8_text_i_rgba32      :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t, rgba32: u32) -> Result ---
	context_fill_utf8_text_i_rgba64      :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t, rgba64: u64) -> Result ---
	context_fill_utf8_text_i_ext         :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t, style: ^Unknown) -> Result ---
	context_fill_utf8_text_d             :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t) -> Result ---
	context_fill_utf8_text_d_rgba32      :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t, rgba32: u32) -> Result ---
	context_fill_utf8_text_d_rgba64      :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t, rgba64: u64) -> Result ---
	context_fill_utf8_text_d_ext         :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t, style: ^Unknown) -> Result ---
	context_fill_utf16_text_i            :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t) -> Result ---
	context_fill_utf16_text_i_rgba32     :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t, rgba32: u32) -> Result ---
	context_fill_utf16_text_i_rgba64     :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t, rgba64: u64) -> Result ---
	context_fill_utf16_text_i_ext        :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t, style: ^Unknown) -> Result ---
	context_fill_utf16_text_d            :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t) -> Result ---
	context_fill_utf16_text_d_rgba32     :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t, rgba32: u32) -> Result ---
	context_fill_utf16_text_d_rgba64     :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t, rgba64: u64) -> Result ---
	context_fill_utf16_text_d_ext        :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t, style: ^Unknown) -> Result ---
	context_fill_utf32_text_i            :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t) -> Result ---
	context_fill_utf32_text_i_rgba32     :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t, rgba32: u32) -> Result ---
	context_fill_utf32_text_i_rgba64     :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t, rgba64: u64) -> Result ---
	context_fill_utf32_text_i_ext        :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t, style: ^Unknown) -> Result ---
	context_fill_utf32_text_d            :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t) -> Result ---
	context_fill_utf32_text_d_rgba32     :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t, rgba32: u32) -> Result ---
	context_fill_utf32_text_d_rgba64     :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t, rgba64: u64) -> Result ---
	context_fill_utf32_text_d_ext        :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t, style: ^Unknown) -> Result ---
	context_fill_glyph_run_i             :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun) -> Result ---
	context_fill_glyph_run_i_rgba32      :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun, rgba32: u32) -> Result ---
	context_fill_glyph_run_i_rgba64      :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun, rgba64: u64) -> Result ---
	context_fill_glyph_run_i_ext         :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun, style: ^Unknown) -> Result ---
	context_fill_glyph_run_d             :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun) -> Result ---
	context_fill_glyph_run_d_rgba32      :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun, rgba32: u32) -> Result ---
	context_fill_glyph_run_d_rgba64      :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun, rgba64: u64) -> Result ---
	context_fill_glyph_run_d_ext         :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun, style: ^Unknown) -> Result ---
	context_fill_mask_i                  :: proc(self: ^ContextCore, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI) -> Result ---
	context_fill_mask_i_rgba32           :: proc(self: ^ContextCore, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI, rgba32: u32) -> Result ---
	context_fill_mask_i_rgba64           :: proc(self: ^ContextCore, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI, rgba64: u64) -> Result ---
	context_fill_mask_i_ext              :: proc(self: ^ContextCore, origin: ^PointI, mask: ^ImageCore, mask_area: ^RectI, style: ^Unknown) -> Result ---
	context_fill_mask_d                  :: proc(self: ^ContextCore, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI) -> Result ---
	context_fill_mask_d_rgba32           :: proc(self: ^ContextCore, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI, rgba32: u32) -> Result ---
	context_fill_mask_d_rgba64           :: proc(self: ^ContextCore, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI, rgba64: u64) -> Result ---
	context_fill_mask_d_ext              :: proc(self: ^ContextCore, origin: ^Point, mask: ^ImageCore, mask_area: ^RectI, style: ^Unknown) -> Result ---
	context_stroke_rect_i                :: proc(self: ^ContextCore, rect: ^RectI) -> Result ---
	context_stroke_rect_i_rgba32         :: proc(self: ^ContextCore, rect: ^RectI, rgba32: u32) -> Result ---
	context_stroke_rect_i_rgba64         :: proc(self: ^ContextCore, rect: ^RectI, rgba64: u64) -> Result ---
	context_stroke_rect_i_ext            :: proc(self: ^ContextCore, rect: ^RectI, style: ^Unknown) -> Result ---
	context_stroke_rect_d                :: proc(self: ^ContextCore, rect: ^Rect) -> Result ---
	context_stroke_rect_d_rgba32         :: proc(self: ^ContextCore, rect: ^Rect, rgba32: u32) -> Result ---
	context_stroke_rect_d_rgba64         :: proc(self: ^ContextCore, rect: ^Rect, rgba64: u64) -> Result ---
	context_stroke_rect_d_ext            :: proc(self: ^ContextCore, rect: ^Rect, style: ^Unknown) -> Result ---
	context_stroke_path_d                :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore) -> Result ---
	context_stroke_path_d_rgba32         :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore, rgba32: u32) -> Result ---
	context_stroke_path_d_rgba64         :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore, rgba64: u64) -> Result ---
	context_stroke_path_d_ext            :: proc(self: ^ContextCore, origin: ^Point, path: ^PathCore, style: ^Unknown) -> Result ---
	context_stroke_geometry              :: proc(self: ^ContextCore, type: GeometryType, data: rawptr) -> Result ---
	context_stroke_geometry_rgba32       :: proc(self: ^ContextCore, type: GeometryType, data: rawptr, rgba32: u32) -> Result ---
	context_stroke_geometry_rgba64       :: proc(self: ^ContextCore, type: GeometryType, data: rawptr, rgba64: u64) -> Result ---
	context_stroke_geometry_ext          :: proc(self: ^ContextCore, type: GeometryType, data: rawptr, style: ^Unknown) -> Result ---
	context_stroke_utf8_text_i           :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t) -> Result ---
	context_stroke_utf8_text_i_rgba32    :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t, rgba32: u32) -> Result ---
	context_stroke_utf8_text_i_rgba64    :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t, rgba64: u64) -> Result ---
	context_stroke_utf8_text_i_ext       :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: cstring, size: c.size_t, style: ^Unknown) -> Result ---
	context_stroke_utf8_text_d           :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t) -> Result ---
	context_stroke_utf8_text_d_rgba32    :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t, rgba32: u32) -> Result ---
	context_stroke_utf8_text_d_rgba64    :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t, rgba64: u64) -> Result ---
	context_stroke_utf8_text_d_ext       :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: cstring, size: c.size_t, style: ^Unknown) -> Result ---
	context_stroke_utf16_text_i          :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t) -> Result ---
	context_stroke_utf16_text_i_rgba32   :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t, rgba32: u32) -> Result ---
	context_stroke_utf16_text_i_rgba64   :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t, rgba64: u64) -> Result ---
	context_stroke_utf16_text_i_ext      :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u16, size: c.size_t, style: ^Unknown) -> Result ---
	context_stroke_utf16_text_d          :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t) -> Result ---
	context_stroke_utf16_text_d_rgba32   :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t, rgba32: u32) -> Result ---
	context_stroke_utf16_text_d_rgba64   :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t, rgba64: u64) -> Result ---
	context_stroke_utf16_text_d_ext      :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u16, size: c.size_t, style: ^Unknown) -> Result ---
	context_stroke_utf32_text_i          :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t) -> Result ---
	context_stroke_utf32_text_i_rgba32   :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t, rgba32: u32) -> Result ---
	context_stroke_utf32_text_i_rgba64   :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t, rgba64: u64) -> Result ---
	context_stroke_utf32_text_i_ext      :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, text: ^u32, size: c.size_t, style: ^Unknown) -> Result ---
	context_stroke_utf32_text_d          :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t) -> Result ---
	context_stroke_utf32_text_d_rgba32   :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t, rgba32: u32) -> Result ---
	context_stroke_utf32_text_d_rgba64   :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t, rgba64: u64) -> Result ---
	context_stroke_utf32_text_d_ext      :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, text: ^u32, size: c.size_t, style: ^Unknown) -> Result ---
	context_stroke_glyph_run_i           :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun) -> Result ---
	context_stroke_glyph_run_i_rgba32    :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun, rgba32: u32) -> Result ---
	context_stroke_glyph_run_i_rgba64    :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun, rgba64: u64) -> Result ---
	context_stroke_glyph_run_i_ext       :: proc(self: ^ContextCore, origin: ^PointI, font: ^FontCore, glyph_run: ^GlyphRun, style: ^Unknown) -> Result ---
	context_stroke_glyph_run_d           :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun) -> Result ---
	context_stroke_glyph_run_d_rgba32    :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun, rgba32: u32) -> Result ---
	context_stroke_glyph_run_d_rgba64    :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun, rgba64: u64) -> Result ---
	context_stroke_glyph_run_d_ext       :: proc(self: ^ContextCore, origin: ^Point, font: ^FontCore, glyph_run: ^GlyphRun, style: ^Unknown) -> Result ---
	context_blit_image_i                 :: proc(self: ^ContextCore, origin: ^PointI, img: ^ImageCore, img_area: ^RectI) -> Result ---
	context_blit_image_d                 :: proc(self: ^ContextCore, origin: ^Point, img: ^ImageCore, img_area: ^RectI) -> Result ---
	context_blit_scaled_image_i          :: proc(self: ^ContextCore, rect: ^RectI, img: ^ImageCore, img_area: ^RectI) -> Result ---
	context_blit_scaled_image_d          :: proc(self: ^ContextCore, rect: ^Rect, img: ^ImageCore, img_area: ^RectI) -> Result ---
}

