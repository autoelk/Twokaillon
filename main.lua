require 'bin'
require 'bean'

function love.load(arg)
  math.randomseed(os.time())
  chaining = false
  wrapping = false

  numBins = 5
  tileSize = math.floor(math.min(love.graphics.getHeight(), love.graphics.getWidth()) / numBins)
  love.graphics.setNewFont(tileSize / 4)

  setup()
end

function setup()
  bins = generatePosition(math.random(100))
end

function love.update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(255, 255, 255))
  for i,v in ipairs(bins) do
    v:Draw()
  end
end

--[[
state represents in binary the choices to be made each turn
if chaining is not enabled, every turn the bean is sowed from the ruma
1: sow from ruma
0: sow from last sowed position
returns a winnable starting position
--]]
function generatePosition(state)
  local bins = {}
  bins[0] = 100000000000000 -- just a big number to represent infinite beans in the ruma
  for i = 1, numBins do
    bins[i] = 0
  end

  local pos = 0
  local lastSowedPosition = 0 -- only necessary for chaining
  while state > 0 do
    pos = 0
    if chaining and bit.band(state, 1) == 1 then
      pos = lastSowedPosition
    end
    state = bit.rshift(state, 1) -- move to next position in decision tree

    local beansInHand = 0
    while bins[pos] > 0 do
      -- move bean from bin to hand, then move to next bin
      bins[pos] = bins[pos] - 1
      beansInHand = beansInHand + 1
      pos = pos + 1

      if wrapping and pos > numBins then
        pos = 0
      end
    end

    -- place all beans in first empty space encountered
    bins[pos] = beansInHand
    lastSowedPosition = pos

    --[[
    io.write('R ')
    for i = 1, 5 do
      io.write(bins[i], ' ')
    end
    io.write('\n')
    --]]
  end

  bins[0] = 0 -- reset ruma

  -- convert to contain bin and bean objects
  for i = 0, numBins do
    local numBeans = bins[i]
    bins[i] = Bin:Create(i)
    for j = 1, numBeans do
      table.insert(bins[i].beans, Bean:Create(bins[i].x + tileSize / 10 + math.random(4 * tileSize / 5), bins[i].y + tileSize / 10 + math.random(4 * tileSize/ 5)))
    end
  end

  return bins
end