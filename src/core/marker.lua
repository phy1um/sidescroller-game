
local entity = require 'entity'

local markerClass = {}
markerClass.name = "Marker"

function markerClass:init(e, args)
    e.name = args.name
    for k,v in pairs(args.fields) do
        e[k] = v
    end
    register(e)
end

markerClass = entity.superObject:extend(markerClass)
entity.define("marker", markerClass)

local markerTargeter = {}
markerTargeter.name = "Marker Targeter"
function markerTargeter:init(e, args)
    e.target = args.target
end

markerTargeter = entity.superObject:extend(markerTargeter)

markerTargeter:addMethod("getPosition", function(e)
    local target = markerList[e.target]
    return target:getPosition()
end)

entity.define("targetMarker", markerTargeter)

local markerList = {}
function register(m)
    markerList[m.name] = m    
end

function unregister(m)
    markerList[m.name] = nil
end

function get(name)
    return markerList[name]
end

return {
    register = register,
    unregister = unregister,
    get = get
}