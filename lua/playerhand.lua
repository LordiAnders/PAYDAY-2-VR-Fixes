--Crash fix. hand_unit can sometimes be nil, but the original function does not check for this
--Seems to happen often when using Hailstorm Mk 5?
--[[
Application has crashed: C++ exception
[string "lib/units/beings/player/playerhand.lua"]:959: attempt to index local 'hand_unit' (a nil value)



SCRIPT STACK

_check_fire_per_weapon() lib/units/beings/player/states/vr/playerstandardvr.lua:1414
_check_action_primary_attack() lib/units/beings/player/states/vr/playerstandardvr.lua:1318
_update_check_actions() lib/units/beings/player/states/playerstandard.lua:1015
__update_standard() lib/units/beings/player/states/playerstandard.lua:444
update() lib/units/beings/player/states/vr/playerstandardvr.lua:710
original() lib/units/beings/player/playermovement.lua:279
@mods/base/req/core/Hooks.lua:264
]]

local old_checkhandthroughwall = PlayerHand.check_hand_through_wall

function PlayerHand:check_hand_through_wall(hand,...)
	local hand_unit = self:hand_unit(hand)

	if not hand_unit or not alive(hand_unit) then
		return false
	end
	
	return old_checkhandthroughwall(self,hand,...)
end