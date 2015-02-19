



net.Receive("StaminaSpawn", function(len)

	local ply = LocalPlayer()


	local MaxStamina = net.ReadFloat()
	local RegenMul = net.ReadFloat()
	local DecayMul = net.ReadFloat()
	
	
	ply.BurgerStamina = MaxStamina
	ply.BurgerMaxStamina = MaxStamina
	ply.BurgerDecayMul = DecayMul
	ply.BurgerRegenMul = RegenMul
	

end)

local JumpLatch = 0

function GetClientMove(cmd)

	local ply = LocalPlayer()

	local NewButtons = cmd:GetButtons()
	
	local Change = FrameTime() * 5
	
	if not first then
	
		ply.BurgerStamina = 100
		ply.BurgerMaxStamina = 100
		ply.BurgerDecayMul = 1
		ply.BurgerRegenMul = 1
		
		
		
		ply.NextRegen = 0
		ply.WaterTick = 0
		
		first = true
		
	end


	if cmd:KeyDown(IN_SPEED) and ( cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) ) and (ply:GetVelocity():Length() > 0) and ( ply:OnGround() or ply:WaterLevel() ~= 0 ) then
	
		if ply.BurgerStamina <= 0 then
		
			NewButtons = NewButtons - IN_SPEED

		else
			
			ply.NextRegen = CurTime() + 1.25
			ply.BurgerStamina = math.Clamp(ply.BurgerStamina - Change * ply.BurgerDecayMul,0,ply.BurgerMaxStamina)

		end
		
	end
	
	--Jumping code provided by bobbleheadbob
	if cmd:KeyDown(IN_JUMP) and ply:OnGround() then
	
		if ply.BurgerStamina <= 5 then
		
			NewButtons = NewButtons - IN_JUMP
			
		else

			if not JumpLatch then

				if cmd:KeyDown(IN_SPEED) and ( cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) ) then
					ply.BurgerStamina = math.Clamp(ply.BurgerStamina - 25*ply.BurgerDecayMul,0,ply.BurgerMaxStamina)
				else
					ply.BurgerStamina = math.Clamp(ply.BurgerStamina - 5*ply.BurgerDecayMul,0,ply.BurgerMaxStamina)
				end

			end

			ply.NextRegen = CurTime() + 1.25
			
		end


		JumpLatch = true
		
		
	elseif not cmd:KeyDown(IN_JUMP) then
		JumpLatch = false
	end
	
	
	if ply:WaterLevel() == 3 then

		ply.NextRegen = CurTime() + 1.25
	
		if ply.BurgerStamina ~= 0 then
		
			ply.BurgerStamina = math.Clamp(ply.BurgerStamina - Change*0.25*ply.BurgerDecayMul ,0,ply.BurgerMaxStamina)
			
		else
		
			if ply.WaterTick <= CurTime() then
					
				net.Start("StaminaDrowning")
					net.WriteFloat(1)
				net.SendToServer()
					
				ply.WaterTick = CurTime() + 1
			
			end
			
		end
		
			
	end
	
	
	if ply.NextRegen then
	
		if ply.NextRegen < CurTime() then
			
			if (cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT)) then
				ply.BurgerStamina = math.Clamp(ply.BurgerStamina + ( Change * 0.1 * ply.BurgerRegenMul ) ,0,ply.BurgerMaxStamina)
			else
				ply.BurgerStamina = math.Clamp(ply.BurgerStamina + ( Change * 0.5 * ply.BurgerRegenMul ) ,0,ply.BurgerMaxStamina)
			end
			
		end
		
	end

	cmd:SetButtons(NewButtons)

end


hook.Add("CreateMove","Burger Sprint",GetClientMove)


local Mat = Material("vgui/hsv-brightness")

surface.CreateFont( "SprintFont", {
	font = "roboto condensed", 
	size = 24, 
	weight = 0, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false, 
} )

function DrawBurStamina()

	local ply = LocalPlayer()
	
	if ply.HasOblivionHUD then return end

	local Stamina = ply.BurgerStamina
	local MaxStamina = ply.BurgerMaxStamina

	if MaxStamina then
			
		local BaseFade = 255
		local BarWidth = 25
		local BarHeight = 25
		
		local OPercent = 5/MaxStamina
		local Percent = Stamina/MaxStamina
		local SizeScale = 1
		
		local XPos = ScrW()/2
		local YPos = ScrH() - BarHeight*2
		local XSize = BarWidth*10
		local YSize = BarHeight
	

			
		surface.SetMaterial( Mat )
		surface.SetDrawColor(0,0,0,BaseFade/2)
		surface.DrawTexturedRectRotated(XPos,YPos,XSize,YSize,0)
			
		surface.SetMaterial( Mat )
		surface.SetDrawColor(0,255,0,BaseFade)
		surface.DrawTexturedRectRotated(XPos,YPos,XSize*0.9*Percent,YSize*0.5,0)

		draw.DrawText("ENERGY","SprintFont",XPos,YPos - BarHeight/2,Color(255,255,255,255*Percent),TEXT_ALIGN_CENTER)
			
	end
	
	


end

hook.Add("HUDPaint","Draw Burger Stamina",DrawBurStamina)




