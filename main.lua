local sprites = require 'sprites'
local assets = require 'assets'

local state = {}

local tiles
function love.load()
  assets.register('png', sprites.Sheet.load)
  assets.register('frag', love.graphics.newShader)
  assets.load('assets')

  tiles = sprites.Sprite.new(assets.starting_tiles)
  state.red = love.graphics.newCanvas(100, 100)
  state.blue = love.graphics.newCanvas(100, 100)
end

function love.update(dt)
  require("lovebird").update()
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()
  love.graphics.print("Hello, LD37")
  tiles:draw()

  -- love.graphics.rectangle('fill', 20, 20, 100, 100)
  love.graphics.setColor(255, 0, 0)
  state.red:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)
  -- love.graphics.rectangle('fill', 30, 30, 100, 100)
  love.graphics.setColor(0, 0, 255)
  state.blue:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)

  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(state.red, 20, 20)
  local pinch = assets.pinch
  love.graphics.setShader(pinch)
  pinch:send('center', {0.5, 0.5})
  pinch:send('radius', 0.3)
  love.graphics.draw(state.blue, 30, 30)
end
