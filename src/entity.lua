local component_class_list = {}
local super = {}
local super_class_name = "__super"
local export = {}
local root = {}

super.name = super_class_name
super.super = nil

local function componentAttach(e, name, other)
    if ~e:has(name) then
        e._components[name] = other
        other._ref = other._ref + 1
    else
        log:error("Cannot attach duplicate " .. name .. " to " .. e._class.name)
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
        log:warn("Could not handle event " .. event.name ..
         " in class " .. self._class.name)
    end

end

local function extend(self, child)
    local newClass = self
    for k,v in pairs(child) do
        if type(child[k]) == "function" and type(self[k]) == "function" then
            newClass[k] = function(e, args)
                self[k](e, args)
                child[k](e, args)
            end
        else 
            newClass[k] = child[k]
        end
    end
    newClass.extend = extend
end

local function listenFor(self, event)
    table.append(self._events, event)
    if ~root.eventListeners[event] then
        root.eventListeners[event] = {}
    end
    table.append(root.eventListeners[event], self)
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
end

local roomComponent = {
    "name": "__room_component"
    "super": super
}

function roomComponent:init(e, args)
    if args.loader then
        e.map = args.loader.buildMap()
        e.tiles = args.loader.buildTiles()
        e.entities = args.loader.getEntityPlaces()
    else 
        log:error("No loader specified for initial room")
    end
end

function roomComponent:load(loader)
    root.event("roomLeave")
    -- make sure there are no stray events
    root.flushEvents()
    e.map = args.loader.buildMap()
    e.tiles = args.loader.buildTiles()
    e.entities = args.loader.getEntityPlaces()
    root.event("roomEnter")
end

local function define(name, class)
    component_class_list[name] = class
end

local function spawn(class, args)
    local e = {}
    local c = component_class_list[class]
    c:init(e)
    root:addEntity(e)
end

define("__room", super:extend(roomComponent))

function spawnRoot(initRoom)
   root:attach("room", spawn("__room", {
       "loader": initRoom
   }))
   root.eventListeners = {
       "update": {}, "draw": {}, "roomEnter": {}, "roomLeave": {}, 
       "keyboard": {}, "mouseClick": {}, "collides": {}, 
       "timer0": {}, "timer1": {}, "timer2": {}, "timer3": {},
       "timer4": {}
   }
end