import libtcod except Map

import entities, maps, generators

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
    interactive: Natural
    map*: Map

#
proc render*(game: var Game) =
  ## draws the map and then the objects on top
  game.buffer.consoleClear()
  game.map.draw(game.buffer)

  for obj in game.objects:
    obj.draw(game.buffer)

  consoleBlit(
    game.buffer,          #source
    0, 0,                 #source position
    widthMap, heightMap,  #source size
    root,                 #destination
    0, 0,                 #destination position
    1.0, 1.0              #blending
  )
  consoleFlush()

#
proc player*(game: var Game): var Entity =
  ## returns the player entity
  game.objects[game.interactive]

#
proc init*(td: typedesc[Game], width, height: cint): Game =
  ## sets up the main console
  result = Game(
    buffer: consoleNew(width, height),
    objects: @[
      Entity.init(25, 22, '@', WHITE),
      Entity.init(55, 22, '@', YELLOW)
    ],
    interactive: 0
  )
  result.map = make_map(widthMap, heightMap, result.player)

#
proc initTest*(td: typedesc[Game], width, height: cint): Game =
  result = Game(
    buffer: consoleNew(width, height),
    objects: @[Entity.init(30, 30, '@', WHITE)],
    map: test_collition_map(width, height)
  )
