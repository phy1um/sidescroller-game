

local Room = {}
local gridW = 32
local gridH = 32

function Room.create(loader) 
    local r = {}
    r.w, r.h = loader.getDimensions()
    r.pixelWidth, r.pixelHeight = r.w * gridW, r.h * gridH
    r.map = loader.buildMap();
    r.tiles = loader.buildTiles()
    r.entityPlaces = loader.getEntityPlaces()
    function r.enter(entityList)
        for _,e in ipairs(r.entityPlaces) do
            entityList.spawnNamed(e.x, e.y, e.name, e.args)
        end
    end
    return r
end

function Room.testCollisionMap(m, x, y)
    local pixelHeight = #m * gridH
    local pixelWidth = #m[0] * gridW
    if x >= 0 and x < pixelWidth and y >= 0 and y < pixelHeight then
        local ix, iy = math.floor(x/gridW)+1, math.floor(y/gridH)+1
        return m[iy][ix] ~= 0
    else
        return true
    end
end

function Room.draw(r) 
    love.graphics.setColor(255,255,255)
    for i,row in pairs(r.map) do
        for j,col in pairs(row) do
            if(col == 1) then
                love.graphics.rectangle("fill", 
                 (j-1)*gridW,  
                 (i-1)*gridH, 
                 gridW, gridH)
            end
        end
    end
end

function Room.getTestLoader() 
    local l = {}
    function l.getDimensions() 
        return 20, 15
    end
    function l.buildMap() 
        return {
            {0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
        }
    end
    function l.buildTiles() 
        return {}
    end
    function l.getEntityPlaces()
        return {}
    end
    return l
end

return Room