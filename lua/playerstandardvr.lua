--These functions needed to be modified for underbarrels to work as intended. The unmodified functions do not check ammo using ammo_base()
--This causes the belt to display ammo for underbarrels incorrectly, as well as allowing underbarrels to be reloaded instantly before the reload is finished

function PlayerStandardVR:_start_action_reload(t)
	local weapon = self._equipped_unit:base()

	if weapon and weapon:can_reload() then
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

		local tweak = weapon:weapon_tweak_data()

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
			if weapon:is_category("saw") then
				managers.hud:belt():start_reload(reload_time, 0, 1)

				self._state_data.needs_full_reload = true
			else
				local max_ammo = math.min(weapon:ammo_base():get_ammo_max_per_clip(), weapon:ammo_base():get_ammo_total())

				managers.hud:belt():start_reload(reload_time, weapon:ammo_base():get_ammo_remaining_in_clip(), max_ammo)
			end
		end

		managers.hud:set_reload_visible(true)
	end
end

function PlayerStandardVR:_current_reload_amount()
	if self._state_data.reload_expire_t then
		local t = TimerManager:game():time()
		local weapon = self._equipped_unit:base()
		local total = self._state_data.reload_expire_t - self._state_data.reload_start_t
		local progress = t - self._state_data.reload_start_t
		local ratio = progress / total
		local max_ammo = math.min(weapon:ammo_base():get_ammo_max_per_clip(), weapon:ammo_base():get_ammo_total())

		return math.floor((max_ammo - weapon:ammo_base():get_ammo_remaining_in_clip()) * ratio) + weapon:ammo_base():get_ammo_remaining_in_clip()
	end
end