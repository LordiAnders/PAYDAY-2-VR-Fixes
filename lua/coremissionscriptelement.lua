--Workaround for players not getting teleported to Mexico on Border Crossing
if Global.game_settings.level_id == "mex" then
	local mex_mission_elements = {
		[100008] = true, --relay_teleport
		[102619] = false, --player_spawned_mexico
	}
	
	Hooks:PreHook(MissionScriptElement,"on_executed","VRFixes_Mex_Teleport_Workaround",function(self)
		if not self._values.enabled then
			return
		end

		local mission_script_var = mex_mission_elements[self._id]
		if mission_script_var ~= nil then
			vrfixes_pause_fadeout = mission_script_var
		end
	end)
end