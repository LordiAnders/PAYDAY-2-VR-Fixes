--Stops akimbo weapons playing empty magazine animation/sound before they're completely empty

local old_tweakdataanimplay = AkimboWeaponBaseVR.tweak_data_anim_play

function AkimboWeaponBaseVR:tweak_data_anim_play(anim,...)
	if anim == "magazine_empty" then
		local mag = self:ammo_base():get_ammo_remaining_in_clip() - 1

		if mag >= 1 then
			return
		end
	end

	return old_tweakdataanimplay(self,anim,...)
end

local __tweak_data_sound = RaycastWeaponBase.play_tweak_data_sound

function AkimboWeaponBaseVR:play_tweak_data_sound(event,...)
	if event == "magazine_empty" then
		local mag = self:ammo_base():get_ammo_remaining_in_clip() - 1

		if mag >= 1 then
			return
		end
	end

	return __tweak_data_sound(self,event,...)
end