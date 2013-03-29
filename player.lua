require "bullet"
require "utils"
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
	love.graphics.circle("line", self.position.x, self.position.y, 10)
	love.graphics.line(self.position.x + math.cos(self.rotation)*5, self.position.y + math.sin(self.rotation)*5,
		self.position.x + math.cos(self.rotation)*15, self.position.y + math.sin(self.rotation)*15)

	for k,v in ipairs(self.bullets) do
	    v:draw()
	end
end