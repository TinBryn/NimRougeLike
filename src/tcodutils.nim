import libtcod

#
proc consoleToggleFullscreen*() =
  ## switches the root console to fullscreen or windowed
  consoleSetFullscreen(not consoleIsFullscreen())

#
proc alt*(key: Key): bool =
  ## detects if either alt key is press
  key.lalt or key.ralt
