StartScreen = {}
StartScreen.__index = StartScreen

function StartScreen.create(mainFont)
   local startscreen = {}             
   setmetatable(startscreen,StartScreen)  
   startscreen.titleFont = love.graphics.newFont("visitor1.ttf", 70)
   startscreen.mainFont = mainFont
   startscreen.bobble = 0
   startscreen.r = 0
   startscreen.g = 60
   startscreen.b = 128
   startscreen.rup = true
   startscreen.gup = true
   startscreen.bup = false
   startscreen.title = "start"
   return startscreen
end

function StartScreen:update(dt)
   self.bobble = self.bobble + 0.05
   -- wobly bobly title stuff
   if self.rup then
      self.r = self.r+5
   else
      self.r = self.r-5
   end
   if self.gup then
      self.g = self.g+5
   else
      self.g = self.g-5
   end
   if self.bup then
      self.b = self.b+5
   else
      self.b = self.b-5
   end
   if self.rup and self.r >= 256 then
      self.rup = false
   elseif not self.rup and self.r <= 0 then
      self.rup = true
   end
   if self.gup and self.g >= 256 then
      self.gup = false
   elseif not self.gup and self.g <= 0 then
      self.gup = true
   end
   if self.bup and self.b >= 256 then
      self.bup = false
   elseif not self.bup and self.b <= 0 then
      self.bup = true
   end
end

function StartScreen:draw()
	love.graphics.setColor(self.r, self.g, self.b, 255)
   love.graphics.setFont(self.titleFont)
   love.graphics.printf("LOVE & GUNS",262, 350 + math.cos(self.bobble)*5, 500,"center")
   
   love.graphics.setFont(self.mainFont)
   love.graphics.setColor(255, 255, 255, 255 * math.abs(math.sin(self.bobble)))
   love.graphics.printf("press SPACE to play",262, 430, 500,"center")
end