import sequtils, libtcod

const
  wallDark* = colorRGB(0, 0, 100)
  wallLight* = colorRGB(130, 110, 50)
  groundDark* = colorRGB(50, 50, 150)
  groundLight* = colorRGB(200, 180, 50)
  groundError* = colorRGB(150, 50, 50)

type
  TileFlags* = enum
    blockSight,
    blocked,
    intersect
  
  Tile* = object
    flags*: set[TileFlags]
  
  Level* = object
    shape*: tuple[w, h: Natural]
    data: seq[Tile]

  Rect* = object
    l, t, r, b: int

#
proc init*(td: typedesc[Rect], x, y, w, h: int): Rect =
  ## create a new rectangle with the top left corner and dimensions
  Rect(l: x, t: y, r: x+w-1, b: y+h-1)

#
proc center*(rect: Rect): tuple[x, y: int] =
  ## give the approximate center of a rectangle
  (
    (rect.l + rect.r) div 2,
    (rect.t + rect.b) div 2
  )

#
proc intersectsWith*(self: Rect, other: Rect): bool =
  ## returns whether 2 rectangles intersect
  self.l <= other.r + 1 and
  self.r >= other.l - 1 and
  self.t <= other.b + 1 and
  self.b >= other.t - 1

#
iterator pairs*(rect: Rect): tuple[x, y: int] =
  ## all x,y pairs inside a rectangle
  for x in rect.l..rect.r:
    for y in rect.t..rect.b:
      yield (x, y)

#
proc empty*(td: typedesc[Tile]): Tile =
  ## creates a new empty tile
  Tile(flags: {})

#
proc wall*(td: typedesc[Tile]): Tile =
  ## creates a new wall tile
  Tile(flags: {blockSight, blocked})

#
proc error*(td: typedesc[Tile]): Tile =
  Tile(flags: {intersect})

#
template init*(td: typedesc[Level], w, h: Natural, init: untyped): Level =
  ## creates a new level of empty tiles with a width and height
  Level(
    shape: (w, h),
    data: newSeqWith(w * h, init)
  )

#
proc `[]`*(level: Level, x, y: Natural): Tile =
  ## accesses a tile in the level
  level.data[x + y * level.shape.w]
#
proc `[]=`*(level: var Level, x, y: Natural, tile: Tile) =
  ## assigns a tile in the level to a new tile
  level.data[x + y * level.shape.w] = tile

#
iterator pairs*(level: Level): tuple[x, y: int] =
  ## scans over each x, y tuple in the level
  for x in 0..<level.shape.w:
    for y in 0..<level.shape.h:
      yield (x, y)

#
proc draw*(level: Level, con: Console) =
  ## draws this level to the console
  for x, y in level:
    if  intersect in level[x, y].flags:
      ##
      consoleSetCharBackground(con, x.int32, y.int32, groundError, BKGND_SET)
    else: 
      if blockSight in level[x, y].flags:
        consoleSetCharBackground(con, x.int32, y.int32, wallDark, BKGND_SET)
      else:
        consoleSetCharBackground(con, x.int32, y.int32, groundDark, BKGND_SET)

#
template create_room*(level: var Level, room: Rect, tile: untyped) =
  ## make all the tiles in the room passable
  for x, y in room:
    level[x, y] = tile

#
proc create_room*(level: var Level, room: Rect) =
  create_room(level, room, Tile.empty)

#
proc create_h_tunnel*(level: var Level, l, r, y: int) =
  ## horizontal tunnel
  for x in min(l,r)..max(l, r):
    level[x, y] = Tile.empty
#
proc create_v_tunnel*(level: var Level, x, t, b: int) =
  ## horizontal tunnel
  for y in min(t, b)..max(t, b):
    level[x, y] = Tile.empty
