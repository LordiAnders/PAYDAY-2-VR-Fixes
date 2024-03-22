--Tries to prevent an involuntary melee attack in some instances
--This only prevents accidental weapon butt melee attacks, melee weapons behave completely differently for some reason when held in the hand
--This *can* sometimes cause actual melee attacks to fail if the player tries to melee while turning or touching the belt at the same time. Tweaking the timers below changes how long melee gets blocked

vrfixes_hit_rotate_t = 0

local function SetMeleeHitRotateT(self,time)
	vrfixes_hit_rotate_t = TimerManager:game():time() + time
end

if RequiredScript == "lib/units/beings/player/handmelee" then

Hooks:PreHook(HandMelee,"update","VRFixes_NoMeleeOnTurn",function(self,unit,t)
	local next_hit_t = math.max(self._next_hit_t or 0,vrfixes_hit_rotate_t or 0)
	if t < vrfixes_hit_rotate_t then
		self._next_hit_t = next_hit_t
	end
end)


--Changes the melee damage penalty to use cooldown values more in line with desktop mode, instead of using the unequip timer (repeat_expire_t + melee_damage_delay)
--Using the unequip timer would cause melee weapons that are normally supposed to be very fast, to be very slow in VR. In some cases it would even make some weapons faster than desktop
--This must be enabled in the mod options first

if VRFixes_Mod.Settings.meleecooldown then
	local old_expire_t

	Hooks:PreHook(HandMelee,"update","VRFixes_Sane_Melee_Damage_pre",function(self)
		if not self:has_melee_weapon() then
			return
		end

		--Not the most elegant way of doing this, but it avoids having to completely replace the function
		local expire_t = tweak_data.blackmarket.melee_weapons[self._entry].expire_t
		old_expire_t = expire_t
		local repeat_expire_t = tweak_data.blackmarket.melee_weapons[self._entry].repeat_expire_t
		local melee_damage_delay = tweak_data.blackmarket.melee_weapons[self._entry].melee_damage_delay or 0
		tweak_data.blackmarket.melee_weapons[self._entry].expire_t = math.min(repeat_expire_t, expire_t) + math.min(melee_damage_delay, repeat_expire_t)
	end)
	Hooks:PostHook(HandMelee,"update","VRFixes_Sane_Melee_Damage_post",function(self)
		if old_expire_t then
			tweak_data.blackmarket.melee_weapons[self._entry].expire_t = old_expire_t
			old_expire_t = nil
		end
	end)
end

elseif RequiredScript == "lib/units/beings/player/states/vr/playerstandardvr" then

Hooks:PreHook(PlayerStandardVR,"_rotate_player","VRFixes_HandMelee_OnRotate",function(self)
	SetMeleeHitRotateT(self,0.04)
end)

elseif RequiredScript == "lib/units/beings/player/states/vr/hand/playerhandstateweapon" then

Hooks:PreHook(PlayerHandStateWeapon,"_link_weapon","VRFixes_HandMelee_LinkWeapon",function(self)
	SetMeleeHitRotateT(self,0.09)
end)

elseif RequiredScript == "lib/units/beings/player/states/vr/hand/playerhandstateakimbo" then

Hooks:PreHook(PlayerHandStateAkimbo,"_link_weapon","VRFixes_HandMelee_LinkWeapon",function(self)
	SetMeleeHitRotateT(self,0.09)
end)

end