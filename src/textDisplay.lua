local entity = require 'entity'
local root = entity.getRoot()

local class = {}
function class:init(e)
    e.message = args.message
    e.font = args.font
    e.size = args.size
    e.colour = args.colour
end

function class:ondraw()
    local x,y = root:getPosition(self)
    love.graphics.print(self.message, x, y)
end

local r = entity.superObject:extend(class)
entity.define("text", r)

return r