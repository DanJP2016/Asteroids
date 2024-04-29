Class = require('class')

math.randomseed(os.time())

require('libs/StateMachine')
require('states/BaseState')
require('states/TitleState')
require('states/PlayState')
require('states/GameEndState')

require('libs/player')
require('libs/Bullet')
require('libs/Asteroids')
require('libs/Ufo')

WIDTH = love.graphics.getWidth()
HEIGHT = love.graphics.getHeight()
CENTER_X = WIDTH / 2
CENTER_Y = HEIGHT / 2

function getRandInt(val1, val2)
  val1 = val1 or 1
  val2 = val2 or 1

  if math.random() < 0.5 then
    return val1
  else
    return val2
  end
end

function chanceSpawn(val)
  val = val or 0.5

  if math.random() > val then
    return true
  end

  return false
end

function distanceBetweenObjects(obj1, obj2)
  return math.sqrt((obj2.pos.x - obj1.pos.x)^2 + (obj2.pos.y - obj1.pos.y)^2)
end

function distanceBetweenPoints(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function circleCollider(obj1, obj2)
  local distance = distanceBetweenObjects(obj1, obj2)

  if obj1.hbradius ~= nil then
    if distance < obj1.hbradius + obj2.radius then
      return true
    end
  elseif obj2.hbradius ~= nil then
    if distance < obj1.radius + obj2.hbradius then
      return true
    end
  else
    if distance < obj1.radius + obj2.radius then
      return true
    end
  end

  return false
end

function love.load()
  love.graphics.setBackgroundColor(0, 0, 0, 0.5)

  love.graphics.setLineWidth(2)
  love.graphics.setLineStyle('rough')

  font = love.graphics.newFont('PressStart2P-Regular.ttf', 32)
  smallfont = love.graphics.newFont('PressStart2P-Regular.ttf', 16)

  _statemachine = StateMachine{
    ['title'] = function() return TitleState() end,
    ['play'] = function() return PlayState() end,
    ['gameover'] = function() return GameEndState() end
  }

 _statemachine:change('title')

  _keys = {}

  playerScore = 0
  highScore = 10000

  lastWave = 1
end

function love.keypressed(key)
  _keys[key] = true
end

function love.keyreleased(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function keyDown(key)
  if _keys[key] then
    return true
  end

  return false
end

function love.update(dt)
  _statemachine:update(dt)
  _keys = {}
end

function love.draw()
  _statemachine:render()
end
