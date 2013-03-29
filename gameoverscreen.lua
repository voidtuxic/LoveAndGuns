GameOverScreen = {}
GameOverScreen.__index = GameOverScreen

function GameOverScreen.create(mainFont, score)
   local gameoverscreen = {}             
   setmetatable(gameoverscreen,GameOverScreen)  
   gameoverscreen.titleFont = love.graphics.newFont("visitor1.ttf", 70)
   gameoverscreen.mainFont = mainFont
   gameoverscreen.bobble = 0
   gameoverscreen.score = score
   gameoverscreen.title = "gameover"
   return gameoverscreen
end

function GameOverScreen:update(dt)
   self.bobble = self.bobble + 0.05
end

function GameOverScreen:draw()
	love.graphics.setColor(255, 50, 50, 255)
   love.graphics.setFont(self.titleFont)
   love.graphics.printf("Game Over",262, 250 + math.cos(self.bobble)*5, 500,"center")

   love.graphics.setColor(255, 255, 255)
   love.graphics.printf(self.score,262, 320, 500,"center")
   
   love.graphics.setFont(self.mainFont)
   love.graphics.setColor(255, 255, 255, 255 * math.abs(math.sin(self.bobble)))
   love.graphics.printf("press SPACE to continue",262, 420, 500,"center")
end