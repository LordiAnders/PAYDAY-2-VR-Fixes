Hooks:PostHook(HUDManager,"add_waypoint","VRFixes_downed_timer_clipping_fix",function(self,id,data)
	local waypoint = self._hud.waypoints[id]
	
	if waypoint then

		local timer_gui = waypoint.timer_gui
		
		if timer_gui and waypoint.distance then
			timer_gui:set_bottom(0)
		end
	end
end)

--Possible fix for player/team ai name labels sometimes not getting removed after the player/team ai leaves the game
--The VR version of _update_name_labels lacks the to_remove code, which is only present in the desktop version
Hooks:PostHook(HUDManagerVR,"_update_name_labels","VRFixes_lingering_name_label_fix",function(self,t)
	if not alive(managers.player:player_unit()) then
		return
	end
	
	local to_remove = {}

	for _, data in ipairs(self._hud.name_labels) do
		if (data.movement and not alive(data.movement._unit)) then
			to_remove[data.id] = true
		end
	end
	
	for id, _ in pairs(to_remove) do
		self:_remove_name_label(id)
	end
end)