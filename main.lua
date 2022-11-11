require 'bin'
require 'bean'

function love.load(arg)
  math.randomseed(os.time())
  chaining = true
  wrapping = true

  numBins = 7
  bins = {}
  tileSize = math.floor(math.min(love.graphics.getHeight(), love.graphics.getWidth()) / numBins)
  love.graphics.setNewFont(tileSize / 4)

  setup()
end

function setup()
  for i = 1, numBins do
    bins[i] = 0
  end
  bins = generatePosition(5)
  updateView()
end

function love.update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(love.math.colorFromBytes(255, 255, 255))
  for i,v in ipairs(objectBins) do
    v:Draw()
  end
end

-- use model to construct a view
function updateView()
  objectBins = {}
  for i,v in ipairs(bins) do
    table.insert(objectBins, Bin:Create(i));
    for j=1, v do
      local x = objectBins[i].x + tileSize / 10 + math.random(4 * tileSize / 5)
      local y = objectBins[i].y + tileSize / 10 + math.random(4 * tileSize / 5)
      table.insert(objectBins[i].beans, Bean:Create(x, y))
    end
  end
end

-- returns a winnable starting position
function generatePosition(moves)
  bins[1] = 100000000000000 -- just a big number to represent infinite beans in the ruma

  local pos = 1
  local lastSowedPosition = 1 -- only necessary for chaining
  for i = 1, moves do
    pos = 1
    if chaining and math.random() > 0.5 and bins[lastSowedPosition] > 1 then
      pos = lastSowedPosition
    end
    lastSowedPosition = unsow(pos)
  end

  bins[1] = 0 -- reset ruma
  return bins
end

function unsow(pos)
  local beansInHand = 0
  while bins[pos] > 0 do
    -- move bean from bin to hand, then move to next bin
    bins[pos] = bins[pos] - 1
    beansInHand = beansInHand + 1
    pos = pos + 1

    if wrapping and pos > numBins then
      pos = 1
    end
  end

  -- place all beans in first empty space encountered
  bins[pos] = beansInHand
  return pos
end

function sow(pos)
  local beansInHand = bins[pos]
  bins[pos] = 0
  while beansInHand > 0 do
    pos = pos - 1
    bins[pos] = bins[pos] + 1
    beansInHand = beansInHand - 1

    if wrapping and bins[pos] < 0 then
      pos = #bins
    else
      return false
    end
  end

  if pos == 1 then
    return true
  elseif chaining and bins[pos] > 0 then
    return sow(pos)
  else
    return false
  end
end