local sprites = require 'sprites'
local assets = require 'assets'
local live = require 'live'
local lume = require 'lume'
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
        {pressed_raw, is_key 'space', function() pinch_layer('test2', state.player.x, state.player.y, 60) end},
        {pressed_raw, is_key 'k', function() release_pinch(#state.layers) end},
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
    love.graphics.draw(self[1])
    for i, layer in ipairs(self) do
      if i ~= 1 then
        local center = {
          layer.center[1] / layer.content:getWidth(),
          layer.center[2] / layer.content:getHeight(),
        }
        local radius = layer.radius / layer.content:getWidth()
        local pinch = assets.pinch
        love.graphics.setShader(pinch)
        pinch:send('center', center)
        pinch:send('radius', radius)
        pinch:send('t', state.time)
        love.graphics.draw(layer.content)
      end
    end
  end
}

function pinch_layer(target, x, y, radius)
  local layer = {
    content = assets.maps[target].image,
    center = {x, y},
    radius = 1
  }
  flux.to(layer, 0.5, {radius = radius})
  lume.push(state.layers, layer)
  return #state.layers
end

function release_pinch(number)
  if number == 1 then
    return
  end
  local layer = state.layers[number]
  flux.to(layer, 0.3, {radius = 1}):oncomplete(function()
      table.remove(state.layers, number)
  end)
  
end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  assets.register('png', sprites.Sheet.load)
  assets.register('frag', love.graphics.newShader)
  assets.load('assets')

  state.machines.player_horizontal:initialize_state(player.movement.horizontal)
  state.machines.player_vertical:initialize_state(player.movement.vertical)
  state.machines.player_direction:initialize_state(player.direction)
  state.machines.player:initialize_state(player)
  state.player = player

  local game = {}
  state.machines.game:initialize_state(game)
  state.game = game

  state.red = love.graphics.newCanvas(100, 100)
  state.blue = love.graphics.newCanvas(100, 100)
  state.green = love.graphics.newCanvas(100, 100)

  state.layers[1] = assets.maps.test1.image
  lume.push(state.layers,
            {content = assets.maps.test2.image, center = {200, 100}, radius = 120},
            {content = assets.maps.test2.image, center = {40, 60}, radius = 20}
  )

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

function love.draw()
  local screen_width, screen_height = love.graphics.getDimensions()
  local mid_x, mid_y = screen_width / 2, screen_height / 2

  -- TODO: remove these when we get actual layers to play with
  love.graphics.setColor(255, 0, 0)
  state.red:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)
  love.graphics.setColor(0, 0, 255)
  state.blue:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)
  love.graphics.setColor(0, 128, 0)
  state.green:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)

  love.graphics.push()
  love.graphics.translate(screen_width / 2, screen_height / 2)
  love.graphics.scale(3)

  -- Update Camera


  love.graphics.translate(
    -state.camera.x - state.player.width / 2,
    -state.camera.y - state.player.height / 2)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()

  love.graphics.print("Hello, LD37")

  state.layers:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()
  state.player:draw()

  love.graphics.pop()

  -- love.graphics.line(mid_x, 0, mid_x, screen_height)
  -- love.graphics.line(0, mid_y, screen_width, mid_y)
end
