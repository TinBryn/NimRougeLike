import libtcod except Map

import entities, maps

const
  ## map properties
  widthMap = 80
  heightMap = 45

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
      Entity.init(25, 22, '@', WHITE),
      Entity.init(55, 22, '@', YELLOW)
    ],
    map: make_map(widthMap, heightMap)
  )

  
