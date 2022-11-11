Bean = {}
Bean.__index = Bean

function Bean:Create(x, y)
  local newBean = {
    x = x or 0,
    y = y or 0
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