/*
	This example showcases Blend2d as the rendering backend for microui, using SDL
	as the cross platform graphics API.

	SDL is used to create the OS window and provide a rendering context.
	Blend2d draws directly into the pixel buffer of an SDL GPU texture.
	microui is used to implement the UI layout.

	SDL events -> microui
	microui -> render commands -> Blend2d
	Blend2d -> GPU texture

	You can also render microui using SDL drawing primitives, but the point is
	to use Blend2d to do rendering on the CPU.

	Bugs:
		- log text input not working
		- clips are too aggressive on paths (text + icons)
*/
package main

import "core:c"

import "base:runtime"
import "core:fmt"
import "core:math"
import "core:mem/virtual"
import "core:strings"

import bl "../binding"
import mu "vendor:microui"
import sdl "vendor:sdl3"

// FontHandle is provided to microui, allowing access to the context within text
// measuring callbacks.
FontHandle :: struct {
	ctx:  ^Context,
	font: ^bl.FontCore,
}

// Context is an amalgam of state required by SDL, microui, blend2d and the ui logic.
Context :: struct {
	runtime_context: runtime.Context,
	mu_ctx:          ^mu.Context,
	bl_ctx:          ^bl.ContextCore,
	face:            ^bl.FontFaceCore,
	font:            ^bl.FontCore,
	window:          ^sdl.Window,
	renderer:        ^sdl.Renderer,
	texture:         ^sdl.Texture,
	bg:              mu.Color,
	cookie:          bl.ContextCookie,
	log_buf:         [1 << 16]byte,
	log_buf_len:     int,
	log_buf_updated: bool,
	frame_count:     i64,
	render_width:    i32,
	render_height:   i32,
	logical_width:   i32,
	logical_height:  i32,
	scale:           i32,
	debug_text:      bool,
}

// context_init initializes SDL, blend2d and microui.
context_init :: proc(ctx: ^Context) {
	ctx.runtime_context = context

	ctx.bl_ctx = new(bl.ContextCore)

	if bl.context_init(ctx.bl_ctx) != 0 {
		panic("failed to create blend2d context")
	}

	ctx.mu_ctx = new(mu.Context)
	mu.init(ctx.mu_ctx)

	assert(sdl.Init({.VIDEO, .EVENTS}))

	display_mode := sdl.GetCurrentDisplayMode(sdl.GetPrimaryDisplay())
	ctx.scale = i32(display_mode.pixel_density)

	window := sdl.CreateWindow(
		"microui - blend2d - sdl3",
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		{.RESIZABLE, .HIGH_PIXEL_DENSITY},
	)

	ctx.window = window

	renderer := sdl.CreateRenderer(window, "")

	ctx.renderer = renderer

	sdl.GetRenderOutputSize(renderer, &ctx.render_width, &ctx.render_height)

	texture := sdl.CreateTexture(
		renderer,
		.RGBA32,
		.STREAMING,
		ctx.render_width,
		ctx.render_height,
	)
	ctx.texture = texture

	sdl.SetTextureBlendMode(
		texture,
		sdl.ComposeCustomBlendMode(
			.ONE,
			.ONE_MINUS_SRC_ALPHA,
			.ADD,
			.ONE,
			.ONE_MINUS_SRC_ALPHA,
			.ADD,
		),
	)

	sdl.SetRenderVSync(renderer, 1)

	window_scale := sdl.GetWindowDisplayScale(ctx.window)
	window_pixel_density := sdl.GetWindowPixelDensity(ctx.window)
	sdl.GetRenderOutputSize(ctx.renderer, &ctx.render_width, &ctx.render_height)

	/*
		init font
	*/

	{
		ctx.face = new(bl.FontFaceCore)
		bl.font_face_init(ctx.face)

		if bl.font_face_create_from_file(
			   ctx.face,
			   "./example/resource/Roboto-Medium.ttf",
			   .NO_FLAGS,
		   ) !=
		   0 {
			panic("failed to load font")
		}

		ctx.font = new(bl.FontCore)
		assert(bl.font_init(ctx.font) == 0)

		assert(bl.font_create_from_face(ctx.font, ctx.face, f32(14 * ctx.scale)) == 0)

		// Setup the font handle. Provides access to the context in the text measuring
		// callbacks.
		fh := new(FontHandle)
		fh.ctx = ctx
		fh.font = ctx.font
		ctx.mu_ctx.style.font = mu.Font(fh)

		ctx.mu_ctx.text_height = proc(font: mu.Font) -> i32 {
			if font == nil {
				return 0
			}

			fh := cast(^FontHandle)(font)

			fm: bl.FontMetrics
			bl.font_get_metrics(fh.font, &fm)

			height := i32(fm.ascent + fm.descent)

			// The font measurements need to be unscaled because microui
			// works within a logical coordinate space.
			return height / fh.ctx.scale
		}

		ctx.mu_ctx.text_width = proc(font: mu.Font, text: string) -> i32 {
			if font == nil {
				return 0
			}

			fh := cast(^FontHandle)(font)

			@(static) gb: bl.GlyphBufferCore
			bl.glyph_buffer_init(&gb)
			defer bl.glyph_buffer_reset(&gb)

			bl.glyph_buffer_set_text(&gb, raw_data(text), len(text), .UTF8)

			tm: bl.TextMetrics
			bl.font_get_text_metrics(fh.font, &gb, &tm)

			// The font measurements need to be unscaled because microui
			// works within a logical coordinate space.
			return i32(tm.advance.x) / fh.ctx.scale
		}
	}
}

WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 800

main :: proc() {
	ctx: Context
	context_init(&ctx)

	arena: virtual.Arena
	assert(virtual.arena_init_growing(&arena) == nil)
	context.allocator = virtual.arena_allocator(&arena)

	sdl.GetWindowSize(ctx.window, &ctx.logical_width, &ctx.logical_height)

	mainloop: for {
		defer virtual.arena_free_all(&arena)
		defer ctx.frame_count += 1

		event: sdl.Event

		for sdl.PollEvent(&event) {
			#partial switch event.type {
			case .QUIT:
				break mainloop
			case .MOUSE_MOTION:
				mu.input_mouse_move(
					ctx.mu_ctx,
					i32(math.round(event.motion.x)),
					i32(math.round(event.motion.y)),
				)
			case .MOUSE_BUTTON_DOWN:
				if btn := sdl_button_to_mu_button(event.button.button); btn != nil {
					mu.input_mouse_down(
						ctx.mu_ctx,
						i32(math.round(event.button.x)),
						i32(math.round(event.button.y)),
						btn.?,
					)
				}
			case .MOUSE_BUTTON_UP:
				if btn := sdl_button_to_mu_button(event.button.button); btn != nil {
					mu.input_mouse_up(
						ctx.mu_ctx,
						i32(math.round(event.button.x)),
						i32(math.round(event.button.y)),
						btn.?,
					)
				}
			case .MOUSE_WHEEL:
				mu.input_scroll(
					ctx.mu_ctx,
					i32(event.wheel.integer_x * -30),
					i32(event.wheel.integer_y * -30),
				)
			case .KEY_DOWN:
				if key := sdl_key_to_mu_key(event.key.key); key != nil {
					mu.input_key_down(ctx.mu_ctx, key.?)
				}
			case .KEY_UP:
				if key := sdl_key_to_mu_key(event.key.key); key != nil {
					mu.input_key_up(ctx.mu_ctx, key.?)
				}
			case .TEXT_INPUT:
				mu.input_text(ctx.mu_ctx, strings.clone_from_cstring(event.text.text))
			}
		}

		render(&ctx)
	}
}

sdl_button_to_mu_button :: proc(sdl_btn: u8) -> Maybe(mu.Mouse) {
	switch sdl_btn {
	case sdl.BUTTON_LEFT:
		return .LEFT
	case sdl.BUTTON_RIGHT:
		return .RIGHT
	case sdl.BUTTON_MIDDLE:
		return .MIDDLE
	case:
		return nil
	}
}

sdl_key_to_mu_key :: proc(sdl_key: sdl.Keycode) -> (ret: Maybe(mu.Key)) {
	switch sdl_key {
	case sdl.K_LSHIFT, sdl.K_RSHIFT:
		return .SHIFT
	case sdl.K_LCTRL, sdl.K_RCTRL:
		return .CTRL
	case sdl.K_LALT, sdl.K_RALT:
		return .ALT
	case sdl.K_BACKSPACE:
		return .BACKSPACE
	case sdl.K_DELETE:
		return .DELETE
	case sdl.K_RETURN:
		return .RETURN
	case sdl.K_LEFT:
		return .LEFT
	case sdl.K_RIGHT:
		return .RIGHT
	case sdl.K_HOME:
		return .HOME
	case sdl.K_END:
		return .END
	case sdl.K_A:
		return .A
	case sdl.K_X:
		return .X
	case sdl.K_C:
		return .C
	case sdl.K_V:
		return .V
	case:
		return nil
	}
}

render :: proc(ctx: ^Context) {
	pixels: rawptr
	pitch: c.int

	if !sdl.LockTexture(ctx.texture, nil, &pixels, &pitch) {
		return
	}

	img: bl.ImageCore

	image_init_res := bl.image_init_as_from_data(
		&img,
		i32(ctx.render_width),
		i32(ctx.render_height),
		.PRGB32,
		pixels,
		int(pitch),
		.RW,
		nil,
		nil,
	)

	if image_init_res != 0 {
		return
	}

	defer bl.image_reset(&img)

	{
		bl.context_begin(ctx.bl_ctx, &img, nil)
		defer bl.context_end(ctx.bl_ctx)

		mu.begin(ctx.mu_ctx)
		all_windows(ctx)
		mu.end(ctx.mu_ctx)

		bl.context_clear_all(ctx.bl_ctx)
		bl.context_fill_all_rgba32(ctx.bl_ctx, transmute(u32)(ctx.bg))

		// cmd_backing is the iteration context, since mu.next_command is implemented 	
		// via pointer math.
		cmd_backing: ^mu.Command
		for var in mu.next_command_iterator(ctx.mu_ctx, &cmd_backing) {
			switch cmd in var {
			case ^mu.Command_Text:
				_render_text(ctx, cmd)
			case ^mu.Command_Icon:
				_render_icon(ctx, cmd)
			case ^mu.Command_Rect:
				_render_rect(ctx, cmd)
			case ^mu.Command_Clip:
				_set_clip(ctx, cmd)
			case ^mu.Command_Jump:
				panic("jm_ jump command")
			}
		}

	}

	src := sdl.FRect {
		w = f32(ctx.render_width),
		h = f32(ctx.render_height),
	}

	sdl.UnlockTexture(ctx.texture)
	sdl.SetRenderDrawColor(ctx.renderer, 0, 0, 0, 255)
	sdl.RenderClear(ctx.renderer)
	sdl.RenderTexture(ctx.renderer, ctx.texture, &src, nil)
	sdl.RenderPresent(ctx.renderer)

	texture_width: f32
	texture_height: f32
	sdl.GetTextureSize(ctx.texture, &texture_width, &texture_height)

	sdl.SetWindowTitle(
		ctx.window,
		fmt.ctprintf(
			"render %vx%v texture %vx%v logical %vx%v scale %v mouse (%v,%v)",
			ctx.render_width,
			ctx.render_height,
			ctx.logical_width,
			ctx.logical_height,
			texture_width,
			texture_height,
			ctx.scale,
			ctx.mu_ctx.mouse_pos.x,
			ctx.mu_ctx.mouse_pos.y,
		),
	)
}

_render_text :: proc(ctx: ^Context, cmd: ^mu.Command_Text) {
	font := cast(^FontHandle)(cmd.font)
	text_data := cast(cstring)(raw_data(cmd.str))
	text_len := uint(len(cmd.str))

	fm: bl.FontMetrics
	bl.font_get_metrics(font.font, &fm)

	@(static) glyph_buffer: bl.GlyphBufferCore
	bl.glyph_buffer_init(&glyph_buffer)
	defer bl.glyph_buffer_reset(&glyph_buffer)

	bl.glyph_buffer_set_text(&glyph_buffer, rawptr(text_data), uint(text_len), .UTF8)

	tm: bl.TextMetrics
	bl.font_get_text_metrics(font.font, &glyph_buffer, &tm)

	// draw the text
	{
		origin := bl.PointI {
			x = (cmd.pos.x * ctx.scale) + i32(tm.bounding_box.x0),
			y = (cmd.pos.y * ctx.scale) + i32(fm.ascent), // Adjust from top to baseline
		}
		bl.context_fill_glyph_run_i_rgba32(
			ctx.bl_ctx,
			&origin,
			ctx.font,
			bl.glyph_buffer_get_glyph_run(&glyph_buffer),
			transmute(u32)(cmd.color),
		)
	}

	if ctx.debug_text {
		// draw bounding box
		{
			rect := bl.RectI {
				x = (cmd.pos.x * ctx.scale) + i32(tm.bounding_box.x0),
				y = (cmd.pos.y * ctx.scale),
				w = i32((tm.advance.x)),
				h = i32(fm.descent + fm.ascent),
			}
			bl.context_stroke_rect_i_rgba32(ctx.bl_ctx, &rect, transmute(u32)(cmd.color))

		}
		// draw baseline
		{
			rect := bl.RectI {
				x = (cmd.pos.x * ctx.scale) + i32(tm.bounding_box.x0),
				y = (cmd.pos.y * ctx.scale) + i32(fm.ascent),
				w = i32((tm.bounding_box.x1 - tm.bounding_box.x0)),
				h = 1,
			}
			bl.context_stroke_rect_i_rgba32(ctx.bl_ctx, &rect, transmute(u32)(cmd.color))
		}
		// draw origin
		{
			rect := bl.RectI {
				x = (cmd.pos.x * ctx.scale) + i32(tm.bounding_box.x0) - 6,
				y = (cmd.pos.y * ctx.scale) - 6,
				w = 12,
				h = 12,
			}
			bl.context_stroke_rect_i_rgba32(ctx.bl_ctx, &rect, transmute(u32)(cmd.color))
		}
	}
}

_render_rect :: proc(ctx: ^Context, cmd: ^mu.Command_Rect) {
	rect := bl.RectI {
		x = cmd.rect.x * ctx.scale,
		y = cmd.rect.y * ctx.scale,
		w = cmd.rect.w * ctx.scale,
		h = cmd.rect.h * ctx.scale,
	}
	bl.context_fill_rect_i_rgba32(ctx.bl_ctx, &rect, transmute(u32)(cmd.color))
}

// _render_icon uses vector paths to draw the icons to showcase blend's path api.
_render_icon :: proc(ctx: ^Context, cmd: ^mu.Command_Icon) {
	color := transmute(u32)(cmd.color)

	rect := bl.Rect {
		x = f64(cmd.rect.x * ctx.scale),
		y = f64(cmd.rect.y * ctx.scale),
		w = f64(cmd.rect.w * ctx.scale),
		h = f64(cmd.rect.h * ctx.scale),
	}

	switch cmd.id {
	case .NONE:
		return
	case .RESIZE:
		size := bl.Size {
			w = 18,
			h = 18,
		}
		_draw_resize(ctx, rect, size, color)
	case .CLOSE:
		size := bl.Size {
			w = 18,
			h = 18,
		}
		_draw_close(ctx, rect, size, color)
	case .CHECK:
		size := bl.Size {
			w = 18,
			h = 18,
		}
		_draw_check(ctx, rect, size, color)
	case .EXPANDED:
		size := bl.Size {
			w = 12,
			h = 8,
		}
		_draw_down_angle(ctx, rect, size, color)
	case .COLLAPSED:
		size := bl.Size {
			w = 8,
			h = 12,
		}
		_draw_right_angle(ctx, rect, size, color)
	}
}

_draw_resize :: proc(ctx: ^Context, rect: bl.Rect, size: bl.Size, rgba: u32) {
	_draw_icon(ctx, rect, size, rgba, proc(p: ^bl.PathCore, size: bl.Size) {
		bl.path_move_to(p, size.w, size.h / 2)
		bl.path_line_to(p, size.w, size.h)
		bl.path_move_to(p, size.w / 2, size.h)
		bl.path_line_to(p, size.w, size.h)
	})
}

_draw_close :: proc(ctx: ^Context, rect: bl.Rect, size: bl.Size, rgba: u32) {
	_draw_icon(ctx, rect, size, rgba, proc(p: ^bl.PathCore, size: bl.Size) {
		bl.path_move_to(p, 0, 0)
		bl.path_line_to(p, size.w, size.h)
		bl.path_move_to(p, size.w, 0)
		bl.path_line_to(p, 0, size.h)
	})
}

_draw_check :: proc(ctx: ^Context, rect: bl.Rect, size: bl.Size, rgba: u32) {
	_draw_icon(ctx, rect, size, rgba, proc(p: ^bl.PathCore, size: bl.Size) {
		bl.path_move_to(p, 0, (size.h / 2))
		bl.path_line_to(p, (size.w / 3), size.h)
		bl.path_line_to(p, size.w, 0)
	})
}

_draw_right_angle :: proc(ctx: ^Context, rect: bl.Rect, size: bl.Size, rgba: u32) {
	_draw_icon(ctx, rect, size, rgba, proc(p: ^bl.PathCore, size: bl.Size) {
		bl.path_move_to(p, 0, 0)
		bl.path_line_to(p, size.w, (size.h / 2))
		bl.path_line_to(p, 0, size.h)
	})
}

_draw_down_angle :: proc(ctx: ^Context, rect: bl.Rect, size: bl.Size, rgba: u32) {
	_draw_icon(ctx, rect, size, rgba, proc(p: ^bl.PathCore, size: bl.Size) {
		bl.path_move_to(p, 0, 0)
		bl.path_line_to(p, (size.w / 2), size.h)
		bl.path_line_to(p, size.w, 0)
	})
}


// _draw_icon centers the path on the rect and draws it via the path_proc.
// path_proc is expected to fill the PathCore with lines.
_draw_icon :: proc(
	ctx: ^Context,
	rect: bl.Rect,
	size: bl.Size,
	rgba: u32,
	path_proc: proc(_: ^bl.PathCore, _: bl.Size),
) {
	@(static) p: bl.PathCore

	bl.path_init(&p)
	defer bl.path_reset(&p)

	path_proc(&p, size)

	origin := bl.Point {
		x = rect.x + (rect.w - size.w) / 2,
		y = rect.y + (rect.w - size.h) / 2,
	}

	bl.context_set_stroke_options(ctx.bl_ctx, &bl.StrokeOptionsCore{width = 2})
	defer bl.context_set_stroke_options(ctx.bl_ctx, &bl.StrokeOptionsCore{width = 1})

	bl.context_stroke_path_d_rgba32(ctx.bl_ctx, &origin, &p, rgba)
}

// FIXME: there's some weird clipping behaviour: the moment text is even partially occluded,
// the entire text run disappears. Also occurs for icons.
_set_clip :: proc(ctx: ^Context, cmd: ^mu.Command_Clip) {
	// TODO: verify this magic number.
	// It's the number that microui spits out, I think it represents a clip clear
	// by logically setting the clip to a super large dimension.
	if cmd.rect.h == 16777216 {
		bl.context_restore(ctx.bl_ctx, &ctx.cookie)
	} else {
		bl.context_save(ctx.bl_ctx, &ctx.cookie)
		bl.context_clip_to_rect_i(
			ctx.bl_ctx,
			&bl.RectI {
				x = cmd.rect.x * ctx.scale,
				y = (ctx.render_height - (cmd.rect.y * ctx.scale + cmd.rect.h * ctx.scale)),
				w = cmd.rect.w * ctx.scale,
				h = cmd.rect.h * ctx.scale,
			},
		)
	}
}

/*
	UI Logic 
*/

u8_slider :: proc(ctx: ^mu.Context, val: ^u8, lo, hi: u8) -> (res: mu.Result_Set) {
	mu.push_id(ctx, uintptr(val))

	@(static) tmp: mu.Real
	tmp = mu.Real(val^)
	res = mu.slider(ctx, &tmp, mu.Real(lo), mu.Real(hi), 0, "%.0f", {.ALIGN_CENTER})
	val^ = u8(tmp)
	mu.pop_id(ctx)
	return
}

write_log :: proc(ctx: ^Context, str: string) {
	ctx.log_buf_len += copy(ctx.log_buf[ctx.log_buf_len:], str)
	ctx.log_buf_len += copy(ctx.log_buf[ctx.log_buf_len:], "\n")
	ctx.log_buf_updated = true
}

read_log :: proc(ctx: ^Context) -> string {
	return string(ctx.log_buf[:ctx.log_buf_len])
}

reset_log :: proc(ctx: ^Context) {
	ctx.log_buf_updated = true
	ctx.log_buf_len = 0
}

all_windows :: proc(ctx: ^Context) {
	@(static) opts := mu.Options{.NO_CLOSE}

	if mu.window(ctx.mu_ctx, "Demo Window", {40, 40, 300, 500}, opts) {
		if .ACTIVE in mu.header(ctx.mu_ctx, "Window Info") {
			win := mu.get_current_container(ctx.mu_ctx)
			mu.layout_row(ctx.mu_ctx, {54, -1}, 0)
			mu.label(ctx.mu_ctx, "Position:")
			mu.label(ctx.mu_ctx, fmt.tprintf("%d, %d", win.rect.x, win.rect.y))
			mu.label(ctx.mu_ctx, "Size:")
			mu.label(ctx.mu_ctx, fmt.tprintf("%d, %d", win.rect.w, win.rect.h))
		}

		if .ACTIVE in mu.header(ctx.mu_ctx, "Window Options") {
			mu.layout_row(ctx.mu_ctx, {120, 120, 120}, 0)
			for opt in mu.Opt {
				state := opt in opts
				if .CHANGE in mu.checkbox(ctx.mu_ctx, fmt.tprintf("%v", opt), &state) {
					if state {
						opts += {opt}
					} else {
						opts -= {opt}
					}
				}
			}
		}

		if .ACTIVE in mu.header(ctx.mu_ctx, "Test Buttons", {.EXPANDED}) {
			mu.layout_row(ctx.mu_ctx, {86, -110, -1})
			mu.label(ctx.mu_ctx, "Test buttons 1:")
			if .SUBMIT in mu.button(ctx.mu_ctx, "Button 1") {write_log(ctx, "Pressed button 1")}
			if .SUBMIT in mu.button(ctx.mu_ctx, "Button 2") {write_log(ctx, "Pressed button 2")}
			mu.label(ctx.mu_ctx, "Test buttons 2:")
			if .SUBMIT in mu.button(ctx.mu_ctx, "Button 3") {write_log(ctx, "Pressed button 3")}
			if .SUBMIT in mu.button(ctx.mu_ctx, "Button 4") {write_log(ctx, "Pressed button 4")}
		}

		if .ACTIVE in mu.header(ctx.mu_ctx, "Tree and Text", {.EXPANDED}) {
			mu.layout_row(ctx.mu_ctx, {140, -1})
			mu.layout_begin_column(ctx.mu_ctx)
			if .ACTIVE in mu.treenode(ctx.mu_ctx, "Test 1") {
				if .ACTIVE in mu.treenode(ctx.mu_ctx, "Test 1a") {
					mu.label(ctx.mu_ctx, "Hello")
					mu.label(ctx.mu_ctx, "world")
				}
				if .ACTIVE in mu.treenode(ctx.mu_ctx, "Test 1b") {
					if .SUBMIT in
					   mu.button(ctx.mu_ctx, "Button 1") {write_log(ctx, "Pressed button 1")}
					if .SUBMIT in
					   mu.button(ctx.mu_ctx, "Button 2") {write_log(ctx, "Pressed button 2")}
				}
			}
			if .ACTIVE in mu.treenode(ctx.mu_ctx, "Test 2") {
				mu.layout_row(ctx.mu_ctx, {53, 53})
				if .SUBMIT in
				   mu.button(ctx.mu_ctx, "Button 3") {write_log(ctx, "Pressed button 3")}
				if .SUBMIT in
				   mu.button(ctx.mu_ctx, "Button 4") {write_log(ctx, "Pressed button 4")}
				if .SUBMIT in
				   mu.button(ctx.mu_ctx, "Button 5") {write_log(ctx, "Pressed button 5")}
				if .SUBMIT in
				   mu.button(ctx.mu_ctx, "Button 6") {write_log(ctx, "Pressed button 6")}
			}
			if .ACTIVE in mu.treenode(ctx.mu_ctx, "Test 3") {
				@(static) checks := [3]bool{true, false, true}
				mu.checkbox(ctx.mu_ctx, "Checkbox 1", &checks[0])
				mu.checkbox(ctx.mu_ctx, "Checkbox 2", &checks[1])
				mu.checkbox(ctx.mu_ctx, "Checkbox 3", &checks[2])

			}
			mu.layout_end_column(ctx.mu_ctx)

			mu.layout_begin_column(ctx.mu_ctx)
			mu.layout_row(ctx.mu_ctx, {-1})
			mu.text(
				ctx.mu_ctx,
				"Lorem ipsum dolor sit amet, consectetur adipiscing " +
				"elit. Maecenas lacinia, sem eu lacinia molestie, mi risus faucibus " +
				"ipsum, eu varius magna felis a nulla.",
			)
			mu.layout_end_column(ctx.mu_ctx)
		}

		if .ACTIVE in mu.header(ctx.mu_ctx, "Background Colour", {.EXPANDED}) {
			mu.layout_row(ctx.mu_ctx, {-78, -1}, 68)
			mu.layout_begin_column(ctx.mu_ctx)
			{
				mu.layout_row(ctx.mu_ctx, {46, -1}, 0)
				mu.label(ctx.mu_ctx, "Red:"); u8_slider(ctx.mu_ctx, &ctx.bg.r, 0, 255)
				mu.label(ctx.mu_ctx, "Green:"); u8_slider(ctx.mu_ctx, &ctx.bg.g, 0, 255)
				mu.label(ctx.mu_ctx, "Blue:"); u8_slider(ctx.mu_ctx, &ctx.bg.b, 0, 255)
				mu.label(ctx.mu_ctx, "Alpha:"); u8_slider(ctx.mu_ctx, &ctx.bg.a, 0, 255)
			}
			mu.layout_end_column(ctx.mu_ctx)

			r := mu.layout_next(ctx.mu_ctx)
			mu.draw_rect(ctx.mu_ctx, r, ctx.bg)
			mu.draw_box(ctx.mu_ctx, mu.expand_rect(r, 1), ctx.mu_ctx.style.colors[.BORDER])
			mu.draw_control_text(
				ctx.mu_ctx,
				fmt.tprintf("#%02x%02x%02x", ctx.bg.r, ctx.bg.g, ctx.bg.b),
				r,
				.TEXT,
				{.ALIGN_CENTER},
			)
		}
	}

	if mu.window(ctx.mu_ctx, "Log Window", {350, 40, 300, 200}, opts) {
		mu.layout_row(ctx.mu_ctx, {-1}, -28)
		mu.begin_panel(ctx.mu_ctx, "Log")
		mu.layout_row(ctx.mu_ctx, {-1}, -1)
		mu.text(ctx.mu_ctx, read_log(ctx))
		if ctx.log_buf_updated {
			panel := mu.get_current_container(ctx.mu_ctx)
			panel.scroll.y = panel.content_size.y
			ctx.log_buf_updated = false
		}
		mu.end_panel(ctx.mu_ctx)

		@(static) buf: [128]byte
		@(static) buf_len: int
		submitted := false
		mu.layout_row(ctx.mu_ctx, {-70, -1})
		if .SUBMIT in mu.textbox(ctx.mu_ctx, buf[:], &buf_len) {
			mu.set_focus(ctx.mu_ctx, ctx.mu_ctx.last_id)
			submitted = true
		}
		if .SUBMIT in mu.button(ctx.mu_ctx, "Submit") {
			submitted = true
		}
		if submitted {
			write_log(ctx, string(buf[:buf_len]))
			buf_len = 0
		}
	}

	if mu.window(ctx.mu_ctx, "Style Window", {350, 250, 300, 240}) {
		@(static) colors := [mu.Color_Type]string {
			.TEXT         = "text",
			.BORDER       = "border",
			.WINDOW_BG    = "window bg",
			.TITLE_BG     = "title bg",
			.TITLE_TEXT   = "title text",
			.PANEL_BG     = "panel bg",
			.BUTTON       = "button",
			.BUTTON_HOVER = "button hover",
			.BUTTON_FOCUS = "button focus",
			.BASE         = "base",
			.BASE_HOVER   = "base hover",
			.BASE_FOCUS   = "base focus",
			.SCROLL_BASE  = "scroll base",
			.SCROLL_THUMB = "scroll thumb",
			.SELECTION_BG = "selection bg",
		}

		sw := i32(f32(mu.get_current_container(ctx.mu_ctx).body.w) * 0.14)
		mu.layout_row(ctx.mu_ctx, {80, sw, sw, sw, sw, -1})
		for label, col in colors {
			mu.label(ctx.mu_ctx, label)
			u8_slider(ctx.mu_ctx, &ctx.mu_ctx.style.colors[col].r, 0, 255)
			u8_slider(ctx.mu_ctx, &ctx.mu_ctx.style.colors[col].g, 0, 255)
			u8_slider(ctx.mu_ctx, &ctx.mu_ctx.style.colors[col].b, 0, 255)
			u8_slider(ctx.mu_ctx, &ctx.mu_ctx.style.colors[col].a, 0, 255)
			mu.draw_rect(ctx.mu_ctx, mu.layout_next(ctx.mu_ctx), ctx.mu_ctx.style.colors[col])
		}
	}
}

