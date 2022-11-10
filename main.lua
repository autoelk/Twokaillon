function love.load(arg)
  lg = love.graphics
  lk = love.keyboard
  lw = love.window
  lm = love.mouse

  chaining = false
  wrapping = false

  setup()
end

function setup()
  bins = generatePosition(5, 8)
end

function love.update(dt)
end

function love.draw()
end

--[[
state represents in binary the choices to be made each turn
if chaining is not enabled, every turn the bean is sowed from the ruma
1: sow from ruma
0: sow from last sowed position
returns a winnable starting position
--]]
function generatePosition(numBins, state)
  local bins = {}
  bins[0] = 100000000000000 -- just a big number to represent infinite beans in the ruma
  for i = 1, numBins, 1 do
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
    io.write("R ")
    for i = 1, 5 do
      io.write(bins[i], " ")
    end
    io.write('\n')
    --]]
  end

  bins[0] = 0 -- reset ruma
  return bins
end