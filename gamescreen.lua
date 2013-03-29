require('player')
require('enemy')

GameScreen = {}
GameScreen.__index = GameScreen

function GameScreen.create()
   local gamescreen = {}             
   setmetatable(gamescreen,GameScreen)  
   gamescreen.enemies = {}
   gamescreen.enemytimer = math.random(5,15)
   gamescreen.explosions = {}
   gamescreen.player = Player.create(512,384)
   gamescreen.title = "game"
   for i = 1,10 do
      table.insert(gamescreen.enemies, Enemy.create(math.random(30,990),math.random(30,720),math.random(1,3)))
   end
   return gamescreen
end

function GameScreen:update(dt)
   self.player:update(dt)
   -- update current enemies
   for k,v in ipairs(self.enemies) do
      v:update(dt,self.player,self.explosions)
      if v.power <= 0.8 then 
         self.player.score = self.player.score + v.score
         table.remove(self.enemies,k)
      end
   end
   -- randomly add enemies
   self.enemytimer = self.enemytimer - dt
   if #self.enemies < 50 and self.enemytimer <= 0 then -- capping at 50 enemies max, lags if not
      self.enemytimer = math.random(5,15)
      for i = 1,math.random(3,8) do
         table.insert(self.enemies, Enemy.create(math.random(30,990),math.random(30,720),math.random(1,3)))
      end
   end
   -- update explosions
   for k,v in ipairs(self.explosions) do
      v.radius = v.radius + 0.2
      if v.radius >= 5 then
         table.remove(self.explosions, k)
      end
   end
end

function GameScreen:draw()
   for k,v in ipairs(self.enemies) do
      v:draw()
   end
   self.player:draw()

   love.graphics.setColor(255,255,0,255)
   for k,v in ipairs(self.explosions) do
      love.graphics.circle("fill", v.position.x, v.position.y, v.radius)
   end

   love.graphics.setColor(50, 250, 50, 200)
   love.graphics.rectangle("fill", 10, 10, self.player.life, 5 )
   love.graphics.print(self.player.score, 10,20)
end