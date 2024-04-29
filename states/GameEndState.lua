GameEndState = Class{__includes = BaseState}

function GameEndState:init()
end

function GameEndState:update(dt)
  if keyDown('return') == true then
    _statemachine:change('play')
  end
end

function GameEndState:render()
  love.graphics.setFont(font)
  love.graphics.printf('Game Over!', 0, 0 + 50, WIDTH, 'center')

  if playerScore > highScore then
    love.graphics.setFont(smallfont)
    love.graphics.printf('New High Score!: ' .. tostring(highScore), 0, CENTER_Y - 100, WIDTH, 'center')
  else
    love.graphics.setFont(smallfont)
    love.graphics.printf('High Score: ' .. tostring(highScore), 0, CENTER_Y - 100, WIDTH, 'center')

    love.graphics.setFont(smallfont)
    love.graphics.printf('Your Score: ' .. tostring(playerScore), 0, CENTER_Y - 50, WIDTH, 'center')
  end

  love.graphics.setFont(smallfont)
  love.graphics.printf('Waves Survived: ' .. tostring(lastWave), 0, CENTER_Y + 10, WIDTH, 'center')

  love.graphics.setFont(smallfont)
  love.graphics.printf('Press Enter To Play Again', 0, CENTER_Y + 125, WIDTH, 'center')
end
