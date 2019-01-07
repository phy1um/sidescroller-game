
local entity = require 'core/entity'

local impulse = {}
impulse.name = "Impulse Mover"

function impulse:init(e, args)
    e.impulses = {}
    for k,v in pairs(args.impulses) do
        e.impulses[k] = v
    end
    e.hAccel = args.hAccel
    e.vAccel = args.vAccel
    e.hMax = args.hMax or 20
    e.vMax = args.vMax or 20
    e.vx = 0
    e.vy = 0
    e.imX = 0
    e.imY = 0
    e.simpleMoverClass = entity.getClass("simpleMover")
    e:listenFor("update")
end

impulse = entity.superObject:extend(impulse)

function sign(x)
    if x > 0 then return 1
    elseif x < 0 then return -1
    else return 0
    end
end

impulse:addMethod("onupdate", function(e, args)
    local absX = math.abs(e.imX)
    local absY = math.abs(e.imY)
    local dx = math.min(absX, e.hAccel) * sign(e.imX)
    local dy = math.min(absY, e.vAccel) * sign(e.imY)
    e.vx = e.vx + dx
    e.vy = e.vy + dy
    e.imX = e.imX - dx
    e.imY = e.imY - dy
    if math.abs(e.imX) < 0.05 then
        e.imX = 0
    end
    if math.abs(e.imY) < 0.05 then
        e.imY = 0
    end

    e.simpleMoverClass.methods.onupdate(e, args)

end)

impulse:addMethod("impulse", function(e, im)
    local imx, imy = e.impulses[im][1], e.impulses[im][2]
    e.imX = imx or 0
    e.imY = imy or 0
end)

entity.define("impulseMover", impulse)