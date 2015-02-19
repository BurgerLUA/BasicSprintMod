function StaminaFootsteps(ply,pos,foot,sound,volume,filter)
	--[[
	if not ply:IsBot() then 
	
		
		local Mod = ( (foot*2) - 1 ) * 0.25 
		local Intensity = ( ply:GetVelocity():Length() / 150 )

		ply:ViewPunch(Angle(-0.1*Intensity,0, Mod * Intensity ))

		if ply:KeyPressed(IN_JUMP) then
			--ply:ViewPunch(Angle(5,0,0))
		end
		
	end
	--]]
end

hook.Add("PlayerFootstep","Stamina Footsteps", StaminaFootsteps)

local nexttick = 0

function StaminaAcceleration(ply,mv)
	--[[
	if not ply:IsBot() then


		if nexttick <= CurTime() then
		
			if not ply.NewAcceleration then
				ply.NewAcceleration = Vector(0,0,0)
			end
			
			if not ply.OldAcceleration then
				ply.OldAcceleration = Vector(0,0,0)
			end

			ply.NewAcceleration = WorldToLocal(ply:GetVelocity(),Angle(0,0,0),Vector(0,0,0),ply:GetAngles())
			
			local nx = ply.NewAcceleration.x
			local ny = ply.NewAcceleration.y
			local nz = ply.NewAcceleration.z
			
			local ox = ply.OldAcceleration.x
			local oy = ply.OldAcceleration.y
			local oz = ply.OldAcceleration.z
			
			local Result = Angle( (-(nx - ox) / 100) + ((nz - oz) / 100) ,0, -(ny - oy) / 100 )

			
			ply.OldAcceleration = WorldToLocal(ply:GetVelocity(),Angle(0,0,0),Vector(0,0,0),ply:GetAngles())
			
			if Result ~= Angle(0,0,0) then
				--print(Result)
				ply:ViewPunch(Result)
			end
				
			nexttick = CurTime() + 0.1
			
		end
	
	end
	
	--]]

end

hook.Add("PlayerTick","Stamina Acceleration", StaminaAcceleration)