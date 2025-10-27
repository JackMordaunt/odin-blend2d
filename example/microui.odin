package main

import "core:fmt"
import "core:thread"

import bl "../binding"
import mu "vendor:microui"
import sdl "vendor:sdl3"

//todo need windowing lib
// SDL3
// tigr (neess bindings)
// glfw
//todo user input
// font loading
Context :: struct {
	mu_ctx:          ^mu.Context,
	bl_ctx:          ^bl.ContextCore,
	log_buf:         [1 << 16]byte,
	log_buf_len:     int,
	log_buf_updated: bool,
	bg:              mu.Color,
}

context_init :: proc(ctx: ^Context) {
	ctx.bl_ctx = new(bl.ContextCore)
	bl.context_init(ctx.bl_ctx)
	ctx.mu_ctx = new(mu.Context)
	mu.init(ctx.mu_ctx)
}

main :: proc() {
	ctx: Context

	context_init(&ctx)

	assert(sdl.Init({.VIDEO, .EVENTS}))

	window := sdl.CreateWindow(
		"microui - blend2d - sdl3",
		800,
		800,
		{.HIGH_PIXEL_DENSITY, .RESIZABLE},
	)

	// NOTE: mus tbe requeried if window is resized.
	surface := sdl.GetWindowSurface(window)

	print_sdl_pixel_format(surface.format)

	// img: bl.ImageCore

	// bl.image_init(&img)
	// bl.image_create(&img, 480, 480, .PRGB32)

	// for {
	// 	defer thread.yield()
	// 	mu.begin(ctx.mu_ctx)
	// 	all_windows(&ctx)
	// 	mu.end(ctx.mu_ctx)
	// 	render(&ctx)
	// }
}

render :: proc(ctx: ^Context) {
	bl.context_clear_all(ctx.bl_ctx)
	defer bl.context_end(ctx.bl_ctx)

	// cmd_backing is the iteration context, since mu.next_command is implemented 	
	// via pointer math.
	cmd_backing: ^mu.Command
	for var in mu.next_command_iterator(ctx.mu_ctx, &cmd_backing) {
		switch cmd in var {
		case ^mu.Command_Text:
		case ^mu.Command_Icon:
		case ^mu.Command_Rect:
			rect := cast(bl.RectI)(cmd.rect)
			bl.context_fill_rect_i_rgba32(ctx.bl_ctx, &rect, transmute(u32)(cmd.color))
		case ^mu.Command_Clip:
		case ^mu.Command_Jump:
		}
	}

}


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

	if mu.window(ctx.mu_ctx, "Demo Window", {40, 40, 300, 450}, opts) {
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

print_sdl_pixel_format :: proc(pf: sdl.PixelFormat) {
	switch pf {
	case .UNKNOWN:
		fmt.println("UNKNOWN")
	case .INDEX1LSB:
		fmt.println("INDEX1LSB")
	case .INDEX1MSB:
		fmt.println("INDEX1MSB")
	case .INDEX2LSB:
		fmt.println("INDEX2LSB")
	case .INDEX2MSB:
		fmt.println("INDEX2MSB")
	case .INDEX4LSB:
		fmt.println("INDEX4LSB")
	case .INDEX4MSB:
		fmt.println("INDEX4MSB")
	case .INDEX8:
		fmt.println("INDEX8")
	case .RGB332:
		fmt.println("RGB332")
	case .XRGB4444:
		fmt.println("XRGB4444")
	case .XBGR4444:
		fmt.println("XBGR4444")
	case .XRGB1555:
		fmt.println("XRGB1555")
	case .XBGR1555:
		fmt.println("XBGR1555")
	case .ARGB4444:
		fmt.println("ARGB4444")
	case .RGBA4444:
		fmt.println("RGBA4444")
	case .ABGR4444:
		fmt.println("ABGR4444")
	case .BGRA4444:
		fmt.println("BGRA4444")
	case .ARGB1555:
		fmt.println("ARGB1555")
	case .RGBA5551:
		fmt.println("RGBA5551")
	case .ABGR1555:
		fmt.println("ABGR1555")
	case .BGRA5551:
		fmt.println("BGRA5551")
	case .RGB565:
		fmt.println("RGB565")
	case .BGR565:
		fmt.println("BGR565")
	case .RGB24:
		fmt.println("RGB24")
	case .BGR24:
		fmt.println("BGR24")
	case .XRGB8888:
		fmt.println("XRGB8888")
	case .RGBX8888:
		fmt.println("RGBX8888")
	case .XBGR8888:
		fmt.println("XBGR8888")
	case .BGRX8888:
		fmt.println("BGRX8888")
	case .ARGB8888:
		fmt.println("ARGB8888")
	case .RGBA8888:
		fmt.println("RGBA8888")
	case .ABGR8888:
		fmt.println("ABGR8888")
	case .BGRA8888:
		fmt.println("BGRA8888")
	case .XRGB2101010:
		fmt.println("XRGB2101010")
	case .XBGR2101010:
		fmt.println("XBGR2101010")
	case .ARGB2101010:
		fmt.println("ARGB2101010")
	case .ABGR2101010:
		fmt.println("ABGR2101010")
	case .RGB48:
		fmt.println("RGB48")
	case .BGR48:
		fmt.println("BGR48")
	case .RGBA64:
		fmt.println("RGBA64")
	case .ARGB64:
		fmt.println("ARGB64")
	case .BGRA64:
		fmt.println("BGRA64")
	case .ABGR64:
		fmt.println("ABGR64")
	case .RGB48_FLOAT:
		fmt.println("RGB48_FLOAT")
	case .BGR48_FLOAT:
		fmt.println("BGR48_FLOAT")
	case .RGBA64_FLOAT:
		fmt.println("RGBA64_FLOAT")
	case .ARGB64_FLOAT:
		fmt.println("ARGB64_FLOAT")
	case .BGRA64_FLOAT:
		fmt.println("BGRA64_FLOAT")
	case .ABGR64_FLOAT:
		fmt.println("ABGR64_FLOAT")
	case .RGB96_FLOAT:
		fmt.println("RGB96_FLOAT")
	case .BGR96_FLOAT:
		fmt.println("BGR96_FLOAT")
	case .RGBA128_FLOAT:
		fmt.println("RGBA128_FLOAT")
	case .ARGB128_FLOAT:
		fmt.println("ARGB128_FLOAT")
	case .BGRA128_FLOAT:
		fmt.println("BGRA128_FLOAT")
	case .ABGR128_FLOAT:
		fmt.println("ABGR128_FLOAT")
	case .YV12:
		fmt.println("YV12")
	case .IYUV:
		fmt.println("IYUV")
	case .YUY2:
		fmt.println("YUY2")
	case .UYVY:
		fmt.println("UYVY")
	case .YVYU:
		fmt.println("YVYU")
	case .NV12:
		fmt.println("NV12")
	case .NV21:
		fmt.println("NV21")
	case .P010:
		fmt.println("P010")
	case .EXTERNAL_OES:
		fmt.println("EXTERNAL_OES")
	case .MJPG:
		fmt.println("MJPG")
	}
}

