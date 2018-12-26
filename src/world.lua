
local Entity = require 'entity'

local World = {}
World.room = {}
World.entity = Entity.makeList()
function World.setRoom(r) 
    World.room = r
end

function World.update(dt)
    World.entity.update(dt, World)
end

return World