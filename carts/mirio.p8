pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- mirio
-- by touilleMan

mapsize = {height=510, width=1022}
cam = {x=0, y=0} -- top left of the camera
GRAVITY = 2
JMPBASECTRL = 6
ply = {x=1 * 8, y=13 * 8, a=0, spd=3, mod=1, anim_frame=0, moving=false, inair=false, jmpctrl=false}
objs = {}

function _init()
end

function collision_on_pos(x, y)
	if x < 0 or y < 0 or x > mapsize.width or y > mapsize.height then
		return true
	end
	celx = x / 8
	cely = y / 8
	if (fget(mget(celx, cely), 0)) then
		return true
	else
		for _, obj in pairs(objs) do
			if (obj.x / 8 == celx and obj.y / 8 == cely) then
				return true
			end
		end
	end

	return false
end

function _draw()
	cls()
	-- move camera
	cam_drift = 40
	if (ply.x > cam.x +	 128 - cam_drift) then -- too far right
		cam.x += ply.x - (cam.x + 128 - cam_drift)
	elseif (ply.x < cam.x + cam_drift) then  -- too far left
		cam.x += ply.x - (cam.x + cam_drift)
	end
	if (ply.y > cam.y + 128 - cam_drift / 2) then -- too far down
		cam.y += ply.y - (cam.y + 128 - cam_drift / 2)
	elseif (ply.y < cam.y + cam_drift) then  -- too far up
		cam.y += ply.y - (cam.y + cam_drift)
	end
	camera(cam.x, cam.y)
	-- draw entire map (cropped by camera)
  	map(0, 0, 0, 0, 128, 128)
	-- draw player
	spr_flip_x = ply.a == 0.75
	spr_flip_y = ply.a == 0.5
	spr(ply.mod, ply.x, ply.y, 1, 1, spr_flip_x, spr_flip_y)
	-- draw hud
	print("ply x: " ..  tostr(ply.x) .. " y: " ..  tostr(ply.y), cam.x, cam.y)
	print("cam x: " ..  tostr(cam.x) .. " y: " ..  tostr(cam.y), cam.x, cam.y + 10)
end

function _update()
	moving = false
	if (btn(0)) then -- left
		moving = true
		ply.a = 0.75
		new_x = ply.x - ply.spd
	elseif (btn(1)) then -- right
		moving = true
		ply.a = 0.25
		new_x = ply.x + ply.spd
	else
		new_x = ply.x
	end
	if (btn(2) and (not ply.inair or ply.jmpctrl > 0)) then -- up
		moving = true
		ply.mod = 4
		if (ply.jmpctrl == 0) then
			-- jump started
			ply.jmpctrl = JMPBASECTRL
		else
			ply.jmpctrl -= 1
		end
		new_y = ply.y - GRAVITY * 2
	else
		ply.jmpctrl = 0
		new_y = ply.y + GRAVITY
	end

	-- collision on top or bottom of the sprite
	if (new_y < ply.y) then
		collision_y = new_y
	else
		collision_y = new_y + 7
	end
	if not collision_on_pos(ply.x + 3, collision_y) then
		-- in air
		ply.inair = true
		ply.y = new_y
	elseif (ply.y > new_y) then
		-- hit something on top of us
	else
		-- hit something under us
		ply.inair = false
	end

	if (not moving) then
		ply.moving = false
		ply.mod = 1  -- idle animation id
		return
	else
		if (ply.anim_frame == 0) then
			ply.mod = (ply.mod - 1) % 2 + 2  -- moving (id 2&3) or jumping (4&5) animations
			ply.anim_frame = 8
		else
			ply.anim_frame -= 1
		end
	end

	if not collision_on_pos(new_x + 3, ply.y + 3) then
		ply.x = new_x
	end
end



__gfx__
00000000000000000000000000000000000000f0000000f000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888000008880000088800000888c0000888c000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000ff000000ff000000ff000000ff0c0000ff0c000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000c8c0000cc8c0000cc8c0000cc8c0000cc8c0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000c88c00000cf00000c88cf000c8800000c8800000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000f88f000008800000f8800000f8800000f8880000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000808000008080000080000000808000008080000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000808000080080000080000008008000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd4ffffff404440404f555555fffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddf4ffff400444004454fff04544444f440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddff4ff400044400005f044f0544444f440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddfff44000044404445444f045ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddfff4400000440444544f044544f444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddff40040004000444544f044544f444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddf40000400444404454444445ffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd4000000404444044f55f055f44444f440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010305000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303033303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303131303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303033303030343334333430303030303030303030313131303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303031313131303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303131313131303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030313131313131303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3232323232323232323232323232323232323232323232323232303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3232323232323232323232323232323232323232323232323232303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
0000000000000000000000000000000000000000000000000000000000000000000000000000000030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
0000000000000000000000000000000000000000000000000000000000000000000000000000000030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
0000000000000000000000000000000000000000000000000000000000000000000000000000000030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
0000000000000000000000000000000000000000000000000000000000000000000000000000000030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
0000000000000000000000000000000000000000000000000000000000000000000000000000000030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303030303030303030303030303030303030303030303030303030303030
