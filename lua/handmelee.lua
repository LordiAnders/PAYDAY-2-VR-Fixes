--Tries to prevent an involuntary melee attack in some instances
--This only prevents accidental weapon butt melee attacks, melee weapons behave completely differently for some reason when held in the hand
--This *can* sometimes cause actual melee attacks to fail if the player tries to melee while turning or touching the belt at the same time. Tweaking the timers below changes how long melee gets blocked

vrfixes_hit_rotate_t = 0

local function SetMeleeHitRotateT(self,time)
	vrfixes_hit_rotate_t = TimerManager:game():time() + time
end

if RequiredScript == "lib/units/beings/player/handmelee" then

Hooks:PreHook(HandMelee,"update","VRFixes_NoMeleeOnTurn",function(self,unit,t)
	if t < vrfixes_hit_rotate_t then
		self._next_hit_t = vrfixes_hit_rotate_t
	end
end)

elseif RequiredScript == "lib/units/beings/player/states/vr/playerstandardvr" then

Hooks:PreHook(PlayerStandardVR,"_rotate_player","VRFixes_HandMelee_OnRotate",function(self)
	SetMeleeHitRotateT(self,0.04)
end)

elseif RequiredScript == "lib/units/beings/player/states/vr/hand/playerhandstateweapon" then

Hooks:PreHook(PlayerHandStateWeapon,"_link_weapon","VRFixes_HandMelee_LinkWeapon",function(self)
	SetMeleeHitRotateT(self,0.09)
end)

end