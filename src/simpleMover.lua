
local entity = require 'entity'
local root = entity.superObject
local log = require 'log'
local inspect = require 'inspect'

local simpleMover = {}
simpleMover.name = "SimpleMover"
function simpleMover:init(e, args)
    e.vx = 0
    e.vy = 0
    e:listenFor("update")
    log.debug("Simple Mover init:")
    log.debug(inspect(e))
end

simpleMover = entity.superObject:extend(simpleMover)

simpleMover:addMethod("onupdate", function(self, ev)
    if self.vx == 0 and self.vy == 0 then return end
    local dt = ev.dt or 1
    local dx,dy = self.vx, self.vy
    dx, dy = dx*dt, dy*dt
    local frict = self._parent:has("friction")
    if frict ~= nil then
        local f = frict:get()
        if self.vx > 0 then
            self.vx = math.max(self.vx - f, 0)
        elseif self.vx < 0 then
            self.vx = math.min(self.vx + f, 0)
        end
    end
    local col = self._parent:has("collision")
    local pos =  self._parent:has("position")
    if col then
        local grav = self._parent:has("gravity")
        if grav ~= nil then
            local g = grav:get()
            if not col:deltaPlaceFree(0, dy) then
                self.vy = 0
                col:moveToCollision(pos, 0, dy)
            else
                self.vy = math.min(self.vy + g, 6)
            end
        end
        if col:deltaPlaceFree(dx, 0) then
            pos:translate(dx, 0)
        end
        if col:deltaPlaceFree(0, dy) then
            pos:translate(0, dy)
        end
    else
        pos:translate(dx, dy)
    end
end)

simpleMover:addMethod("set", function(self, xx, yy)
    self:setHorizontal(xx)
    self:setVertical(yy)
end)

simpleMover:addMethod("setHorizontal", function(self, xx)
    if xx ~= nil then
        self.vx = xx
    end
end)

simpleMover:addMethod("setVertical", function(self, yy)
    if yy ~= nil then
        self.vy = yy
    end
end)

entity.define("simpleMover", simpleMover)
return simpleMover