--Akimbo Bronco .44 (pd2_dlc_osa) was missing animation tweakdata that caused reload animations to not work

Hooks:PostHook(WeaponFactoryTweakData,"_init_x_rage","VRTweakDataFixes_X_Rage_AnimationFix",function(self)
	if _G.IS_VR then
		self.wpn_fps_pis_x_rage.override.wpn_fps_pis_rage_body_standard.animations.reload = "reload"
		self.wpn_fps_pis_x_rage.override.wpn_fps_pis_rage_body_smooth.animations.reload = "reload"
	end
end)