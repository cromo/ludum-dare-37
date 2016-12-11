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
  x = 32,
  y = 32,
  width = 16,
  height = 16,
  speed = 60,
  direction = {},
  movement = {
    horizontal = {},
    vertical = {}
  },
  init = function(self)
    -- Setup initial states
    state.machines.player_horizontal:initialize_state(self.movement.horizontal)
    state.machines.player_vertical:initialize_state(self.movement.vertical)
    state.machines.player_direction:initialize_state(self.direction)
    state.machines.player:initialize_state(self)

    -- Setup a physics body for our lovely ghost
    self.body = love.physics.newBody(state.world, 32, 32, "dynamic")
    self.body:setFixedRotation(true)
    local origin_point = love.physics.newCircleShape(8, 12, 6.0)
    self.fixture = love.physics.newFixture(self.body, origin_point, 1)
    self.fixture:setGroupIndex(self.plane.group)
    self.fixture:setMask(2)
  end,
  switch_to_plane = function(self, plane)
    self.fixture:setGroupIndex(plane.group)
    self.plane = plane
  end,
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

      -- self.x = self.x + position_delta.x * self.speed * dt
      -- self.y = self.y + position_delta.y * self.speed * dt

      self.body:setLinearVelocity(self.speed * position_delta.x, self.speed * position_delta.y)
    else
      self.current_speed = 0

      self.body:setLinearVelocity(0, 0)
    end

    self.x = self.body:getX()
    self.y = self.body:getY()
  end,
  draw = function(self)
    local x, y = self.x, self.y
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
