
require 'core/entity'

require 'core/text'
require 'core/vec2'
require 'core/room'
require 'collision/aabb'
require 'movers/drag'
require 'movers/simpleMover'
require 'drawable/primitive'

require 'testPlayer'

require 'log'

function argSub(args, sub)
    for k,v in pair(args) do
        if string.sub(v, 0, 1) == "$" then
            local var = string.sub(v, 1)
            local replace = sub[var]
            if replace == nil then
                log.error("Failed to do variable substitution for " .. v)
            else
               args[k] = replace 
            end
        end
    end
end

function spawnComponents(to, list)
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
            spawnComponents(e, c.components)
        end
        class = entity.superObject:extend(class)
        entity.define(c.name, class)
    end
end

