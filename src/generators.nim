import random, sequtils
import libtcod except Map
import maps, entities

const
  roomMaxSize = 10
  roomMinSize = 6
  maxRooms = 30


# random number generator
randomize()

#
proc test_collition_map*(width, height: Natural): Map =
  ##
  result = Map.init(width, height, Tile.wall)

  let room1 = Rect.init(20, 20, 11, 20)
  result.create_room(room1)
  let room2 = Rect.init(30, 10, 20, 20)
  if room2.intersectsWith(room1):
    ##
    result.create_room(room2, Tile.error())
  else:
    ##
    result.create_room(room2, Tile.empty())

#
proc makeMap*(width, height: Natural, player: var Entity): Map =
  ## makes a randomly generated map of connected rooms

  # make a solid map
  result = Map.init(width, height, Tile.wall)
  # place to store rooms
  var rooms: seq[Rect] = @[]
  
  for _ in 0..<maxRooms:
    let
      w = rand(roomMinSize..roomMaxSize)
      h = rand(roomMinSize..roomMaxSize)
      x = rand(0..width - w - 1)
      y = rand(0..height - h - 1)
      newRoom = Rect.init(x, y, w, h)
    let
      failed = rooms.any(proc (room: Rect): bool = room.intersectsWith(newRoom))
    
    if not failed:
      result.create_room(newRoom)
      let (newX, newY) = newRoom.center()
      if  rooms.len == 0:
        player = Entity.init(newX, newY, '@', WHITE)