#include "scripts/utils.lua"
#include "scripts/menu.lua"
#include "scripts/savedata.lua"
#include "scripts/ui.lua"
#include "datascripts/color4.lua"
#include "datascripts/inputList.lua"

local forcefieldActive = false

local circleSprite = nil

function init()
	saveFileInit()
	menu_init()
	
	circleSprite = LoadSprite("sprites/circle.png")
end

function tick(dt)
	menu_tick(dt)
	
	if not isMenuOpen() then
		toolLogic(dt)
	end
	
	if forcefieldActive then
		doForceField()
		renderForceField()
	end
end

function draw(dt)	
	if isMenuOpen() then
		menu_draw(dt)
	else
		drawUI(dt)
	end
end

function toolLogic(dt)
	if InputPressed(binds["Toggle_Forcefield"]) then
		forcefieldActive = not forcefieldActive
	end
end

-- Object handlers

-- UI Functions (excludes sound specific functions)

function drawUI(dt)
	UiPush()
		UiAlign("left top")
		UiTranslate(UiWidth() * 0.01, UiWidth() * 0.01)
		UiFont("regular.ttf", 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		
		UiText("[" .. binds["Toggle_Forcefield"]:upper() .. "] Forcefield active: " .. tostring(forcefieldActive))
		
		UiFont("regular.ttf", 13)
		
		UiTranslate(0, 28)
		
		UiText("Menu is now in the pause menu.")
	UiPop()
end

-- World Sound functions

-- Action functions

function doForceField()
	local playerPos = GetPlayerTransform().pos
	
	local rangeVec = Vec(range / 2, range / 2, range / 2)
	
	local minPos = VecAdd(playerPos, VecScale(rangeVec, -1))
	local maxPos = VecAdd(playerPos, rangeVec)
	
	local bodies = QueryAabbBodies(minPos, maxPos)
	
	local playerVehicle = GetPlayerVehicle()
	
	for i = 1, #bodies do
		local body = bodies[i]
		
		local vehicleHandle = GetBodyVehicle(body)
		
		if IsBodyDynamic(body) and (vehicleHandle ~= playerVehicle or playerVehicle == 0) then
			local bodyTransform = GetBodyTransform(body)
			local directionFromPlayer = VecDir(playerPos, bodyTransform.pos)
			
			local mass = GetBodyMass(body)
			
			local distanceStrength = range - VecDist(playerPos, bodyTransform.pos)
			
			local strengthAdjustedDirectionVector = VecScale(directionFromPlayer, forceStrength * mass + distanceStrength * 2)
			
			--SetBodyVelocity(body, strengthAdjustedDirectionVector)
			ApplyBodyImpulse(body, bodyTransform.pos, strengthAdjustedDirectionVector)
		end
	end
end

-- Sprite functions

function renderForceField()
	local circlePos = VecAdd(GetPlayerTransform().pos, Vec(0, 0.2, 0))
	
	local lookPos = VecAdd(circlePos, Vec(0, 10, 0))
	
	local circleRot = QuatLookAt(circlePos, lookPos)
	
	local spriteTransform = Transform(circlePos, circleRot)
	
	--DrawSprite(handle, transform, width, height, [r], [g], [b], [a], [depthTest], [additive])
	DrawSprite(circleSprite, spriteTransform, range * 2, range * 2, 1, 1, 1, 1, true, false)
	DrawSprite(circleSprite, spriteTransform, range * 2, range * 2, 0, 1, 1, 1, false, false)
end

-- UI Sound Functions
