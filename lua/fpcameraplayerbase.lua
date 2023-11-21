--Used to pause collision teleports
--Workaround for Border Crossing not teleporting players to Mexico
local old_update_fadeout = FPCameraPlayerBase._update_fadeout

function FPCameraPlayerBase:_update_fadeout(...)
	if vrfixes_pause_fadeout then
		return
	end
	
	return old_update_fadeout(self,...)
end