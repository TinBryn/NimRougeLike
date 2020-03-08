import libtcod, maps

type
  Entity* = object
    x, y: int
    symbol: char
    color: Color

#
proc init*(td: typedesc[Entity], x, y: int, sym: char, col: Color): Entity =
  ## initialises a new entity with position, symbol and color
  Entity(x: x, y: y, symbol: sym, color: col)

#
proc move*(self: var Entity, h, v: int) =
  ## moves the entity by a specified displacement
  inc(self.x, h)
  inc(self.y, v)

#
proc move*(self: var Entity, h, v: int, map: maps.Map) =
  ## checks the map if the entity can move and if so moves
  let
    newx = self.x + h
    newy = self.y + v
  if newx in 0..<map.shape.w and newy in 0..<map.shape.h and blocked notin map[newx, newy].flags:
    self.x = newx
    self.y = newy
#
proc draw*(self: Entity, con: Console) =
  ## renders this entity to a console
  consoleSetDefaultForeground(con, self.color)
  consolePutChar(con, int32(self.x), int32(self.y), self.symbol, BKGND_NONE)
