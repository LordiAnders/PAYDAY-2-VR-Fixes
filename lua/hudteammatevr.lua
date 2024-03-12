--Sets the ammo panel font size back to the intended size. set_ammo_amount_by_type was overriding it without accounting for the VR HUD
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

--[[
	The VR version of hudteammate overrides activate_ability_radial_anim in order to hide and show the health icon for the main player's VR HUD when they activate an ability,
	so the ability icon doesn't clip into it. However, health_icon is nil on teammates, which causes the function to silently fail when triggered on anyone but the main player
	This causes the ability icon to become stuck on teammates, and the progress circle never activates
	
	To fix this, we grab the original function (using hudteammatevr_pre.lua), just before the game's hudteammatevr script overrides it, then we revert it back to the original function afterwards,
	then we use BLT hooks instead to check if health_icon is valid BEFORE trying to hide/show it
]]
Hooks:OverrideFunction(HUDTeammate,"activate_ability_radial_anim",HUDTeammate.orig_radial_anim)

Hooks:PreHook(HUDTeammate,"activate_ability_radial_anim","VRFixes_Ability_Radial_Anim_Workaround_pre",function(o,anim_time,progress_start,radial_ability_panel,ability_meter,health_icon)
	if health_icon then
		health_icon:set_visible(false)
	end
end)

Hooks:PostHook(HUDTeammate,"activate_ability_radial_anim","VRFixes_Ability_Radial_Anim_Workaround_post",function(o,anim_time,progress_start,radial_ability_panel,ability_meter,health_icon)
	if health_icon then
		health_icon:set_visible(true)
	end
end)