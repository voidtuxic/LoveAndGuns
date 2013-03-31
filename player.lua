require "bullet"
require "utils"
require('sound')
vector = require "vector"
Player = {}
Player.__index = Player

function Player.create(x, y)
   local player = {}             
   setmetatable(player,Player)  
   player.position = {}
   player.position.x = x
   player.position.y = y
   player.rotation = 0
   player.bullets = {}
   player.bullettimer = 0
   player.life = 100
   player.score = 0
   return player
end

function Player:update(dt)
	self.bullettimer = self.bullettimer + dt
	-- orientation
	local delta = vector(0,0)
	delta.x, delta.y = love.mouse.getPosition()
	delta.x = delta.x - self.position.x
	delta.y = delta.y - self.position.y
	delta:normalize_inplace()
	if delta.y > 0 then
		self.rotation = math.acos(delta.x)
	else
		self.rotation = -math.acos(delta.x)
	end

	-- shooting
	self.bullettimer = self.bullettimer + dt
	if self.bullettimer >= 0.2 and love.mouse.isDown('l') then
		self.bullettimer = 0
		table.insert(self.bullets, Bullet.create(self.position.x,self.position.y, delta.x, delta.y))
		table.insert(self.bullets, Bullet.create(self.position.x + math.cos(self.rotation + math.pi/2)*15,
			self.position.y + math.sin(self.rotation + math.pi/2)*15, delta.x, delta.y))
		table.insert(self.bullets, Bullet.create(self.position.x + math.cos(self.rotation - math.pi/2)*15,
			self.position.y + math.sin(self.rotation - math.pi/2)*15, delta.x, delta.y))
		Sounds.shoot:stop()
		Sounds.shoot:play()
	end

	for k,v in ipairs(self.bullets) do
	    v:update(dt)
		if v.life >= 2 then -- 2 seconds bullets, should be enough for offscreen
			table.remove(self.bullets,k)
		end
	end

	-- movement
	delta = vector(0,0)
	if(love.keyboard.isDown('w')) then
		delta.y = -1
	elseif(love.keyboard.isDown('s')) then
		delta.y = 1
	end
	if(love.keyboard.isDown('a')) then
		delta.x = -1
	elseif(love.keyboard.isDown('d')) then
		delta.x = 1
	end
	delta:normalize_inplace()
	self.position.x = utils.clamp(10, self.position.x + delta.x * 4, 1014)
	self.position.y = utils.clamp(10, self.position.y + delta.y * 4, 758)
end

function Player:draw()
	love.graphics.setColor(100, 250, 100)
    
    utils.rotate(self.rotation + math.pi/2, self.position.x, self.position.y) -- this. helper. just don't look. don't
	
	-- primitive goodness
	love.graphics.circle("line", self.position.x, self.position.y, 10)
	love.graphics.line(self.position.x, self.position.y - 5,
		self.position.x, self.position.y - 15)
	love.graphics.line(
		self.position.x - 10, self.position.y - 20,
		self.position.x - 17, self.position.y - 20,
		self.position.x - 17, self.position.y + 10,
		self.position.x - 10, self.position.y + 10,
		self.position.x - 10, self.position.y - 20
		)
	love.graphics.line(
		self.position.x + 10, self.position.y - 20,
		self.position.x + 17, self.position.y - 20,
		self.position.x + 17, self.position.y + 10,
		self.position.x + 10, self.position.y + 10,
		self.position.x + 10, self.position.y - 20
		)
	love.graphics.triangle("line",
		self.position.x + 17, self.position.y - 20,
		self.position.x + 23, self.position.y - 20,
		self.position.x + 17, self.position.y - 5
		)
	love.graphics.triangle("line",
		self.position.x - 17, self.position.y - 20,
		self.position.x - 23, self.position.y - 20,
		self.position.x - 17, self.position.y - 5
		)

    utils.rotate(-(self.rotation + math.pi/2), self.position.x, self.position.y)

	for k,v in ipairs(self.bullets) do
	    v:draw({0, 200, 250})
	end
end