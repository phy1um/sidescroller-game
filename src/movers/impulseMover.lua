
local entity = require 'core/entity'
local inspect = require 'inspect'
local log = require 'log'

local impulse = {}
impulse.name = "Impulse Mover"

function impulse:init(e, args)
    e.impulses = {}
    e.active = {}
    for k,v in pairs(args.impulses) do
        e.impulses[k] = v
        e.active[k] = 0
    end
    e.hAccel = args.hAccel
    e.vAccel = args.vAccel
    e.hMax = args.hMax
    e.vMax = args.vMax
    e.vx = 0
    e.vy = 0
    e.simpleMoverClass = entity.getClass("simpleMover")
    e:listenFor("update")
    e:listenFor("draw")
end

impulse = entity.superObject:extend(impulse)

function sign(x)
    if x > 0 then return 1
    elseif x < 0 then return -1
    else return 0
    end
end

impulse:addMethod("ondraw", function(e)
    local px, py = e:getPosition()
    love.graphics.print(e.vx, px, py - 15)
end)

impulse:addMethod("onupdate", function(e, args)
    for im, duration in pairs(e.active) do
        if duration ~= nil and duration > 0 then
            local p = e.impulses[im]
            local sumX = e.vx + p.dx
            e.vx = math.min(math.abs(sumX), p.hMax or 999) * sign(sumX)
            local sumY = e.vy + p.dy
            e.vy = math.min(math.abs(sumY), p.vMax or 999) * sign(sumY)
            e.active[im] = e.active[im] - 1
        end
    end
    e.simpleMoverClass.methods.onupdate(e, args)

end)

impulse:addMethod("impulse", function(e, im)
    e.active[im] = e.impulses[im].duration
end)

entity.define("impulseMover", impulse)