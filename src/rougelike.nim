import libtcod

proc clear(con: Console) = consoleClear(con)
proc putChar(con: Console, w, h: cint, c: char, flag: BkGndFlag) = consolePutChar(con, w, h, c, flag)

const
  width: cint = 80
  height: cint = 50
  fpsLimit: cint = 60
  root: Console = nil

proc init() =
  ## sets up the main console
  consoleSetCustomFont(
    fontFile = "resources/arial10x10.png",
    flags = FONT_LAYOUT_TCOD or FONT_TYPE_GREYSCALE
  )
  consoleInitRoot(width, height, "Nim/rougelike")
  sysSetFps(fpsLimit)

proc mainLoop() =
  root.consoleSetDefaultForeground(WHITE)
  while not consoleIsWindowClosed():
    root.clear()
    root.putChar(width div 2, height div 2, '@', BKGND_NONE)
    consoleFlush()
    discard consoleWaitForKeypress(false)

when isMainModule:
  ## the main entry point
  init()

  mainLoop()
