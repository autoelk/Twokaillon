require 'bean'

Bin = {}
Bin.__index = Bin

function Bin:Create(x, y)
  local newBin = {
    x = x,
    y = y,
    beans = {}
  }
  setmetatable(newBin, self)
  return newBin
end

function Bin:Draw()
  love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))

  love.graphics.rectangle("line", self.x, self.y, tileSize, tileSize, 20, 20)

  for i, v in ipairs(self.beans) do
    v:Draw()
  end

  love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
  love.graphics.printf(#self.beans, self.x, self.y + math.floor(3 * tileSize / 8), tileSize, "center")
end

-- move x beans from this bin to other
function Bin:Move(other, x)
  x = x or 1
  for i = 1, x do
    table.insert(other.beans, self.beans[1]) -- add first bean to other
    table.remove(self.beans) -- remove first bean
    other.beans[#other.beans]:GenPos(other)
  end
end