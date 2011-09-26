--
local WIDE  = 10
local SPEED = 10
local UPDATE_FREQ= 200
local timeCount = 0


--Create Snake
local snake = {}
snake[1] = display.newRect(display.contentWidth *0.5,
						   display.contentHeight*0.5,
						   WIDE,
						   WIDE)
snake[1]:setFillColor(255, 255, 255)


--Create Food
local food
food = display.newRect(math.random(display.screenOriginX, display.viewableContentWidth +display.screenOriginX-WIDE),
                       math.random(display.screenOriginY, display.viewableContentHeight+display.screenOriginY-WIDE),
					   WIDE,
					   WIDE)
food:setFillColor(255, 255, 255)


--Restart
local function restart()
	--remove display
	for i,v in ipairs(snake) do
	  v:removeSelf()
	end
	food:removeSelf()
	
	--create display
	snake = {}
	snake[1] = display.newRect(display.contentWidth *0.5,
							   display.contentHeight*0.5,
							   WIDE,
							   WIDE)
	snake[1]:setFillColor(255, 255, 255)
	food = display.newRect(math.random(display.screenOriginX, display.viewableContentWidth +display.screenOriginX-WIDE),
						   math.random(display.screenOriginY, display.viewableContentHeight+display.screenOriginY-WIDE),
						   WIDE,
						   WIDE)
	food:setFillColor(255, 255, 255)
end


--FrameEvent
local xdir = SPEED
local ydir = 0
local screenTop    = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft   = display.screenOriginX
local screenRight  = display.viewableContentWidth + display.screenOriginX
print("Top:   "..screenTop)
print("Bottom:"..screenBottom)
print("Left:  "..screenLeft)
print("Right: "..screenRight)


local function animate(event)
    --if timeCount == 0 then timeCount = event.time end
	--if (event.time - timeCount) < UPDATE_FREQ then return end
	
	local xpos = snake[1].x
	local ypos = snake[1].y
	
	--hit check
	if xpos+xdir+WIDE*0.5 > screenRight or xpos+xdir-WIDE*0.5 < screenLeft then
		restart()
	    return
	end
	if ypos+ydir+WIDE*0.5 > screenBottom or ypos+ydir-WIDE*0.5 < screenTop then
	    restart()
	    return
	end
	for i,v in ipairs(snake) do
		if xpos+xdir == v.x and ypos+ydir == v.y then
			if i ~= #snake then
				restart()
				return
			end
		end
	end

	--eat food
	local xnext = xpos+xdir
	local ynext = ypos+ydir
	if (xnext >= food.x-WIDE and xnext <= food.x+WIDE) and (ynext >= food.y-WIDE and ynext <= food.y+WIDE) then
		snake[#snake+1] = display.newRect(snake[#snake].x-WIDE*0.5,
										  snake[#snake].y-WIDE*0.5,
										  WIDE,
										  WIDE)
		snake[#snake]:setFillColor(255, 255, 255)

		--reset food position
		food.x = math.random( display.screenOriginX+WIDE*0.5, display.viewableContentWidth+display.screenOriginX-WIDE*0.5 )
		food.y = math.random( display.screenOriginY+WIDE*0.5, display.viewableContentHeight+display.screenOriginY-WIDE*0.5 )
	end
	
	--move
	if #snake==1 then
		snake[1]:translate( xdir, ydir )
	else
		for i,v in ipairs(snake) do
			v.xold = v.x
			v.yold = v.y
			if i == 1 then v:translate(xdir, ydir)
			else v:translate(snake[i-1].xold-v.x, snake[i-1].yold-v.y)
			end
		end
	end
	
	print(snake[1].x, snake[1].y)
	timeCount = 0
end
timer.performWithDelay(UPDATE_FREQ, animate, 0 )
--Runtime:addEventListener( "enterFrame", animate );


--TouchEvent
local xin = 0;
local yin = 0;

local function touch(event)
    local phase = event.phase
	if phase == "began" then
		print("-----------began change dir------------")
		print("began", "event.x:"..event.x, "event.y:"..event.y)
		xin = event.x
		yin = event.y 
	elseif phase == "ended" then
		print("-----------ended change dir------------")
		print("ended", "event.x:"..event.x, "event.y:"..event.y)
		local hor = math.abs(event.x - xin)
		local ver = math.abs(event.y - yin)
		print("hor:"..hor, "ver:"..ver)
		if hor > ver then
			if event.x > xin then xdir = SPEED else xdir = SPEED*-1 end
			ydir = 0
		elseif ver > hor then
			xdir = 0
			if event.y > yin then ydir = SPEED else ydir = SPEED*-1 end
		end
		print("xdir:"..xdir, "ydir:"..ydir)
		print()
	end
end
Runtime:addEventListener( "touch", touch )