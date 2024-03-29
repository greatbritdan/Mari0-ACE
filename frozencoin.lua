--most simple entity ever
--syke, they can be frozen now
--syke syke? their not just coins anymore

frozencoin = class:new()

function frozencoin:init(x, y, t)
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1

	self.width = 1
	self.height = 1

	self.speedx = 0
	self.speedy = 0
	
	self.active = true
	self.static = true

	self.category = 32
	self.mask = {true}

	self.rotation = 0

	self.t = t or "coin"

	self.brick = false
end

function frozencoin:draw()
	local img
	if self.t == "mushroom" then
		img = mushroomfrozenimg
	elseif self.t == "nothing" then
		img = frozenimg
	elseif self.t == "muncher" then
		img = muncherfrozenimg
	elseif self.t == "brick" then
		if self.brick then
			img = coinfrozenimg
		else
			img = coinbrickfrozenimg
		end
	else
		if self.brick then
			img = coinbrickfrozenimg
		else
			img = coinfrozenimg
		end
	end
	love.graphics.draw(img, coinquads[spriteset][coinframe], math.floor((self.x-xscroll)*16*scale), ((self.y-yscroll)*16-8)*scale, 0, scale, scale)
end

function frozencoin:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function frozencoin:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function frozencoin:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function frozencoin:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function frozencoin:passivecollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function frozencoin:globalcollide(a, b)
	if (a == "fireball" and b.t == "fireball") or a == "castlefirefire" or a == "longfire" or a == "fire" or a == "plantfire" or a == "brofireball" or a == "upfire" or a == "angrysun" or b.meltsice then
		self:meltice()
	end
end

function frozencoin:meltice(destroy)
	self.active = false

	if self.t == "nothing" then
	elseif self.t == "mushroom" then
		--stupid animation
		obj = mushroom:new(self.cox-0.5, self.coy-2/16)
		obj.uptimer = mushroomtime+0.00001
		obj.speedx = mushroomspeed
		table.insert(objects["mushroom"], obj)
	elseif self.t == "muncher" then
		table.insert(objects["muncher"], muncher:new(self.x+0.5, self.y+15/16, true))
	elseif self.t == "brick" then
		if self.brick then
			objects["coin"][tilemap(self.cox, self.coy)] = coin:new(self.cox, self.coy)
		else
			local bricki = 7
			if spriteset == 2 then
				bricki = 49
			elseif spriteset == 3 then
				bricki = 122
			end
			map[self.cox][self.coy][1] = bricki
			map[self.cox][self.coy][2] = nil
			map[self.cox][self.coy].oldtile = 116
			objects["tile"][tilemap(self.cox, self.coy)] = tile:new(self.x, self.y, 1, 1, true)
			generatespritebatch()
		end
	elseif self.brick then	
		local bricki = 7
		if spriteset == 2 then
			bricki = 49
		elseif spriteset == 3 then
			bricki = 122
		end
		map[self.cox][self.coy][1] = bricki
		map[self.cox][self.coy][2] = nil
		map[self.cox][self.coy].oldtile = 116
		objects["tile"][tilemap(self.cox, self.coy)] = tile:new(self.x, self.y, 1, 1, true)
		generatespritebatch()
	else
		objects["coin"][tilemap(self.cox, self.coy)] = coin:new(self.cox, self.coy)
	end

	if destroy then
		playsound(blockbreaksound)
		local debris = "80,210,250,255"
		if blockdebrisquads[debris] then
			table.insert(blockdebristable, blockdebris:new(self.cox-.5, self.coy-.5, 3.5, -23, blockdebrisimage, blockdebrisquads[debris][spriteset]))
			table.insert(blockdebristable, blockdebris:new(self.cox-.5, self.coy-.5, -3.5, -23, blockdebrisimage, blockdebrisquads[debris][spriteset]))
			table.insert(blockdebristable, blockdebris:new(self.cox-.5, self.coy-.5, 3.5, -14, blockdebrisimage, blockdebrisquads[debris][spriteset]))
			table.insert(blockdebristable, blockdebris:new(self.cox-.5, self.coy-.5, -3.5, -14, blockdebrisimage, blockdebrisquads[debris][spriteset]))
		end
	else
		makepoof(self.x+.5, self.y+.5, "makerpoof")
	end
	objects["frozencoin"][tilemap(self.cox, self.coy)] = nil
end