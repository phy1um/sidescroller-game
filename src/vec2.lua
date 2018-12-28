
local entity = require 'entity'

local vec2 = {}
vec2.name = "Vector 2D"

function vec2:init(e, args)
    e.x = args.x
    e.y = args.y
end

vec2 = entity.superObject:extend(vec2)

vec2:addMethod("add", function(self, x, y)
    return self.x+x, self.y+y
end)

vec2:addMethod("translate", function(self, dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end)

entity.define("vec2", vec2)

return vec2