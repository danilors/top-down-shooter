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

    zombies = {}
    zombieSpeed = 140

    bullets = {}
    bulletSpeed = 500
end

function love.update(dt)
    playerKeyBoardActions(dt)
    zombieMovement(dt)
    bulletsMovement(dt)
    zombieBulletsColision(dt)
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
    for i, z in ipairs(zombies) do
        love.graphics.draw(
            sprites.zombie,
            z.x,
            z.y,
            zombiePlayerAngle(z),
            nil,
            nil,
            sprites.zombie:getWidth() / 2,
            sprites.zombie:getHeight() / 2
        )
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(
            sprites.bullet,
            b.x,
            b.y,
            nil,
            0.5,
            nil,
            sprites.bullet:getWidth() / 2,
            sprites.bullet:getHeight() / 2
        )
    end
end

function playerKeyBoardActions(dt)
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

function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(enemy)
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
    local zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.speed = zombieSpeed
    zombie.dead = false
    table.insert(zombies, zombie)
end

function zombieMovement(dt)
    for i, z in ipairs(zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)

        if distanceBetween(z.x, z.y, player.x, player.y) < 50 then
            for j, z in ipairs(zombies) do
                zombies[j] = nil
            end
        end
    end
end

function bulletsMovement(dt)
    for i, b in ipairs(bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = bulletSpeed
    bullet.dead = false
    bullet.direction = playerMouseAngle()
    table.insert(bullets, bullet)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnBullet()
    end
end

function zombieBulletsColision(dt)
    for i, z in ipairs(zombies) do
        for j, b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true;
                b.dead = true
            end
        end
    end
    
    for i = #zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end
end