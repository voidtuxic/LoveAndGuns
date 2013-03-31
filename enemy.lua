require "utils"
require "bullet"
require('sound')
vector = require "vector"
Enemy = {}
Enemy.__index = Enemy

function Enemy.create(x, y, power)
   local enemy = {}             
   setmetatable(enemy,Enemy)  
   enemy.position = {}
   enemy.position.x = x
   enemy.position.y = y
   enemy.rotation = math.random(-1,1)
   enemy.power = 0
   enemy.tpower = power
   enemy.agroradius = power*300
   enemy.hasagro = false
   enemy.bullets = {}
   enemy.bullettimer = 0
   enemy.score = power*100
   enemy.growing = true
   return enemy
end

function Enemy:update(dt, player, explosions)

	if self.growing then -- useless growing effect, si senor
		self.power = self.power + 0.1
		if self.power >= self.tpower then
			self.growing = false
		end
		return
	end
	-- agro check
	self.hasagro = utils.checkCircularCollision(self.position.x, self.position.y, player.position.x, player.position.y, self.agroradius, 10) 

	-- has agro action
	if self.hasagro then
		-- get orientation
		local delta = vector(0,0)
		delta.x, delta.y = player.position.x, player.position.y
		delta.x = delta.x - self.position.x
		delta.y = delta.y - self.position.y
		delta:normalize_inplace()
		if delta.y > 0 then
			self.rotation = math.acos(delta.x)
		else
			self.rotation = -math.acos(delta.x)
		end
		-- check if can shoot
		if utils.checkCircularCollision(self.position.x, self.position.y, player.position.x, player.position.y, self.agroradius/2, 10) then
			self.bullettimer = self.bullettimer + dt
			if self.bullettimer >= 2/self.power then -- shoot
				self.bullettimer = 0
				table.insert(self.bullets, Bullet.create(self.position.x,self.position.y, delta.x, delta.y, 4))
				Sounds.shoot:stop()
				Sounds.shoot:play()
			end
		else -- move towards player
			self.position.x = self.position.x + delta.x
			self.position.y = self.position.y + delta.y
			if delta.y > 0 then
				self.rotation = math.acos(delta.x)
			else
				self.rotation = -math.acos(delta.x)
			end
		end
	end

	-- player bullet hit
	for k,v in ipairs(player.bullets) do
		if utils.checkCircularCollision(self.position.x, self.position.y, v.position.x, v.position.y, 10*self.power, 1) then
			self.power = self.power - 0.2
   			self.agroradius = self.power*300
   			table.insert(explosions, {radius = 0, position = {x = v.position.x, y = v.position.y}}) -- add explosion
   			table.remove(player.bullets,k)
		end
	end

	-- player missile hit
	for k,v in ipairs(player.missiles) do
		if utils.checkCircularCollision(self.position.x, self.position.y, v.position2.x, v.position2.y, 10*self.power, v.exploderadius) then
			self.power = 0
   			self.agroradius = self.power*300
   			v.explode = true
   			table.insert(explosions, {radius = 0, position = {x = self.position.x, y = self.position.y}}) -- add explosion
		end
	end

	-- self bullet update
	for k,v in ipairs(self.bullets) do
	    v:update(dt)
		if v.life >= 2 then -- 2 seconds bullets, should be enough for offscreen
			table.remove(self.bullets,k)
		end
		if utils.checkCircularCollision(player.position.x, player.position.y, v.position.x, v.position.y, 10, 1) then
			player.life = player.life - 1
   			table.insert(explosions, {radius = 0, position = {x = v.position.x, y = v.position.y}}) -- add explosion
   			table.remove(self.bullets,k)
		end
	end
end

function Enemy:draw()
	love.graphics.setColor(250, 100 * (1/self.power), 100 * (1/self.power))
	love.graphics.circle("line", self.position.x, self.position.y, 10*self.power)
	love.graphics.line(self.position.x + math.cos(self.rotation)*5, self.position.y + math.sin(self.rotation)*5,
		self.position.x + math.cos(self.rotation)*(15*self.power), self.position.y + math.sin(self.rotation)*(15*self.power))
	--if self.hasagro then
	--	love.graphics.setColor(100,100,250,10)
	--else
	--	love.graphics.setColor(255,255,255,10)
	--end
	--love.graphics.circle("line", self.position.x, self.position.y, self.agroradius)
	--love.graphics.setColor(255,255,255,10)
	--love.graphics.circle("line", self.position.x, self.position.y, self.agroradius/2)
	for k,v in ipairs(self.bullets) do
	    v:draw()
	end
end