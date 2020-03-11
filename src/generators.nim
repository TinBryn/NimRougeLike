import random, sequtils
import maps, entities

const
  roomMaxSize = 10
  roomMinSize = 6
  maxRooms = 30


# random number generator
proc init*() =
  randomize()

#
proc test_collition_map*(width, height: Natural): Map =
  ##
  result = Map.init(width, height, Tile.wall)

  let room1 = Rect.init(20, 20, 11, 20)
  let room2 = Rect.init(31, 10, 19, 20)
  result.create_room(room1)
  if room2.intersectsWith(room1):
    ##
    result.create_room(room1, Tile.error())
    result.create_room(room2, Tile.error())
  else:
    ##
    result.create_room(room1, Tile.empty())
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
      failed = rooms.anyIt(it.intersectsWith(newRoom))
    
    if failed:
      ##
      # result.create_room(newRoom, Tile.error())
    else:
      ##
      result.create_room(newRoom)
      let (newX, newY) = newRoom.center()
      if  rooms.len == 0:
        player.move(newX, newY)
      else:
        ##
        let (prevX, prevY) = rooms[^1].center
        if rand(0..1) == 1:
          result.create_h_tunnel(prevX, newX, prevY)
          result.create_v_tunnel(newX, prevY, newY)
        else:
          result.create_v_tunnel(prevX, prevY, newY)
          result.create_h_tunnel(prevX, newX, newY)
      rooms.add(newRoom)

      