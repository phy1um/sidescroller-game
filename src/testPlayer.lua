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

player:addMethod("onupdate",  function(e, ev)

    if love.keyboard.isDown("w") then
        if e._parent:has("collision"):onGround() then
            e._parent:has("mover"):impulse("up")
        end
    end

    if love.keyboard.isDown("a") then
        e._parent:has("mover"):impulse("left")
    elseif love.keyboard.isDown("d") then
        e._parent:has("mover"):impulse("right")
    end
end)

entity.define("testPlayerControl", player)
return player
