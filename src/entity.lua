local log = require 'log'

local component_class_list = {}
local super = {}
local super_class_name = "__super"
local export = {}
local root = {}

super.name = super_class_name
super.super = nil

local function componentAttach(e, name, other)
    if not e:has(name) then
        e._components[name] = other
        other._ref = other._ref or 0 + 1
        other._parent = e
    else
        log.error("Cannot attach duplicate " .. name .. " to " .. e._class.name)
    end
end

local function componentDetach(e, name)
    if e:has(name) then
        local tmp = e._components[name]
        e._components[name] = nil
        tmp._ref = tmp._ref - 1
        if tmp._ref <= 0 then
            tmp:delete()
        end
    end
    -- do nothing on detatch superfluous
end

local function componentDelete(self)
    for name in pairs(self._components) do
        self:detach(name)
    end
    for ev,_ in pairs(self._events) do
        root.eventHandlers[ev][self] = nil
    end
end

local function componentEvent(self, event)
    local handler = "on" .. event.name
    if self[handler] then
        self[handler](event)
    else
        log.warn("Could not handle event " .. event.name ..
         " in class " .. self._class.name)
    end

end

local function copy(o)
    local cp = {}
    for k,v in pairs(o) do
        cp[k] = v
    end
    return cp
end

local function extend(self, child)
    local newClass = copy(self)
    for k,v in pairs(child) do
        if type(child[k]) == "function" and k ~= "extend" then
            newClass[k] = function(e, args)
                self[k](e, args)
                child[k](e, args)
            end
        else 
            newClass[k] = child[k]
        end
    end
    newClass.extend = extend
    newClass.super = self
end

local function listenFor(self, event)
    table.append(self._events, event)
    if not root.eventListeners[event] then
        root.eventListeners[event] = {}
    end
    table.append(root.eventListeners[event], self)
end

local function has(self, name)
    return self[name]
end

super.extend = extend
function super:init(e)
    e._components = {}
    e._events = {}
    e._parent = nil
    e._ref = 0
    e._class = self
    if self.super then
        e.super = self.super
    end
    e.attach = componentAttach
    e.detach = componentDetach
    e.delete = componentDelete
    e.handleEvent = componentEvent
    e.listenFor = listenFor
    e.has = has
end

local roomComponent = {}
roomComponent.name = "__room_component"

function roomComponent:init(e, args)
    if args.loader then
        e.initLoader = args.loader
    else 
        log.error("No loader specified for initial room")
    end
end

function roomComponent:load(loader)
    local loader = loader or self.initLoader
    root.event("roomLeave")
    -- make sure there are no stray events
    root.flushEvents()
    e.map = loader.buildMap()
    e.tiles = loader.buildTiles()
    e.entities = {}
    local entitySpawn = loader.getEntityPlaces()
    for o,_ in pairs(entitySpawn) do
        root:addEntity(spawn(o.name, o.args))
    end
    root.fire("roomEnter")
end

local function define(name, class)
    component_class_list[name] = class
end

local function spawn(class, args)
    local e = {}
    local c = component_class_list[class]
    if c then
        c:init(e, args)
        root:addEntity(e)
    else
        log.error("Could not spawn class " .. class)
    end
    return e
end

define("__room", super:extend(roomComponent))

function spawnRoot(initRoom)
   super:init(root)
   root:attach("room", spawn("__room", {
       loader= initRoom
   }))
   root.eventListeners = {
       update= {}, draw= {}, roomEnter= {}, roomLeave= {}, 
       keyboard= {}, mouseClick= {}, collides= {}, 
   }
end

function root:fire(event)
    local ev = event
    if type(event) == "string" then
        local tmp = event    
        event = { name= tmp } 
    end
    local name = event.name
    local fn = "on" .. name
    if self.eventListeners[name] then
        for o in pairs(self.eventListeners[name]) do
            if o[fn] then
                o[fn](o, event)
            else
                log.warn("No handler for event " .. fn
                 .. " in class " .. o._class.name)
            end
        end
    end
end

function root:flushEvents()
end

function root:getPosition(e)
    local x,y = 0,0
    if e._parent then
        x,y = self:getPosition(e._parent)
    end
    if e.position then
        x = x + e.position.x
        y = y + e.position.y
    end
    return x,y
end

function root:addEntity(e)
    table.append(self.room.entities, e)
end

function root:collidesPoint(e, x, y)
    return Room.testCollisionMap(self.room.map, x,y)
end

return {
    spawn= spawn,
    define= define,
    spawnRoot= spawnRoot,
    superObject= super,
    getRoot= function() return root end
}