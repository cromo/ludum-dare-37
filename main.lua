local sprites = require 'sprites'
local assets = require 'assets'
local live = require 'live'

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

state = {}
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
}

local tiles
function love.load()
  assets.register('png', sprites.Sheet.load)
  assets.register('frag', love.graphics.newShader)
  assets.load('assets')

  local player = {
    direction = {},
    movement = {
      horizontal = {},
      vertical = {}
    },
  }
  state.machines.player_horizontal:initialize_state(player.movement.horizontal)
  state.machines.player_vertical:initialize_state(player.movement.vertical)
  state.machines.player_direction:initialize_state(player.direction)
  state.player = player

  local game = {}
  state.machines.game:initialize_state(game)
  state.game = game

  tiles = sprites.Sprite.new(assets.starting_tiles)
  state.red = love.graphics.newCanvas(100, 100)
  state.blue = love.graphics.newCanvas(100, 100)
end

function love.update(dt)
  require("lovebird").update()

  state.emitters.delta_time:emit(dt)
  live.EventQueue.pump{
    state.game,
    state.player.movement.horizontal,
    state.player.movement.vertical,
    state.player.direction,
  }
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
  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()
  love.graphics.print("Hello, LD37")
  tiles:draw()

  love.graphics.setColor(255, 0, 0)
  state.red:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)
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
