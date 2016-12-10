local sprites = require 'sprites'
local assets = require 'assets'

function love.load()
  assets.register('png', sprites.Sheet.load)
  assets.load('assets')
end

function love.update(dt)
  require("lovebird").update()
end

function love.draw()
  love.graphics.print("Hello, LD37")
end
