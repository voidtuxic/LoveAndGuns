require('player')
require('enemy')
require('utils')

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
   gamescreen.stagenumber = 1
   gamescreen.stagestarttimer = 5
   gamescreen.stagewaves = 0
   return gamescreen
end

function GameScreen:update(dt)
   self.player:update(dt)

   -- update explosions
   for k,v in ipairs(self.explosions) do
      v.radius = v.radius + 0.2
      if v.radius >= 5 then
         table.remove(self.explosions, k)
      end
   end

   -- stage announcement
   if self.stagestarttimer > 0 then
      self.stagestarttimer = self.stagestarttimer - dt
      return
   end

   -- check if stage ended
   if self.stagewaves >= self.stagenumber and #self.enemies == 0 then
      self.stagewaves = 0
      self.stagenumber = self.stagenumber + 1
      self.stagestarttimer = 5
      return
   end

   -- update current enemies
   for k,v in ipairs(self.enemies) do
      v:update(dt,self.player,self.explosions)
      if not v.growing and v.power <= 0.8 then 
         self.player.score = self.player.score + v.score
         table.remove(self.enemies,k)
         Sounds.boom:stop()
         Sounds.boom:play()
      end
   end

   -- randomly add enemies
   self.enemytimer = self.enemytimer - dt
   if self.stagewaves < self.stagenumber 
         and ((#self.enemies < 50 and self.enemytimer <= 0) or #self.enemies == 0) then -- capping at 50 enemies max, lags if not
      self.enemytimer = math.random(5,15)
      self.stagewaves = self.stagewaves + 1 -- new wave of enemies
      for i = 1,math.random(10 + utils.clamp(0,5*(self.stagenumber/5),35),
                              20 + utils.clamp(0,5*(self.stagenumber/5),35)) do -- you're not surviving. not today
         table.insert(self.enemies, Enemy.create(math.random(30,990),math.random(30,720),math.random(1,5)))
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

   love.graphics.setColor(255,255,255,255)
   if self.stagestarttimer > 0 then
      love.graphics.printf("STAGE "..self.stagenumber,262, 364, 500,"center")
   else
      love.graphics.printf("STAGE "..self.stagenumber.." - "..self.stagewaves,262, 0, 500,"center")
   end
end