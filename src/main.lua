

local room = require 'room'
local entity = require 'entity'
local log = require 'log'
local luaRoom = require 'luaRoomLoader'
local initRoom = luaRoom.fromFile('test.json')

entity.spawnRoot(initRoom)
local root = entity.getRoot() 

require 'vec2'
require 'testPlayer'
require 'textDisplay'

function love.draw()
        if root:has("room") and root:has("room").map then
            room.draw(root:has("room").map)
        else
            log.warn("No room to draw in root object")
            love.event.quit()
        end
        root:fire("draw")
end

function love.update(dt)
    root:fire("update", {dt})
end

function love.quit()
    root:dump()
    return 
end

function love.keypressed(key ,scan, isrepeat)
    if key == "escape" then
        message = "Quit!"
        love.event.quit()
    end
end
