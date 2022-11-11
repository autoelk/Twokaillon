require 'bean'

Bin = {}
Bin.__index = Bin

function Bin:Create(num)
  local newBin = {
    num = num,
    x = num * tileSize,
    y = tileSize * 3,
    beans = {}
  }
  setmetatable(newBin, self)
  return newBin
end

function Bin:Draw()
  love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
  if self.num == 1 then
    love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
  end
  love.graphics.rectangle("line", self.x, self.y, tileSize, tileSize, 20, 20)
  for i,v in ipairs(self.beans) do
    v:Draw()
  end
  love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
  love.graphics.printf(#self.beans, self.x, self.y + math.floor(3 * tileSize / 8), tileSize, "center")
end