--Crash fix. player_unit is sometimes nil when this function gets called, happens seemingly randomly when a heist starts as a client
--[[
Application has crashed: C++ exception
[string "lib/units/beings/player/states/vr/hand/player..."]:132: attempt to index a nil value



SCRIPT STACK

trans_func() lib/units/beings/player/states/vr/hand/playerhandstate.lua:38
do_state_change() lib/utils/statemachine.lua:62
_update_controllers() lib/units/beings/player/playerhand.lua:402
lib/units/beings/player/playerhand.lua:506
]]

local old_atexit = PlayerHandStateWeapon.at_exit
local delayedcalls_id_count = 0

function PlayerHandStateWeapon:at_exit(next_state)
	if not alive(managers.player:player_unit()) then
		DelayedCalls:Add("PlayerHandStateWeapon_VRCRASHFIX_Looping_"..delayedcalls_id_count,0.05,function()
			self:at_exit(next_state) --Try and repeat the function after a delay, it looks important so it might not be safe to outright discard
		end)
		
		delayedcalls_id_count = delayedcalls_id_count + 1
		
		return
	end

	return old_atexit(self,next_state)
end