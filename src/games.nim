import libtcod except Map
import entities, levels, generators

const
  ## map properties
  widthMap = 80
  heightMap = 50

  ## general properties
  root: Console = nil

type
  Game* = object
    ## the state of the current game
    buffer: Console
    objects: seq[Entity]
    interactive: Natural
    level*: Level
    fov: libtcod.Map

#
proc render*(game: var Game) =
  ## draws the map and then the objects on top
  game.buffer.consoleClear()
  game.level.draw(game.buffer)

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
      Entity.init(0, 0, '@', WHITE)
    ],
    interactive: 0,
    fov: mapNew(width, height)
  )
  generators.init()
  result.level = make_level(width, height, result.player)
  for x,y in pairs(result.level):
    ##
    
#
proc initTest*(td: typedesc[Game], width, height: cint): Game =
  result = Game(
    buffer: consoleNew(width, height),
    objects: @[Entity.init(30, 30, '@', WHITE)],
    level: test_collision_level(width, height)
  )
