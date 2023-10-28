--Tries to prevent an involuntary melee attack when snap turning
--This only prevents accidental weapon butt melee attacks, melee weapons behave completely differently for some reason when held in the hand
--This *can* sometimes cause actual melee attacks to fail if the player tries to melee while turning at the same time. Tweaking the time below changes how long melee is blocked after turning

vrfixes_hit_rotate_t = 0

if RequiredScript == "lib/units/beings/player/handmelee" then

Hooks:PreHook(HandMelee,"update","VRFixes_NoMeleeOnTurn",function(self,unit,t)
	if t < vrfixes_hit_rotate_t then
		self._next_hit_t = vrfixes_hit_rotate_t
	end
end)

elseif RequiredScript == "lib/units/beings/player/states/vr/playerstandardvr" then

Hooks:PreHook(PlayerStandardVR,"_rotate_player","VRFixes_OnRotate",function(self)
	vrfixes_hit_rotate_t = TimerManager:game():time() + 0.04
end)

end