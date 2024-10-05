--Stops akimbo weapons playing empty magazine animation/sound before they're completely empty

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

--Required so akimbo weapons don't share the same vector,
--otherwise multiple calls to set_gadget_position will cause lasers to clip into each other
local tmp_pos_vec = Vector3()
function AkimboWeaponBaseVR:set_gadget_position(pos,...)
	if not self._enabled then
		return
	end

	if self.parent_weapon then
		local active_gadget = self:get_active_gadget()

		if active_gadget and active_gadget.set_position then
			mvector3.set(tmp_pos_vec, active_gadget._unit:position())
			mvector3.subtract(tmp_pos_vec, self._unit:position())
			mvector3.add(tmp_pos_vec, pos)
			active_gadget:set_position(tmp_pos_vec)
		end
	else
		AkimboWeaponBaseVR.super.set_gadget_position(self, pos, ...)
	end
end

function AkimboWeaponBaseVR:set_visibility_state(...)
	AkimboWeaponBaseVR.super.set_visibility_state(self, ...)

	--Causes second gun to be hidden whenever the primary hand touches the VR belt, or changes state
	--The second gun can still be fired when made invisible by this, and it causes gadget effects to float in the air
	--[[if alive(self._second_gun) then
		self._second_gun:base():set_visibility_state(...)
	end]]
end

--Attempt at fixing gadget states becoming desynced between akimbo weapons

--The original function makes it so the second gun's gadget will inherit whatever gadget state the primary gun is currently in when the second gun gets enabled
--However, it doesn't account for the fact that the primary gun's gadget gets turned off when the hand state changes,
--which causes the second gun's gadget to start off if the primary hand happens to not be in the 'weapon' state, since that turns the gadget off
Hooks:OverrideFunction(AkimboWeaponBaseVR,"on_enabled",function(self,...)
	if alive(self.parent_weapon) then
		local gadget_on_state = self.parent_weapon:base()._gadget_on or 0
		self._last_gadget_idx = (gadget_on_state > 0 and gadget_on_state or self.parent_weapon:base()._last_gadget_idx)
		--self._last_gadget_idx = self.parent_weapon:base()._gadget_on
	end

	AkimboWeaponBaseVR.super.on_enabled(self, ...)
end)