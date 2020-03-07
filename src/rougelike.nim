import libtcod

proc clear(con: Console) = consoleClear(con)
proc putChar(con: Console, w, h: cint, c: char, flag: BkGndFlag) = consolePutChar(con, w, h, c, flag)
proc alt(key: Key): bool = key.lalt or key.ralt
proc consoleToggleFullscreen() = consoleSetFullscreen(not consoleIsFullscreen())

const
  width: cint = 80
  height: cint = 50
  fpsLimit: cint = 60
  root: Console = nil

type
  Player = object
    x, y: cint
  Game = object
    player: Player

proc move(player: var Player, x, y: cint) =
  player.x.inc x
  player.y.inc y

proc handle_keys(player: var Player): bool =
  ## updates the player coordinates and returns if the game should quit
  let key: Key = consoleWaitForKeypress(true)
  case key.vk:
  of K_ENTER:
    if key.alt: consoleToggleFullscreen()
  of K_ESCAPE: return true
  of K_UP: player.move(0, -1)
  of K_DOWN: player.move(0, 1)
  of K_LEFT: player.move(-1, 0)
  of K_RIGHT: player.move(1, 0)
  else:
    ## default
  false

proc render(game: var Game) =
  ## draws the current state to the console
  root.clear()
  root.putChar(game.player.x, game.player.y, '@', BKGND_NONE)
  consoleFlush()

proc init(): Game =
  ## sets up the main console
  consoleSetCustomFont(
    fontFile = "resources/arial10x10.png",
    flags = FONT_LAYOUT_TCOD or FONT_TYPE_GREYSCALE
  )
  consoleInitRoot(width, height, "Nim/rougelike")
  sysSetFps(fpsLimit)
  root.consoleSetDefaultForeground(WHITE)
  Game(player: Player(x: width div 2, y: height div 2))

proc mainLoop(game: var Game) =
  while not consoleIsWindowClosed():
    render(game)
    if handle_keys(game.player):
      break

when isMainModule:
  ## the main entry point
  var game = init()

  mainLoop(game)
