Missile = {}
Missile.__index = Missile

function Missile.create(x, y, dirx, diry, dx, dy)
   local missile = {}             
   setmetatable(missile,Missile)  
   missile.position1 = {}
   missile.position1.x = x
   missile.position1.y = y
   missile.position2 = {}
   missile.position2.x = x
   missile.position2.y = y
   missile.destination = {}
   missile.destination.x = dx
   missile.destination.y = dy
   missile.direction = {}
   missile.direction.x = dirx
   missile.direction.y = diry
   missile.life = 0
   missile.speed = 8
   missile.trailalpha = 255
   missile.explosionalpha = 255
   missile.explode = false
   missile.exploded = false
   missile.exploderadius = 0
   missile.explodemaxradius = math.random(50,100)
   return missile
end

function Missile:update(dt)
   if not self.explode and self.position2.x > self.destination.x + 15 or self.position2.x < self.destination.x - 15 then
   	self.position2.x = self.position2.x + self.direction.x * self.speed
   	self.position2.y = self.position2.y + self.direction.y * self.speed
   else
      self.explode = true
      if self.trailalpha > 0 then
         self.trailalpha = self.trailalpha - 5
      end
      if self.exploderadius < self.explodemaxradius then
         self.exploderadius = self.exploderadius + 4
      else
         self.exploded = true
         if self.explosionalpha > 0 then
            self.explosionalpha = self.explosionalpha - 5
         end
      end
   end
	self.life = self.life + dt
end

function Missile:draw()
	love.graphics.setColor(0, 200, 250, self.trailalpha)
	love.graphics.line(self.position1.x, self.position1.y,
		self.position2.x, self.position2.y)
   if self.explode then
      love.graphics.setColor(0, 200, 250, self.explosionalpha)
   end
   love.graphics.circle("fill", self.position2.x, self.position2.y, 2 + self.exploderadius)
end