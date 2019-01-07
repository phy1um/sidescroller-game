
local entity = require 'core/entity'

local prim = {}
prim.name = "Primitive"
function prim:init(e, args)
    e:listenFor("draw")
    for k,v in pairs(args) do
        if k == "color" or k == "colour" then
            e.r = v[1]
            e.g = v[2]
            e.b = v[3]
        else
            e[k] = v
        end
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