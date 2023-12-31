--Adjusts ladder exit points at top/bottom to prevent going through walls or becoming stuck
--Ladders are checked based on their position instead of their ID because their unit_data() becomes unreliable when joining as a client for some reason
--There might be better ways of identifying ladders, but it has to be compatible both as a client and host without being mutually exclusive
local ladder_adjusters = {
	["big"] = { --Big Bank
		["Vector3(-950, -1299, -1500)"] = {top = Vector3(-10,190,-315),bottom = Vector3(0,0,120)}, --elevator (103575)
		["Vector3(-229.403, -3573.44, 1952.14)"] = {top = Vector3(-90,89,-110)} --crane bottom ladder (105631)
	},
	["election_day_2"] = { --Election Day day 2
		["Vector3(-2193, -822, 0.000232458)"] = {top = Vector3(115,77,-48)} --warehouse right side (102685)
	},
	["pal"] = { --Counterfeit
		["Vector3(-735, -77, -398)"] = {top = Vector3(-90,70,0)} --sewer exit behind wall (101111)
	}
}

--[[Ladder.DEBUG = true

Hooks:PostHook(Ladder,"debug_draw","VRFixes_Ladder_Exit_Debug",function(self)
	Ladder.debug_brush_2:sphere(self._bottom_exit, 5)
	Ladder.debug_brush_2:sphere(self._top_exit, 5)
end)]]

Hooks:PostHook(Ladder,"set_config","VRFixes_Adjust_Ladder_Exits",function(self)
	local level_id = Global.game_settings.level_id
	local adjustment = ladder_adjusters[level_id]
	
	--BLT:Log(LogLevel.WARN,"Checking ladder at "..self._unit:position())
	
	if adjustment then
		--BLT:Log(LogLevel.WARN,level_id.." has ladder adjustments...")
	
		local adjustment_unit = adjustment[tostring(self._unit:position())]
		
		if adjustment_unit then
			--BLT:Log(LogLevel.WARN,"Adjusting ladder...")
			mvector3.add(self._top_exit,adjustment_unit.top or Vector3())
			mvector3.add(self._bottom_exit,adjustment_unit.bottom or Vector3())
		end
	end
end)