--Prevents throwing too many grenades if dual wielding them
--The anti-cheat would get tripped by this if the grenade count goes under 0 (i.e dual throwing with only 1 grenade left), as the function doesn't check the ammo count before attempting to throw
--This will end up marking the player as a cheater, and getting auto-kicked if the host has the option turned on
local old_state_update = PlayerHandStateItem.update

function PlayerHandStateItem:update(...)
	local controller = managers.vr:hand_state_machine():controller()

	if controller:get_input_pressed("use_item_vr") and self._item_type == "throwable" and not managers.player:player_unit():hand():check_hand_through_wall(self:hsm():hand_id()) then
		if not managers.player:can_throw_grenade() then
			self:_remove_unit()
			managers.player:player_unit():movement():current_state():set_throwing_projectile(self:hsm():hand_id())
			self:hsm():change_to_default()
			
			return
		end
	end
	
	return old_state_update(self,...)
end