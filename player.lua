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

local tile_size = 16

local carryables = {
  planar_key = true
}

local player = {
  x = 15 * tile_size,
  y = 29 * tile_size,
  width = 16,
  height = 16,
  speed = 60,
  type = "player",
  active_layers = {},
  direction = {},
  movement = {
    horizontal = {},
    vertical = {}
  },
  carry = {
    type = 'player_reach',
    onBeginContactWith = function(self, object)
      if not object.type then return end
      if carryables[object.type] then
        self.pickup = object
      end
      if object.type == 'receptacle' then
        self.drop_target = object
      end
    end,
    onEndContactWith = function(self, object)
      if not object.type then return end
      if carryables[object.type] then
        self.pickup = nil
      end
      if object.type == 'receptacle' then
        self.drop_target = nil
      end
    end,
    grab = function(self)
      if self.drop_target and self.drop_target.holding == self.pickup then
        self.drop_target:unparent()
      end
      self.holding = self.pickup
    end,
    drop = function(self)
      self.dropping = self.holding
      self.holding = nil
    end,
  },
  init = function(self)
    -- Setup initial states
    state.machines.player_horizontal:initialize_state(self.movement.horizontal)
    state.machines.player_vertical:initialize_state(self.movement.vertical)
    state.machines.player_direction:initialize_state(self.direction)
    state.machines.player_carry:initialize_state(self.carry)
    state.machines.player:initialize_state(self)

    -- Setup a physics body for our lovely ghost
    self.body = love.physics.newBody(state.world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    local origin_point = love.physics.newCircleShape(8, 12, 6.0)
    self.fixture = love.physics.newFixture(self.body, origin_point, 1)
    self.fixture:setGroupIndex(self.plane.group)
    -- Don't collide with most plane statics (the group overrides this)
    self.fixture:setMask(state.collision_categories.plane_static)
    self.fixture:setUserData(self)
    self.fixture:setCategory(state.collision_categories.default)

    local reachable_range = love.physics.newCircleShape(8, 8, 6)
    self.reach = love.physics.newFixture(self.body, reachable_range, 1)
    self.reach:setSensor(true)
    self.reach:setUserData(self.carry)
    self.reach:setCategory(state.collision_categories.default)
  end,
  bubble_to_highest_layer = function(self)
    local highest = -1
    local highest_layer = nil
    for _, layer in pairs(self.active_layers) do
      if layer:index() > highest then
        highest = layer:index()
        highest_layer = layer
      end
    end
    if highest_layer then
      self.fixture:setGroupIndex(highest_layer.plane.group)
      self.plane = highest_layer.plane
    else
      print("Couldn't find layer to bubble to! This shouldn't happen.")
    end
  end,
  onBeginContactWith = function(self, object)
    if object.type == "layer" then
      local layer = object
      self.active_layers[layer] = layer
      self:bubble_to_highest_layer()
    end
  end,
  onEndContactWith = function(self, object)
    if object.type == "layer" then
      local layer = object
      self.active_layers[layer] = nil
      self:bubble_to_highest_layer()
    end
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

    -- Reposition the reach bubble
    local direction = self.direction.state.name
    local reach_delta = 4
    local reach_offset = {
      left = {-1, 0},
      right = {1, 0},
      up = {0, -1},
      down = {0, 1},
    }

    local reach_base = {self.fixture:getShape():getPoint()}
    self.reach:getShape():setPoint(
      reach_base[1] + reach_delta * reach_offset[direction][1],
      reach_base[2] + reach_delta * reach_offset[direction][2])

    -- Reposition carried object
    if self.carry.holding then
      local held = self.carry.holding
      held.parented = true
      held.body:setPosition(self.x, self.y - 16)
    end
    if self.carry.dropping then
      local held = self.carry.dropping
      self.carry.dropping = nil
      if self.carry.drop_target and not self.carry.drop_target.holding then
        self.carry.drop_target:hold(held)
      else
        held.parented = false
        local put_offset = 12.5
        held.body:setPosition(
          self.x + put_offset * reach_offset[direction][1],
          self.y + put_offset * reach_offset[direction][2])
      end
    end
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

    local holding_offset = 0
    if self.carry.state.name == 'holding' then
      holding_offset = -10
    end

    if self.carry.holding then
      self.carry.holding:draw(x, y - 16)
    end
    local hands_behind = direction == up
    if hands_behind then
      hands:draw(x, y - 1 + holding_offset)
    end
    player:draw(x, y)
    if not hands_behind then
      hands:draw(x, y + holding_offset)
    end
  end
}

return player
