Asteroids = Class{}

function setOffSets()
  local offsets = {}
  local dx = 0
  local dy = 0
  local jag = math.random(1, 3) / getRandInt(10, 20)

  for i = 1, 8 do
    dx = math.random() * jag * 2 + 1 - jag
    dy = math.random() * jag * 2 + 1 - jag

    table.insert(offsets, dx)
    table.insert(offsets, dy)
  end

  return offsets
end

function setVerts(x, y, radius, angle, offset)
  local dx = 0
  local dy = 0
  local verts = {}
  local maxVerts = 8

  for i = 1, maxVerts do
    dx = x + radius * offset[i] * math.cos(angle + i * math.pi * 2 / maxVerts)
    dy = y + radius * offset[i] * math.sin(angle + i * math.pi * 2 / maxVerts)

    table.insert(verts, dx)
    table.insert(verts, dy)
  end

  return verts
end

function Asteroids:init(entity, x, y, radius)
  x = x or math.random(WIDTH)
  y = y or math.random(HEIGHT)
  radius = radius or 60
  entity = entity or nil
  self.pos = {x = x, y = y}
  self.radius = radius
  self.angle = math.random(359)
  self.speed = 1

  if entity ~= nil then
    if distanceBetweenObjects(self, entity) <self.radius + entity.radius == true then
      repeat
        self.pos.x = math.random(WIDTH)
        self.pos.y = math.random(HEIGHT)
      until distanceBetweenObjects(self, entity) < self.radius + entity.radius == false
    end
  end

  self.offsets = setOffSets()
  self.verts = setVerts(self.pos.x, self.pos.y, self.radius, self.angle, self.offsets)
end

function Asteroids:update(dt)
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

  self.pos.x = self.pos.x + math.cos(self.angle) * self.speed
  self.pos.y = self.pos.y + math.sin(self.angle) * self.speed
end

function Asteroids:render()
  love.graphics.setColor(1, 1, 1, 1)
  self.verts = setVerts(self.pos.x, self.pos.y, self.radius, self.angle, self.offsets)
  love.graphics.polygon('line', self.verts)
end
