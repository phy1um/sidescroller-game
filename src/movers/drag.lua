
local entity = require 'core/entity'
local log = require 'log'
local GRAVITY_DEFAULT = 1.6

local grav = {}
grav.name = "Gravity"
function grav:init(e, args)
    if args.gravity ~= nil then
        e.gravity = args.gravity
    else
        log.debug("Using default grav")
        e.gravity = GRAVITY_DEFAULT
    end
end

grav = entity.superObject:extend(grav)

grav:addMethod("get", function(self)
    return self.gravity
end)

local frict = {}
frict.name = "Friction"
function frict.init(e, args)
    if args.friction ~= nil then
        e.friction = args.friction
    else
        e.friction = 0
    end
end

frict = entity.superObject:extend(frict)

frict:addMethod("get", function(self)
    return self.friction or 0.6
end)

entity.define("friction", frict)
entity.define("gravity", grav)