import tcod_define

type
  Color* {.bycopy.} = object
    r*, g*, b*: uint8

  ColorRGBA* {.bycopy.} = object
    r*, g*, b*, a*: uint8

proc colorRGB*(r, g, b: uint8): Color {.importtcod: "TCOD_color_RGB".}
proc colorHSV*(h, s, v: float32): Color {.importtcod: "TCOD_color_HSV".}

proc `==`*(a, b: Color): bool {.importtcod: "TCOD_color_equals".}
proc `+`*(a, b: Color): Color {.importtcod: "TCOD_color_add".}
proc `-`*(a, b: Color): Color {.importtcod: "TCOD_color_subtract".}
proc `*`*(a, b: Color): Color {.importtcod: "TCOD_color_multiply".}
proc `*`*(a: Color, b: float32): Color {.importtcod: "TCOD_color_multiply_scalar".}
proc `*`*(a: float32, b: Color): Color = b * a
proc h*(color: Color): float32 {.importtcod: "TCOD_color_get_hue".}
proc `h=`*(color: var Color, hue: float32) {.importtcod: "TCOD_color_set_hue".}
proc s*(color: Color): float32 {.importtcod: "TCOD_color_get_saturation".}
proc `s=`*(color: var Color, saturation: float32) {.importtcod: "TCOD_color_set_saturation".}
proc v*(color: Color): float32 {.importtcod: "TCOD_color_get_value".}
proc `v=`*(color: var Color, value: float32) {.importtcod: "TCOD_color_set_value".}
proc `h+=`*(color: var Color, hshift: float32) {.importtcod: "TCOD_color_shift_hue".}
