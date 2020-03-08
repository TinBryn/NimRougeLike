import libtcod, sequtils

const
  wallDark* = colorRGB(0, 0, 100)
  groundDark* = colorRGB(50, 50, 150)

type
  TileFlags* = enum
    blockSight,
    blocked
  
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
  Rect(l: x, t: y, r: x+w, b: y+h)

#
iterator indicies*(rect: Rect): tuple[x, y: int] =
  ## all x,y pairs inside a rectangle
  for x in rect.l..<rect.r:
    for y in rect.t..<rect.b:
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

proc init*(td: typedesc[Map], w, h: Natural): Map =
  ## creates a new map of empty tiles with a width and height
  Map(
    shape: (w, h),
    data: newSeqWith(w * h, Tile.wall)
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
    if blockSight in map[x, y].flags:
      consoleSetCharBackground(con, x.int32, y.int32, wallDark, BKGND_SET)
    else:
      consoleSetCharBackground(con, x.int32, y.int32, groundDark, BKGND_SET)

#
proc create_room*(map: var Map, room: Rect) =
  ## make all the tiles in the room passable
  for x, y in room.indicies:
    map[x, y] = Tile.empty

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

#
proc make_map*(w, h: Natural): Map =
  ## makes a map with 2 rooms
  result = Map.init(w, h)
  let room1 = Rect.init(20, 15, 10, 15)
  let room2 = Rect.init(50, 15, 10, 15)
  result.create_room(room1)
  result.create_room(room2)
  result.create_h_tunnel(25, 55, 22)
