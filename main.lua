local assets = require 'assets'
local live = require 'live'
local lume = require 'lume'
local planes = require 'planes'
local sprites = require 'sprites'
local sti = require 'sti'
local flux = require 'flux'

local player = require("player")

local f = lume.lambda
local trace = lume.trace

local update = 'dt'
local pressed_raw = 'raw_key_pressed'
local released_raw = 'raw_key_released'

local playing = 'playing'
local pressed = 'key_pressed'
local released = 'key_released'

local direction = 'direction'

local escape = 'escape'
local up = 'up'
local down = 'down'
local left = 'left'
local right = 'right'

local neutral = 'neutral'

local function is_equal(key)
  return function(state, k)
    return key == k
  end
end

local is_key = is_equal

local function emit(emitter, data)
  return function()
    return emitter:emit(data)
  end
end

local function key_tribool(negative, positive)
  local direction = state.emitters.direction
  return live.StateMachine.new_from_table{
    {nil, neutral},
    {
      neutral,
      {
        {pressed, is_key(negative), emit(direction, negative), negative},
        {pressed, is_key(positive), emit(direction, positive), positive},
        {released, is_key(negative), emit(direction, positive), positive},
        {released, is_key(positive), emit(direction, negative), negative},
      }
    },
    {
      negative,
      {
        {pressed, is_key(positive), emit(direction, neutral), neutral},
        {released, is_key(negative), emit(direction, neutral), neutral},
      }
    },
    {
      positive,
      {
        {pressed, is_key(negative), emit(direction, neutral), neutral},
        {released, is_key(positive), emit(direction, neutral), neutral},
      }
    },
  }
end

state = {
  time = 0,
  collision_categories = {}
}

state.collision_categories.default = 1
state.collision_categories.plane_static = 2
state.collision_categories.layer_sensor = 3

function is_debug()
  return state.debug
end

state.emitters = {
  delta_time = live.Emitter.new(update),
  raw_key_pressed = live.Emitter.new(pressed_raw),
  raw_key_released = live.Emitter.new(released_raw),

  key_pressed = live.Emitter.new(pressed),
  key_released = live.Emitter.new(released),

  direction = live.Emitter.new(direction),
}
state.machines = {
  game = live.StateMachine.new_from_table{
    {nil, playing},
    {
      playing, {
        {pressed_raw, is_key(escape), love.event.quit, 'final'},
        {pressed_raw, is_key(up), emit(state.emitters.key_pressed, up), playing},
        {pressed_raw, is_key(down), emit(state.emitters.key_pressed, down), playing},
        {pressed_raw, is_key(left), emit(state.emitters.key_pressed, left), playing},
        {pressed_raw, is_key(right), emit(state.emitters.key_pressed, right), playing},
        {released_raw, is_key(up), emit(state.emitters.key_released, up), playing},
        {released_raw, is_key(down), emit(state.emitters.key_released, down), playing},
        {released_raw, is_key(left), emit(state.emitters.key_released, left), playing},
        {released_raw, is_key(right), emit(state.emitters.key_released, right), playing},
        {pressed_raw, is_key 'space', emit(state.emitters.key_pressed, 'carry'), playing},
        {pressed_raw, {is_debug, is_key 'q'}, function() pinch_layer(state.planes.lab, state.player.x, state.player.y, 50) end},
        {pressed_raw, {is_debug, is_key 'w'}, function() pinch_layer(state.planes.volcano, state.player.x, state.player.y, 50) end},
        {pressed_raw, {is_debug, is_key 'e'}, function() pinch_layer(state.planes.mansion, state.player.x, state.player.y, 50) end},
        {pressed_raw, {is_debug, is_key 'k'}, function() release_pinch(#lume.reject(state.layers, f'x -> x.removing')) end},
        {pressed_raw, {is_debug, is_key '1'}, function() state.player:switch_to_plane(state.planes.volcano) end},
        {pressed_raw, {is_debug, is_key '2'}, function() state.player:switch_to_plane(state.planes.mansion) end},
      }
    },
  },
  player_horizontal = key_tribool(left, right),
  player_vertical = key_tribool(up, down),
  player_direction = live.StateMachine.new_from_table{
    {nil, up},
    {
      left,
      {
        {direction, is_equal(up), nil, up},
        {direction, is_equal(down), nil, down},
        {direction, is_equal(right), nil, right},
      }
    },
    {
      right,
      {
        {direction, is_equal(left), nil, left},
        {direction, is_equal(down), nil, down},
        {direction, is_equal(up), nil, up},
      }
    },
    {
      up,
      {
        {direction, is_equal(left), nil, left},
        {direction, is_equal(down), nil, down},
        {direction, is_equal(right), nil, right},
      }
    },
    {
      down,
      {
        {direction, is_equal(left), nil, left},
        {direction, is_equal(up), nil, up},
        {direction, is_equal(right), nil, right},
      }
    },
  },
  player_carry = live.StateMachine.new_from_table{
    {nil, 'empty_handed'},
    {
      'empty_handed',
      {
        {pressed, {is_key 'carry', f'self -> self.pickup'}, f'self -> self:grab()', 'holding'},
      }
    },
    {
      'holding',
      {
        {pressed, is_key 'carry', f'self -> self:drop()', 'empty_handed'}
      }
    }
  },
  player = live.StateMachine.new_from_table{
    {nil, playing},
    {
      playing,
      {
        {update, nil, player.update, playing}
      }
    },
  },
}
state.layers = {
  draw = function(self)
    love.graphics.setColor(255, 255, 255)
    --love.graphics.draw(self[1].prerender)
    for i, layer in ipairs(self) do
      --if i ~= 1 then
        local center = {
          layer.center[1] / layer.plane.prerender:getWidth(),
          layer.center[2] / layer.plane.prerender:getHeight(),
        }
        local radius = layer.radius / layer.plane.prerender:getWidth()
        local pinch = assets.pinch
        love.graphics.setShader(pinch)
        pinch:send('center', center)
        pinch:send('radius', radius)
        pinch:send('t', state.time)
        love.graphics.draw(layer.plane.prerender)
      --end
    end
  end
}

function pinch_layer(target, x, y, radius, instant)
  local layer = {
    plane = target,
    center = {x, y},
    radius = radius,
    removing = false,
    type = "layer",
    index = function(self)
      for i = 1, #state.layers do
        if state.layers[i] == self then
          return i
        end
      end
      print("Couldn't find ourself in the list! Oh noes...")
      return nil
    end
  }
  if not instant then
    layer.radius = 1
    flux.to(layer, 0.5, {radius = radius}):onupdate(
      function() layer.fixture:getShape():setRadius(layer.radius) end)
  end
  lume.push(state.layers, layer)

  layer.body = love.physics.newBody(state.world, x, y, "dynamic")
  layer.body:setFixedRotation(true)
  local collision_circle = love.physics.newCircleShape(0, 0, layer.radius)
  layer.fixture = love.physics.newFixture(layer.body, collision_circle, 1)
  layer.fixture:setSensor(true)
  layer.fixture:setCategory(state.collision_categories.layer_sensor)
  layer.fixture:setUserData(layer)

  return layer
end

function release_pinch(layer)
  layer = layer or #state.layers
  if type(layer) == 'number' then
    layer = state.layers[layer]
  end
  if layer == state.layers[1] then
    return
  end
  if layer.removing then
    -- the layer is already on its way out
    return
  end
  layer.removing = true
  flux.to(layer, 0.3, {radius = 1}):onupdate(function()
      layer.fixture:getShape():setRadius(layer.radius)
  end):oncomplete(function()
      layer.fixture:destroy()
      local index = layer:index()
      table.remove(state.layers, index)
  end)
end

function world_begin_contact(a, b, coll)
  if a:getUserData() ~= nil and b:getUserData() ~= nil then
    a_obj = a:getUserData()
    b_obj = b:getUserData()
    if a_obj.onBeginContactWith then
      a_obj:onBeginContactWith(b_obj)
    end
    if b_obj.onBeginContactWith then
      b_obj:onBeginContactWith(a_obj)
    end
  end
end

function world_end_contact(a, b, coll)
  if a:getUserData() ~= nil and b:getUserData() ~= nil then
    a_obj = a:getUserData()
    b_obj = b:getUserData()
    if a_obj.onEndContactWith then
      a_obj:onEndContactWith(b_obj)
    end
    if b_obj.onEndContactWith then
      b_obj:onEndContactWith(a_obj)
    end
  end
end

find_highest_layer = function(object)
  local highest = -1
  local highest_layer = nil
  for _, layer in pairs(object.active_layers) do
    if layer:index() > highest then
      highest = layer:index()
      highest_layer = layer
    end
  end
  if highest_layer then
    return highest_layer
  else
    print("Couldn't find layer to bubble to! This shouldn't happen.")
    return nil
  end
end

local function new_carryable(x, y, type, properties, plane)
  local carryable = lume.merge({
      x = x,
      y = y,
      type = type,
      active_layers = {},
      active = false,
      plane = plane or state.planes.reality,
      onBeginContactWith = function(self, object)
        if object.type == "layer" then
          local layer = object
          self.active_layers[layer] = layer
          --- Bubble to top layer
          local highest_layer = find_highest_layer(self)
          if self.active then
            self.plane = highest_layer.plane
          else
            if highest_layer.plane == self.plane then
              self.active = true
            end
          end
        end
      end,
      onEndContactWith = function(self, object)
        if object.type == "layer" then
          local layer = object
          self.active_layers[layer] = nil
          --- Bubble to top layer
          local highest_layer = find_highest_layer(self)
          if self.active then
            --- If layer is collapsing, then:
            if not self.parented and layer.removing and highest_layer.plane ~= layer.plane then
              self.active = false
            else
              self.plane = highest_layer.plane
            end
          else
            if highest_layer.plane == self.plane then
              self.active = true
            end
          end
        end
      end,
      update = function(self)
        if self.active then
          self.x, self.y = self.body:getPosition()
          self.visible = true
          self.fixture:setSensor(false)
          self.fixture:setMask()
        else
          self.visible = false
          self.fixture:setSensor(true)
          self.body:setLinearVelocity(0,0)
          self.fixture:setMask(state.collision_categories.default, state.collision_categories.plane_static)
        end
      end,
      draw = function() end,
      parented = false,
      active_layers = {}}, properties)
  carryable.body = love.physics.newBody(state.world, carryable.x, carryable.y, "kinematic")
  carryable.body:setFixedRotation(true)
  local carryable_shape = love.physics.newCircleShape(8, 12, 6)
  carryable.fixture = love.physics.newFixture(carryable.body, carryable_shape, 1)
  carryable.fixture:setCategory(state.collision_categories.default)
  carryable.fixture:setUserData(carryable)
  return carryable
end

local function new_planar_key(x, y, to_plane, initial_plane)
  local function draw(self, x, y)
    local original_color = {love.graphics.getColor()}
    love.graphics.setColor(unpack(self.to_plane.color))
    if self.parented then
      love.graphics.draw(self.plane.key_image, x, y)
      love.graphics.setColor(unpack(original_color))
      return
    end
    love.graphics.draw(self.plane.key_image, self.x, self.y)
    love.graphics.setColor(unpack(original_color))
  end
  return new_carryable(x, y, 'planar_key', {to_plane = to_plane, draw = draw}, initial_plane)
end

local function new_receptacle(x, y, properties, hold, unparent, plane)
  local draw = function(self) end
  local receptacle = lume.merge({
      x = x,
      y = y,
      type = 'receptacle',
      active_layers = {},
      active = false,
      plane = plane or state.planes.lab,
      onBeginContactWith = function(self, object)
        if object.type == 'layer' then
          local layer = object
          self.active_layers[layer] = layer
          local highest_layer = find_highest_layer(self)
          if self.plane == highest_layer.plane or (self.holding and self.holding.to_plane and self.holding.to_plane == highest_layer.plane) then
            self.active = true
          else
            self.active = false
          end
        end
      end,
      onEndContactWith = function(self, object)
        if object.type == 'layer' then
          local layer = object
          self.active_layers[layer] = nil
          local highest_layer = find_highest_layer(self)
          if self.plane == highest_layer.plane then
            self.active = true
          else
            self.active = false
          end
        end
      end,
      update = function(self)
        if self.active then
          self.x, self.y = self.body:getPosition()
          self.visible = true
          self.fixture:setSensor(false)
          self.fixture:setMask()
        else
          self.visible = false
          self.fixture:setSensor(true)
          self.body:setLinearVelocity(0,0)
          self.fixture:setMask(state.collision_categories.default, state.collision_categories.plane_static)
        end
      end,
      draw = draw},
    properties, {
      hold = hold,
      unparent = unparent})
  receptacle.body = love.physics.newBody(state.world, receptacle.x, receptacle.y, 'kinematic')
  receptacle.body:setFixedRotation(true)
  local receptacle_shape = love.physics.newCircleShape(8, 12, 6)
  receptacle.fixture = love.physics.newFixture(receptacle.body, receptacle_shape, 1)
  receptacle.fixture:setUserData(receptacle)
  receptacle.fixture:setCategory(state.collision_categories.default)
  return receptacle
end

local function new_anchor(x, y, radius, origin_plane)
  local function hold(self, object)
    self.holding = object
    object.parented = true
    object.body:setPosition(self.body:getPosition())
    if object.type == 'planar_key' then
      local width = 16
      self.pinch = pinch_layer(object.to_plane, self.x + width / 2, self.y, self.radius)
    end
  end
  local function unparent(self)
    release_pinch(self.pinch)
    self.pinch = nil
    self.holding = nil
  end
  local function draw(self)
    love.graphics.draw(assets.anchor_base.image, self.x, self.y - 16)
    local color = {love.graphics.getColor()}
    love.graphics.setColor(unpack(self.plane.color))
    love.graphics.draw(assets.anchor_detail_white.image, self.x, self.y - 16)
    love.graphics.setColor(unpack(color))
    if self.holding then
      self.holding:draw(self.x, self.y - 24)
    end
  end
  return new_receptacle(x, y, {radius = radius, plane = origin_plane, draw = draw}, hold, unparent)
end

local function new_spitter(x, y, direction)
  local rotation = {
    down = 0,
    left = math.pi / 2,
    up = math.pi,
    right = 3 * math.pi / 2,
  }
  local spitter = {
    x = x,
    y = y,
    facing = direction,
    draw = function(self)
      local image = assets['flame-spitter'].image
      love.graphics.draw(image, self.x, self.y, rotation[direction], nil, nil, image:getWidth() / 2, image:getHeight() / 2)
    end,
  }
  return spitter
end

function love.load(args)
  state.debug = lume.find(args, '--debug')

  love.graphics.setDefaultFilter('nearest', 'nearest')

  assets.register('png', sprites.Sheet.load)
  assets.register('frag', love.graphics.newShader)
  assets.register('lua', function(path) return sti.new(path, {'box2d'}) end)
  assets.load('assets')

  love.window.setTitle("Pinch")
  love.window.setIcon(assets['ghost-down'].image:getData())

  state.planes = planes()

  state.world = love.physics.newWorld(0, 0, false)
  for name, plane in pairs(state.planes) do
    local map = assets[plane.map_name]
    plane.map = map
    plane.map:box2d_init(state.world)
    if plane.map.layers.game_elements then
      plane.map.layers.game_elements.visible = false
    end
    plane.prerender = love.graphics.newCanvas(map.width * map.tilewidth, map.height * map.tileheight)
    plane.prerender:renderTo(function() plane.map:draw() end)

    -- Go through the world and assign the appropriate
    -- group number to all the new objects that were just
    -- added for this plane
    for _, body in pairs(state.world:getBodyList()) do
      for _, fixture in pairs(body:getFixtureList()) do
        if fixture:getGroupIndex() == 0 then
          fixture:setGroupIndex(plane.group)
          fixture:setCategory(state.collision_categories.plane_static)
        end
      end
    end
  end

  state.world:setCallbacks(world_begin_contact, world_end_contact, nil, nil)

  player.plane = state.planes.reality

  player:init()
  state.player = player

  local game = {}
  state.machines.game:initialize_state(game)
  state.game = game

  local map_size = 32
  local tile_size = 16
  local instant = true
  pinch_layer(state.planes.reality, 0, 0, 32 * 16 * 2, instant) -- twice the width
  pinch_layer(state.planes.lab, 16 * 32 / 2, 16 * 32 / 2, 32 * 16 * 2, instant)

  state.camera = {x=player.x, y=player.y}

  state.carryables = {}
  lume.push(state.carryables, new_planar_key(player.x - 30, player.y, state.planes.lab, state.planes.volcano))
  lume.push(state.carryables, new_planar_key(player.x - 30, player.y + 16, state.planes.volcano, state.planes.lab))
  local gold_key = new_planar_key(0, 0, state.planes.gold, state.planes.gold)
  lume.push(state.carryables, gold_key)

  state.receptacles = {}
  lume.push(state.receptacles, new_anchor(player.x + 30, player.y, 140, state.planes.lab))
  local final_anchor = new_anchor(player.x, player.y - 70, 4 * tile_size, state.planes.gold)
  lume.push(state.receptacles, final_anchor)
  final_anchor:hold(gold_key)

  for _, plane in pairs(state.planes) do
    if plane.map.layers.game_elements then
      for _, object in ipairs(plane.map.layers.game_elements.objects) do
        if object.type == 'key' then
          lume.push(state.carryables, new_planar_key(
                      object.x - 8,
                      object.y - 12,
                      state.planes[object.properties.to],
                      state.planes[object.properties.start]))
        end
        if object.type == 'anchor' then
          lume.push(state.receptacles, new_anchor(
                      object.x + object.width / 2 - 6,
                      object.y + object.height / 2,
                      object.width / 2,
                      state.planes[object.properties.start]
          ))
        end
      end
    end
  end

  state.spitter = new_spitter(player.x - 30, player.y - 2.5 * 16, 'down')
end

function love.update(dt)
  require("lovebird").update()
  flux.update(dt)

  state.time = state.time + dt

  state.emitters.delta_time:emit(dt)
  live.EventQueue.pump{
    state.game,
    state.player.movement.horizontal,
    state.player.movement.vertical,
    state.player.direction,
    state.player.carry,
    state.player,
  }

  lume.each(state.carryables, 'update', dt)
  lume.each(state.receptacles, 'update', dt)

  local follow_weight = 3.0 * dt
  state.camera.x = state.camera.x *
    (1.0 - follow_weight) + player.x * follow_weight

  state.camera.y = state.camera.y *
    (1.0 - follow_weight) + player.y * follow_weight

  state.world:update(dt)
end

function love.keypressed(key, scancode, is_repeat)
  if is_repeat then
    return
  end
  state.emitters.raw_key_pressed:emit(key)
end

function love.keyreleased(key)
  state.emitters.raw_key_released:emit(key)
end

function debug_physics(world)
  if not state.debug then
    return
  end
  for _, body in pairs(state.world:getBodyList()) do
    for _, fixture in pairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      if fixture:getGroupIndex() ~= state.player.plane.group then
        love.graphics.setColor(64, 64, 64)
        if shape:getType() == "circle" then
          local pos_x, pos_y = body:getWorldPoint(shape:getPoint())
          love.graphics.circle('line', pos_x, pos_y, shape:getRadius())
        else
          love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
        end
      end
    end
  end
  for _, body in pairs(state.world:getBodyList()) do
    for _, fixture in pairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      if fixture:getGroupIndex() == state.player.plane.group then
        love.graphics.setColor(255, 255, 255)
        if shape:getType() == "circle" then
          local pos_x, pos_y = body:getWorldPoint(shape:getPoint())
          love.graphics.circle('line', pos_x, pos_y, shape:getRadius())
        else
          love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
        end
      end
    end
  end
  love.graphics.setColor(255, 255, 255)
end

function love.draw()
  local screen_width, screen_height = love.graphics.getDimensions()
  local mid_x, mid_y = screen_width / 2, screen_height / 2

  love.graphics.push()
  love.graphics.translate(screen_width / 2, screen_height / 2)
  love.graphics.scale(3)

  love.graphics.translate(
    -state.camera.x - state.player.width / 2,
    -state.camera.y - state.player.height / 2)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()
  state.layers:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()

  local draw_list = lume.concat({state.player}, lume.filter(state.carryables, f'x -> not x.parented'), state.receptacles)
  lume.each(lume.sort(draw_list, 'y'), function(object)
    if object.visible == nil or object.visible ~= false then
      object:draw()
    end
  end)

  -- state.spitter:draw()

  debug_physics(state.world)

  love.graphics.pop()
end
