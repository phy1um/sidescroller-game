
local log = require 'log'
local entity = require 'entity' 

local gridW = 32
local gridH = 32

local roomComponent = {}
roomComponent.name = "__room_component"

function roomComponent:init(e, args)
    if args == nil or args.loader == nil then
        log.error("Must specify loader in args for room:init")
        love.event.quit()
    else 
        e.initLoader = args.loader
    end
end

local room = entity.superObject:extend(roomComponent)
entity.define("__room", room)

room:addMethod("load", function (self, loader)
    local root = self._parent
    local loader = loader or self.initLoader
    root:fire("roomLeave")
    -- make sure there are no stray events
    root.flushEvents()
    self.map = loader.buildMap()
    self.h = #self.map
    self.w = #self.map[1]
    self.pixelHeight = self.h * gridH
    self.pixelWidth = self.w * gridW
    if self.pixelWidth == nil or self.pixelHeight == nil then
        log.error("Could not initialise grid dimensions")
        love.event.quit()
    end
    self.tiles = loader.buildTiles()
    self.entities = {}
    local entitySpawn = loader.getEntityPlaces()
    for _,o in pairs(entitySpawn) do
        root:addEntity(entity.spawn(o.name, o.args))
    end
    root:fire("roomEnter")
end)


room:addMethod("testCollisionMap", function(self, x, y)
    local m = self.map
    if x >= 0 and x < self.pixelWidth and y >= 0 and y < self.pixelHeight then
        local ix, iy = math.floor(x/gridW)+1, math.floor(y/gridH)+1
        return m[iy][ix] ~= 0
    else
        return true
    end
end)

room:addMethod("ondraw", function(self) 
    love.graphics.setColor(255,255,255)
    for i,row in pairs(self.map) do
        for j,col in pairs(row) do
            if(col == 1) then
                love.graphics.rectangle("fill", 
                 (j-1)*gridW,  
                 (i-1)*gridH, 
                 gridW, gridH)
            end
        end
    end
end)

return room