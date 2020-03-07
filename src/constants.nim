import libtcod

const
  ## screen dimensions
  widthScreen*: cint = 80
  heightScreen*: cint = 50
  
  ## map properties
  widthMap*: cint = 80
  heightMap*: cint = 45

  wallDark* = colorRGB(0, 0, 100)
  groundDark* = colorRGB(50, 50, 150)

  ## general properties
  fpsLimit*: cint = 60
  root*: Console = nil
