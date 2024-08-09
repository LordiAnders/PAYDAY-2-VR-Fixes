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

--Positions the down counter so that it doesn't clip into the ammo counter on teammates
Hooks:PostHook(HUDTeammateVR,"set_state","VRFixes_Down_counter_reposition",function(self)
	if not self._main_player then
		local teammate_panel = self._panel
		local name = teammate_panel:child("name")
		local name_bg = teammate_panel:child("name_bg")
		local revive_panel = self._player_panel:child("revive_panel")
		revive_panel:set_center_y(name_bg:y() + name_bg:h() / 2 + 2)
		revive_panel:set_right(name_bg:x())
	end
end)

--Bandaid fix for player names sometimes going invisible
--Callsign's alpha is sometimes 0 when this gets called, causing player names to turn invisible
--This is unbelievably hard to diagnose, and I can't quite pin-point out why it's happening
Hooks:PostHook(HUDTeammate,"set_callsign","VRFixes_Callsign_Alpha",function(self)
	local teammate_panel = self._panel
	local callsign = teammate_panel:child("callsign")
	if callsign:color().a == 0 then
		callsign:set_color(callsign:color():with_alpha(1))

		local name = teammate_panel:child("name")

		name:set_color(name:color():with_alpha(1))
	end
end)

--Hook for updating the secondary counter in the deployable belt item, for deployables with secondary functions (shaped charges)
--This requires new, custom functions in hudbelt.lua, since the original belt doesn't support secondary amount texts normally
--This also requires playermanager.lua. Otherwise there are cases where the counter will not update properly
Hooks:PreHook(HUDTeammateVR,"set_deployable_equipment_amount_from_string","VRFixes_set_shaped_charges_count",function(self,index,data)
	--Needs to be PreHook. The original function calls HUDBeltInteraction:set_state, which controls visibility. The text needs to be created before set_state gets called
	if self._main_player then
		local belt_id = index == 1 and "deployable" or "deployable_secondary"

		managers.hud:belt():set_amount_secondary(belt_id, data.amount[2]) --Custom function added in hudbelt.lua
	end
end)

Hooks:PostHook(HUDTeammateVR,"set_deployable_equipment_amount","VRFixes_set_shaped_charges_count",function(self,index,data)
	if self._main_player then
		local belt_id = index == 1 and "deployable" or "deployable_secondary"

		--set_deployable_equipment_amount_from_string gets called even for deployables without a secondary function, which causes a secondary counter to get created
		--If set_deployable_equipment_amount gets called afterwards, remove the bogus secondary counter by setting the amount to nil
		--This is a bit of a workaround...
		managers.hud:belt():set_amount_secondary(belt_id)
	end
end)