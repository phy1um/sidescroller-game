local json = require 'json'
local loader = {}

function loader.fromFile(fname)
    local l ={}
    local data = love.filesystem.read("string", fname)
    local levelData = json.decode(data)
    function l.getDimensions()
        return levelData.width, levelData.height
    end
    function l.buildMap()
        return levelData.map
    end
    function l.buildTiles()
        return levelData.tiles 
    end
    return l
end

return loader