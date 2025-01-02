function love.load()
    sprites = {}
    sprites.background = love.graphics.newImage("assets/sprites/background.png")
    sprites.bullet = love.graphics.newImage("assets/sprites/bullet.png")
    sprites.player = love.graphics.newImage("assets/sprites/player.png")
    sprites.zombie = love.graphics.newImage("assets/sprites/zombie.png")

    frameRate = 60
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 5 * frameRate
end

function love.update(dt)
    keyBoardActions(dt)
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)

    love.graphics.draw(
        sprites.player,
        player.x,
        player.y,
        playerMouseAngle(),
        nil,
        nil,
        sprites.player:getWidth() / 2,
        sprites.player:getHeight() / 2
    )
end

function keyBoardActions(dt)
    local playerSpeed = player.speed * dt
    if love.keyboard.isDown("d") then
        player.x = player.x + playerSpeed
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - playerSpeed
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - playerSpeed
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + playerSpeed
    end
end


function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end