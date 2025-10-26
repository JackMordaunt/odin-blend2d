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


//! Orientation.
Orientation :: enum u32 {
	//! Horizontal orientation.
	HORIZONTAL = 0,

	//! Vertical orientation.
	VERTICAL   = 1,

	//! Maximum value of `BLOrientation`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Type of a font or font face, see \ref BLFontFace (or \ref BLFontFaceCore).
FontFaceType :: enum u32 {
	//! None or unknown font type.
	NONE       = 0,

	//! TrueType/OpenType font type (.ttf/.otf files and font collections).
	OPENTYPE   = 1,

	//! Maximum value of `BLFontFaceType`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Font stretch.
FontStretch :: enum u32 {
	//! Ultra condensed stretch.
	ULTRA_CONDENSED = 1,

	//! Extra condensed stretch.
	EXTRA_CONDENSED = 2,

	//! Condensed stretch.
	CONDENSED       = 3,

	//! Semi condensed stretch.
	SEMI_CONDENSED  = 4,

	//! Normal stretch.
	NORMAL          = 5,

	//! Semi expanded stretch.
	SEMI_EXPANDED   = 6,

	//! Expanded stretch.
	EXPANDED        = 7,

	//! Extra expanded stretch.
	EXTRA_EXPANDED  = 8,

	//! Ultra expanded stretch.
	ULTRA_EXPANDED  = 9,

	//! Maximum value of `BLFontStretch`.
	MAX_VALUE       = 9,
	FORCE_UINT      = 4294967295,
}

//! Font style.
FontStyle :: enum u32 {
	//! Normal style.
	NORMAL     = 0,

	//! Oblique.
	OBLIQUE    = 1,

	//! Italic.
	ITALIC     = 2,

	//! Maximum value of `BLFontStyle`.
	MAX_VALUE  = 2,
	FORCE_UINT = 4294967295,
}

//! Font weight.
FontWeight :: enum u32 {
	//! Thin weight (100).
	THIN        = 100,

	//! Extra light weight (200).
	EXTRA_LIGHT = 200,

	//! Light weight (300).
	LIGHT       = 300,

	//! Semi light weight (350).
	SEMI_LIGHT  = 350,

	//! Normal weight (400).
	NORMAL      = 400,

	//! Medium weight (500).
	MEDIUM      = 500,

	//! Semi bold weight (600).
	SEMI_BOLD   = 600,

	//! Bold weight (700).
	BOLD        = 700,

	//! Extra bold weight (800).
	EXTRA_BOLD  = 800,

	//! Black weight (900).
	BLACK       = 900,

	//! Extra black weight (950).
	EXTRA_BLACK = 950,
	FORCE_UINT  = 4294967295,
}

//! Font string identifiers used by OpenType 'name' table.
FontStringId :: enum u32 {
	//! Copyright notice.
	COPYRIGHT_NOTICE              = 0,

	//! Font family name.
	FAMILY_NAME                   = 1,

	//! Font subfamily name.
	SUBFAMILY_NAME                = 2,

	//! Unique font identifier.
	UNIQUE_IDENTIFIER             = 3,

	//! Full font name that reflects all family and relevant subfamily descriptors.
	FULL_NAME                     = 4,

	//! Version string. Should begin with the synta `Version <number>.<number>`.
	VERSION_STRING                = 5,

	//! PostScript name for the font.
	POST_SCRIPT_NAME              = 6,

	//! Trademark notice/information for this font.
	TRADEMARK                     = 7,

	//! Manufacturer name.
	MANUFACTURER_NAME             = 8,

	//! Name of the designer of the typeface.
	DESIGNER_NAME                 = 9,

	//! Description of the typeface.
	DESCRIPTION                   = 10,

	//! URL of font vendor.
	VENDOR_URL                    = 11,

	//! URL of typeface designer.
	DESIGNER_URL                  = 12,

	//! Description of how the font may be legally used.
	LICENSE_DESCRIPTION           = 13,

	//! URL where additional licensing information can be found.
	LICENSE_INFO_URL              = 14,

	//! Reserved.
	RESERVED                      = 15,

	//! Typographic family name.
	TYPOGRAPHIC_FAMILY_NAME       = 16,

	//! Typographic subfamily name.
	TYPOGRAPHIC_SUBFAMILY_NAME    = 17,

	//! Compatible full name (MAC only).
	COMPATIBLE_FULL_NAME          = 18,

	//! Sample text - font name or any other text from the designer.
	SAMPLE_TEXT                   = 19,

	//! PostScript CID findfont name.
	POST_SCRIPT_CID_NAME          = 20,

	//! WWS family name.
	WWS_FAMILY_NAME               = 21,

	//! WWS subfamily name.
	WWS_SUBFAMILY_NAME            = 22,

	//! Light background palette.
	LIGHT_BACKGROUND_PALETTE      = 23,

	//! Dark background palette.
	DARK_BACKGROUND_PALETTE       = 24,

	//! Variations PostScript name prefix.
	VARIATIONS_POST_SCRIPT_PREFIX = 25,

	//! Count of common font string ids.
	COMMON_MAX_VALUE              = 26,

	//! Start of custom font string ids.
	CUSTOM_START_INDEX            = 255,
	FORCE_UINT                    = 4294967295,
}

//! Bit positions used by \ref BLFontCoverageInfo structure.
//!
//! Each bit represents a range (or multiple ranges) of unicode characters.
FontCoverageGroup :: enum u32 {
	BASIC_LATIN                             = 0,   //!< [000000-00007F] Basic Latin.
	LATIN1_SUPPLEMENT                       = 1,   //!< [000080-0000FF] Latin-1 Supplement.
	LATIN_EXTENDED_A                        = 2,   //!< [000100-00017F] Latin Extended-A.
	LATIN_EXTENDED_B                        = 3,   //!< [000180-00024F] Latin Extended-B.
	IPA_EXTENSIONS                          = 4,   //!< [000250-0002AF] IPA Extensions.

	//!< [001D00-001D7F] Phonetic Extensions.
	//!< [001D80-001DBF] Phonetic Extensions Supplement.
	SPACING_MODIFIER_LETTERS                = 5,   //!< [0002B0-0002FF] Spacing Modifier Letters.

	//!< [00A700-00A71F] Modifier Tone Letters.
	//!< [001DC0-001DFF] Combining Diacritical Marks Supplement.
	COMBINING_DIACRITICAL_MARKS             = 6,   //!< [000300-00036F] Combining Diacritical Marks.
	GREEK_AND_COPTIC                        = 7,   //!< [000370-0003FF] Greek and Coptic.
	COPTIC                                  = 8,   //!< [002C80-002CFF] Coptic.
	CYRILLIC                                = 9,   //!< [000400-0004FF] Cyrillic.

	//!< [000500-00052F] Cyrillic Supplement.
	//!< [002DE0-002DFF] Cyrillic Extended-A.
	//!< [00A640-00A69F] Cyrillic Extended-B.
	ARMENIAN                                = 10,  //!< [000530-00058F] Armenian.
	HEBREW                                  = 11,  //!< [000590-0005FF] Hebrew.
	VAI                                     = 12,  //!< [00A500-00A63F] Vai.
	ARABIC                                  = 13,  //!< [000600-0006FF] Arabic.

	//!< [000750-00077F] Arabic Supplement.
	NKO                                     = 14,  //!< [0007C0-0007FF] NKo.
	DEVANAGARI                              = 15,  //!< [000900-00097F] Devanagari.
	BENGALI                                 = 16,  //!< [000980-0009FF] Bengali.
	GURMUKHI                                = 17,  //!< [000A00-000A7F] Gurmukhi.
	GUJARATI                                = 18,  //!< [000A80-000AFF] Gujarati.
	ORIYA                                   = 19,  //!< [000B00-000B7F] Oriya.
	TAMIL                                   = 20,  //!< [000B80-000BFF] Tamil.
	TELUGU                                  = 21,  //!< [000C00-000C7F] Telugu.
	KANNADA                                 = 22,  //!< [000C80-000CFF] Kannada.
	MALAYALAM                               = 23,  //!< [000D00-000D7F] Malayalam.
	THAI                                    = 24,  //!< [000E00-000E7F] Thai.
	LAO                                     = 25,  //!< [000E80-000EFF] Lao.
	GEORGIAN                                = 26,  //!< [0010A0-0010FF] Georgian.

	//!< [002D00-002D2F] Georgian Supplement.
	BALINESE                                = 27,  //!< [001B00-001B7F] Balinese.
	HANGUL_JAMO                             = 28,  //!< [001100-0011FF] Hangul Jamo.
	LATIN_EXTENDED_ADDITIONAL               = 29,  //!< [001E00-001EFF] Latin Extended Additional.

	//!< [002C60-002C7F] Latin Extended-C.
	//!< [00A720-00A7FF] Latin Extended-D.
	GREEK_EXTENDED                          = 30,  //!< [001F00-001FFF] Greek Extended.
	GENERAL_PUNCTUATION                     = 31,  //!< [002000-00206F] General Punctuation.

	//!< [002E00-002E7F] Supplemental Punctuation.
	SUPERSCRIPTS_AND_SUBSCRIPTS             = 32,  //!< [002070-00209F] Superscripts And Subscripts.
	CURRENCY_SYMBOLS                        = 33,  //!< [0020A0-0020CF] Currency Symbols.
	COMBINING_DIACRITICAL_MARKS_FOR_SYMBOLS = 34,  //!< [0020D0-0020FF] Combining Diacritical Marks For Symbols.
	LETTERLIKE_SYMBOLS                      = 35,  //!< [002100-00214F] Letterlike Symbols.
	NUMBER_FORMS                            = 36,  //!< [002150-00218F] Number Forms.
	ARROWS                                  = 37,  //!< [002190-0021FF] Arrows.

	//!< [0027F0-0027FF] Supplemental Arrows-A.
	//!< [002900-00297F] Supplemental Arrows-B.
	//!< [002B00-002BFF] Miscellaneous Symbols and Arrows.
	MATHEMATICAL_OPERATORS                  = 38,  //!< [002200-0022FF] Mathematical Operators.

	//!< [002A00-002AFF] Supplemental Mathematical Operators.
	//!< [0027C0-0027EF] Miscellaneous Mathematical Symbols-A.
	//!< [002980-0029FF] Miscellaneous Mathematical Symbols-B.
	MISCELLANEOUS_TECHNICAL                 = 39,  //!< [002300-0023FF] Miscellaneous Technical.
	CONTROL_PICTURES                        = 40,  //!< [002400-00243F] Control Pictures.
	OPTICAL_CHARACTER_RECOGNITION           = 41,  //!< [002440-00245F] Optical Character Recognition.
	ENCLOSED_ALPHANUMERICS                  = 42,  //!< [002460-0024FF] Enclosed Alphanumerics.
	BOX_DRAWING                             = 43,  //!< [002500-00257F] Box Drawing.
	BLOCK_ELEMENTS                          = 44,  //!< [002580-00259F] Block Elements.
	GEOMETRIC_SHAPES                        = 45,  //!< [0025A0-0025FF] Geometric Shapes.
	MISCELLANEOUS_SYMBOLS                   = 46,  //!< [002600-0026FF] Miscellaneous Symbols.
	DINGBATS                                = 47,  //!< [002700-0027BF] Dingbats.
	CJK_SYMBOLS_AND_PUNCTUATION             = 48,  //!< [003000-00303F] CJK Symbols And Punctuation.
	HIRAGANA                                = 49,  //!< [003040-00309F] Hiragana.
	KATAKANA                                = 50,  //!< [0030A0-0030FF] Katakana.

	//!< [0031F0-0031FF] Katakana Phonetic Extensions.
	BOPOMOFO                                = 51,  //!< [003100-00312F] Bopomofo.

	//!< [0031A0-0031BF] Bopomofo Extended.
	HANGUL_COMPATIBILITY_JAMO               = 52,  //!< [003130-00318F] Hangul Compatibility Jamo.
	PHAGS_PA                                = 53,  //!< [00A840-00A87F] Phags-pa.
	ENCLOSED_CJK_LETTERS_AND_MONTHS         = 54,  //!< [003200-0032FF] Enclosed CJK Letters And Months.
	CJK_COMPATIBILITY                       = 55,  //!< [003300-0033FF] CJK Compatibility.
	HANGUL_SYLLABLES                        = 56,  //!< [00AC00-00D7AF] Hangul Syllables.
	NON_PLANE                               = 57,  //!< [00D800-00DFFF] Non-Plane 0 *.
	PHOENICIAN                              = 58,  //!< [010900-01091F] Phoenician.
	CJK_UNIFIED_IDEOGRAPHS                  = 59,  //!< [004E00-009FFF] CJK Unified Ideographs.

	//!< [002E80-002EFF] CJK Radicals Supplement.
	//!< [002F00-002FDF] Kangxi Radicals.
	//!< [002FF0-002FFF] Ideographic Description Characters.
	//!< [003400-004DBF] CJK Unified Ideographs Extension A.
	//!< [020000-02A6DF] CJK Unified Ideographs Extension B.
	//!< [003190-00319F] Kanbun.
	PRIVATE_USE_PLANE0                      = 60,  //!< [00E000-00F8FF] Private Use (Plane 0).
	CJK_STROKES                             = 61,  //!< [0031C0-0031EF] CJK Strokes.

	//!< [00F900-00FAFF] CJK Compatibility Ideographs.
	//!< [02F800-02FA1F] CJK Compatibility Ideographs Supplement.
	ALPHABETIC_PRESENTATION_FORMS           = 62,  //!< [00FB00-00FB4F] Alphabetic Presentation Forms.
	ARABIC_PRESENTATION_FORMS_A             = 63,  //!< [00FB50-00FDFF] Arabic Presentation Forms-A.
	COMBINING_HALF_MARKS                    = 64,  //!< [00FE20-00FE2F] Combining Half Marks.
	VERTICAL_FORMS                          = 65,  //!< [00FE10-00FE1F] Vertical Forms.

	//!< [00FE30-00FE4F] CJK Compatibility Forms.
	SMALL_FORM_VARIANTS                     = 66,  //!< [00FE50-00FE6F] Small Form Variants.
	ARABIC_PRESENTATION_FORMS_B             = 67,  //!< [00FE70-00FEFF] Arabic Presentation Forms-B.
	HALFWIDTH_AND_FULLWIDTH_FORMS           = 68,  //!< [00FF00-00FFEF] Halfwidth And Fullwidth Forms.
	SPECIALS                                = 69,  //!< [00FFF0-00FFFF] Specials.
	TIBETAN                                 = 70,  //!< [000F00-000FFF] Tibetan.
	SYRIAC                                  = 71,  //!< [000700-00074F] Syriac.
	THAANA                                  = 72,  //!< [000780-0007BF] Thaana.
	SINHALA                                 = 73,  //!< [000D80-000DFF] Sinhala.
	MYANMAR                                 = 74,  //!< [001000-00109F] Myanmar.
	ETHIOPIC                                = 75,  //!< [001200-00137F] Ethiopic.

	//!< [001380-00139F] Ethiopic Supplement.
	//!< [002D80-002DDF] Ethiopic Extended.
	CHEROKEE                                = 76,  //!< [0013A0-0013FF] Cherokee.
	UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS   = 77,  //!< [001400-00167F] Unified Canadian Aboriginal Syllabics.
	OGHAM                                   = 78,  //!< [001680-00169F] Ogham.
	RUNIC                                   = 79,  //!< [0016A0-0016FF] Runic.
	KHMER                                   = 80,  //!< [001780-0017FF] Khmer.

	//!< [0019E0-0019FF] Khmer Symbols.
	MONGOLIAN                               = 81,  //!< [001800-0018AF] Mongolian.
	BRAILLE_PATTERNS                        = 82,  //!< [002800-0028FF] Braille Patterns.
	YI_SYLLABLES_AND_RADICALS               = 83,  //!< [00A000-00A48F] Yi Syllables.

	//!< [00A490-00A4CF] Yi Radicals.
	TAGALOG_HANUNOO_BUHID_TAGBANWA          = 84,  //!< [001700-00171F] Tagalog.

	//!< [001720-00173F] Hanunoo.
	//!< [001740-00175F] Buhid.
	//!< [001760-00177F] Tagbanwa.
	OLD_ITALIC                              = 85,  //!< [010300-01032F] Old Italic.
	GOTHIC                                  = 86,  //!< [010330-01034F] Gothic.
	DESERET                                 = 87,  //!< [010400-01044F] Deseret.
	MUSICAL_SYMBOLS                         = 88,  //!< [01D000-01D0FF] Byzantine Musical Symbols.

	//!< [01D100-01D1FF] Musical Symbols.
	//!< [01D200-01D24F] Ancient Greek Musical Notation.
	MATHEMATICAL_ALPHANUMERIC_SYMBOLS       = 89,  //!< [01D400-01D7FF] Mathematical Alphanumeric Symbols.
	PRIVATE_USE_PLANE_15_16                 = 90,  //!< [0F0000-0FFFFD] Private Use (Plane 15).

	//!< [100000-10FFFD] Private Use (Plane 16).
	VARIATION_SELECTORS                     = 91,  //!< [00FE00-00FE0F] Variation Selectors.

	//!< [0E0100-0E01EF] Variation Selectors Supplement.
	TAGS                                    = 92,  //!< [0E0000-0E007F] Tags.
	LIMBU                                   = 93,  //!< [001900-00194F] Limbu.
	TAI_LE                                  = 94,  //!< [001950-00197F] Tai Le.
	NEW_TAI_LUE                             = 95,  //!< [001980-0019DF] New Tai Lue.
	BUGINESE                                = 96,  //!< [001A00-001A1F] Buginese.
	GLAGOLITIC                              = 97,  //!< [002C00-002C5F] Glagolitic.
	TIFINAGH                                = 98,  //!< [002D30-002D7F] Tifinagh.
	YIJING_HEXAGRAM_SYMBOLS                 = 99,  //!< [004DC0-004DFF] Yijing Hexagram Symbols.
	SYLOTI_NAGRI                            = 100, //!< [00A800-00A82F] Syloti Nagri.
	LINEAR_B_SYLLABARY_AND_IDEOGRAMS        = 101, //!< [010000-01007F] Linear B Syllabary.

	//!< [010080-0100FF] Linear B Ideograms.
	//!< [010100-01013F] Aegean Numbers.
	ANCIENT_GREEK_NUMBERS                   = 102, //!< [010140-01018F] Ancient Greek Numbers.
	UGARITIC                                = 103, //!< [010380-01039F] Ugaritic.
	OLD_PERSIAN                             = 104, //!< [0103A0-0103DF] Old Persian.
	SHAVIAN                                 = 105, //!< [010450-01047F] Shavian.
	OSMANYA                                 = 106, //!< [010480-0104AF] Osmanya.
	CYPRIOT_SYLLABARY                       = 107, //!< [010800-01083F] Cypriot Syllabary.
	KHAROSHTHI                              = 108, //!< [010A00-010A5F] Kharoshthi.
	TAI_XUAN_JING_SYMBOLS                   = 109, //!< [01D300-01D35F] Tai Xuan Jing Symbols.
	CUNEIFORM                               = 110, //!< [012000-0123FF] Cuneiform.

	//!< [012400-01247F] Cuneiform Numbers and Punctuation.
	COUNTING_ROD_NUMERALS                   = 111, //!< [01D360-01D37F] Counting Rod Numerals.
	SUNDANESE                               = 112, //!< [001B80-001BBF] Sundanese.
	LEPCHA                                  = 113, //!< [001C00-001C4F] Lepcha.
	OL_CHIKI                                = 114, //!< [001C50-001C7F] Ol Chiki.
	SAURASHTRA                              = 115, //!< [00A880-00A8DF] Saurashtra.
	KAYAH_LI                                = 116, //!< [00A900-00A92F] Kayah Li.
	REJANG                                  = 117, //!< [00A930-00A95F] Rejang.
	CHAM                                    = 118, //!< [00AA00-00AA5F] Cham.
	ANCIENT_SYMBOLS                         = 119, //!< [010190-0101CF] Ancient Symbols.
	PHAISTOS_DISC                           = 120, //!< [0101D0-0101FF] Phaistos Disc.
	CARIAN_LYCIAN_LYDIAN                    = 121, //!< [0102A0-0102DF] Carian.

	//!< [010280-01029F] Lycian.
	//!< [010920-01093F] Lydian.
	DOMINO_AND_MAHJONG_TILES                = 122, //!< [01F030-01F09F] Domino Tiles.

	//!< [01F000-01F02F] Mahjong Tiles.
	INTERNAL_USAGE_123                      = 123, //!< Reserved for internal usage (123).
	INTERNAL_USAGE_124                      = 124, //!< Reserved for internal usage (124).
	INTERNAL_USAGE_125                      = 125, //!< Reserved for internal usage (125).
	INTERNAL_USAGE_126                      = 126, //!< Reserved for internal usage (126).
	INTERNAL_USAGE_127                      = 127, //!< Reserved for internal usage (127).

	//! Maximum value of `BLFontCoverageGroup`.
	MAX_VALUE                               = 127,
	FORCE_UINT                              = 4294967295,
}

//! Text direction.
TextDirection :: enum u32 {
	//! Left-to-right direction.
	LTR        = 0,

	//! Right-to-left direction.
	RTL        = 1,

	//! Maximum value of `BLTextDirection`.
	MAX_VALUE  = 1,
	FORCE_UINT = 4294967295,
}

//! Glyph id - a 32-bit unsigned integer.
GlyphId :: u32

//! Contains additional information associated with a glyph used by \ref BLGlyphBuffer.
GlyphInfo :: struct {
	//! \name Members
	//! \{
	cluster:  u32,
	reserved: u32,
}

//! Glyph placement.
//!
//! Provides information about glyph offset (x/y) and advance (x/y).
GlyphPlacement :: struct {
	//! \name Members
	//! \{
	placement: PointI,
	advance:   PointI,
}

//! Character to glyph mapping state.
GlyphMappingState :: struct {
	//! \name Members
	//! \{
	
	//! Number of glyphs or glyph-items on output.
	glyph_count: c.size_t,

	//! Index of the first undefined glyph (SIZE_MAX if none).
	undefined_first: c.size_t,

	//! Undefined glyph count (chars that have no mapping).
	undefined_count: c.size_t,
}

//! Information passed to a \ref BLPathSinkFunc sink by \ref BLFont::get_glyph_outlines().
GlyphOutlineSinkInfo :: struct {
	glyph_index:   c.size_t,
	contour_count: c.size_t,
}

//! Font coverage information struct provides information about ranges of unicode characters supported by a font-face.
//!
//! \remarks The information is stored in "OS/2" table in TTF/OTF font. Blend2D reads this information and populates
//! `BLFontCoverageInfo` struct from such data, however, there is no guarantee that what font describes is actually
//! true.
FontCoverageInfo :: struct {
	//! \name Members
	//! \{
	
	//! Unicode coverage data as a bit array of 4 32-bit unsigned integers.
	data: [4]u32,
}

//! Font PANOSE classification.
FontPanoseInfo :: struct {
	using _: struct #raw_union {
		data:        [10]u8,
		family_kind: u8,

		text: struct {
			family_kind:      u8,
			serif_style:      u8,
			weight:           u8,
			proportion:       u8,
			contrast:         u8,
			stroke_variation: u8,
			arm_style:        u8,
			letterform:       u8,
			midline:          u8,
			x_height:         u8,
		},

		script: struct {
			family_kind:  u8,
			tool_kind:    u8,
			weight:       u8,
			spacing:      u8,
			aspect_ratio: u8,
			contrast:     u8,
			topology:     u8,
			form:         u8,
			finials:      u8,
			x_ascent:     u8,
		},

		decorative: struct {
			family_kind:      u8,
			decorative_class: u8,
			weight:           u8,
			aspect:           u8,
			contrast:         u8,
			serif_variant:    u8,
			treatment:        u8,
			lining:           u8,
			topology:         u8,
			character_range:  u8,
		},

		symbol: struct {
			family_kind:               u8,
			symbol_kind:               u8,
			weight:                    u8,
			spacing:                   u8,
			aspect_ratio_and_contrast: u8,
			aspect_ratio_94:           u8,
			aspect_ratio_119:          u8,
			aspect_ratio_157:          u8,
			aspect_ratio_163:          u8,
			aspect_ratio_211:          u8,
		},
	},
}

//! 2x2 transformation matrix used by \ref BLFont. It's similar to \ref BLMatrix2D,
//! however, it doesn't provide a translation part as it's assumed to be zero.
FontMatrix :: struct {
	using _: struct #raw_union {
		m: [4]f64,

		using _: struct {
			m00: f64,
			m01: f64,
			m10: f64,
			m11: f64,
		},
	},
}

//! Scaled \ref BLFontDesignMetrics based on font size and other properties.
FontMetrics :: struct {
	//! Font size.
	size: f32,

	using _: struct #raw_union {
		using _: struct {
			//! Font ascent (horizontal orientation).
			ascent: f32,

			//! Font ascent (vertical orientation).
			v_ascent: f32,

			//! Font descent (horizontal orientation).
			descent: f32,

			//! Font descent (vertical orientation).
			v_descent: f32,
		},

		using _: struct {
			ascent_by_orientation:  [2]f32,
			descent_by_orientation: [2]f32,
		},
	},

	//! Line gap.
	line_gap: f32,

	//! Distance between the baseline and the mean line of lower-case letters.
	x_height: f32,

	//! Maximum height of a capital letter above the baseline.
	cap_height: f32,

	//! Minimum x, reported by the font.
	x_min: f32,

	//! Minimum y, reported by the font.
	y_min: f32,

	//! Maximum x, reported by the font.
	x_max: f32,

	//! Maximum y, reported by the font.
	y_max: f32,

	//! Text underline position.
	underline_position: f32,

	//! Text underline thickness.
	underline_thickness: f32,

	//! Text strikethrough position.
	strikethrough_position: f32,

	//! Text strikethrough thickness.
	strikethrough_thickness: f32,
}

//! Design metrics of a font.
//!
//! Design metrics is information that \ref BLFontFace collected directly from the font data. It means that all
//! fields are measured in font design units.
//!
//! When a new \ref BLFont instance is created a scaled metrics \ref BLFontMetrics is automatically calculated
//! from \ref BLFontDesignMetrics including other members like transformation, etc...
FontDesignMetrics :: struct {
	//! Units per EM square.
	units_per_em: i32,

	//! Lowest readable size in pixels.
	lowest_ppem: i32,

	//! Line gap.
	line_gap: i32,

	//! Distance between the baseline and the mean line of lower-case letters.
	x_height: i32,

	//! Maximum height of a capital letter above the baseline.
	cap_height: i32,

	using _: struct #raw_union {
		using _: struct {
			//! Ascent (horizontal layout).
			ascent: i32,

			//! Ascent (vertical layout).
			v_ascent: i32,

			//! Descent (horizontal layout).
			descent: i32,

			//! Descent (vertical layout).
			v_descent: i32,

			//! Minimum leading-side bearing (horizontal layout).
			h_min_lsb: i32,

			//! Minimum leading-side bearing (vertical layout).
			v_min_lsb: i32,

			//! Minimum trailing-side bearing (horizontal layout).
			h_min_tsb: i32,

			//! Minimum trailing-side bearing (vertical layout).
			v_min_tsb: i32,

			//! Maximum advance (horizontal layout).
			h_max_advance: i32,

			//! Maximum advance (vertical layout).
			v_max_advance: i32,
		},

		using _: struct {
			//! Horizontal & vertical ascents.
			ascent_by_orientation: [2]i32,

			//! Horizontal & vertical descents.
			descent_by_orientation: [2]i32,

			//! Minimum leading-side bearing (horizontal and vertical).
			min_lsb_by_orientation: [2]i32,

			//! Minimum trailing-side bearing (horizontal and vertical)..
			min_tsb_by_orientation: [2]i32,

			//! Maximum advance width (horizontal) and height (vertical).
			max_advance_by_orientation: [2]i32,
		},
	},

	//! Aggregated bounding box of all glyphs in the font.
	//!
	//! \note This value is reported by the font data so it's not granted to be true.
	glyph_bounding_box: BoxI,

	//! Text underline position.
	underline_position: i32,

	//! Text underline thickness.
	underline_thickness: i32,

	//! Text strikethrough position.
	strikethrough_position: i32,

	//! Text strikethrough thickness.
	strikethrough_thickness: i32,
}

//! Text metrics.
TextMetrics :: struct {
	advance:          Point,
	leading_bearing:  Point,
	trailing_bearing: Point,
	bounding_box:     Box,
}

