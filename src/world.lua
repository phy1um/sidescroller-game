
local Entity = require 'entity'

local World = {}
World.room = {}
World.entity = Entity.makeList()
function World.setRoom(r) 
    World.room = r
    r.enter(World.entity)
end

function World.update(dt)
    World.entity.update(dt, World)
end

function World.defineClass(c, name)
    Entity.defineClass(c, name)
end

return World