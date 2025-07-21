Hooks:PostHook(HUDManager,"add_waypoint","VRFixes_downed_timer_clipping_fix",function(self,id,data)
	local waypoint = self._hud.waypoints[id]
	
	if waypoint then

		local timer_gui = waypoint.timer_gui
		
		if timer_gui and waypoint.distance then
			timer_gui:set_bottom(0)
		end
	end
end)