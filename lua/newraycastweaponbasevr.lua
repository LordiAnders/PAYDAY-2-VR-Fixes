--Temporarily changes name_id to the underbarrel name_id when underbarrels are toggled
--This allows VR tweakdata to be implemented for weapons in underbarrel modes

function NewRaycastWeaponBaseVR:underbarrel_is_on()
	local underbarrel_part = managers.weapon_factory:get_part_from_weapon_by_type("underbarrel", self._parts)

	if underbarrel_part and alive(underbarrel_part.unit) and underbarrel_part.unit:base() and underbarrel_part.unit:base().toggle then
		return underbarrel_part.unit:base():is_on()
	end

	return nil
end

Hooks:PostHook(NewRaycastWeaponBase,"underbarrel_toggle","VRTweakDataFixes_RaycastUnderbarrelFix_CustomMagUnitFinish",function(self)
	if self:underbarrel_is_on() and not self.temp_ul_name_id then
		self.temp_ul_name_id = self.name_id
		self.name_id = self:underbarrel_name_id()
		if alive(self._second_gun) then
			self._second_gun:base().temp_ul_name_id = self._second_gun:base().name_id
			self._second_gun:base().name_id = self._second_gun:base():underbarrel_name_id()
		end
	elseif self.temp_ul_name_id then
		self.name_id = self.temp_ul_name_id
		self.temp_ul_name_id = nil
		if alive(self._second_gun) then
			self._second_gun:base().name_id = self._second_gun:base().temp_ul_name_id
			self._second_gun:base().temp_ul_name_id = nil
		end
	end
end)

--Records the ammo count during reload actions to track how many bullets should be visible in magazines, see cosmeticweaponbase.lua
--This is set using a variable before reloading starts since otherwise checking reload_amount when the magazine is spawned would cause the magazine to always be partially filled since magazines are spawned after a delay
local function VRTweakFixes_StartReload(self)
	self.vrfixesammoreloadcount = managers.player:player_unit():movement():current_state():_current_reload_amount() or self:get_ammo_total()
end
local function VRTweakFixes_FinishReload(self)
	self.vrfixesammoreloadcount = nil
end
Hooks:PreHook(NewRaycastWeaponBaseVR,"start_reload","VRTweakFixes_Magazine_BulletsObjects",VRTweakFixes_StartReload)
Hooks:PostHook(NewRaycastWeaponBaseVR,"finish_reload","VRTweakFixes_Magazine_BulletsObjects",VRTweakFixes_FinishReload)

Hooks:PostHook(NewRaycastWeaponBaseVR,"start_reload","VRTweakFixes_AnimationEffects_Workaround",function(self)
	--I couldn't get this to work properly as part of reloading timelines so now it's spawned here instead. Used for ms3gl exhaust effect when using exclusive set
	local tweak_data = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_animation_effect or nil
	if tweak_data then
		local effect = {
			effect = Idstring(tweak_data.name)
		}

		local part_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk(tweak_data.part, self._factory_id, self._blueprint)
		
		if not part_list or not self._parts[part_list[1]] or not self._parts[part_list[1]].unit then return end
		
		local unit = self._parts[part_list[1]].unit

		effect.position = tweak_data.pos
		effect.parent = unit:get_object(Idstring(tweak_data.object))

		World:effect_manager():spawn(effect)
	end
end)

--Allows attaching additional units to a held magazine by setting reload_part_addon in weapon reload timeline. Used for ECP held magazine and hk51b magazine
--Also allows using a different part as held magazine if reload_part_override is set in the reload timeline. Used for certain weapons so they display the correct (modded) ammo when held
--See weaponfactorymanager.lua which overrides the hardcoded "magazine" part lookup in spawn_magazine_unit()

Hooks:PreHook(NewRaycastWeaponBaseVR,"spawn_belt_magazine_unit","VRFixes_Belt_Magazine_Override",function(self)
	VRFixes_Mod.customparttype = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_part_override or nil
	VRTweakFixes_StartReload(self)
end)
Hooks:PostHook(NewRaycastWeaponBaseVR,"spawn_belt_magazine_unit","VRFixes_Belt_Magazine_Addons",function(self,pos)
	local mag_unit = Hooks:GetReturn()

	local reload_addon = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_part_addon or nil
	if reload_addon then
		if type(reload_addon) == "table" then
			for k,v in pairs(reload_addon) do
				VRFixes_Mod.customparttype = k

				local second_mag = self:spawn_magazine_unit(pos + v.pos,v.rot)
				mag_unit:link(mag_unit:orientation_object():name(),second_mag)
			end
		else
			VRFixes_Mod.customparttype = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_part_addon or nil
			
			local second_mag = self:spawn_magazine_unit(pos)
			mag_unit:link(mag_unit:orientation_object():name(),second_mag)
		end
	end
	
	VRFixes_Mod.customparttype = nil

	return mag_unit
end)

Hooks:PreHook(NewRaycastWeaponBase,"drop_magazine_object","VRTweakFixes_Magazine_Override",function(self)
	VRFixes_Mod.customparttype = tweak_data.vr.reload_timelines[self.name_id] and tweak_data.vr.reload_timelines[self.name_id].reload_part_override or nil
end)
Hooks:PostHook(NewRaycastWeaponBase,"drop_magazine_object","VRTweakFixes_Magazine_Override",function(self)
	VRFixes_Mod.customparttype = nil
end)

--This needed to be modified so tmp_pos_vec is defined inside the function, instead of outside
--Otherwise it causes lasers on akimbo weapons to use share the same position when using set_gadget_position
Hooks:OverrideFunction(NewRaycastWeaponBase,"set_gadget_position",function(self,pos)
	if not self._enabled then
		return
	end

	local active_gadget = self:get_active_gadget()

	if active_gadget and active_gadget.set_position then
		local tmp_pos_vec = Vector3()
	
		mvector3.set(tmp_pos_vec, active_gadget._unit:position())
		mvector3.subtract(tmp_pos_vec, self._unit:position())
		mvector3.add(tmp_pos_vec, pos)
		active_gadget:set_position(tmp_pos_vec)
	end
end)

--Fixes laser beam becoming offset on gadgets that are placed in a non-default rotation
local old_set_gadget_rot = NewRaycastWeaponBase.set_gadget_rotation

function NewRaycastWeaponBase:set_gadget_rotation(rot,...)
	if not self._enabled then
		return
	end
	
	local gadget_rotation
	if self._a_fl_gadget_rotation then
		gadget_rotation = self._a_fl_gadget_rotation
	else
		local a_object = self._unit:get_object(Idstring("a_fl"))
		if a_object then
			self._a_fl_gadget_rotation = a_object:local_rotation()
			gadget_rotation = self._a_fl_gadget_rotation
		end
	end
	
	if gadget_rotation then
		mrotation.multiply(rot,gadget_rotation)
	end
	
	return old_set_gadget_rot(self,rot,...)
end