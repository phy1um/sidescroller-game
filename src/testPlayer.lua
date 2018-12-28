local c = {}
local entity = require 'entity'
local root = entity.getRoot()

c.name = "TestPlayer"

function c:init(e, args)
    e:attach("position", entity.spawn("vec2", args))
    e:listenFor("draw")
    e:listenFor("update")
end 

local player = entity.superObject:extend(c)

player:addMethod("ondraw", function(self)
    local x,y = self:getPosition(self)
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", x, y, 10)
end)

player:addMethod("onupdate",  function(self, ev)
    local dt = ev.dt or 1
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

    if dx == 0 and dy == 0 then
        return
    end

    dx, dy = dx*dt, dy*dt
    local tx, ty = self:has("position"):add(dx, dy)
    if not root:collidesPoint(tx, ty) then
        self:has("position"):translate(dx, dy)
    end
end)

entity.define("testPlayer", player)
return player
