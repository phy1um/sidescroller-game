
local entity = require 'entity'

local vec2 = {}
function vec2:init(e, args)
    e.x = args.x
    e.y = args.y
end

function vec2:add(x, y)
    return self.x+x, self.y+y
end

function vec2:translate(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

local r = entity.superObject:extend(vec2)
entity.define("vec2", r)

return r