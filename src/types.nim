import libtcod, constants, sequtils

type
  Object* = object
    ## a general game object
    x, y: cint
    c: char
    colour: Color
  
  Tile = object
    blocked, blockSight: bool
  
  Map = seq[seq[Tile]]

  Game* = object
    ## the state of the current game
    buffer: Console
    objects: seq[Object]
    map: Map

proc initObject*(x, y: cint, char: char, colour: Color): Object =
  Object(x: x, y: y, c: char, colour: colour)

proc move*(self: var Object, x, y: cint, game: Game) =
  let newx = self.x + x
  let newy = self.y + y
  if newx in 0..<widthMap and newy in 0..<heightMap and not game.map[newx][newy].blocked:
    self.x = newx
    self.y = newy

proc draw*(self: Object, con: Console) =
  ## renders this object onto the console
  consoleSetDefaultForeground(con, self.colour)
  consolePutChar(con, self.x, self.y, self.c, BKGND_NONE)

proc empty*(td: typedesc[Tile]): Tile = Tile(blocked: false, blockSight: false)
proc wall*(td: typedesc[Tile]): Tile = Tile(blocked: true, blockSight: true)

proc newMap*(width, height: cint): Map =
  newSeqWith(width, newSeqWith(height, Tile.empty))

proc render*(game: var Game) =
  ## draws the map and then the objects on top
  game.buffer.consoleClear()
  for y in 0..<heightMap:
    for x in 0..<widthMap:
      let wall = game.map[x][y].blockSight
      if wall:
        consoleSetCharBackground(game.buffer, x, y, wallDark, BKGND_SET)
      else:
        consoleSetCharBackground(game.buffer, x, y, groundDark, BKGND_SET)

  for obj in game.objects:
    obj.draw(game.buffer)

  game.buffer.consoleBlit(0, 0, widthMap, heightMap, root, 0, 0, 1.0, 1.0)
  consoleFlush()

proc player*(game: var Game): var Object = game.objects[0]

proc initGame*(width, height: cint): Game =
  ## sets up the main console
  result = Game(
    buffer: consoleNew(width, height),
    objects: @[
      initObject(width div 2, height div 2, '@', WHITE),
      initObject(width div 2 - 5, height div 2, '@', YELLOW)
    ],
    map: newMap(widthMap, heightMap)
  )

  result.map[30][22] = Tile.wall
  result.map[50][22] = Tile.wall
