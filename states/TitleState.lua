TitleState = Class{__includes = BaseState}

function TitleState:update(dt)
  if keyDown('return') then
    _statemachine:change('play')
  end
end

function TitleState:render()
  love.graphics.setFont(font)
  love.graphics.printf('Asteroids', 0, CENTER_Y - 50, WIDTH, 'center')

  love.graphics.setFont(smallfont)
  love.graphics.printf('Press Enter', 0, CENTER_Y + 50, WIDTH, 'center')
end
