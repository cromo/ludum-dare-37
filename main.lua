local sprites = require 'sprites'
local assets = require 'assets'
local live = require 'live'
local lume = require 'lume'

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
  player = live.StateMachine.new_from_table{
    {nil, playing},
    {
      playing,
      {
        {update, nil, player.update, playing}
      }
    },
  }
}

local tiles
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
    state.player,
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
  local screen_width, screen_height = love.graphics.getDimensions()
  local mid_x, mid_y = screen_width / 2, screen_height / 2

  -- TODO: remove these when we get actual layers to play with
  love.graphics.setColor(255, 0, 0)
  state.red:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)
  love.graphics.setColor(0, 0, 255)
  state.blue:renderTo(function() love.graphics.rectangle('fill', 0, 0, 100, 100) end)

  love.graphics.push()
  love.graphics.translate(screen_width / 2, screen_height / 2)
  love.graphics.scale(3)
  love.graphics.translate(
    math.floor(-state.player.x - state.player.width / 2 + 0.5),
    math.floor(-state.player.y - state.player.height / 2 + 0.5))

  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()

  love.graphics.print("Hello, LD37")
  tiles:draw()


  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(state.red, 20, 20)
  local pinch = assets.pinch
  love.graphics.setShader(pinch)
  pinch:send('center', {0.5, 0.5})
  pinch:send('radius', 0.3)
  love.graphics.draw(state.blue, 30, 30)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setShader()
  state.player:draw()

  love.graphics.pop()

  -- love.graphics.line(mid_x, 0, mid_x, screen_height)
  -- love.graphics.line(0, mid_y, screen_width, mid_y)
end
