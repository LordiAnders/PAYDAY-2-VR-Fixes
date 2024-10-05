--Fixes akimbo weapon gadget lasers lagging behind when moving
--This requires the set_gadget_position edit in akimboweaponbasevr, or else both weapons' lasers will share the same position
local weapon_pos = Vector3()

Hooks:PostHook(PlayerHandStateAkimbo,"update","VRFixes_Akimbo_Gadget_Laser_Lag_Fix",function(self)
	mvector3.set(weapon_pos, self:hsm():position())

	if alive(self._weapon_unit) then
		if self._weapon_kick then
			mvector3.subtract(weapon_pos, self._weapon_unit:rotation():y() * self._weapon_kick)
		end
	
		local tweak = tweak_data.vr:get_offset_by_id(self._weapon_unit:base().name_id)

		if tweak and tweak.position then
			mvector3.add(weapon_pos, tweak.position:rotate_with(self._weapon_unit:rotation()))
			self._weapon_unit:base():set_gadget_position(weapon_pos)
		end
		
		local rot = self:hsm():rotation()
		self._weapon_unit:base():set_gadget_rotation(rot)
	end
end)