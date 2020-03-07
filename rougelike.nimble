# Package

version       = "0.1.0"
author        = "Kieran Griffiths"
description   = "A practice rougelike game"
license       = "MIT"
srcDir        = "src"
bin           = @["rougelike"]


# Dependencies

requires "nim >= 1.0.0"
requires "libtcod_nim >= 1.112.0"


# Tasks

task debug, "":
  exec "nim c --outdir:debug --linedir:on --debuginfo:on --debugger:native src/rougelike.nim"
