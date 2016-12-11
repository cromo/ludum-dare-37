local assets = require 'assets'
local live = require 'live'
local lume = require 'lume'
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
}
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
        {pressed_raw, is_key 'q', function() pinch_layer(state.planes.volcano, state.player.x, state.player.y, 50) end},
        {pressed_raw, is_key 'w', function() pinch_layer(state.planes.mansion, state.player.x, state.player.y, 50) end},
        {pressed_raw, is_key 'k', function() release_pinch(#state.layers) end},
        {pressed_raw, is_key '1', function() state.player:switch_to_plane(state.planes.volcano) end},
        {pressed_raw, is_key '2', function() state.player:switch_to_plane(state.planes.mansion) end},
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

function pinch_layer(target, x, y, radius)
  local layer = {
    plane = target,
    center = {x, y},
    radius = 1,
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
  flux.to(layer, 0.5, {radius = radius})
  lume.push(state.layers, layer)

  layer.body = love.physics.newBody(state.world, x, y, "static")
  layer.body:setFixedRotation(true)
  local collision_circle = love.physics.newCircleShape(0, 0, radius)
  layer.fixture = love.physics.newFixture(layer.body, collision_circle, 1)
  layer.fixture:setSensor(true)
  layer.fixture:setUserData(layer)

  return #state.layers
end

function release_pinch(number)
  number = number or #state.layers
  if number == 1 then
    return
  end
  local layer = state.layers[number]
  flux.to(layer, 0.3, {radius = 1}):oncomplete(function()
      table.remove(state.layers, number)
  end)

  layer.fixture:destroy()
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

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  assets.register('png', sprites.Sheet.load)
  assets.register('frag', love.graphics.newShader)
  assets.register('lua', function(path) return sti.new(path, {'box2d'}) end)
  assets.load('assets')

  state.planes = {}
  state.planes.reality = {
    map_name = "reality",
    color = {0,0,0},
    group = 1
  }
  state.planes.volcano = {
    map_name = "test1",
    color = {255,0,0},
    group = 2
  }
  state.planes.mansion = {
    map_name = "test2",
    color = {128,128,128},
    group = 3
  }

  state.world = love.physics.newWorld(0, 0, false)
  for name, plane in pairs(state.planes) do
    local map = assets[plane.map_name]
    plane.map = map
    plane.map:box2d_init(state.world)
    plane.prerender = love.graphics.newCanvas(map.width * map.tilewidth, map.height * map.tileheight)
    plane.prerender:renderTo(function() plane.map:draw() end)

    -- Go through the world and assign the appropriate
    -- group number to all the new objects that were just
    -- added for this plane
    for _, body in pairs(state.world:getBodyList()) do
      for _, fixture in pairs(body:getFixtureList()) do
        if fixture:getGroupIndex() == 0 then
          fixture:setGroupIndex(plane.group)
          fixture:setCategory(2)
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

  pinch_layer(state.planes.reality, 0, 0, 32 * 16 * 2) -- twice the width

  state.camera = {x=0, y=0}
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
    state.player,
  }

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
  for _, body in pairs(state.world:getBodyList()) do
    for _, fixture in pairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      if fixture:getGroupIndex() == state.player.plane.group then
        love.graphics.setColor(255, 255, 255)
      else
        love.graphics.setColor(64, 64, 64)
      end
      if shape:getType() == "circle" then
        local pos_x, pos_y = body:getWorldPoint(shape:getPoint())
        love.graphics.circle('line', pos_x, pos_y, shape:getRadius())
      else
        love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
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
  state.player:draw()

  debug_physics(state.world)

  love.graphics.pop()
end
