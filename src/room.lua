

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
    return r
end

function Room.enter(entityList, r)
    for _,e in ipairs(r.entityPlaces) do
        entityList.spawnNamed(e.x, e.y, e.name, e.args)
    end
end

function Room.testCollision(r, x, y)
    if x >= 0 and x < r.pixelWidth and y >= 0 and y < r.pixelHeight then
        local ix, iy = math.floor(x/gridW)+1, math.floor(y/gridH)+1
        return r.map[iy][ix] ~= 0
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

function Room.getJsonLoader()

end

return Room