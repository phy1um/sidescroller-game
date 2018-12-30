local entity = require 'entity'
local root = entity.getRoot()

local class = {}
class.name = "TextDisplay"
function class:init(e, args)
    e.message = args.message
    e.font = args.font
    e.size = args.size
    e.colour = args.colour
    e:listenFor("draw")
end


local r = entity.superObject:extend(class)

r:addMethod("ondraw", function(self)
    local x,y = root:getPosition(self)
    love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
    love.graphics.print(self.message, x, y)
end)

entity.define("text", r)

return r