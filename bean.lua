Bean = {}
Bean.__index = Bean

function Bean:Create(x, y)
  local newBean = {
    x = x or 0,
    y = y or 0,
    newX,
    newY
  }
  setmetatable(newBean, self)
  return newBean
end

function Bean:Draw()
  love.graphics.setColor(love.math.colorFromBytes(235, 60, 54))
  love.graphics.circle("fill", self.x, self.y, tileSize / 10)
  love.graphics.setColor(love.math.colorFromBytes(171, 19, 65))
  love.graphics.circle("line", self.x, self.y, tileSize / 10)
end

-- calculates position that the bean should be at in relation to its goal position
function Bean:CalcPos()
  -- if math.abs(self.newX - self.x) > 0.1 then
  --   self.x = self.x + (self.newX - self.x) / 20
  -- else
  --   self.x = self.newX
  -- end

  -- if math.abs(self.newY - self.y) > 0.1 then
  --   self.y = self.y + (self.newY - self.y) / 20
  -- else
  --   self.y = self.newY
  -- end

  self.x = self.newX
  self.y = self.newY
end

-- generates a newX and newY for the bean to move to within a bin
function Bean:GenPos(bin)
  local radius = tileSize / 10
  self.newX = bin.x + math.random(radius, tileSize - radius)
  self.newY = bin.y + math.random(radius, tileSize - radius)
end