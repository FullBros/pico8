pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

--- thanks
--- @2darray


--
-- game
--

function _init()

end

function _update()
  player_move()
end

function _draw()
  cls()
  map_display()
  player_display()
  camera_follow()
  print_debug()
end


-->8

--
-- players
--


function create_player ()

  p = {}
  p.character = 1
  p.spr = (p.character == 1) and 1 or 17

  p.x = 30
  p.y = 30

  p.w = 8
  p.h = 8

  p.speed = .8
  p.vx = 0
  p.vy = 0
  p.vmax = 3
  p.vths = .3
  p.friction = .8

  p.frame = 0
  p.running = false
  p.flipped = false

  return p

end

player = create_player()

speed = 0
beat = 0

function player_move()

  -- player actions
  i = {x = 0, y = 0} -- input
  if( btn(0) ) then i.x = -1 end
  if( btn(1) ) then i.x = 1 end
  if( btn(2) ) then i.y = -1 end
  if( btn(3) ) then i.y = 1 end

  if (abs(i.x) + abs(i.y) > 1) then
    -- normalize diagonal moves
    dist = sqrt(i.x*i.x+i.y*i.y)
    i.x /= dist
    i.y /= dist
  end


  -- velocity
  player.vx += i.x * player.speed
  player.vy += i.y * player.speed

  if (abs(player.vx) < player.vths) player.vx = 0
  if (abs(player.vy) < player.vths) player.vy = 0


  -- collision detection
  c = player_collision(player)
  --add(debug, c)
  if (c == 1) then player.vx *= -player.friction end
  if (c == 2) then player.vy *= -player.friction end

  -- move
  player.x += player.vx
  player.y += player.vy


  -- sound
  if player.running then
    if (beat == 0) sfx(2)
    beat = (beat + 1) % 4
  end



   -- friction
   player.vx *= player.friction
   player.vy *= player.friction
end


function player_display()
  player.frame = (player.frame+1) %4
  player.running = abs(player.vx) > 0 or abs(player.vy) > 0
  player.flipped = player.vx < 0

  sprite = player.running and player.spr + player.frame + 1 or player.spr
  spr(sprite, player.x, player.y, 1, 1, player.flipped)
end


-->8

---
--- map
---

function map_display()
  map(0,0,0,0,128,128)
end


function collision (x,y)
  sprite = mget(flr(x)/8, flr(y)/8)
  return not fget(sprite, 1)
end


function player_collision (p)

  tx = p.x + p.vx
  ty = p.y + p.vy

  --add(debug, collision(tx, ty+p.h))
  --add(debug, collision(tx+p.w, ty+p.h))

  if
    collision(tx, ty+p.h) and
    collision(tx+p.w, ty+p.h)
  then return 2 end


  if
     collision(tx, ty+p.h) or
     collision(tx+p.w, ty+p.h)
  then return 1 end


  return 0

end




---
--- camera
---

function create_camera(x, y)

   cam = {}
   cam.x = x
   cam.y = y
   cam.stiffness = .2

   return cam

end

cam = create_camera(player.x, player.y)


function camera_follow()

   cam.x += ((player.x-64) - cam.x) * cam.stiffness
   cam.y += ((player.y-64) - cam.y) * cam.stiffness
   camera(cam.x, cam.y)
end





-->8

--
-- utilities
--

-- debug
debug = {}

function print_debug()
  j = 0

  for i in all(debug) do
    print(i, camx, camy + j*10 )
    j += 1
  end

  debug = {}
end


-- dark
dpal={0,1,1,2,1,13,6,2,4,9,3,13,5,2,9}
function dark(l)
 l=l or 0
 if l>0 then
  for i=0,15 do
   col=dpal[i] or 0
   for a=1,l-0.5 do
    col=dpal[col]
   end
   pal(i,col)
  end
 end
end




__gfx__
000000000009990000999900000999000099990000099900000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
00000000009fff900999ff900099ff900999ff900099ff90000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
007007000993f390999ff300099ff300999ff300099ff300000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
00077000999fff00099fff00999fff00099fff00999fff00000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
0007700009988880009888f0099888000098880009988800000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
0070070000f888f0000f88000008f80000088f000008f800000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
000000000008880000588850000888000058885000088800000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
000000000005050000000000000055000000000000005500000000000000000000000000dddddddd666666661111111100000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000ee8a8eee0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000eee8eee80000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeee0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000eeee8eee0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeee0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000ee8eeee80000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000008eeeee8a0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000eee8eee80000000000000000000000000000000000000000
__label__
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
00000000000000000000000000000000001111111166666666666666666666666666666666666666666666666666666666666666666666666611111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111ddddddddddddddddddddddddd999dddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddd9fff9ddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111ddddddddddddddddddddddd993f39ddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddd999fffdddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111ddddddddddddddddddddddd998888ddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111ddddddddddddddddddddddddf888fddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111ddddddddddddddddddddddddd888dddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111ddddddddddddddddddddddddd5d5dddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd11111111000000
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000011111111111111111111111111111111dddddddddddddddd1111111111111111111111111111111111111111111111
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
000000000000000000000000000000000000000000111111116666666666666666dddddddddddddddd6666666666666666666666666666666666666666666666
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
00000000000000000000000000000000000000000011111111dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd

__gff__
0000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000b0b0b0b0b0b0b0b0b0b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b1a1a1a1a1a1a1a1a1a0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b1a1a1a1a1a1a1a1a1a0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0909090909090909090b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0909090909090909090b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0909090909090909090b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0909090909090909090b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0909090909090909090b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0b0b0b09090b0b0b0b0b0b0b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b0a0a09090a0a0a0a0a0a0a0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b0a0a09090a0a0a0a0a0a0a0b0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b09090909090909090909090b0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b09090909090909090909090a0909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b09090909090909090909090a0909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b0909090909090909090909090909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b0909090909090909090909090909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b09090909090909090909090b0909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b09090b0b0b0b0b0b0b09090b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b0a0a0a0a0a09090a0a0a0a0b0a0a09090a0a0a0a0a0a0a0a0a0a0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b0a0a0a0a0a09090a0a0a0a0b0a0a09090a0a0a0a0a0a0a0a0a0a0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090a09090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090a09090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090909090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090b09090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090b09090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b09090909090909090909090b09090909090909090909090909090b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000180100e0100e0100601000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000800000100700a0600705000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000d010050100101000010100000a0000700000000100000a0000700000000100000a0000700000000100000a0000700000000100000a0000700000000100000a0000700000000100000a0000700000000
__music__
00 01424344

