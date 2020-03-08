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
    data: newSeqWith(w * h, Tile.empty)
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
