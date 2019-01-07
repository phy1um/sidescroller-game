
local entity = require 'core/entity'

require 'core/text'
require 'core/vec2'
require 'core/room'
require 'core/container'
require 'collision/aabb'
require 'movers/drag'
require 'movers/simpleMover'
require 'movers/impulseMover'
require 'drawable/primitive'

require 'testPlayer'

local log = require 'log'
local json = require 'json'

function argSub(args, sub)
    for k,v in pairs(args) do
        if type(v) == "string" and string.sub(v, 0, 1) == "$" then
            log.debug(" ## (" .. v .. ") Substituting")
            local var = string.sub(v, 2)
            if sub[var] ~= nil then
                local replace = sub[var]
                if replace == nil then
                    log.error("Failed to do variable substitution for " .. v)
                else
                   args[k] = replace 
                   log.debug(" ## (" .. v ..") New value = " .. replace)
                end
            else
                log.error("No parameter " .. var .. " provided in entity init")
            end
        else
            log.debug("For key " .. k .. " val type = " .. type(v))
        end
    end
end

function spawnComponents(to, list, args)
    for _,comp in pairs(list) do
        local compArgs = comp.args or {}
        argSub(compArgs, args)
        local sub = entity.spawn(comp.class, compArgs)
        if comp.components then
            spawnComponents(sub, comp.components)
        end
        to:attach(comp.name, sub)
    end

end

function loadClassesFromObject(o)
    for _,c in pairs(o) do
        local class = {}
        class.name = c.displayName
        function class:init(e, args)
            if e == nil then
                log.debug("### Somehow initialising nil entity? ### ")
            end
            spawnComponents(e, c.components, args)
        end
        class = entity.superObject:extend(class)
        entity.define(c.name, class)
    end
end

function loadClassesFromFile(fname)
    local data = love.filesystem.read("string", fname)
    local classes = json.decode(data)
    loadClassesFromObject(classes)
end

return {
    loadClassesFromFile=loadClassesFromFile,
    loadClassesFromObject=loadClassesFromObject
}
