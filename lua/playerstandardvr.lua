--Fixes Counterstrike skill not working with VR melee
Hooks:PostHook(PlayerStandard,"in_melee","VRFixes_In_Melee",function(self)
	local melee_hand = self._unit:hand():get_active_hand_id("melee")

	if melee_hand then
		return self._unit:hand():hand_unit(melee_hand):melee():charge_start_t() and true
	end
end)

Hooks:PostHook(PlayerStandard,"discharge_melee","VRFixes_Discharge_Melee",function(self)
	local melee_hand = self._unit:hand():get_active_hand_id("melee")
	
	if melee_hand then
		local hand_unit = self._unit:hand():hand_unit(melee_hand):melee()
		
		hand_unit._next_hit_t = TimerManager:game():time() + tweak_data.blackmarket.melee_weapons[hand_unit._entry].expire_t
		hand_unit._next_full_hit_t = hand_unit._next_hit_t
		hand_unit._charge_start_t = nil
	end
end)

--Reapplies the infiltrator/sociopath melee bonus if the melee weapon hits a corpse, within a small period after a kill
--Tries to prevent cases where melee weapons sometimes strike the corpse in the same swing, and unfairly consuming the melee bonus
local stacking_hit_grace_period = 0
Hooks:PreHook(PlayerStandard,"_check_melee_special_damage","VRFixes_Stacking_Hit_Grace",function(self,col_ray,character_unit,defense_data)
	local t = TimerManager:game():time()
	if defense_data and defense_data.type == "death" then
		stacking_hit_grace_period = t + 0.33
	elseif t < stacking_hit_grace_period then
		if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
			self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
			self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or {
				nil,
				0
			}
			local stack = self._state_data.stacking_dmg_mul.melee

			if character_unit:character_damage().dead and character_unit:character_damage():dead() then
				stack[1] = t + managers.player:upgrade_value("melee", "stacking_hit_expire_t", 1) - (t - stacking_hit_grace_period)
				stack[2] = math.min(stack[2] + 1, tweak_data.upgrades.max_melee_weapon_dmg_mul_stacks or 5)
			end
		end
	end
end)

--Stop faulty conditions from stopping the fire animation on the final shot
--The conditions to stop the animation do not check if the trigger is being held or released, when attempting to do dryfire
--So when the final shot is fired, the game will immediately check if it should stop the animation, because the trigger is still being held briefly
--This is only an issue when the auto reload setting is turned off
local old_fire_per_weapon = PlayerStandardVR._check_fire_per_weapon
function PlayerStandardVR:_check_fire_per_weapon(t, pressed, held, released, weap_base, ...)
	if not pressed and (held or released) then
		if weap_base.clip_empty and weap_base:clip_empty() then
			if self:_interacting() then
				return false
			end

			local should_reload_immediately = self._equipped_unit:base().should_reload_immediately and self._equipped_unit:base():should_reload_immediately()
			
			if not managers.vr:get_setting("auto_reload") and not should_reload_immediately then
				held = false
				released = false
			end
		end
	end
	return old_fire_per_weapon(self, t, pressed, held, released, weap_base, ...)
end

--These functions needed to be modified for underbarrels to work as intended. The unmodified functions do not check ammo using ammo_base()
--This causes the belt to display ammo for underbarrels incorrectly, as well as allowing underbarrels to be reloaded instantly before the reload is finished
--Also attempts to fix partial reloads sometimes restoring negative ammo in some cases, when using manual reloading
Hooks:OverrideFunction(PlayerStandardVR,"_start_action_reload",function(self,t)
	local weapon = self._equipped_unit:base()

	if weapon and weapon:can_reload() then
		self._state_data.reload_time_offset = nil
		local time_manager = TimerManager:game():time()
		--TimerManager can sometimes go out of sync from the 't' timer, which causes _current_reload_amount to return negative values, restoring negative ammo when performing partial reloads
		--In order to fix this; if the timer becomes desynced, an offset is made, which is added onto the timer in _current_reload_amount, which should correct it so it doesn't return negative ammo
		--This seems to have fixed it after testing it for a while, but it is a bit of a bandaid solution
		--This is hard to diagnose, because it happens seemingly randomly. The bug seems to occur if you play as a client and the heist hasn't started yet
		if time_manager < t then
			self._state_data.reload_time_offset = t - time_manager
		end
	
		weapon:tweak_data_anim_stop("fire")

		local speed_multiplier = weapon:reload_speed_multiplier()
		local empty_reload = weapon:clip_empty() and 1 or 0

		if weapon._use_shotgun_reload then
			empty_reload = weapon:ammo_base():get_ammo_max_per_clip() - weapon:ammo_base():get_ammo_remaining_in_clip()
		end

		local reload_time = 0

		if weapon:reload_enter_expire_t() then
			reload_time = reload_time + weapon:reload_enter_expire_t(not weapon:started_reload_empty()) / speed_multiplier
		end

		if weapon:reload_exit_expire_t() then
			reload_time = reload_time + weapon:reload_exit_expire_t(not weapon:started_reload_empty()) / speed_multiplier
		end
		
		local tweak = weapon:ammo_base():weapon_tweak_data()

		if weapon:clip_empty() then
			reload_time = reload_time + (tweak.timers.reload_empty or weapon:reload_expire_t() or 2.6) / speed_multiplier
		else
			reload_time = reload_time + (tweak.timers.reload_not_empty or weapon:reload_expire_t() or 2.2) / speed_multiplier
		end

		if not managers.vr:get_setting("auto_reload") then
			if table.contains(tweak.categories, "bow") then
				reload_time = 0
			else
				reload_time = reload_time - tweak_data.vr.reload_buff
			end
		end

		self._state_data.reload_start_t = t
		self._state_data.reload_expire_t = t + reload_time

		weapon:start_reload(reload_time)
		self._ext_network:send("reload_weapon", empty_reload, speed_multiplier)

		if not managers.vr:get_setting("auto_reload") then
			if managers.hud:belt() then --Check added for compatibility with the More Weapon Stats mod. The belt is not accessible from the main menu, or loadout screen, which causes an error when MWS performs fake reloads to generate stats
				if weapon:is_category("saw") then
					managers.hud:belt():start_reload(reload_time, 0, 1)

					self._state_data.needs_full_reload = true
				else
					local max_ammo = math.min(weapon:ammo_base():get_ammo_max_per_clip(), weapon:ammo_base():get_ammo_total())

					managers.hud:belt():start_reload(reload_time, weapon:ammo_base():get_ammo_remaining_in_clip(), max_ammo)
				end
			end
		end

		managers.hud:set_reload_visible(true)
	end
end)

Hooks:OverrideFunction(PlayerStandardVR,"_current_reload_amount",function(self)
	if self._state_data.reload_expire_t then
		local t = TimerManager:game():time() + (self._state_data.reload_time_offset or 0)
		local weapon = self._equipped_unit:base()
		local total = self._state_data.reload_expire_t - self._state_data.reload_start_t
		local progress = t - self._state_data.reload_start_t
		local ratio = progress / total
		local max_ammo = math.min(weapon:ammo_base():get_ammo_max_per_clip(), weapon:ammo_base():get_ammo_total())

		return math.floor((max_ammo - weapon:ammo_base():get_ammo_remaining_in_clip()) * ratio) + weapon:ammo_base():get_ammo_remaining_in_clip()
	end
end)

--Fixes Civilian and Clean player states using run speeds when warping, and allowing jumping
--Ideally this should be in its own separate file, with a _can_run() function defined in it that returns false,
--but I want to avoid splitting the two fixes into two different files, since they both address similar issues
if VRFixes_Mod.Settings.civilianstatefix then
	Hooks:PostHook(PlayerStandardVR,"_can_run","VRFixes_Civilian_state_run_fix",function(self)
		local state_name = self._ext_movement:current_state_name()
		local disable_run = state_name == "civilian" or state_name == "clean"
		
		if disable_run then
			return false
		end
	end)

	Hooks:PostHook(WarpTargetState,"_update_warp_variables","VRFixes_Clean_state_jump_fix",function(self)
		local state_name = self.params.unit:movement():current_state_name()
		local disable_jump = state_name == "clean"
		
		if disable_jump then
			self._warp_ext:set_enable_jump(false)
		end
	end)
end