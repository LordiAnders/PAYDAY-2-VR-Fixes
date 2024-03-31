--Adds a small delay before being able to fire your weapon, if masking up by placing the mask directly on the head
--Seeks to prevent accidentally firing the weapon instantly when masking up this way, potentially ruining stealth if the weapon is not silenced
Hooks:PostHook(PlayerMaskOffVR,"exit","VRFixes_Instant_Mask_Attack_delay",function(self)
	local exit_data = Hooks:GetReturn()
	if exit_data and exit_data.skip_mask_anim then
		exit_data.equip_weapon_expire_t = managers.player:player_timer():time() + 0.6
		return exit_data
	end
end)