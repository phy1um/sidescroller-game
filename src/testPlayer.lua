local class = {}
local entity = require 'entity'

function class:init(e, args)
    e:attach("position", entity:spawn("vec2", args))
end 

function c.ondraw()
    local x,y = root:getPosition(self)
    love.graphics.circle("fill", x, y, 10)
end

function c:onupdate(ev)
    local dt = ev.dt
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then
        dy = -2.2
    elseif love.keyboard.isDown("s") then
        dy = 2.2
    end

    if love.keyboard.isDown("a") then
        dx = -2.2
    elseif love.keyboard.isDown("d") then
        dx = 2.2
    end

    dx, dy = dx*dt, dy*dt
    local tx, ty = self.position:add(dx, dy)
    if not root:collidesPoint(tx, ty) then
        self.position:translate(dx, dy)
    end
end

local r = entity.super:extend(c)
entity.define("testPlayer", r)
return r
