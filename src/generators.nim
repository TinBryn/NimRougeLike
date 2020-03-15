import random, sequtils
import levels, entities

const
  roomMaxSize = 10
  roomMinSize = 6
  maxRooms = 30


# random number generator
proc init*() =
  randomize()

#
proc test_collision_level*(width, height: Natural): Level =
  ##
  result = Level.init(width, height, Tile.wall)

  let room1 = Rect.init(20, 20, 11, 20)
  let room2 = Rect.init(40, 10, 19, 20)
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
proc makeLevel*(width, height: Natural, player: var Entity): Level =
  ## makes a randomly generated level of connected rooms

  # make a solid level
  result = Level.init(width, height, Tile.wall)
  # place to store rooms
  var rooms: seq[Rect] = @[]
  
  for _ in 0..<maxRooms:
    let
      w = rand(roomMinSize..roomMaxSize)
      h = rand(roomMinSize..roomMaxSize)
      x = rand(1..width - w - 2)
      y = rand(1..height - h - 2)
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

      