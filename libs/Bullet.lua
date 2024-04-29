Bullet = Class{}

function Bullet:init(x, y, angle)
  self.pos = {x = x, y = y}
  self.size = {w = 2, h = 2}
  self.angle = angle
  self.radius = 2
  self.speed = 12
  self.alive = true
end

function Bullet:update(dt)
  self.pos.x = self.pos.x - math.cos(self.angle) * self.speed
  self.pos.y = self.pos.y - math.sin(self.angle) * self.speed

  if self.pos.x < 0 then
    self.alive = false
  end

  if self.pos.x > WIDTH then
    self.alive = false
  end

  if self.pos.y < 0 then
    self.alive = false
  end

  if self.pos.y > HEIGHT then
    self.alive = false
  end
end

function Bullet:render()
  love.graphics.circle('fill', self.pos.x, self.pos.y, self.radius)
end
