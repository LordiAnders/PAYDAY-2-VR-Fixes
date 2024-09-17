--Stops akimbo weapons playing empty magazine animation/sound before they're completely empty

--TODO: Can possibly be simplified? The AKIMBO variable is only used in a few places to determine if magazine_empty functions should run.
--Make sure it is set to true in RaycastWeaponBase:add_ammo though, as AKIMBO is used for some ammo calculations 

local function mag_check(anim,weapon)
	if anim == "magazine_empty" then
		local mag = weapon:ammo_base():get_ammo_remaining_in_clip()

		if mag > 1 then
			return true
		end
	end
end

local old_tweakdataanimplay = AkimboWeaponBaseVR.tweak_data_anim_play

function AkimboWeaponBaseVR:tweak_data_anim_play(anim,...)
	if mag_check(anim,self) then return end

	return old_tweakdataanimplay(self,anim,...)
end

local __tweak_data_sound = RaycastWeaponBase.play_tweak_data_sound

function AkimboWeaponBaseVR:play_tweak_data_sound(event,...)
	if mag_check(event,self) then return end

	return __tweak_data_sound(self,event,...)
end

--Applies the same fix for when hand state changes (touching belt for example)
local prevakimbo
Hooks:PreHook(AkimboWeaponBaseVR,"_check_magazine_empty","VRFixes_Akimbo_check_magazine_empty",function(self)
	if self.AKIMBO then
		prevakimbo = self.AKIMBO
		self.AKIMBO = false
	end
end)
Hooks:PostHook(AkimboWeaponBaseVR,"_check_magazine_empty","VRFixes_Akimbo_check_magazine_empty",function(self)
	if prevakimbo then
		self.AKIMBO = prevakimbo
		prevakimbo = nil
	end
end)