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


//! File information flags, used by \ref BLFileInfo.
FileInfoFlags :: enum u32 {
	//! File owner has read permission (compatible with 0400 octal notation).
	OWNER_R          = 256,

	//! File owner has write permission (compatible with 0200 octal notation).
	OWNER_W          = 128,

	//! File owner has execute permission (compatible with 0100 octal notation).
	OWNER_X          = 64,

	//! A combination of \ref BL_FILE_INFO_OWNER_R, \ref BL_FILE_INFO_OWNER_W, and \ref BL_FILE_INFO_OWNER_X.
	OWNER_MASK       = 448,

	//! File group owner has read permission (compatible with 040 octal notation).
	GROUP_R          = 32,

	//! File group owner has write permission (compatible with 020 octal notation).
	GROUP_W          = 16,

	//! File group owner has execute permission (compatible with 010 octal notation).
	GROUP_X          = 8,

	//! A combination of \ref BL_FILE_INFO_GROUP_R, \ref BL_FILE_INFO_GROUP_W, and \ref BL_FILE_INFO_GROUP_X.
	GROUP_MASK       = 56,

	//! Other users have read permission (compatible with 04 octal notation).
	OTHER_R          = 4,

	//! Other users have write permission (compatible with 02 octal notation).
	OTHER_W          = 2,

	//! Other users have execute permission (compatible with 01 octal notation).
	OTHER_X          = 1,

	//! A combination of \ref BL_FILE_INFO_OTHER_R, \ref BL_FILE_INFO_OTHER_W, and \ref BL_FILE_INFO_OTHER_X.
	OTHER_MASK       = 7,

	//! Set user ID to file owner user ID on execution (compatible with 04000 octal notation).
	SUID             = 2048,

	//! Set group ID to file's user group ID on execution (compatible with 02000 octal notation).
	SGID             = 1024,

	//! A combination of all file permission bits.
	PERMISSIONS_MASK = 4095,

	//! A flag specifying that this is a regular file.
	REGULAR          = 65536,

	//! A flag specifying that this is a directory.
	DIRECTORY        = 131072,

	//! A flag specifying that this is a symbolic link.
	SYMLINK          = 262144,

	//! A flag describing a character device.
	CHAR_DEVICE      = 1048576,

	//! A flag describing a block device.
	BLOCK_DEVICE     = 2097152,

	//! A flag describing a FIFO (named pipe).
	FIFO             = 4194304,

	//! A flag describing a socket.
	SOCKET           = 8388608,

	//! A flag describing a hidden file (Windows only).
	HIDDEN           = 16777216,

	//! A flag describing a hidden file (Windows only).
	EXECUTABLE       = 33554432,

	//! A flag describing an archive (Windows only).
	ARCHIVE          = 67108864,

	//! A flag describing a system file (Windows only).
	SYSTEM           = 134217728,

	//! File information is valid (the request succeeded).
	VALID            = 2147483648,
	FORCE_UINT       = 4294967295,
}

//! File open flags, see \ref BLFile::open().
FileOpenFlags :: enum u32 {
	//! No flags.
	NO_FLAGS         = 0,

	//! Opens the file for reading.
	//!
	//! The following system flags are used when opening the file:
	//!   - `O_RDONLY` (Posix)
	//!   - `GENERIC_READ` (Windows)
	READ             = 1,

	//! Opens the file for writing:
	//!
	//! The following system flags are used when opening the file:
	//!   - `O_WRONLY` (Posix)
	//!   - `GENERIC_WRITE` (Windows)
	WRITE            = 2,

	//! Opens the file for reading & writing.
	//!
	//! The following system flags are used when opening the file:
	//!   - `O_RDWR` (Posix)
	//!   - `GENERIC_READ | GENERIC_WRITE` (Windows)
	RW               = 3,

	//! Creates the file if it doesn't exist or opens it if it does.
	//!
	//! The following system flags are used when opening the file:
	//!   - `O_CREAT` (Posix)
	//!   - `CREATE_ALWAYS` or `OPEN_ALWAYS` depending on other flags (Windows)
	CREATE           = 4,

	//! Opens the file for deleting or renaming (Windows).
	//!
	//! Adds `DELETE` flag when opening the file to `ACCESS_MASK`.
	DELETE           = 8,

	//! Truncates the file.
	//!
	//! The following system flags are used when opening the file:
	//!   - `O_TRUNC` (Posix)
	//!   - `TRUNCATE_EXISTING` (Windows)
	TRUNCATE         = 16,

	//! Opens the file for reading in exclusive mode (Windows).
	//!
	//! Exclusive mode means to not specify the `FILE_SHARE_READ` option.
	READ_EXCLUSIVE   = 268435456,

	//! Opens the file for writing in exclusive mode (Windows).
	//!
	//! Exclusive mode means to not specify the `FILE_SHARE_WRITE` option.
	WRITE_EXCLUSIVE  = 536870912,

	//! Opens the file for both reading and writing (Windows).
	//!
	//! This is a combination of both `BL_FILE_OPEN_READ_EXCLUSIVE` and `BL_FILE_OPEN_WRITE_EXCLUSIVE`.
	RW_EXCLUSIVE     = 805306368,

	//! Creates the file in exclusive mode - fails if the file already exists.
	//!
	//! The following system flags are used when opening the file:
	//!   - `O_EXCL` (Posix)
	//!   - `CREATE_NEW` (Windows)
	CREATE_EXCLUSIVE = 1073741824,

	//! Opens the file for deleting or renaming in exclusive mode (Windows).
	//!
	//! Exclusive mode means to not specify the `FILE_SHARE_DELETE` option.
	DELETE_EXCLUSIVE = 2147483648,
	FORCE_UINT       = 4294967295,
}

//! File seek mode, see \ref BLFile::seek().
//!
//! \note Seek constants should be compatible with constants used by both POSIX
//! and Windows API.
FileSeekType :: enum u32 {
	//! Seek from the beginning of the file (SEEK_SET).
	SET        = 0,

	//! Seek from the current position (SEEK_CUR).
	CUR        = 1,

	//! Seek from the end of the file (SEEK_END).
	END        = 2,

	//! Maximum value of `BLFileSeekType`.
	MAX_VALUE  = 3,
	FORCE_UINT = 4294967295,
}

//! File read flags used by \ref BLFileSystem::read_file().
FileReadFlags :: enum u32 {
	//! No flags.
	NO_FLAGS         = 0,

	//! Use memory mapping to read the content of the file.
	//!
	//! The destination buffer `BLArray<>` would be configured to use the memory mapped buffer instead of allocating its
	//! own.
	MMAP_ENABLED     = 1,

	//! Avoid memory mapping of small files.
	//!
	//! The size of small file is determined by Blend2D, however, you should expect it to be 16kB or 64kB depending on
	//! host operating system.
	MMAP_AVOID_SMALL = 2,

	//! Do not fallback to regular read if memory mapping fails. It's worth noting that memory mapping would fail for
	//! files stored on filesystem that is not local (like a mounted network filesystem, etc...).
	MMAP_NO_FALLBACK = 8,
	FORCE_UINT       = 4294967295,
}

//! A thin abstraction over a native OS file IO [C API].
FileCore :: struct {
	//! A file handle - either a file descriptor used by POSIX or file handle used by Windows. On both platforms the
	//! handle is always `intptr_t` to make FFI easier (it's basically the size of a pointer / machine register).
	//!
	//! \note A handle of value `-1` is considered invalid and/or uninitialized. This value also matches Windows API
	//! `INVALID_HANDLE_VALUE`, which is also defined to be -1.
	handle: c.intptr_t,
}

//! File information.
FileInfo :: struct {
	//! \name Members
	//! \{
	size:          u64,
	modified_time: i64,
	flags:         FileInfoFlags,
	uid:           u32,
	gid:           u32,
	reserved:      [5]u32,
}

@(default_calling_convention="c", link_prefix="bl_")
foreign lib {
	//! \name BLFile C API Functions
	//!
	//! File read/write functionality is provided by \ref BLFileCore in C API and wrapped by \ref BLFile in C++ API.
	//!
	//! \{
	file_init     :: proc(self: ^FileCore) -> Result ---
	file_reset    :: proc(self: ^FileCore) -> Result ---
	file_open     :: proc(self: ^FileCore, file_name: cstring, open_flags: FileOpenFlags) -> Result ---
	file_close    :: proc(self: ^FileCore) -> Result ---
	file_seek     :: proc(self: ^FileCore, offset: i64, seek_type: FileSeekType, position_out: ^i64) -> Result ---
	file_read     :: proc(self: ^FileCore, buffer: rawptr, n: c.size_t, bytes_read_out: ^c.size_t) -> Result ---
	file_write    :: proc(self: ^FileCore, buffer: rawptr, n: c.size_t, bytes_written_out: ^c.size_t) -> Result ---
	file_truncate :: proc(self: ^FileCore, max_size: i64) -> Result ---
	file_get_info :: proc(self: ^FileCore, info_out: ^FileInfo) -> Result ---
	file_get_size :: proc(self: ^FileCore, file_size_out: ^u64) -> Result ---

	//! \name BLFileSystem C API Functions
	//!
	//! \{
	file_system_get_info   :: proc(file_name: cstring, info_out: ^FileInfo) -> Result ---
	file_system_read_file  :: proc(file_name: cstring, dst: ^ArrayCore, max_size: c.size_t, read_flags: FileReadFlags) -> Result ---
	file_system_write_file :: proc(file_name: cstring, data: rawptr, size: c.size_t, bytes_written_out: ^c.size_t) -> Result ---
}

