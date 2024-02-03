Hooks:PostHook(VRFadeout,"update","VRFixes_Mounted_Turret_fadeout",function(self)
	if managers.player:current_state() == "player_turret" then
		self._fadeout.effect.color.alpha = 0
	end
end)