
local entity = require 'core/entity'

local prim = {}
prim.name = "Primitive"
function prim:init(e, args)
    e:listenFor("draw")
    for k,v in pairs(args) do
        e[k] = v
    end
end

local box = entity.superObject:extend(prim)

box:addMethod("ondraw", function(self) 
    local x,y = self:getPosition()
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.rectangle("fill", x, y, self.w, self.h)
end)

local circle = entity.superObject:extend(prim)

circle:addMethod("ondraw", function(self)
    local x,y = self:getPosition()
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", x, y, self.radius)
end)

circle.name = "Primitive-Circle"
box.name = "Primitive-Rectangle"
entity.define("rectangle", box)
entity.define("circle", circle)