
local entity = require 'core/entity'
local root = entity.getRoot()
local log = require 'log'
local aabb = {}


aabb.name = "AABB"
function aabb:init(e, args)
    e.w = args.w 
    e.h = args.h
end

aabb = entity.superObject:extend(aabb)

aabb:addMethod("deltaPlaceFree", function(self, dx, dy)
    local x,y = self:getPosition()
    local w,h = self.w, self.h
    x,y = x+dx, y+dy
    if root:collidesPoint(x, y) or root:collidesPoint(x+w, y) 
            or root:collidesPoint(x, y+h) or root:collidesPoint(x+w, y+h) then
        return false
    else
        return true
    end
end)

aabb:addMethod("onGround", function(self)
    local x,y = self:getPosition()
    local w,h = self.w, self.h
    local g = root:collidesPoint(x, y+h+1) or root:collidesPoint(x+w, y+h+1)
    if g == true then
        log.info("On ground")
    end
    return g
end)

aabb:addMethod("moveToCollision", function(self, pos, mx, my)
    if mx ~= 0 and mx ~= nil then
        local sign = 1
        local moved = false
        if mx < 0 then sign = -1 end
        for i=mx,0,sign do
            if self:deltaPlaceFree(i, 0) then
                pos:translate(i, 0)
                moved = true
                break
            end
        end
    end
    if my ~= 0  and my ~= nil then
        local sign = 1
        local moved = false
        if my > 0 then sign = -1 end
        for i=my,0,sign do
            if self:deltaPlaceFree(0, i) then
                pos:translate(0, i)
                moved = true
                break
            end
        end
        if moved then
            log.debug("Resolved collision down")
        end
    end
end)

aabb:addMethod("contains", function(self, px, py)
    local x,y = self:getPosition()
    if px >= x and px <= x+self.w and py >= y and py <= py+self.h then
        return true
    else
        return false
    end
end)

entity.define("aabb", aabb)