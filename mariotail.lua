mariotail = class:new()

function mariotail:init(x, y, dir, v)
	--PHYSICS STUFF
	self.x = v.x-10/16
	self.y = y+10/16
	self.speedy = 0
	self.speedx = 0
	self.width = 2
	self.height = 8/16
	if v and v.size == 10 then
		self.height = 1
		self.y = self.y - 8/16
	end
	self.active = true
	self.static = false
	self.category = 13
	
	self.mask = {	true,
					false, true, false, false, true,
					false, true, false, true, false,
					false, true, false, true, false,
					true, true, false, false, false,
					false, true, false, false, true,
					false, false, false, false, true,
					false, true}
					
	self.destroy = false
	self.destroysoon = false
	self.playhitsound = true
	self.timer = 0
	self.gravity = 0
	self.rotation = 0 --for portals
	self.player = v
end

function mariotail:update(dt)
	self.timer = self.timer + dt
	if self.timer > raccoonspintime then
		self.destroy = true
	end
	
	self.x = self.player.x-10/16
	self.y = self.player.y+10/16
	if self.player.size == 10 then
		self.y = self.y - 8/16
	end
	
	if self.destroy or self.playhitsound == false then
		return true
	else
		return false
	end
end

function mariotail:leftcollide(a, b)
	self:hitstuff(a, b)
	return false
end

function mariotail:rightcollide(a, b)
	self:hitstuff(a, b)
	return false
end

function mariotail:floorcollide(a, b)
	self:hitstuff(a, b)
	return false
end

function mariotail:ceilcollide(a, b)
	self:hitstuff(a, b)
	return false
end

function mariotail:passivecollide(a, b)
	self:hitstuff(a, b)
	return false
end

function mariotail:hitstuff(a, b)
	if self.used then
		return
	end

	if a == "tile" then
		if self.playhitsound then
			playsound(blockhitsound)
			self.playhitsound = false
		end
		local x, y = b.cox, b.coy
		hitblock(x, y, {size=2})

		self.used = true
	elseif a == "tilemoving" then
		if self.playhitsound then
			playsound(blockhitsound)
			self.playhitsound = false
		end
		b:hit("mariotail", self)

		self.used = true
	elseif mariotailkill[a] then
		local dir = "right"
		if b.x+b.width/2 < self.x+self.width/2 then
			dir = "left"
		end
		if b.flipshell then
			--flip koopa shells
			playsound(shotsound)
			if not b.small then
				addpoints(100, b.x+b.width/2, b.y)
			end
			b:flipshell(dir)
			self.destroy = true
		else
			--kill normally
			b:shotted(dir)
			if a ~= "bowser" then
				addpoints(firepoints[a], self.x, self.y)
			end
			if a == "koopaling" then
				self.destroy = true
			end
		end
		if dir == "right" then
			makepoof(self.x+self.width, self.y+self.height/2, "pow")
		else
			makepoof(self.x, self.y+self.height/2, "pow")
		end
		self.used = true
	elseif a == "enemy" then
		local dir = "right"
		if b.x+b.width/2 < self.x+self.width/2 then
			dir = "left"
		end
		if b.shellanimal then
			--flip koopa shells
			if not b.small then
				addpoints(100, b.x+b.width/2, b.y)
			end
			b:shotted(dir, true)
			self.destroy = true
			if dir == "right" then
				makepoof(self.x+self.width, self.y+self.height/2, "pow")
			else
				makepoof(self.x, self.y+self.height/2, "pow")
			end
		elseif b:shotted(dir, "leaf", false, false) ~= false then
			--kill normally
			addpoints(b.firepoints or 200, self.x, self.y)
			if dir == "right" then
				makepoof(self.x+self.width, self.y+self.height/2, "pow")
			else
				makepoof(self.x, self.y+self.height/2, "pow")
			end
		end
		self.used = true
	end
end