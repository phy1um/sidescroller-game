local log = require 'log'

local component_class_list = {}
local super = {}
local super_class_name = "__super"
local export = {}
local root = {}
local json = require 'json'
local inspect = require 'inspect'

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
         if type(v) == "table" then
            v = copy(v)
         end
        cp[k] = v
    end
    return cp
end

local function extend(self, child)
    local newClass = copy(self)
    for k,v in pairs(child) do
        if type(child[k]) == "function" and type(self[k]) == "function" and k ~= "extend" then
            newClass[k] = function(me, e, args)
                self[k](me, e, args)
                child[k](me, e, args)
            end
        else 
            newClass[k] = child[k]
        end
    end
    newClass.extend = extend
    newClass.super = self
    log.info("Extended " .. self.name .. " to " .. child.name)
    return newClass
end

local function listenFor(self, event)
    log.info("Creating event for " .. event .. " in " .. self._class.name)
    self._events[#self._events + 1] = event
    if root.eventListeners[event] == nil then
        log.info("Creating event for " .. event .. " in " .. self._class.name)
        root.eventListeners[event] = {}
    end
    local listeners = root.eventListeners[event]
    listeners[#listeners + 1] = self
end

local function has(self, name)
    return self._components[name]
end

local function getPosition(self)
    local x,y = 0,0
    if self._parent ~= nil then
        x,y = self._parent:getPosition()
    end
    if self:has("position") then
        x, y = x + self:has("position").x, y + self:has("position").y
    end
    return x,y
end

super.extend = extend
super.methods = {
    attach = componentAttach,
    detach = componentDetatch,
    handleEvent = componentEvent,
    listenFor = listenFor,
    has = has,
    getPosition = getPosition
}

function super:addMethod(name, fn)
    self.methods[name] = fn
end

function super:init(e)
    e._components = {}
    e._events = {}
    e._parent = nil
    e._ref = 0
    e._class = self
    if self.super then
        e.super = self.super
    end
    for k,v in pairs(self.methods) do
        e[k] = v
    end
end

local function define(name, class)
    if class == nil then
        log.error("Nil class provided in definition for " .. name)
        love.event.quit()
    else 
        component_class_list[name] = class
    end
end

local function spawn(class, args)
    local e = {}
    local c = component_class_list[class]
    if c ~= nil then
        c:init(e, args)
        root:addEntity(e)
        return e
    else
        log.error("Could not spawn class " .. class)
        return nil
    end
end

function spawnRoot(initRoom)
    super:init(root)
    root.eventListeners = {
       update= {}, draw= {}, roomEnter= {}, roomLeave= {}, 
       keyboard= {}, mouseClick= {}, collides= {}, 
    }
    local roomClass = component_class_list["__room"]
    if roomClass == nil then
        log.error("No class defined for __room, cannot init root")
    end
    local room = {}
    roomClass:init(room, {loader=initRoom})
    root:attach("room", room)
    log.info("Attached room to root")
    if not root:has("room") then
        log.error("Failed to load room component for root")
        love.event.quit()
    end
    room:load(initRoom)
    room:listenFor("draw")
    local r = root:has("room")
    if r.map == nil or r.entities == nil then
        log.error("Failed to initialize room component")
        love.event.quit()
    end
   
end

function root:fire(event)
    local ev = event
    if type(event) == "string" then
        local tmp = event    
        event = { name= tmp } 
    end
    local name = event.name
    --log.info("Event "  .. event.name)
    local fn = "on" .. name
    if self.eventListeners[name] then
        --log.debug("Event listeners: " .. #self.eventListeners[name])
        for _,o in pairs(self.eventListeners[name]) do
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
    local pos = e:has("position")
    if e.position then
        x = x + pos.x
        y = y + pos.y
    end
    return x,y
end

function root:addEntity(e)
    local tb = self:has("room").entities
    tb[#tb + 1] = e
end

function root:collidesPoint(x, y)
    if x == nil or y == nil then
        log.error("NIL in collidesPoint")
        return true
    else
        return self:has("room"):testCollisionMap(x,y)
    end
end

function root:dump()
    log.debug(inspect(self))
end

return {
    spawn= spawn,
    define= define,
    spawnRoot= spawnRoot,
    superObject= super,
    getRoot= function() return root end
}