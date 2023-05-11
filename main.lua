--[[
    Love2d looks for main functions 
     it has a certain order that the program HAS TO run

]]
Class = require 'class'
push = require 'push'
require 'Ball'
require 'Paddle'

--screen ratio 16:9
WINDOW_WIDTH = 750
WINDOW_HEIGHT = 750

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 432

PADDLE_SPEED = 200
player1= Paddle(10,30,5,20)
player2= Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)
player3= Paddle(30,10,20,5)
player4= Paddle(VIRTUAL_WIDTH+10,VIRTUAL_HEIGHT-10,20,5)
player1Score=7
player2Score=7
player3Score=7
player4Score=7

--runs when the game first starts up, only once... ONLY ONCE
function love.load()
    -- nearest-nearest filtering on upscaling and downscaling to prevent blurring of text and graphics
    love.graphics.setDefaultFilter('nearest','nearest')

    --set the seed of the serve
    math.randomseed(os.time())

    --more retro font
    smallFont=love.graphics.newFont('font.ttf',8)
    largeFont=love.graphics.newFont('font.ttf',16)
    scoreFont=love.graphics.newFont('font.ttf',32)
    --set font to retro look
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
    }

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })

    ball = Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,4,4)

    gameState='start'
end

function love.update(dt)
    if love.keyboard.isDown('w')then
        player1.dy=-PADDLE_SPEED
         
    elseif love.keyboard.isDown('s')then
        player1.dy=PADDLE_SPEED
    else
        player1.dy=0
    end
    if love.keyboard.isDown('up')then
        player2.dy=-PADDLE_SPEED
    elseif love.keyboard.isDown('down')then
        player2.dy=PADDLE_SPEED
    else
        player2.dy=0
    end
    if love.keyboard.isDown('r')then
        player3.dx=-PADDLE_SPEED
    elseif love.keyboard.isDown('f')then
        player3.dx=PADDLE_SPEED
    else
        player3.dx=0
    end
    if love.keyboard.isDown('u')then
        player4.dx=-PADDLE_SPEED
    elseif love.keyboard.isDown('j')then
        player4.dx=PADDLE_SPEED
    else
        player4.dx=0
    end

    if gameState == 'serve' then 
        if servingPlayer == 1 then 
            ball.dx = math.random(140,200)
            ball.dy = math.random(-50,50)
        elseif servingPlayer == 2 then
            ball.dx = math.random(-140,-200)
            ball.dy = math.random(-50,50)
        elseif servingPlayer == 3 then 
            ball.dy = math.random(-140,-200)
            ball.dx = math.random(-50,50)
        elseif servingPlayer == 4 then
            ball.dy = math.random(140,200)
            ball.dx = math.random(-50,50)
        end

    elseif gameState == 'play' then

        if ball:collides(player1)then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x+5
            if ball.dy<0 then 
                ball.dy= - math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2)then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x-5
            if ball.dy<0 then 
                ball.dy= - math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player3)then
            ball.dy = -ball.dy * 1.03
            ball.y = player3.y+5
            if ball.dx<0 then 
                ball.dx= - math.random(10,150)
            else
                ball.dx = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player4)then
            ball.dy = -ball.dy * 1.03
            ball.y = player4.y-5
            if ball.dx<0 then 
                ball.dx= - math.random(10,150)
            else
                ball.dx = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        ball:update(dt)
    end

    if ball.x < 0 then
        player1Score = player1Score - 1
        servingPlayer = 1
            sounds['score']:play()
            ball:reset()
            gameState = 'serve'
    end
    if ball.x > VIRTUAL_WIDTH then     -- player 1 and 2 get mixed up somewhere here. I'm not sure how or why, but I made it work.  
        player2Score = player2Score - 1
        servingPlayer = 2
            sounds['score']:play()
            ball:reset()
            gameState = 'serve'
    end
    if ball.y < 0 then
        player3Score = player3Score - 1
        servingPlayer = 4
            sounds['score']:play()
            ball:reset()
            gameState = 'serve'
    end
    if ball.y > VIRTUAL_HEIGHT then
        player4Score = player4Score - 1
        servingPlayer = 3
            sounds['score']:play()
            ball:reset()
            gameState = 'serve'
    end

    player1:update(dt)
    player2:update(dt)
    player3:update(dt)
    player4:update(dt)
end

function love.keypressed(key)
    if key =='escape' then
        love.event.quit()
    elseif key=='enter' or key=='return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        
        elseif gameState == 'done' then
            gameState = 'serve'
            ball:reset()
            player1Score = 7
            player2Score = 7
            player3Score = 7
            player4Score = 7
        end

    end
end
--called after update function by Love2d, this draws what is on your screen
function love.draw()
    --begin rendering a virtual res
    push:apply('start')


    love.graphics.clear(40,45,52,255)
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(LoosingPlayer) .. ' Looses!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(255,255,0)
    love.graphics.print(tostring(player4Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(0,255,0)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
    love.graphics.setColor(255,0,0)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 - 50, 100 )
    love.graphics.setColor(0,0,255)
    love.graphics.print(tostring(player3Score), VIRTUAL_WIDTH / 2 + 30, 100 )
        
    if player1Score > 0 then      -- How the game gets reset and where the looser is determind. This is where the player 1 and 2 mix up gets comprimised.
        love.graphics.setColor(255,0,0)
        player1:render()
    else
        LoosingPlayer = "1" 
        gameState = 'done'
    end
    if player2Score > 0 then 
        love.graphics.setColor(0,255,0)
        player2:render()
    else
        LoosingPlayer = "2" 
        gameState = 'done'
    end
    if player3Score > 0 then 
        love.graphics.setColor(0,0,255)
        player3:render()
    else 
        LoosingPlayer = "3"
        gameState = 'done'
    end
    if player4Score > 0 then 
        love.graphics.setColor(255,255,0)
        player4:render()
    else 
        LoosingPlayer = "4"
        gameState = 'done'
    end
    love.graphics.setColor(255,255,255)
    ball:render()
    displayFPS()
    --end rendering
    push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

--[[
    Called by LÖVE whenever we resize the screen; here, we just want to pass in the
    width and height to push so our virtual resolution can be resized as needed.
]]
function love.resize(w, h)
    push:resize(w, h)
end
