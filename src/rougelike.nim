import libtcod

const
  screenWidth: cint = 80
  screenHeight: cint = 50
  limitFPS: cint = 20

type
  Tcod = object
    root: Console

when isMainModule:
  ##the main entry point
  consoleSetCustomFont(
    fontFile = "resources/arial10x10.png",
    flags = FONT_LAYOUT_TCOD or FONT_TYPE_GREYSCALE
  )

  consoleInitRoot(
    w = screenWidth,
    h = screenHeight,
    title = "Nim/libtcod tutorial")
  
  var tcod = Tcod(root: consoleNew(screenWidth, screenHeight))

  sysSetFps(limitFPS)

  while not consoleIsWindowClosed():
    tcod.root.consoleSetDefaultForeground(WHITE)
    tcod.root.consoleClear()
    tcod.root.consolePutChar(1, 1, '@', BKGND_NONE)
    consoleFlush()
    discard consoleWaitForKeypress(false)
