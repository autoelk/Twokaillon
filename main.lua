require 'bin'
require 'bean'

function love.load(arg)
  math.randomseed(os.time())

  numBins = 7
  tileSize = math.floor(math.min(love.graphics.getHeight(), love.graphics.getWidth()) / numBins)
  love.graphics.setNewFont(tileSize / 4)
  hand = Bin:Create(tileSize, tileSize)
  bins = {}

  setup()
end

function setup()
  chaining = false
  wrapping = false
  gameState = "player1"

  bins = generatePosition(5)
end

function love.update(dt)
  for i, v in ipairs(bins) do
    for j, k in ipairs(v.beans) do
      k:CalcPos()
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(255, 255, 255))
  hand:Draw()
  for i, v in ipairs(bins) do
    v:Draw()
  end

  if gameState == "player1" or gameState == "player2" then
    love.graphics.printf(gameState, 100, tileSize * 5, love.graphics.getWidth(), "left")
  end

  if gameState == "overPlayer1" then
    love.graphics.printf("Player 1 Wins", 0, math.floor(love.graphics.getHeight() / 3), love.graphics.getWidth(), "center")
  elseif gameState == "overPlayer2" then
    love.graphics.printf("Player 2 Wins", 0, math.floor(love.graphics.getHeight() / 3), love.graphics.getWidth(), "center")
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and (gameState == "player1" or gameState == "player2") then
    -- find correct bin
    for i, v in ipairs(bins) do
      if v.x <= x and x <= v.x + tileSize and v.y <= y and y <= v.y + tileSize then

        if gameState == "player1" then
          gameState = "player2"
        elseif gameState == "player2" then
          gameState = "player1"
        end

        if not sow(i) then
          if gameState == "player1" then
            gameState = "overPlayer2"
          elseif gameState == "player2" then
            gameState = "overPlayer1"
          end
        end
      end
    end
  end
end

-- returns a winnable starting position
function generatePosition(moves)
  for i = 1, numBins do
    bins[i] = Bin:Create(i * tileSize, 3 * tileSize)
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

-- unsow from given position, returns last sowed position
function unsow(pos)
  while #bins[pos].beans > 0 do
    bins[pos]:Move(hand)
    pos = pos + 1

    if wrapping and pos > numBins then
      pos = 1
    end
  end

  -- place all beans in first empty space encountered
  hand:Move(bins[pos], #hand.beans)
  return pos
end

-- sow from given position, returns true if sow was successful
function sow(pos)
  bins[pos]:Move(hand, #bins[pos].beans)

  while #hand.beans > 0 do
    pos = pos - 1
    
    if pos < 1 then
      if wrapping then
        pos = #bins
      else
        return false
      end
    end

    hand:Move(bins[pos])
  end

  if pos == 1 then
    return true
  elseif chaining and #bins[pos].beans > 0 then
    return sow(pos)
  else
    return false
  end
end