PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.player = player()
  self.ufo = Ufo(self.player)
  self.maxSpawn = 3
  self.wave = 1
  self.nextSpawn = true
  self.maxPlayerBullets = 5
  self.maxUfoBullets = 5
  self.asteroids = {}
  self.bullets = {}
  self.alienBullets = {}
  self.score = 0
  self.newLife = 10000

  -- radius of asteroids and ufo used to determine points gained
  self.scoreTable = {
    [60] = 100,
    [30] = 200,
    [28] = 200,
    [15] = 300,
    [13] = 500
  }

  -- timer for spawning asteroids
  self.timer = 0

  self.particle = love.graphics.newCanvas(10, 10)
    love.graphics.setCanvas(self.particle)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', 0, 0, 5, 5)
  love.graphics.setCanvas()

  self.particles = love.graphics.newParticleSystem(self.particle, 500)
  self.particles:setParticleLifetime(1, 1.2)
  self.particles:setInsertMode('random')
  self.particles:setRadialAcceleration(200, 300)
  self.particles:setLinearAcceleration(-100, -100, 100, 100)
  self.particles:setColors(1, 1, 1, 0.9, 0.8, 0.7, 0.3, 0)
end

function PlayState:spawnAsteroid(entity)
  local asteroid = Asteroids(entity)
  table.insert(self.asteroids, asteroid)
end

function PlayState:splitAsteroid(asteroid, tbl)
  local a

  if asteroid.radius == 60 then
    for i = 1, 2 do
      a = Asteroids(nil, asteroid.pos.x, asteroid.pos.y, 30)
      a.pos.x = a.pos.x + a.radius
      a.pos.y = a.pos.y + a.radius
      a.angle = a.angle * -1
      a.speed = a.speed + 1
      table.insert(tbl, a)
    end
  elseif asteroid.radius == 30 then
    for i = 1, 3 do
      a = Asteroids(nil, asteroid.pos.x, asteroid.pos.y, 15)
      a.pos.x = a.pos.x + a.radius
      a.pos.y = a.pos.y + a.radius
      a.angle = a.angle * -1
      a.speed = a.speed + 1
      table.insert(tbl, a)
    end
  end
end

function PlayState:update(dt)
  self.player:update(dt)
  self.particles:update(dt)

  if self.score % 300 == 0 and self.ufo.alive == false and self.score > 0 then
    if chanceSpawn(0.7) then
      self.ufo.alive = true
    end
  end

  if self.ufo.alive == true then
    self.ufo:update(dt)

    if self.ufo.fire == true then
      table.insert(self.alienBullets, self.ufo:shoot(self.player))
    end
  end

  if self.nextSpawn == true and #self.asteroids ~= self.wave then
    self.timer = self.timer + dt
    if self.timer >= 0.5 then
      if chanceSpawn(0.7) then self:spawnAsteroid(self.player) end
      self.timer = 0
    end
  end

  if #self.asteroids == self.wave then
    self.nextSpawn = false
  end

  if self.nextSpawn == false and #self.asteroids == 0 then
    self.nextSpawn = true
    self.wave = self.wave + 1
  end

  if #self.asteroids > 0 then
    for i = #self.asteroids, 1, -1 do
      self.asteroids[i]:update(dt)
    end
  end

  if self.player.fire == true and #self.bullets < self.maxPlayerBullets then
    table.insert(self.bullets, self.player:shoot())
  end

  if #self.bullets > 0 then
    for i = #self.bullets, 1, -1 do
      if self.bullets[i].alive == true then
        self.bullets[i]:update(dt)

        -- check for collision with asteroids
        for j = #self.asteroids, 1,  -1 do
          if circleCollider(self.bullets[i], self.asteroids[j]) then
            self.bullets[i].alive = false
            self.score = self.score + self.scoreTable[self.asteroids[j].radius]
            self.newLife = self.newLife - self.scoreTable[self.asteroids[j].radius]

            if self.newLife <= 0 then
              self.newLife = 10000
              self.player.lives = self.player.lives + 1
            end

            if self.asteroids[j].radius > 15 then PlayState:splitAsteroid(self.asteroids[j], self.asteroids) end

            self.particles:moveTo(self.asteroids[j].pos.x, self.asteroids[j].pos.y)
            self.particles:setEmissionArea('ellipse', self.asteroids[j].radius, self.asteroids[j].radius, math.rad(360), true)
            self.particles:emit(150)
            table.remove(self.asteroids, j)
          end
        end
      end

      if circleCollider(self.bullets[i], self.ufo) then
        self.particles:moveTo(self.ufo.pos.x, self.ufo.pos.y)
        self.particles:setEmissionArea('ellipse', self.ufo.radius, self.ufo.radius, math.rad(360), true)
        self.particles:emit(350)

        self.bullets[i].alive = false
        self.ufo.alive = false
        self.ufo:reset()

        self.score = self.score + self.scoreTable[self.ufo.radius]
        self.newLife = self.newLife - self.scoreTable[self.ufo.radius]

        if self.newLife <= 0 then
          self.newLife = 10000
          self.player.lives = self.player.lives + 1
        end
      end

      if self.bullets[i].alive == false then
        table.remove(self.bullets, i)
      end
    end
  end

  if #self.alienBullets > 0 then
    for i = #self.alienBullets, 1, -1 do

      if self.alienBullets[i].alive == true then
        self.alienBullets[i]:update(dt)
      end

        for j = #self.asteroids, 1,  -1 do
          if circleCollider(self.alienBullets[i], self.asteroids[j]) then
            self.alienBullets[i].alive = false

            if self.asteroids[j].radius > 15 then PlayState:splitAsteroid(self.asteroids[j], self.asteroids) end

            self.particles:moveTo(self.asteroids[j].pos.x, self.asteroids[j].pos.y)
            self.particles:setEmissionArea('ellipse', self.asteroids[j].radius, self.asteroids[j].radius, math.rad(360), true)
            self.particles:emit(150)
            table.remove(self.asteroids, j)
          end
        end

        if self.player.alive == true and circleCollider(self.alienBullets[i], self.player) then
          self.alienBullets[i].alive = false

          if self.player.immortal == false then
            self.player.alive = false
            self.player.lives  = self.player.lives - 1

            self.particles:moveTo(self.player.pos.x, self.player.pos.y)
            self.particles:setEmissionArea('ellipse', self.player.radius, self.player.radius, math.rad(360), true)
            self.particles:emit(350)
          end

          if self.player.lives > 0 then
            self.player:respawn()
          end
        end

      if self.alienBullets[i].alive == false then
        table.remove(self.alienBullets, i)
      end
    end
  end

  if self.player.alive == true and self.player.lives > 0 then
    for i = #self.asteroids, 1, -1 do
      if circleCollider(self.asteroids[i], self.player) == true then
        if self.player.immortal == false then
          self.player.immortal = true
          self.player.alive = false
          self.player.lives = self.player.lives - 1

          if self.player.lives > 0 then
            self.player:respawn()
          end
        end

        -- split asteroids on impact with player ?
        --if self.asteroids[i].radius > 15 then PlayState:splitAsteroid(self.asteroids[i], self.asteroids) end

        self.particles:moveTo(self.player.pos.x, self.player.pos.y)
        self.particles:setEmissionArea('ellipse', self.player.radius, self.player.radius, math.rad(360), true)
        self.particles:emit(350)

        table.remove(self.asteroids, i)
      end
    end
  end

  if self.player.alive == true and self.ufo.alive == true then
      if circleCollider(self.ufo, self.player) == true then
        self.ufo.alive = false
        self.ufo:reset()
        if self.player.immortal == false then
          self.player.immortal = true
          self.player.alive = false
          self.player.lives = self.player.lives - 1

          if self.player.lives > 0 then
            self.player:respawn()
          end
        end
        self.particles:moveTo(self.player.pos.x, self.player.pos.y)
        self.particles:setEmissionArea('ellipse', self.player.radius, self.player.radius, math.rad(360), true)
        self.particles:emit(350)

        self.particles:moveTo(self.ufo.pos.x, self.ufo.pos.y)
        self.particles:setEmissionArea('ellipse', self.ufo.radius, self.ufo.radius, math.rad(360), true)
        self.particles:emit(350)
      end
  end

  if self.player.lives <= 0 then
    playerScore = self.score
    lastWave = self.wave
    _statemachine:change('gameover')
  end
end

function PlayState:render()
  love.graphics.draw(self.particles)

  if #self.asteroids > 0 then
    for i = #self.asteroids, 1, -1 do
      self.asteroids[i]:render()
    end
  end

  if #self.bullets > 0 then
    for i = 1, #self.bullets do
      self.bullets[i]:render()
    end
  end

  if #self.alienBullets > 0 then
    for i = 1, #self.alienBullets do
      self.alienBullets[i]:render()
    end
  end

  if self.player.alive == true and self.player.lives > 0 then
    self.player:render()
  end

  if self.ufo.alive == true then
    self.ufo:render()
  end


  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Score: ' .. self.score, 20, 15)
  love.graphics.print('Lives: ' .. self.player.lives, WIDTH - 200, 15)
end
