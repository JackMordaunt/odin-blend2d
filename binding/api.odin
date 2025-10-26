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


BYTE_ORDER :: 1234

//! \ingroup bl_globals
//!
//! Result code used by most Blend2D functions (32-bit unsigned integer).
//!
//! The \ref BLResultCode enumeration contains Blend2D result codes that contain Blend2D specific set of errors
//! and an extended set of errors that can come from WIN32 or POSIX APIs. Since the success result code is zero
//! it's recommended to use the following check to determine whether a call failed or not:
//!
//! ```
//! BLResult result = do_something();
//! if (result != BL_SUCCESS) {
//!   // `do_something()` failed...
//! }
//! ```
Result :: u32

//! \ingroup bl_globals
//!
//! Tag is a 32-bit integer consisting of 4 characters in the following format:
//!
//! ```
//! tag = ((a << 24) | (b << 16) | (c << 8) | d)
//! ```
//!
//! Tags are used extensively by OpenType fonts and other binary formats like PNG. In most cases TAGs should only
//! contain ASCII letters, digits, and spaces.
//!
//! Blend2D uses \ref BLTag in public and internal APIs to distinguish between a regular `uint32_t` and tag.
Tag :: u32

//! \ingroup bl_globals
//!
//! Unique identifier that can be used for caching purposes.
//!
//! Some objects such as \ref BLImage and \ref BLFontFace have assigned an unique identifier that can be used to
//! identify such objects for caching purposes. This identifier is never zero, so zero can be safely used as
//! "uncached".
//!
//! \note Unique identifier is per-process. It's implemented as an increasing global or thread-local counter in
//! a way that identifiers would not collide.
UniqueId :: u64

//! \ingroup bl_globals
//!
//! BLUnknown is `void` - it's used in places that accept pointer to \ref BLVarCore or any \ref BLObjectCore
//! compatible object.
Unknown :: struct {}

//! \ingroup bl_globals
//!
//! A sink that can be used to debug various parts of Blend2D.
DebugMessageSinkFunc :: proc "c" (message: cstring, size: c.size_t, user_data: rawptr)

//! \ingroup bl_globals
//!
//! Blend2D result code.
ResultCode :: enum u32 {
	//! Successful result code.
	SUCCESS                            = 0,
	ERROR_START_INDEX                  = 65536,
	ERROR_OUT_OF_MEMORY                = 65536, //!< Out of memory                 [ENOMEM].
	ERROR_INVALID_VALUE                = 65537, //!< Invalid value/argument        [EINVAL].
	ERROR_INVALID_STATE                = 65538, //!< Invalid state                 [EFAULT].
	ERROR_INVALID_HANDLE               = 65539, //!< Invalid handle or file.       [EBADF].
	ERROR_INVALID_CONVERSION           = 65540, //!< Invalid conversion.
	ERROR_OVERFLOW                     = 65541, //!< Overflow or value too large   [EOVERFLOW].
	ERROR_NOT_INITIALIZED              = 65542, //!< Object not initialized.
	ERROR_NOT_IMPLEMENTED              = 65543, //!< Not implemented               [ENOSYS].
	ERROR_NOT_PERMITTED                = 65544, //!< Operation not permitted       [EPERM].
	ERROR_IO                           = 65545, //!< IO error                      [EIO].
	ERROR_BUSY                         = 65546, //!< Device or resource busy       [EBUSY].
	ERROR_INTERRUPTED                  = 65547, //!< Operation interrupted         [EINTR].
	ERROR_TRY_AGAIN                    = 65548, //!< Try again                     [EAGAIN].
	ERROR_TIMED_OUT                    = 65549, //!< Timed out                     [ETIMEDOUT].
	ERROR_BROKEN_PIPE                  = 65550, //!< Broken pipe                   [EPIPE].
	ERROR_INVALID_SEEK                 = 65551, //!< File is not seekable          [ESPIPE].
	ERROR_SYMLINK_LOOP                 = 65552, //!< Too many levels of symlinks   [ELOOP].
	ERROR_FILE_TOO_LARGE               = 65553, //!< File is too large             [EFBIG].
	ERROR_ALREADY_EXISTS               = 65554, //!< File/directory already exists [EEXIST].
	ERROR_ACCESS_DENIED                = 65555, //!< Access denied                 [EACCES].
	ERROR_MEDIA_CHANGED                = 65556, //!< Media changed                 [Windows::ERROR_MEDIA_CHANGED].
	ERROR_READ_ONLY_FS                 = 65557, //!< The file/FS is read-only      [EROFS].
	ERROR_NO_DEVICE                    = 65558, //!< Device doesn't exist          [ENXIO].
	ERROR_NO_ENTRY                     = 65559, //!< Not found, no entry (fs)      [ENOENT].
	ERROR_NO_MEDIA                     = 65560, //!< No media in drive/device      [ENOMEDIUM].
	ERROR_NO_MORE_DATA                 = 65561, //!< No more data / end of file    [ENODATA].
	ERROR_NO_MORE_FILES                = 65562, //!< No more files                 [ENMFILE].
	ERROR_NO_SPACE_LEFT                = 65563, //!< No space left on device       [ENOSPC].
	ERROR_NOT_EMPTY                    = 65564, //!< Directory is not empty        [ENOTEMPTY].
	ERROR_NOT_FILE                     = 65565, //!< Not a file                    [EISDIR].
	ERROR_NOT_DIRECTORY                = 65566, //!< Not a directory               [ENOTDIR].
	ERROR_NOT_SAME_DEVICE              = 65567, //!< Not same device               [EXDEV].
	ERROR_NOT_BLOCK_DEVICE             = 65568, //!< Not a block device            [ENOTBLK].
	ERROR_INVALID_FILE_NAME            = 65569, //!< File/path name is invalid     [n/a].
	ERROR_FILE_NAME_TOO_LONG           = 65570, //!< File/path name is too long    [ENAMETOOLONG].
	ERROR_TOO_MANY_OPEN_FILES          = 65571, //!< Too many open files           [EMFILE].
	ERROR_TOO_MANY_OPEN_FILES_BY_OS    = 65572, //!< Too many open files by OS     [ENFILE].
	ERROR_TOO_MANY_LINKS               = 65573, //!< Too many symbolic links on FS [EMLINK].
	ERROR_TOO_MANY_THREADS             = 65574, //!< Too many threads              [EAGAIN].
	ERROR_THREAD_POOL_EXHAUSTED        = 65575, //!< Thread pool is exhausted and couldn't acquire the requested thread count.
	ERROR_FILE_EMPTY                   = 65576, //!< File is empty (not specific to any OS error).
	ERROR_OPEN_FAILED                  = 65577, //!< File open failed              [Windows::ERROR_OPEN_FAILED].
	ERROR_NOT_ROOT_DEVICE              = 65578, //!< Not a root device/directory   [Windows::ERROR_DIR_NOT_ROOT].
	ERROR_UNKNOWN_SYSTEM_ERROR         = 65579, //!< Unknown system error that failed to translate to Blend2D result code.
	ERROR_INVALID_ALIGNMENT            = 65580, //!< Invalid data alignment.
	ERROR_INVALID_SIGNATURE            = 65581, //!< Invalid data signature or header.
	ERROR_INVALID_DATA                 = 65582, //!< Invalid or corrupted data.
	ERROR_INVALID_STRING               = 65583, //!< Invalid string (invalid data of either UTF8, UTF16, or UTF32).
	ERROR_INVALID_KEY                  = 65584, //!< Invalid key or property.
	ERROR_DATA_TRUNCATED               = 65585, //!< Truncated data (more data required than memory/stream provides).
	ERROR_DATA_TOO_LARGE               = 65586, //!< Input data too large to be processed.
	ERROR_DECOMPRESSION_FAILED         = 65587, //!< Decompression failed due to invalid data (RLE, Huffman, etc).
	ERROR_INVALID_GEOMETRY             = 65588, //!< Invalid geometry (invalid path data or shape).
	ERROR_NO_MATCHING_VERTEX           = 65589, //!< Returned when there is no matching vertex in path data.
	ERROR_INVALID_CREATE_FLAGS         = 65590, //!< Invalid create flags (BLContext).
	ERROR_NO_MATCHING_COOKIE           = 65591, //!< No matching cookie (BLContext).
	ERROR_NO_STATES_TO_RESTORE         = 65592, //!< No states to restore (BLContext).
	ERROR_TOO_MANY_SAVED_STATES        = 65593, //!< Cannot save state as the number of saved states reached the limit (BLContext).
	ERROR_IMAGE_TOO_LARGE              = 65594, //!< The size of the image is too large.
	ERROR_IMAGE_NO_MATCHING_CODEC      = 65595, //!< Image codec for a required format doesn't exist.
	ERROR_IMAGE_UNKNOWN_FILE_FORMAT    = 65596, //!< Unknown or invalid file format that cannot be read.
	ERROR_IMAGE_DECODER_NOT_PROVIDED   = 65597, //!< Image codec doesn't support reading the file format.
	ERROR_IMAGE_ENCODER_NOT_PROVIDED   = 65598, //!< Image codec doesn't support writing the file format.
	ERROR_PNG_MULTIPLE_IHDR            = 65599, //!< Multiple IHDR chunks are not allowed (PNG).
	ERROR_PNG_INVALID_IDAT             = 65600, //!< Invalid IDAT chunk (PNG).
	ERROR_PNG_INVALID_IEND             = 65601, //!< Invalid IEND chunk (PNG).
	ERROR_PNG_INVALID_PLTE             = 65602, //!< Invalid PLTE chunk (PNG).
	ERROR_PNG_INVALID_TRNS             = 65603, //!< Invalid tRNS chunk (PNG).
	ERROR_PNG_INVALID_FILTER           = 65604, //!< Invalid filter type (PNG).
	ERROR_JPEG_UNSUPPORTED_FEATURE     = 65605, //!< Unsupported feature (JPEG).
	ERROR_JPEG_INVALID_SOS             = 65606, //!< Invalid SOS marker or header (JPEG).
	ERROR_JPEG_INVALID_SOF             = 65607, //!< Invalid SOF marker (JPEG).
	ERROR_JPEG_MULTIPLE_SOF            = 65608, //!< Multiple SOF markers (JPEG).
	ERROR_JPEG_UNSUPPORTED_SOF         = 65609, //!< Unsupported SOF marker (JPEG).
	ERROR_FONT_NOT_INITIALIZED         = 65610, //!< Font doesn't have any data as it's not initialized.
	ERROR_FONT_NO_MATCH                = 65611, //!< Font or font face was not matched (BLFontManager).
	ERROR_FONT_NO_CHARACTER_MAPPING    = 65612, //!< Font has no character to glyph mapping data.
	ERROR_FONT_MISSING_IMPORTANT_TABLE = 65613, //!< Font has missing an important table.
	ERROR_FONT_FEATURE_NOT_AVAILABLE   = 65614, //!< Font feature is not available.
	ERROR_FONT_CFF_INVALID_DATA        = 65615, //!< Font has an invalid CFF data.
	ERROR_FONT_PROGRAM_TERMINATED      = 65616, //!< Font program terminated because the execution reached the limit.
	ERROR_GLYPH_SUBSTITUTION_TOO_LARGE = 65617, //!< Glyph substitution requires too much space and was terminated.
	ERROR_INVALID_GLYPH                = 65618, //!< Invalid glyph identifier.
	ERROR_FORCE_UINT                   = 4294967295,
}

//! \ingroup bl_globals
//!
//! Byte order.
ByteOrder :: enum u32 {
	//! Little endian byte-order.
	LE         = 0,

	//! Big endian byte-order.
	BE         = 1,

	//! Native (host) byte-order.
	NATIVE     = 0,

	//! Swapped byte-order (BE if host is LE and vice versa).
	SWAPPED    = 1,
	FORCE_UINT = 4294967295,
}

//! \ingroup bl_globals
//!
//! Data access flags.
DataAccessFlags :: enum u32 {
	//! No data access flags.
	NO_FLAGS   = 0,

	//! Read access.
	READ       = 1,

	//! Write access.
	WRITE      = 2,

	//! Read and write access.
	RW         = 3,
	FORCE_UINT = 4294967295,
}

//! \ingroup bl_globals
//!
//! Data source type.
DataSourceType :: enum u32 {
	//! No data source.
	NONE       = 0,

	//! Memory data source.
	MEMORY     = 1,

	//! File data source.
	FILE       = 2,

	//! Custom data source.
	CUSTOM     = 3,

	//! Maximum value `BLDataSourceType`.
	MAX_VALUE  = 3,
	FORCE_UINT = 4294967295,
}

//! \ingroup bl_globals
//!
//! Modification operation applied to Blend2D containers.
ModifyOp :: enum u32 {
	//! Assign operation, which reserves space only to fit the requested input.
	ASSIGN_FIT  = 0,

	//! Assign operation, which takes into consideration successive appends.
	ASSIGN_GROW = 1,

	//! Append operation, which reserves space only to fit the current and appended content.
	APPEND_FIT  = 2,

	//! Append operation, which takes into consideration successive appends.
	APPEND_GROW = 3,

	//! Maximum value of `BLModifyOp`.
	MAX_VALUE   = 3,
	FORCE_UINT  = 4294967295,
}

//! \ingroup bl_globals
//!
//! Boolean operator.
BooleanOp :: enum u32 {
	//! Result = B.
	COPY       = 0,

	//! Result = A & B.
	AND        = 1,

	//! Result = A | B.
	OR         = 2,

	//! Result = A ^ B.
	XOR        = 3,

	//! Result = A & ~B.
	AND_NOT    = 4,

	//! Result = ~A & B.
	NOT_AND    = 5,

	//! Maximum value of `BLBooleanOp`.
	MAX_VALUE  = 5,
	FORCE_UINT = 4294967295,
}

//! \ingroup bl_styling
//!
//! Extend mode.
ExtendMode :: enum u32 {
	//! Pad extend [default].
	PAD                 = 0,

	//! Repeat extend.
	REPEAT              = 1,

	//! Reflect extend.
	REFLECT             = 2,

	//! Alias of `BL_EXTEND_MODE_PAD`.
	PAD_X_PAD_Y         = 0,

	//! Pad X and repeat Y.
	PAD_X_REPEAT_Y      = 3,

	//! Pad X and reflect Y.
	PAD_X_REFLECT_Y     = 4,

	//! Alias of `BL_EXTEND_MODE_REPEAT`.
	REPEAT_X_REPEAT_Y   = 1,

	//! Repeat X and pad Y.
	REPEAT_X_PAD_Y      = 5,

	//! Repeat X and reflect Y.
	REPEAT_X_REFLECT_Y  = 6,

	//! Alias of `BL_EXTEND_MODE_REFLECT`.
	REFLECT_X_REFLECT_Y = 2,

	//! Reflect X and pad Y.
	REFLECT_X_PAD_Y     = 7,

	//! Reflect X and repeat Y.
	REFLECT_X_REPEAT_Y  = 8,

	//! Count of simple extend modes (that use the same value for X and Y).
	SIMPLE_MAX_VALUE    = 2,

	//! Count of complex extend modes (that can use independent values for X and Y).
	COMPLEX_MAX_VALUE   = 8,

	//! Maximum value of `BLExtendMode`.
	MAX_VALUE           = 8,
	FORCE_UINT          = 4294967295,
}

//! \ingroup bl_text
//!
//! Text encoding.
TextEncoding :: enum u32 {
	//! UTF-8 encoding.
	UTF8       = 0,

	//! UTF-16 encoding (native endian).
	UTF16      = 1,

	//! UTF-32 encoding (native endian).
	UTF32      = 2,

	//! LATIN1 encoding (one byte per character).
	LATIN1     = 3,

	//! Platform native `wchar_t` (or Windows `WCHAR`) encoding, alias to
	//! either UTF-32, UTF-16, or UTF-8 depending on `sizeof(wchar_t)`.
	WCHAR      = 2,

	//! Maximum value of `BLTextEncoding`.
	MAX_VALUE  = 3,
	FORCE_UINT = 4294967295,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! This function is called by Blend2D when an internal assertion failure happens.
	//!
	//! Failing an assertion means that there is either a bug in Blend2D or in user code that uses Blend2D and that the
	//! state of the application is already corrupted and thus irrecoverable. Note that this would be a fatal error if
	//! this function gets called in production.
	runtime_assertion_failure :: proc(file: cstring, line: i32, msg: cstring) ---
}

//! Provides start and end indexes. It has the same semantics as Slices in other programming languages - range is
//! always within [star, end) internal (start is inclusive, end is exclusive). It's used to specify a range of an
//! operation of indexed containers like \ref BLString, \ref BLArray, \ref BLGradient, \ref BLPath, etc...
Range :: struct {
	start: c.size_t,
	end:   c.size_t,
}

ArrayView :: struct {
	data: rawptr,
	size: c.size_t,
}

StringView :: struct {
	data: cstring,
	size: c.size_t,
}

DataView :: ArrayView

