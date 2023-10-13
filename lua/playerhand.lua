--Crash fix. hand_unit can sometimes be nil, but the original function does not check for this
--Seems to happen often when using Hailstorm Mk 5?

local old_checkhandthroughwall = PlayerHand.check_hand_through_wall

function PlayerHand:check_hand_through_wall(hand,...)
	local hand_unit = self:hand_unit(hand)

	if not hand_unit or not alive(hand_unit) then
		return false
	end
	
	return old_checkhandthroughwall(self,hand,...)
end