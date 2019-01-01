local c = {}
local entity = require 'core/entity'
local root = entity.getRoot()
local log = require 'log'


c.name = "TestPlayer"

function c:init(e, args)
    --log.debug("Spawning player at " .. args.x .. "," .. args.y)
    --e:attach("position", entity.spawn("vec2", args))
    --e:attach("mover", entity.spawn("simpleMover"))
    --e:attach("collision", entity.spawn("aabb", {w=20,h=20}))
    --e:attach("friction", entity.spawn("friction", {friction=0.6}))
    --e:attach("gravity", entity.spawn("gravity", {gravity=0.6}))
    --e:attach("text", entity.spawn("text", {message="Player", colour={r=255,g=0,b=0}}))
    --e:attach("render", entity.spawn("circle", {r=255, g=0, b=0, radius=10}))
    e:listenFor("update")
    --e.isEntity = true
end 

local player = entity.superObject:extend(c)

player:addMethod("onupdate",  function(self, ev)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then
        if self._parent:has("collision"):onGround() then
            dy = -10.2
        end
    end

    if love.keyboard.isDown("a") then
        dx = -3.2
    elseif love.keyboard.isDown("d") then
        dx = 3.2
    end
    if dx ~= 0 then 
        self._parent:has("mover"):setHorizontal(dx)
    end
    if dy ~= 0 then
        self._parent:has("mover"):setVertical(dy)
    end
end)

entity.define("testPlayerControl", player)
return player
