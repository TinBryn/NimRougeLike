import libtcod, games, entities

const
  ## screen dimensions
  widthScreen*: cint = 80
  heightScreen*: cint = 50
  
  ## map properties
  widthMap*: cint = 80
  heightMap*: cint = 45

  ## general properties
  fpsLimit*: cint = 60
  root*: Console = nil

#
proc alt(key: Key): bool =
  ## detects if either alt key is press
  key.lalt or key.ralt

#
proc consoleToggleFullscreen() =
  ## switches the root console to fullscreen or windowed
  consoleSetFullscreen(not consoleIsFullscreen())

#
proc handle_keys(game: var Game): bool =
  ## updates the player coordinates and returns if the game should quit
  let key: Key = consoleWaitForKeypress(true)
  case key.vk:
  of K_ENTER:
    if key.alt: consoleToggleFullscreen()
  of K_ESCAPE: return true
  of K_UP: game.player.move(0, -1, game.map)
  of K_DOWN: game.player.move(0, 1, game.map)
  of K_LEFT: game.player.move(-1, 0, game.map)
  of K_RIGHT: game.player.move(1, 0, game.map)
  else:
    ## don't do anything otherwise
  false

#
proc init(width, height: cint): Game =
  ## loads up the console and creates a game
  consoleSetCustomFont(
    fontFile = "resources/arial10x10.png",
    flags = FONT_LAYOUT_TCOD or FONT_TYPE_GREYSCALE
  )
  consoleInitRoot(width, height, "Nim/rougelike")
  sysSetFps(fpsLimit)
  Game.init(width, height)

#
proc mainLoop(game: var Game) =
  ## loops the game handling input and rendering to game
  while not consoleIsWindowClosed():
    game.render()
    if handle_keys(game):
      break
  if consoleIsFullscreen():
    consoleSetFullscreen(false)

#
when isMainModule:
  ## the main entry point
  var game = init(widthScreen, heightScreen)
  game.mainLoop()
