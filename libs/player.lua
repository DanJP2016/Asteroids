player = Class{}

function player:init()
  self.pos = {x = CENTER_X, y = CENTER_Y}
  self.vel = {x = 0, y = 0}
  self.size = {w = 20, h = 20}
  self.offset = {x = 10, y = 10}
  self.angle = 90
  self.speed = 0.09
  self.rVel = 200
  self.radius = 30
  self.hbradius = 8
  self.thrust = false
  self.immortal = false
  self.immortalTimer = 3000
  self.mod = 0.08
  self.alpha = 1
  self.fire = false
  self.alive = true
  self.lives = 3
end

function player:blink()
  if self.alpha >= 1 then
    self.mod = self.mod * -1
  elseif self.alpha <= 0 then
    self.mod = self.mod * -1
  end

  self.alpha = self.alpha + self.mod
end

function player:shoot()
  bullet = Bullet(self.pos.x, self.pos.y, math.rad(self.angle))

  return bullet
end

function player:respawn()
  self.pos = {x = CENTER_X, y = CENTER_Y}
  self.vel = {x = 0, y = 0}
  self.size = {w = 20, h = 20}
  self.angle = 90
  self.mod = 0.08
  self.immortal = true
  self.alpha = 1
  self.alive = true
end

function player:update(dt)
  if self.immortal == true then
    self.immortalTimer = self.immortalTimer - 10
    self:blink()

    if self.immortalTimer <= 0 then
      self.immortal = false
      self.immortalTimer = 3000
      self.alpha = 1
      self.mod = 0.06
    end
  end

  if self.pos.x < 0 then
    self.pos.x = WIDTH
  end

  if self.pos.x > WIDTH then
    self.pos.x = 0
  end

  if self.pos.y < 0 then
    self.pos.y = HEIGHT
  end

  if self.pos.y > HEIGHT then
    self.pos.y = 0
  end

  if keyDown('space') == true then
    self.fire = true
  else
    self.fire = false
  end

  if keyDown('j') then
    self.pos.x = math.random(0, WIDTH)
    self.pos.y = math.random(0, HEIGHT)
  end

  if love.keyboard.isDown('left') then
    self.angle = self.angle - self.rVel * dt
  end

  if love.keyboard.isDown('right') then
    self.angle = self.angle + self.rVel * dt
  end

  if love.keyboard.isDown('up') then
    self.thrust = true
  else
    self.thrust = false
  end

  if self.thrust == true then
    self.vel.x = self.vel.x + math.cos(math.rad(self.angle)) * self.speed
    self.vel.y = self.vel.y + math.sin(math.rad(self.angle)) * self.speed
  end

  self.vel.x = self.vel.x * 0.99
  self.vel.y = self.vel.y * 0.99

  self.pos.x = self.pos.x - self.vel.x
  self.pos.y = self.pos.y - self.vel.y
end

function player:render()
  love.graphics.setColor(1, 1, 1, self.alpha)

  love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.rotate(math.rad(self.angle))

    love.graphics.line(0 -self.size.w / 2, 0,
                       self.size.w, self.size.h / 2,
                       self.size.w, -self.size.h / 2,
                       0 - self.size.w / 2, 0)

    -- draw line for engine thrust
    if self.thrust == true then
      love.graphics.line(0 + self.size.w, 0, self.size.w + self.size.w, 0)
    end

  love.graphics.pop()
end
