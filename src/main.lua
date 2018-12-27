
local entity = require 'entity'
local luaRoom = require 'luaRoomLoader'
local initRoom = luaRoom.fromFile('test.json')

entity.spawnRoot()
local root = entity.getRoot() 

require 'vec2'
require 'testPlayer'
require 'textDisplay'

function love.draw()
    root:fire("draw")
end

function love.update(dt)
    root:fire("update", {dt})
end

function love.quit()
    return 
end

function love.keypressed(key ,scan, isrepeat)
    if key == "escape" then
        message = "Quit!"
        love.event.quit()
    end
end
