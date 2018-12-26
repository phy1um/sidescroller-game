

local Room = require 'room'
local World = require 'world'
--local room = Room.create(Room.getTestLoader())
local luaRoom = require 'luaRoomLoader'
local room = Room.create(luaRoom.fromFile('test.json'))
World.setRoom(room)
local message = "Game running..."

local c = {}
function c.init(x)
    x.foo = "foo"
end 
function c.draw(ctx, x)
    local st = string.format("%d:%d", x.x, x.y)
    love.graphics.print(st, x.x - 10, x.y - 30)
    love.graphics.circle("fill", x.x, x.y, 10)
end
function c.update(dt, ctx, x)
    local dx, dy = 0,0
    if love.keyboard.isDown("w") then
        dy = -2.2
    elseif love.keyboard.isDown("s") then
        dy = 2.2
    end

    if love.keyboard.isDown("a") then
        dx = -2.2
    elseif love.keyboard.isDown("d") then
        dx = 2.2
    end

    if not Room.testCollision(ctx.room, x.x + dx, x.y + dy) then
        x.x = x.x + dx
        x.y = x.y + dy
    end
end
    
World.entity.spawn(100, 100, c)

function love.draw()
    Room.draw(World.room)
    World.entity.draw(World)
    love.graphics.setColor(0,0,0)
    love.graphics.print(message, 10, 10)
end

function love.update(dt)
    World.update(dt)
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
