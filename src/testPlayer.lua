local c = {}
local entity = require 'entity'
local root = entity.getRoot()
local log = require 'log'

require 'drag'

c.name = "TestPlayer"

function c:init(e, args)
    log.debug("Spawning player at " .. args.x .. "," .. args.y)
    e:attach("position", entity.spawn("vec2", args))
    e:attach("mover", entity.spawn("simpleMover"))
    e:attach("collision", entity.spawn("aabb", {w=20,h=20}))
    e:attach("friction", entity.spawn("friction", {friction=0.6}))
    e:attach("gravity", entity.spawn("gravity", {gravity=0.6}))
    e:listenFor("draw")
    e:listenFor("update")
    e.isEntity = true
end 

local player = entity.superObject:extend(c)

player:addMethod("ondraw", function(self)
    local x,y = self:getPosition(self)
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", x+10, y+10, 10)
end)

player:addMethod("onupdate",  function(self, ev)
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
    if dx ~= 0 then 
        self:has("mover"):setHorizontal(dx)
    end
    if dy ~= 0 then
        self:has("mover"):setVertical(dy)
    end
end)

entity.define("testPlayer", player)
return player
