--Reapplies the intended ammo panel font size back to the intended size. set_ammo_ammount_by_type was overriding it
Hooks:PostHook(HUDTeammateVR,"set_ammo_amount_by_type","VRFixes_AmmoPanel_Text_Size",function(self)
	if not self._main_player then return end
	
	local active_type, inactive_type = unpack(self._equipped_weapon_type == "secondary" and {
		"secondary",
		"primary"
	} or {
		"primary",
		"secondary"
	})
	local active_panel = self._ammo_panel:child(active_type .. "_weapon_panel")
	local inactive_panel = self._ammo_panel:child(inactive_type .. "_weapon_panel")

	local clip = active_panel:child("ammo_clip")
	local total = active_panel:child("ammo_total")

	clip:set_font_size(clip:h())
	total:set_font_size(total:h())

	clip = inactive_panel:child("ammo_clip")
	total = inactive_panel:child("ammo_total")

	clip:set_font_size(clip:h() / 1.5)
	total:set_font_size(total:h() / 1.5)
end)