
local entity = require 'entity'

local markerClass = {}
markerClass.name = "Marker"

function markerClass:init(e, args)
    e.name = args.name
    for k,v in pairs(args.fields) do
        e[k] = v
    end
end

markerClass = entity.superObject:extend(markerClass)
entity.define("marker", markerClass)

local markerProvider = {}
markerProvider.name = "Marker Service"
function markerProvider:init(e, args)
    e.markers = {}
end

markerProvider = entity.superObject:extend(markerProvider)

markerProvider:addMethod("register", function(e)
    if self.markers[e.name] == nil then
        self.markers[e.name] = e
    end
end)

markerProvider:addMethod("unregister", function(e)
    if type(e) == "string" then 
        self.markers[e] = nil
    else
        self.markers[e.name] = nil
    end
end)

markerProvider:addMethod("get", function(name)
    return self.markers[name]
end)

entity.define("markerProvider", markerProvider)