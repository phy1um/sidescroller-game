
local entity = require 'core/entity'
local cont = {}

function cont:init(e, args)
    return
end

cont = entity.superObject:extend(cont)
entity.define("container", cont)
return cont