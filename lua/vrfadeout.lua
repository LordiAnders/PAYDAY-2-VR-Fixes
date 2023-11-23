--Disables collision teleport when 'vrfixes_pause_fadeout' is true. Workaround for not getting teleported properly on Border Crossing
Hooks:PostHook(VRFadeout,"update","VRFixes_VRFadeout_update",function(self)
	if vrfixes_pause_fadeout then
		return false
	end
end)