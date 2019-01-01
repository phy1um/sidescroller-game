

require 'loadClasses'

local room = require 'core/room'
local entity = require 'core/entity'
local log = require 'log'
local luaRoom = require 'core/luaRoomLoader'

local initRoom = luaRoom.fromFile('test.json')

entity.spawnRoot(initRoom)
local root = entity.getRoot() 


function love.draw()
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
    if key == "p" then
        root:dump()
    end
end
