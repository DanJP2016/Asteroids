Ufo = Class{}

function Ufo:init(entity)
  x = getRandInt(0, WIDTH)
  y = (math.random(25, HEIGHT - 25)) / 2

  vel_x = 0
  vel_y = 0
  if x <= 0 then vel_x = 1 else vel_x = -1 end

  self.pos = {x = x, y = y}
  self.vel = {x = 0, y = 0}
  self.speed = 4
  self.radius = 13
  self.hbradius = 13
  self.shootTimer = 0
  self.fire = false
  self.alive = false
end

function Ufo:shoot(target)
  local o = getRandInt(-40, 40)

  local a = math.atan2(self.pos.y - target.pos.y + o, self.pos.x + o - target.pos.x)

  local bullet = Bullet(self.pos.x, self.pos.y, a)
  return bullet
end

function Ufo:reset()
  x = getRandInt(0, WIDTH)
  y = math.random(25, HEIGHT - 25)

  vel_x = 0
  vel_y = 0
  if x <= 0 then vel_x = 1 else vel_x = -1 end

  self.pos = {x = x, y = y}
  self.shootTimer = 0
end

function Ufo:update(dt)
  if self.alive == true then
    self.pos.x = self.pos.x + self.speed * vel_x
    if vel_y > 0 then
      self.pos.y = (self.pos.y + self.speed * vel_y)
    end
    self.shootTimer = self.shootTimer + dt

    if self.shootTimer >= 1.0 then
      self.fire = true
      self.shootTimer = 0
    else
      self.fire = false
    end
  end

  if self.pos.x + 18 < 0 or self.pos.x - 18 > WIDTH then
    self.alive = false
    self:reset()
  end

  if self.pos.y < 0 or self.pos.y > HEIGHT then
    self.alive = false
    self:reset()
  end

  -- chance to change y direction when ufo passed a certain point in x direction
  if self.pos.x == 100 or self.pos.x == WIDTH - 100 then
    if chanceSpawn() then
      vel_y = getRandInt(1, -1)
    else
      vel_y = 0
    end
  end
end

function Ufo:render()
  love.graphics.setColor(1, 1, 1, 1)

  love.graphics.ellipse('line', self.pos.x, self.pos.y, 18, 8)
  love.graphics.line(self.pos.x - (self.radius - 12), self.pos.y, self.pos.x + (self.radius - 8), self.pos.y)
  love.graphics.circle('line', self.pos.x, self.pos.y, 10)
end
