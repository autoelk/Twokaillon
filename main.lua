require 'bin'
require 'bean'

function love.load(arg)
  math.randomseed(os.time())

  numBins = 7
  bins = {}
  tileSize = math.floor(math.min(love.graphics.getHeight(), love.graphics.getWidth()) / numBins)
  love.graphics.setNewFont(tileSize / 4)

  setup()
end

function setup()
  chaining = false
  wrapping = false
  gameState = "player1"

  bins = generatePosition(5)
end

function love.update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(255, 255, 255))
  for i, v in ipairs(bins) do
    bins[i]:Draw()
  end

  if gameState == "player1" or gameState == "player2" then
    love.graphics.printf(gameState, 100, 100, love.graphics.getWidth(), "left")
  end

  if gameState == "overPlayer1" then
    love.graphics.printf("Player 1 Wins", 0, math.floor(love.graphics.getHeight() / 3), love.graphics.getWidth(), "center")
  elseif gameState == "overPlayer2" then
    love.graphics.printf("Player 2 Wins", 0, math.floor(love.graphics.getHeight() / 3), love.graphics.getWidth(), "center")
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and (gameState == "player1" or gameState == "player2")then
    -- find correct bin
    for i, v in ipairs(bins) do
      if v.x <= x and x <= v.x + tileSize and v.y <= y and y <= v.y + tileSize then

        if gameState == "player1" then
          gameState = "player2"
        elseif gameState == "player2" then
          gameState = "player1"
        end

        if not sow(i) then
          endGame()
        end
      end
    end
  end
end


function endGame()
  if gameState == "player1" then
    gameState = "overPlayer2"
  elseif gameState == "player2" then
    gameState = "overPlayer1"
  end
end

-- returns a winnable starting position
function generatePosition(moves)
  for i = 1, numBins do
    bins[i] = Bin:Create(i)
  end

  -- place a large number of beans into the ruma
  for i = 1, 100 do 
    table.insert(bins[1].beans, Bean:Create())
  end

  local pos = 1
  local lastSowedPosition = 1 -- only necessary for chaining
  for i = 1, moves do
    if chaining and math.random() > 0.5 and bins[lastSowedPosition].beans > 1 then
      pos = lastSowedPosition
    else
      pos = 1
    end
    lastSowedPosition = unsow(pos)
  end

  bins[1].beans = {} -- reset ruma
  return bins
end

function unsow(pos)
  local beansInHand = {}
  while #bins[pos].beans > 0 do
    -- move bean from bin to hand, then move to next bin
    table.insert(beansInHand, bins[pos].beans[1]) -- add first bean to hand
    table.remove(bins[pos].beans) -- remove first bean
    pos = pos + 1

    if wrapping and pos > numBins then
      pos = 1
    end
  end

  bins[pos].beans = beansInHand -- place all beans in first empty space encountered
  return pos
end

function sow(pos)
  local beansInHand = bins[pos].beans
  bins[pos].beans = {}

  while #beansInHand > 0 do
    pos = pos - 1
    if pos < 1 then
      if wrapping then
        pos = #bins
      else
        return false
      end
    end

    table.insert(bins[pos].beans, beansInHand[1]) -- add first bean from hand
    table.remove(beansInHand) -- remove first bean from beansInHand
  end

  if pos == 1 then
    return true
  elseif chaining and #bins[pos].beans > 0 then
    return sow(pos)
  else
    return false
  end
end