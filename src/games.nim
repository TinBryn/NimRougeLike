from libtcod import
  Console, Color, consolePutChar, consoleSetDefaultForeground, consoleClear,
  BKGND_NONE, BKGND_SET, consoleSetCharBackground, consoleNew,
  WHITE, YELLOW, consoleBlit, consoleFlush

import entities, maps

const
  ## map properties
  widthMap: cint = 80
  heightMap: cint = 45

  ## general properties
  root: Console = nil

type
  Game* = object
    ## the state of the current game
    buffer: Console
    objects: seq[Entity]
    map*: Map


proc render*(game: var Game) =
  ## draws the map and then the objects on top
  game.buffer.consoleClear()
  game.map.draw(game.buffer)

  for obj in game.objects:
    obj.draw(game.buffer)

  game.buffer.consoleBlit(0, 0, widthMap, heightMap, root, 0, 0, 1.0, 1.0)
  consoleFlush()

proc player*(game: var Game): var Entity = game.objects[0]

proc init*(td: typedesc[Game], width, height: cint): Game =
  ## sets up the main console
  result = Game(
    buffer: consoleNew(width, height),
    objects: @[
      Entity.init(width div 2, height div 2, '@', WHITE),
      Entity.init(width div 2 - 5, height div 2, '@', YELLOW)
    ],
    map: Map.init(widthMap, heightMap)
  )

  result.map[30, 22] = Tile.wall
  result.map[50, 22] = Tile.wall
