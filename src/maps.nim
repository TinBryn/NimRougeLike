import libtcod, sequtils

const
  wallDark* = colorRGB(0, 0, 100)
  groundDark* = colorRGB(50, 50, 150)
  groundError* = colorRGB(150, 50, 50)

type
  TileFlags* = enum
    blockSight,
    blocked,
    intersect
  
  Tile* = object
    flags*: set[TileFlags]
  
  Map* = object
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
  self.l <= other.r and
  self.r >= other.l and
  self.t <= other.b and
  self.b >= other.t

#
iterator indicies*(rect: Rect): tuple[x, y: int] =
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
template init*(td: typedesc[Map], w, h: Natural, init: untyped): Map =
  ## creates a new map of empty tiles with a width and height
  Map(
    shape: (w, h),
    data: newSeqWith(w * h, init)
  )

#
proc `[]`*(map: Map, x, y: Natural): Tile =
  ## accesses a tile in the map
  map.data[x + y * map.shape.w]
#
proc `[]=`*(map: var Map, x, y: Natural, tile: Tile) =
  ## assigns a tile in the map to a new tile
  map.data[x + y * map.shape.w] = tile

#
iterator indicies*(map: Map): tuple[x, y: int] =
  ## scans over each x, y tuple in the map
  for x in 0..<map.shape.w:
    for y in 0..<map.shape.h:
      yield (x, y)

#
proc draw*(map: Map, con: Console) =
  ## draws this map to the console
  for x, y in map.indicies:
    if  intersect in map[x, y].flags:
      ##
      consoleSetCharBackground(con, x.int32, y.int32, groundError, BKGND_SET)
    else: 
      if blockSight in map[x, y].flags:
        consoleSetCharBackground(con, x.int32, y.int32, wallDark, BKGND_SET)
      else:
        consoleSetCharBackground(con, x.int32, y.int32, groundDark, BKGND_SET)

#
template create_room*(map: var Map, room: Rect, tile: untyped) =
  ## make all the tiles in the room passable
  for x, y in room.indicies:
    map[x, y] = tile

#
proc create_room*(map: var Map, room: Rect) =
  create_room(map, room, Tile.empty)

#
proc create_h_tunnel*(map: var Map, l, r, y: int) =
  ## horizontal tunnel
  for x in l..r:
    map[x, y] = Tile.empty
#
proc create_v_tunnel*(map: var Map, x, t, b: int) =
  ## horizontal tunnel
  for y in t..b:
    map[x, y] = Tile.empty
