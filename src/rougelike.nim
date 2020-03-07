import libtcod, types, constants

proc alt(key: Key): bool = key.lalt or key.ralt
proc consoleToggleFullscreen() = consoleSetFullscreen(not consoleIsFullscreen())


proc handle_keys(game: var Game): bool =
  ## updates the player coordinates and returns if the game should quit
  let key: Key = consoleWaitForKeypress(true)
  case key.vk:
  of K_ENTER:
    if key.alt: consoleToggleFullscreen()
  of K_ESCAPE: return true
  of K_UP: game.player.move(0, -1, game)
  of K_DOWN: game.player.move(0, 1, game)
  of K_LEFT: game.player.move(-1, 0, game)
  of K_RIGHT: game.player.move(1, 0, game)
  else:
    ## don't do anything otherwise
  false

proc init(width, height: cint): Game =
  consoleSetCustomFont(
    fontFile = "resources/arial10x10.png",
    flags = FONT_LAYOUT_TCOD or FONT_TYPE_GREYSCALE
  )
  consoleInitRoot(width, height, "Nim/rougelike")
  sysSetFps(fpsLimit)
  initGame(width, height)

proc mainLoop(game: var Game) =
  while not consoleIsWindowClosed():
    game.render()
    if handle_keys(game):
      break
  if consoleIsFullscreen():
    consoleSetFullscreen(false)

when isMainModule:
  ## the main entry point
  var game = init(widthScreen, heightScreen)

  game.mainLoop()
