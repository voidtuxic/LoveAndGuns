Bullet = {}
Bullet.__index = Bullet

function Bullet.create(x, y, dx, dy, speed)
   local bullet = {}             
   setmetatable(bullet,Bullet)  
   bullet.position = {}
   bullet.position.x = x
   bullet.position.y = y
   bullet.direction = {}
   bullet.direction.x = dx
   bullet.direction.y = dy
   bullet.life = 0
   bullet.speed = speed or 8
   return bullet
end

function Bullet:update(dt)
	self.position.x = self.position.x + self.direction.x * self.speed
	self.position.y = self.position.y + self.direction.y * self.speed
	self.life = self.life + dt
end

function Bullet:draw(color)
	love.graphics.setColor(color or {250, 200, 0})
   love.graphics.circle("fill", self.position.x, self.position.y, 2)
	--love.graphics.line(self.position.x, self.position.y,
	--	self.position.x + self.direction.x*4, self.position.y + self.direction.y*4)
end