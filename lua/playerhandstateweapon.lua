--[[
11:49:13 PM FATAL ERROR:  (C:\projects\payday2-superblt\src\InitiateState.cpp:320) [string "lib/units/beings/player/states/vr/hand/player..."]:132: attempt to index field 'player' (a nil value)
stack traceback:
	[string "lib/units/beings/player/states/vr/hand/player..."]:132: in function 'at_exit'
	...empt at fixing VR client crash/playerhandstateweapon.lua:1: in main chunk
	[C]: in function 'dofile'
	mods/base/base.lua:169: in function 'RunHookFile'
	mods/base/base.lua:157: in function 'RunHookTable'
	mods/base/base.lua:189: in function 'require'
	[string "lib/units/beings/player/playerhandstatemachin..."]:5: in main chunk
	[C]: in function 'require'
	mods/base/base.lua:188: in function 'require'
	[string "lib/units/beings/player/playerhand.lua"]:3: in main chunk
	[C]: in function 'require'
	mods/base/base.lua:188: in function 'require'
	[string "lib/setups/gamesetup.lua"]:95: in main chunk
	[C]: in function 'require'
	mods/base/base.lua:188: in function 'require'
	[string "lib/setups/networkgamesetup.lua"]:1: in main chunk
	[C]: in function 'require'
	mods/base/base.lua:188: in function 'require'
	[string "lib/entry.lua"]:6: in main chunk
	[C]: in function 'require'
	mods/base/base.lua:188: in function 'require'
	[string "core/lib/coreentry.lua"]:19: in main chunk


	Application has crashed: C++ exception
	[string "lib/units/beings/player/states/vr/hand/player..."]:132: attempt to index a nil value



	SCRIPT STACK

	trans_func() lib/units/beings/player/states/vr/hand/playerhandstate.lua:38
	do_state_change() lib/utils/statemachine.lua:62
	_update_controllers() lib/units/beings/player/playerhand.lua:402
	lib/units/beings/player/playerhand.lua:506
]]

--Crash fix attempt. player_unit is sometimes nil when this function gets called, happens seemingly randomly when a heist starts as a client
--Still waiting to see if this works, I've definitely narrowed the crash down to this function based on the line count and debugging the function

local old_atexit = PlayerHandStateWeapon.at_exit
local delayedcalls_id_count = 0

function PlayerHandStateWeapon:at_exit(next_state)
	if not alive(managers.player:player_unit()) then
		local logstring = "CRASH PREVENTED - PlayerHandStateWeapon:at_exit ERROR player_unit WAS INVALID"
		BLT:Log(LogLevel.ERROR,logstring)
		managers.chat:feed_system_message(ChatManager.GAME,logstring)
		
		DelayedCalls:Add("PlayerHandStateWeapon_VRCRASHFIX_Looping_"..delayedcalls_id_count,0.05,function()
			self:at_exit(next_state) --Try and repeat the function after a delay, it looks important so it might not be safe to outright discard
		end)
		
		delayedcalls_id_count = delayedcalls_id_count + 1
		
		return
	end

	return old_atexit(self,next_state)
end