import macros

const LIBTCOD_NAME* = 
  when defined(linux):
    "libtcod.so(|.1.0.12)"
  elif defined(MacOSX):
    "libtcod.dylib"
  else:
    "libtcod.dll"

macro importtcod*(name: string, p: untyped): untyped =
  ##
  result = newStmtList(p)
  result[0][4] = parseStmt("{.cdecl, dynLib: LIBTCOD_NAME, importc:\"" & $name & "\".}")[0]
