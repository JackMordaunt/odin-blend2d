when ODIN_OS == .Windows {
	foreign import lib "blend2d.lib"
} else when ODIN_OS == .Darwin {
	foreign import lib "libblend2d.a"
} else when ODIN_OS == .Linux {
	foreign import lib "libblend2d.a"
}
