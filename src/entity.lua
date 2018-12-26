
local Env = {}
local class_list = {}
function Env.makeList() 
    local Entity = {}
    local entity_list = {}
    local entity_unique_id = 0

    function Entity.spawn(x, y, class) 
        local e = {
            x = x,
            y = y,
            w = class.w,
            h = class.h,
            id = entity_unique_id,
            class = class,
            image_data = {
                frame = 0,
            }
        }
        entity_unique_id = entity_unique_id + 1
        class.init(e)
        --table.append(entity_list,e)
        entity_list[#entity_list+1]=e
    end

    function Entity.spawnNamed(x, y, name)
        Entity.spawn(x, y, class_list[name])
    end

    function Entity.remove(e) 
        table.remove(e)
    end

    function Entity.clear()
        entity_list = {}
    end

    function Entity.collidesPoint(x, y) 
        local ids = {}
        for _, e in pairs(entity_list) do
            if e.x >= x and e.y >= y and e.x + e.w <= x
            and e.y + e.h <= h then
                table.append(ids,e)
            end
        return ids
        end
    end

    function Entity.draw(ctx) 
        love.graphics.setColor(255,0,0)
        for _,e in ipairs(entity_list) do
            e.class.draw(ctx, e)
        end
    end

    function Entity.update(dt, ctx) 
        for _,e in ipairs(entity_list) do
            e.class.update(dt, ctx, e)
        end
    end

    return Entity
end

function Env.extend(to, from)
    to.super = from
end

function Env.defineClass(class, name)
    class_list[name] = class
end

return Env