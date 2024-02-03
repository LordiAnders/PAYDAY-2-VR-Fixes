Hooks:PostHook(WeaponFactoryTweakData,"init","VRTweakDataFixes_FactoryTweakFixes",function(self)
	--Fix Akimbo Bronco .44 (pd2_dlc_osa) reload animations missing from parts
	self.wpn_fps_pis_x_rage.override.wpn_fps_pis_rage_body_standard.animations.reload = "reload"
	self.wpn_fps_pis_x_rage.override.wpn_fps_pis_rage_body_smooth.animations.reload = "reload"
	
	self.parts.wpn_fps_pis_x_type54_underbarrel.animations.bipod_reload = "reload_not_empty" --Akimbo Káng Arms Model 54 (pd2_dlc_tawp) underbarrel reload
	
	self.wpn_fps_pis_x_judge.override.wpn_fps_pis_judge_body_standard.animations.reload = "reload"
	self.wpn_fps_pis_x_judge.override.wpn_fps_pis_judge_body_modern.animations.reload = "reload"
	self.wpn_fps_pis_x_judge.override.wpn_fps_pis_judge_body_standard.animations.fire = "recoil"
	self.wpn_fps_pis_x_judge.override.wpn_fps_pis_judge_body_modern.animations.fire = "recoil"
	self.wpn_fps_pis_x_judge.override.wpn_fps_pis_judge_body_standard.animations.fire_steelsight = "recoil"
	self.wpn_fps_pis_x_judge.override.wpn_fps_pis_judge_body_modern.animations.fire_steelsight = "recoil"

	--Several parts were missing bullet object definitions despite existing in their models
	--Technically not VR specific fixes, these could be noticed in desktop as well
	self.parts.wpn_fps_m4_upg_m_quick.bullet_objects = {
		amount = 2,
		prefix = "g_bullet_"
	}
	self.parts.wpn_fps_upg_ak_m_quick.bullet_objects = {
		amount = 1,
		prefix = "g_bullet_"
	}
	self.parts.wpn_fps_ass_g36_m_quick.bullet_objects = {
		amount = 28,
		prefix = "g_bullet_"
	}
	self.parts.wpn_fps_smg_mac10_m_quick.bullet_objects = {
		amount = 1,
		prefix = "g_bullet_"
	}
	self.parts.wpn_fps_smg_sr2_m_quick.bullet_objects = {
		amount = 3,
		prefix = "g_bullet_"
	}

	self.parts.wpn_fps_lmg_par_m_standard.bullet_objects = {
		amount = 5,
		prefix = "g_bullet_"
	}

	self.parts.wpn_fps_sho_rota_m_standard.bullet_objects = {
		amount = 6,
		prefix = "g_slug_"
	}
end)