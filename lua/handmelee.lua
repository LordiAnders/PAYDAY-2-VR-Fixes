vrfixes_hit_rotate_t = 0

if RequiredScript == "lib/units/beings/player/handmelee" then

Hooks:PreHook(HandMelee,"update","VRFixes_NoMeleeOnTurn",function(self,unit,t)
	if t < vrfixes_hit_rotate_t then
		self._next_hit_t = vrfixes_hit_rotate_t
	end
end)

elseif RequiredScript == "lib/units/beings/player/states/vr/playerstandardvr" then

Hooks:PreHook(PlayerStandardVR,"_rotate_player","VRFixes_OnRotate",function(self)
	vrfixes_hit_rotate_t = TimerManager:game():time() + 0.2
end)

end