local assets = require 'assets'
local lume = require 'lume'
local sprites = require 'sprites'

local up = 'up'
local down = 'down'
local left = 'left'
local right = 'right'

local pressed = 'key_pressed'
local released = 'key_released'

local update = 'dt'

local player = {
  x = 0,
  y = 0,
  width = 16,
  height = 16,
  direction = {},
  movement = {
    horizontal = {},
    vertical = {}
  },
  update = function(self, dt)
    local horizontal = self.movement.horizontal.state.name
    local vertical = self.movement.vertical.state.name

    local direction_contribution = {
      left = -1, right = 1,
      up = -1, down = 1,
      neutral = 0
    }

    local position_delta = {
      x = direction_contribution[horizontal],
      y = direction_contribution[vertical]
    }

    local distance = lume.distance(0, 0, position_delta.x, position_delta.y)
    if 0 < distance then
      position_delta = lume.map(position_delta, function(i) return i / distance end)
    end

    local speed = 40
    self.x = self.x + position_delta.x * speed * dt
    self.y = self.y + position_delta.y * speed * dt
  end,
  draw = function(self)
    local x, y = self.x, self.y
    x = math.floor(x + 0.5)
    y = math.floor(y + 0.5)
    local direction = self.direction.state.name
    local main_image = assets['ghost-' .. direction]
    local player = sprites.Sprite.new(main_image)

    local hand_direction = direction
    if hand_direction == up then
      hand_direction = down
    end
    local hands_image = assets['hands-' .. hand_direction]
    local hands = sprites.Sprite.new(hands_image)

    local hands_behind = direction == up
    if hands_behind then
      hands:draw(x, y - 1)
    end
    player:draw(x, y)
    if not hands_behind then
      hands:draw(x, y)
    end
  end
}

return player
