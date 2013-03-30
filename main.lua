require('gamescreen')
require('startscreen')
require('gameoverscreen')
require('sound')

spacekeypress = false

function love.load()
   -- font courtesy of Ænigma - http://www.dafont.com/fr/visitor.font
   mainFont = love.graphics.newFont("visitor1.ttf", 30);
   screen = StartScreen.create(mainFont)
   Sounds.shoot:setVolume(0.2)
   Sounds.boom:setVolume(0.5)
end

function love.update(dt)
   screen:update(dt)
   if screen.title == "start" and love.keyboard.isDown(' ') and not spacekeypress then
      screen = GameScreen.create()
   end
   if screen.title == "game" and screen.player.life <= 0 then
      screen = GameOverScreen.create(mainFont, screen.player.score)
   end
   if screen.title == "gameover" and love.keyboard.isDown(' ') and not spacekeypress then
      screen = StartScreen.create(mainFont)
   end
   spacekeypress = love.keyboard.isDown(' ')
end

function love.draw()
   screen:draw()
end