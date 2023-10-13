--[[
	New variables added:
		reload_part_override = "string" --Allows overriding the hardcoded "magazine" part when spawning magazines. Requires custom_mag_unit to be nil, otherwise custom_mag_unit takes priority
		reload_part_override_hidden = {table} --List of objects in the spawned magazine that should be invisible
		reload_part_addon = "string" or {table} --Spawns additional magazines that is attached to the regular one. Used for magazines that are made of multiple parts
		reload_animation_effect = {table} --Plays the effect when reloading but only if the part is valid. Workaround for ms3gl exhaust effect with exclusive set equipped
	
	Notes:
		magazine_offsets:
			weapon_offset: Overrides magazine insertion point instead of looking up location of magazine part on the weapon
		
		visible:
			parts: Parts can be set as boolean instead of table of objects to hide the whole part. Must be table of objects on hk51b or it breaks bullet belt physics
			
		reload_part_type: Needs to be a valid part otherwise reload timeline will not play properly
		
		anims: Animations are errornously reset when belt is touched, caused deliberately by _set_parts_enabled. Requires overriding function to fix
		
		reload_part_override (Custom): Used in favor of custom_mag_unit since it makes it possible for weapon modifications to affect the appearance of held magazines, such as stinger grenades for underbarrels, or crossbow bolts
		
		hk51b: The bullet belt code is just way over my head. It functions as a charm which only works on an actual weapon unit. I've instead redone the held magazine by hand with reload_part_addon, but it won't have any physics
]]

Hooks:PostHook(TweakDataVR,"init","VRTweakDataFixes_Init",function(self,tweak_data)
	self.locked.weapons.contraband = nil
	self.locked.weapons.groza = nil
	self.locked.weapons.hunter = nil
	self.locked.weapons.frankish = nil
	self.locked.weapons.arblast = nil

	--Little Friend 7.62 - Underbarrel mode (pd2_dlc_chico)
	self.weapon_offsets.weapons.contraband_m203 = self.weapon_offsets.weapons.contraband
	self.weapon_assist.weapons.contraband_m203 = self.weapon_assist.weapons.contraband
	--[[self.magazine_offsets.contraband_m203 = {
		position = Vector3(1.5, 0, 2),
		rotation = Rotation(-45, 12, -20),
		weapon_offset = Vector3(0,26,1)
	}]]
	self.magazine_offsets.contraband_m203 = {
		position = Vector3(9.5, 14, 8),
		rotation = Rotation(-45, 12, -20),
		weapon_offset = Vector3(0,26,1)
	}
	self.reload_timelines.contraband_m203 = {
		--custom_mag_unit = "units/pd2_dlc_gage_assault/weapons/wpn_fps_gre_m79_pts/wpn_fps_gre_m79_grenade",
		reload_part_type = "underbarrel",
		reload_part_override = "underbarrel",
		reload_part_override_hidden = {
			"g_lock",
			"g_b",
			"g_base"
		},
		start = {
			{
				time = 0,
				sound = "contraband_grenade_pull_handle"
			},
			{
				time = 0.03,
				anims = {
					{
						anim_group = "bipod_reload",
						to = 0.8,
						from = 0.4,
						part = "underbarrel"
					}
				}
			},
			{
				time = 0.06,
				visible = {
					visible = false,
					parts = {
						underbarrel = {
							"g_grenade_1",
							"g_grenade_shell"
						}
					}
				},
				effect = {
					object = "a_gl",
					name = "effects/payday2/particles/weapons/shells/shell_40mm"
				}
			}
		},
		finish = {
			{
				time = 0,
				sound = "contraband_grenade_shell_in",
				anims = {
					{
						anim_group = "bipod_reload",
						from = 2.1,
						part = "underbarrel"
					}
				},
				visible = {
					visible = true,
					parts = {
						underbarrel = {
							"g_grenade_1",
							"g_grenade_shell"
						}
					}
				}
			},
			{
				time = 0.5,
				sound = "contraband_grenade_push_handle"
			}
		}
	}
	
	--KETCHNOV Byk-1 (pd2_dlc_sawp)
	self.weapon_offsets.weapons.groza = {
		position = Vector3(-0.5, 0.8, 1.5)
	}
	self.magazine_offsets.groza.position = Vector3(0, 0, 2)
	self.weapon_assist.weapons.groza = {
		grip = "idle_wpn",
		position = Vector3(-1, 18.5, -2)
	}
	self.reload_timelines.groza.start[1].sound = "wp_groza_mag_out"
	self.reload_timelines.groza.finish[1].sound = "wp_groza_mag_in"
	self.reload_timelines.groza.finish[3].sound = "wp_groza_lever_release"
	
	--KETCHNOV Byk-1 - Underbarrel mode (pd2_dlc_sawp)
	self.weapon_offsets.weapons.groza_underbarrel = self.weapon_offsets.weapons.groza
	self.weapon_assist.weapons.groza_underbarrel = self.weapon_assist.weapons.groza
	--[[self.magazine_offsets.groza_underbarrel = {
		position = Vector3(1.5, 0, 2),
		rotation = Rotation(-45, 12, -20),
		weapon_offset = Vector3(0,26,0)
	}]]
	self.magazine_offsets.groza_underbarrel = {
		position = Vector3(-8.5, -5, 8),
		rotation = Rotation(-45, 12, -20),
		weapon_offset = Vector3(0,26,0)
	}
	self.reload_timelines.groza_underbarrel = {
		--custom_mag_unit = "units/pd2_dlc_gage_assault/weapons/wpn_fps_gre_m79_pts/wpn_fps_gre_m79_grenade",
		reload_part_type = "underbarrel",
		reload_part_override = "underbarrel",
		reload_part_override_hidden = {
			"g_gp25",
			"g_switch"
		},
		start = {
			{
				time = 0,
				sound = "wp_gl40_shell_out",
				visible = {
					visible = false,
					parts = {
						underbarrel = {
							"g_grenade"
						}
					}
				}
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_groza_mag_contact",
				anims = {
					{
						anim_group = "bipod_reload",
						from = 0.8,
						part = "underbarrel"
					}
				},
				visible = {
					visible = true,
					parts = {
						underbarrel = {
							"g_grenade"
						}
					}
				}
			},
			{
				time = 0.2,
				sound = "wp_gl40_shell_in"
			}
		}
	}
	
	--Pistol Crossbow (pd2_dlc_turtles)
	self.magazine_offsets.hunter = {
		position = Vector3(0,-4,0),
		rotation = Rotation(0,0,-90)
	}
	self.reload_timelines.hunter.reload_part_override = "ammo"
	self.reload_timelines.hunter.custom_mag_unit = nil
	self.reload_timelines.hunter.start[1].sound = nil
	self.reload_timelines.hunter.start[1].anims = {
		{
			anim_group = "reload",
			part = "barrel",
			to = 0.3
			
		},
		{
			anim_group = "reload",
			part = "lower_reciever",
			to = 0.3
		}
	}
	self.reload_timelines.hunter.start[2] = {
		time = 0.2,
		sound = "wp_dragon_lever_pull"
	}
	self.reload_timelines.hunter.finish[1].anims = {
		{
			anim_group = "reload",
			part = "barrel",
			from = 0.3
		},
		{
			anim_group = "reload",
			part = "lower_reciever",
			from = 0.3
		}
	}
	self.reload_timelines.hunter.finish[1].pos = Vector3(0,50,2)
	self.reload_timelines.hunter.finish[1].rot = Rotation(0,10,0)
	self.reload_timelines.hunter.finish[2].pos = Vector3()
	self.reload_timelines.hunter.finish[2].rot = Rotation()
	
	--Heavy Crossbow (pd2_dlc_steel)
	self.weapon_offsets.weapons.arblast = {
		grip = "weapon_2_grip",
		position = Vector3(-0.5,1.8,-3.4)
	}
	self.magazine_offsets.arblast = {
		position = Vector3(0,-6,0),
		rotation = Rotation(0,0,-90)
	}
	self.reload_timelines.arblast = {
		reload_part_type = "ammo",
		reload_part_override = "ammo",
		start = {
			{
				time = 0,
				sound = "wp_arblast_new_arrow_01",
				anims = {
					{
						anim_group = "reload",
						part = "barrel",
						from = 0.6
					},
					{
						anim_group = "reload",
						part = "lower_reciever",
						from = 0.6
					}
				}
			},
			{
				time = 0.1,
				sound = "wp_arblast_wind_up_01",
			},
			{
				time = 0.25,
				sound = "wp_arblast_wind_up_02",
			},
			{
				time = 0.4,
				sound = "wp_arblast_wind_up_03",
			},
			{
				time = 0.55,
				sound = "wp_arblast_wind_up_04",
			},
			{
				time = 0.7,
				sound = "wp_arblast_wind_up_05",
			}
		},
		finish = {
			{
				time = 0,
				pos = Vector3(0,23,8),
				rot = Rotation(0,20,0)
			},
			{
				time = 0.5,
				sound = "wp_arblast_arrow_click_01",
				pos = Vector3(),
				rot = Rotation()
			}
		}
	}

	--Light Crossbow (pd2_dlc_steel)
	self.weapon_offsets.weapons.frankish = {
		grip = "weapon_2_grip",
		position = Vector3(-0.5,1.8,-3.4)
	}
	self.magazine_offsets.frankish = {
		position = Vector3(0,-6,0),
		rotation = Rotation(0,0,-90)
	}
	self.reload_timelines.frankish = {
		reload_part_type = "ammo",
		reload_part_override = "ammo",
		start = {
			{
				time = 0,
				sound = "wp_frankish_pull_string",
				anims = {
					{
						anim_group = "reload",
						part = "barrel",
						from = 0.3
					},
					{
						anim_group = "reload",
						part = "lower_reciever",
						from = 1
					}
				}
			},
			{
				time = 0.4,
				sound = "wp_frankish_string_locked"
			}
		},
		finish = {
			{
				time = 0,
				pos = Vector3(0,23,8),
				rot = Rotation(0,20,0)
			},
			{
				time = 0.5,
				sound = "wp_frankish_new_arrow",
				pos = Vector3(),
				rot = Rotation()
			}
		}
	}

	self.magazine_offsets.ms3gl = {
		position = Vector3(2.5, 1, 2),
		rotation = Rotation(-45, 12, -20),
		weapon_offset = Vector3(0,-12,4)
	}
	self.weapon_assist.weapons.ms3gl.position = Vector3(-1.5, 13, 1)
	self.reload_timelines.ms3gl = {
		reload_part_type = "upper_reciever",
		reload_animation_effect = {
			part = "exclusive_set",
			object = "a_efx_exhaust",
			name = "effects/payday2/particles/weapons/fps_parts/fps_ms3gl_exhaust_smoke",
			pos = Vector3(5,0,0)
		},
		start = {
			{
				time = 0,
				sound = "wp_3gl_reload_slide_out",
				pos = Vector3(),
				visible = {
					visible = false,
					parts = {
						magazine = true
					}
				}
			},
			{
				time = 0.02,
				pos = Vector3(0,-17,0)
				--[[effect = {
					object = "a_upper",
					name = "effects/payday2/particles/weapons/shells/shell_40mm"
				}]]
			}
		},
		finish = {
			{
				time = 0,
				pos = Vector3(0,-17,0),
				visible = {
					visible = true,
					parts = {
						magazine = true
					}
				},
				sound = "wp_3gl_reload_mag_in",
				anims = {
					{
						anim_group = "reload_loop",
						to = 0.8,
						from = 0.57
					}
				}
			},
			{
				time = 0.65,
				pos = Vector3(0,-17,0)
			},
			{
				time = 0.99,
				sound = "wp_3gl_reload_slide_in",
				pos = Vector3()
			}
		}
	}
	
	--Kahn .357 (pd2_dlc_pxp2)
	self.weapon_offsets.weapons.korth.position = Vector3(-0.5,1,3)
	self.reload_timelines.korth.start = {
		{
			time = 0,
			sound = "wp_foley_generic_lever_pull",
			anims = {
				{
					anim_group = "reload",
					to = 0.8,
					from = 0.4,
					part = "magazine"
				}
			}
		},
		{
			time = 0.1,
			sound = "wp_korth_reload_mag_out"
		},
		{
			time = 0.2,
			sound = "wp_korth_reload_bullet_out",
			anims = {
				{
					anim_group = "reload",
					to = 2.0,
					from = 1.3,
					part = "magazine"
				}
			},
			visible = {
				visible = false,
				parts = {
					magazine = {
						"g_bullets_1"
					}
				}
			}
		},
		{
			time = 0.21,
			effect = {
				object = "a_m",
				name = "effects/payday2/particles/weapons/shells/shell_revolver_dump"
			}
		}
	}
	self.reload_timelines.korth.finish = {
			{
			time = 0,
			sound = "wp_korth_reload_bullet_in",
			anims = {
				{
					anim_group = "reload",
					from = 2.2,
					part = "magazine"
				}
			},
			visible = {
				visible = false,
				parts = {
					magazine = {
						"g_speedloader"
					}
				}
			}
		},
		{
			time = 0.01,
			visible = {
				visible = true,
				parts = {
					magazine = {
						"g_bullets_1"
					}
				}
			}
		},
		{
			time = 0.97,
			sound = "wp_korth_reload_mag_in",
			anims = {
				{
					anim_group = "reload",
					from = 2.8,
					part = "magazine"
				}
			}
		}
	}
	self.reload_timelines.x_korth = self.reload_timelines.korth
	self.weapon_offsets.weapons.x_korth = self.weapon_offsets.weapons.korth
	
	--Claire 12G (pd2_dlc_sdb)
	self.reload_timelines.coach.reload_part_type = "stock"
	self.reload_timelines.coach.start = {
			{
			time = 0,
			sound = "wp_coach_barrel_open",
			anims = {
				{
					anim_group = "reload",
					to = 0.3,
					from = 0.1
				}
			}
		},
		{
			time = 0.05,
			visible = {
				visible = false,
				parts = {
					right_slug = true,
					left_slug = true
				}
			},
			effect = {
				object = "g_right_slug",
				name = "effects/payday2/particles/weapons/shells/shell_slug_2x",
				part = "right_slug"
			}
		}
	}
	self.reload_timelines.coach.finish = {
		{
			sound = "wp_coach_shells_in",
			time = 0,
			visible = {
				visible = true,
				parts = {
					right_slug = true,
					left_slug = true
				}
			},
			anims = {
				{
					anim_group = "reload",
					to = 1.2,
					from = 0.98
				}
			}
		},
		{
			time = 0.3,
			sound = "wp_coach_grab"
		},
		{
			time = 0.4,
			sound = "wp_coach_barrel_close",
			anims = {
				{
					anim_group = "reload",
					from = 1.9
				}
			}
		}
	}
	
	--SG Versteckt 51D (pd2_dlc_pxp1)
	local belt_magazine_bullets = {"g_bullet_1","g_bullet_2","g_bullet_3"}
	local belt_0_bullets = {"g_bullet_4","g_bullet_5"}
	local belt_3_bullets = {"g_bullet_12","g_bullet_13","g_bullet_14"}
	local belt_6_bullets = {"g_bullet_21","g_bullet_22","g_bullet_23","g_bullet_24"}
	self.weapon_assist.weapons.hk51b = {
		grip = "idle_wpn",
		position = Vector3(-1.2, 29, 3)
	}
	self.magazine_offsets.hk51b = {
		position = Vector3(3,-2,-8),
		rotation = Rotation(90,-80,0)
	}
	self.reload_timelines.hk51b = {
		reload_part_type = "magazine_extra_2",
		reload_part_override = "magazine_extra_2",
		reload_part_addon = {
			["magazine"] = {pos = Vector3(2.8,-2.17,4.37),rot = Rotation(-90,0,0)},
			["belt_1"] = {pos = Vector3(2.85,1.4,3.57),rot = Rotation(90,0,0),ammo_offset = 3},
			["belt_2"] = {pos = Vector3(2.85,1.4,0.97),rot = Rotation(90,0,0),ammo_offset = 5},
			["belt_3"] = {pos = Vector3(2.85,1.4,-1.67),rot = Rotation(90,0,0),ammo_offset = 7},
			["belt_4"] = {pos = Vector3(2.85,1.4,-4.27),rot = Rotation(90,0,0),ammo_offset = 10},
			["belt_5"] = {pos = Vector3(2.85,1.4,-8.12),rot = Rotation(90,0,0),ammo_offset = 13},
			["belt_6"] = {pos = Vector3(2.85,1.4,-11.97),rot = Rotation(90,0,0),ammo_offset = 16},
			["belt_7"] = {pos = Vector3(2.85,1.4,-15.82),rot = Rotation(90,0,0),ammo_offset = 20},
			["belt_8"] = {pos = Vector3(2.85,1.4,-20.97),rot = Rotation(90,0,0),ammo_offset = 24}
		},
		start = {
			{
				time = 0,
				sound = "wp_hk51b_reload_mag_release",
				pos = Vector3(),
				rot = Rotation(),
				visible = false,
				anims = {
					{
						anim_group = "reload_not_empty",
						to = 1.2,
						from = 0.8,
						part = "magazine"
					},
					{
						anim_group = "reload_not_empty",
						to = 1.2,
						from = 0.8,
						part = "magazine_extra_2"
					}
				}
			},
			{
				time = 0.03,
				sound = "wp_hk51b_reload_mag_out"
			},
			{
				time = 0.1,
				visible = {
					visible = false,
					parts = {
						magazine = belt_magazine_bullets,
						belt_1 = belt_0_bullets,
						belt_2 = belt_0_bullets,
						belt_3 = belt_0_bullets,
						belt_4 = belt_3_bullets,
						belt_5 = belt_3_bullets,
						belt_6 = belt_3_bullets,
						belt_7 = belt_6_bullets,
						belt_8 = belt_6_bullets
					}
				}
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_hk51b_reload_mag_in",
				visible = true,
				anims = {
					{
						anim_group = "reload_not_empty",
						to = 2.4,
						from = 1.7,
						part = "magazine"
					},
					{
						anim_group = "reload_not_empty",
						to = 2.4,
						from = 1.7,
						part = "magazine_extra_2"
					}
				}
			},
			{
				time = 0.5,
				pos = Vector3(),
				rot = Rotation()
			},
			{
				time = 0.7,
				sound = "wp_hk51b_reload_lever_release",
				pos = Vector3(5, 0, 0)
			},
			{
				time = 0.9,
				pos = Vector3(10,0,-4),
				rot = Rotation(0,0,30),
				visible = false,
				--drop_mag = true,
				anims = {
					{
						anim_group = "reload_not_empty",
						from = 4.4,
						part = "magazine"
					},
					{
						anim_group = "reload_not_empty",
						from = 4.4,
						part = "magazine_extra_2"
					}
				}
			}
		}
	}
	
	--Peacemaker .45 (pd2_dlc_west)
	self.reload_timelines.peacemaker.reload_part_type = "upper_reciever"
	self.reload_timelines.peacemaker.start = {
		{
			time = 0,
			sound = "wp_pmkr45_open_latch",
			anims = {
				{
					anim_group = "reload_exit",
					to = 0.1,
					from = 0.1,
					part = "lower_reciever"
				},
				{
					anim_group = "reload_exit",
					to = 0.1,
					from = 0.1,
					part = "upper_reciever"
				},
				{
					anim_group = "reload_enter",
					from = 0.13,
					part = "lower_reciever"
				}
			}
		},
		{
			time = 0.1,
			sound = "wp_pmkr45_cylinder_click_01",
			anims = {
				{
					anim_group = "reload_enter",
					from = 0.7,
					part = "upper_reciever"
				}
			}
		},
		{
			time = 0.2,
			sound = "wp_pmkr45_load_bullet",
			visible = {
				visible = false,
				parts = {
					upper_reciever = {
						"g_bullet_7"
					}
				}
			},
			anims = {
				{
					anim_group = "reload",
					to = 0.4,
					from = 0.1,
					part = "upper_reciever"
				}
			}
		},
		{
			time = 0.25,
			visible = {
				visible = false,
				parts = {
					upper_reciever = {
						"g_bullets_static1",
						"g_bullet_1",
						"g_bullet_2",
						"g_bullet_3",
						"g_bullet_4",
						"g_bullet_5",
						"g_bullet_6"
					}
				}
			}
		}
	}
	self.reload_timelines.peacemaker.finish = {
		{
			time = 0,
			sound = "wp_pmkr45_load_bullet",
			visible = {
				visible = true,
				parts = {
					upper_reciever = {
						"g_bullets_static1",
						"g_bullet_2",
						"g_bullet_3",
						"g_bullet_4",
						"g_bullet_5",
						"g_bullet_6",
						"g_bullet_7"
					}
				}
			},
			anims = {
				{
					anim_group = "reload_enter",
					to = 1,
					from = 1,
					part = "upper_reciever"
				},
				{
					anim_group = "reload_enter",
					to = 1,
					from = 1,
					part = "lower_reciever"
				},
				{
					anim_group = "reload",
					to = 0.8,
					from = 0.3,
					part = "upper_reciever"
				}
			}
		},
		{
			time = 0.2,
			sound = "wp_pmkr45_cylinder_click_02"
		},
		{
			time = 0.7,
			sound = "wp_pmkr45_close_latch",
			anims = {
				{
					anim_group = "reload_exit",
					part = "lower_reciever",
					from = 0.1
				},
				{
					anim_group = "reload_exit",
					part = "upper_reciever",
					from = 0.1
				}
			}
		},
		{
			time = 0.99,
			visible = {
				visible = true,
				parts = {
					upper_reciever = {
						"g_bullet_1"
					}
				}
			}
		}
	}
	
	--MA-17 Flamethrower (pd2_dlc_sft)
	self.magazine_offsets.system = {
		position = Vector3(4,0,10),
		rotation = Rotation(0,-82,0),
		weapon_offset = Vector3(-6,24,2)
	}
	self.weapon_assist.weapons.system = {
		grip = "idle_wpn",
		position = Vector3(-1.2, 24, 0)
	}
	self.reload_timelines.system = {
		start = {
			{
				time = 0,
				sound = "wp_system_open_valve",
				anims = {
					{
					anim_group = "reload",
						to = 3,
						from = 2.1
					}
				}
			},
			{
				time = 0.01,
				sound = "wp_system_pull_tube"
			},
			{
				time = 0.02,
				sound = "wp_system_twist_tube"
			},
			{
				time = 0.05,
				pos = Vector3(),
				rot = Rotation()
			},
			{
				time = 0.06,
				pos = Vector3(0, 4, 0),
				rot = Rotation()
			},
			{
				drop_mag = true,
				time = 0.07,
				visible = false,
				pos = Vector3(-8, 4, 3),
				rot = Rotation(10, 10, -10)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_system_insert_tube",
				visible = true,
				pos = Vector3(-8, 4, 3),
				rot = Rotation(10, 10, -10)
			},
			{
				time = 0.3,
				sound = "wp_system_lock_tube",
				pos = Vector3(0, 4, 0)
			},
			{
				time = 0.6,
				sound = "wp_system_close_valve",
				rot = Rotation(),
				pos = Vector3()
			},
			{
				time = 0.9,
				anims = {
					{
						anim_group = "reload",
						from = 8
					}
				}
			}
		}
	}

	--KSP (pd2_dlc_gage_lmg)
	self.reload_timelines.m249 = {
		start = {
			{
				time = 0,
				sound = "wp_m249_cover_up",
				anims = {
					{
						anim_group = "reload",
						to = 0.9,
						from = 0.5,
						part = "upper_reciever"
					}
				}
			},
			{
				time = 0.05,
				pos = Vector3(),
				rot = Rotation()
			},
			{
				drop_mag = true,
				time = 0.07,
				visible = false,
				sound = "wp_m249_box_out",
				pos = Vector3(-7, 0, 0),
				rot = Rotation(0,0,-15)
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_m249_box_in",
				visible = true,
				pos = Vector3(-7, 0, 0),
				rot = Rotation(0,0,-15),
				anims = {
					{
						anim_group = "reload",
						--to = 3.2,
						from = 3.9,
						part = "upper_reciever"
					}
				}
			},
			{
				time = 0.46,
				pos = Vector3(),
				rot = Rotation()
			},
			{
				time = 0.47,
				sound = "wp_m249_cover_down"
			},
			{
				time = 0.98,
				sound = "wp_m249_lever_release"
			}
		}
	}
	
	--KSP 58 (pd2_dlc_par)
	self.reload_timelines.par = deep_clone(self.reload_timelines.m249)
	self.reload_timelines.par.start[1].sound = "wp_svinet_cover_up"
	self.reload_timelines.par.start[1].anims = {
		{
			anim_group = "reload",
			to = 2.9,
			from = 2.5,
			part = "upper_reciever"
		}
	}
	self.reload_timelines.par.start[3].sound = "wp_svinet_mag_out"
	self.reload_timelines.par.finish[1].sound = "wp_svinet_mag_in"
	self.reload_timelines.par.finish[1].anims = {
		{
			anim_group = "reload",
			from = 5.9,
			part = "upper_reciever"
		}
	}
	self.reload_timelines.par.finish[3].sound = "wp_svinet_cover_down"
	self.reload_timelines.par.finish[4].sound = "wp_svinet_lever_release"

	--Buzzsaw 42 (pd2_dlc_gage_historical)
	local mg42_parts = {"g_mag","g_bullet_1","g_bullet_2","g_bullet_3","g_bullet_4","g_bullet_5","g_bullet_6","g_band_1","g_band_2","g_band_3","g_band_4","g_mag_handle"}
	self.reload_timelines.mg42.start = {
		{
			time = 0,
			sound = "wp_mg42_cover_open",
			anims = {
				{
					anim_group = "reload",
					to = 3.7,
					from = 2.4,
					part = "lower_reciever"
				}
			}
		},
		{
			time = 0.07,
			sound = "wp_mg42_box_remove",
			anims = {
				{
					anim_group = "reload",
					to = 3.9,
					from = 3.4,
					part = "lower_reciever"
				}
			}
		},
		{
			time = 0.12,
			visible = {
				visible = false,
				parts = {
					lower_reciever = mg42_parts
				}
			}
		}
	}
	self.reload_timelines.mg42.finish = {
		{
			time = 0,
			sound = "wp_mg42_box_slide_in",
			visible = {
				visible = true,
				parts = {
					lower_reciever = mg42_parts
				}
			},
			anims = {
				{
					anim_group = "reload",
					to = 4.9,
					from = 4.4,
					part = "lower_reciever"
				}
			}
		},
		{
			time = 0.76,
			sound = "wp_mg42_cover_close",
			anims = {
				{
					anim_group = "reload",
					--to = 0.9,
					from = 6.1,
					part = "lower_reciever"
				}
			}
		},
		{
			time = 0.99,
			sound = "wp_mg42_lever_release"
		}
	}
	
	--Airbow (pd2_dlc_ecp)
	self.magazine_offsets.ecp.weapon_offset = Vector3(0,12,10)
	self.reload_timelines.ecp = {
		reload_part_addon = "ammo",
		start = {
			{
				time = 0,
				sound = "wp_ecp_pull_lever",
				anims = {
					{
						anim_group = "reload",
						from = 0.5,
						to = 0.8
					}
				}
			},
			{
				time = 0.06,
				sound = "wp_ecp_remove_clip",
				anims = {
					{
						anim_group = "reload",
						from = 1.2,
						to = 1.5
					}
				}
			},
			{
				drop_mag = true,
				time = 0.18,
				visible = {
					visible = false,
					parts = {
						magazine = true,
						ammo = true
					}
				}
			}
		},
		finish = {
			{
				time = 0,
				sound = "wp_ecp_attach_clip",
				anims = {
					{
						anim_group = "reload",
						from = 2.35
					}
				},
				visible = {
					visible = true,
					parts = {
						magazine = true,
						ammo = true
					}
				}
			},
			{
				time = 0.99,
				sound = "wp_ecp_hit_clip",
				anims = {
					{
						anim_group = "reload",
						from = 2.9
					}
				}
			}
		}
	}

	--Akimbo Matever .357 (pd2_dlc_arena)
	self.weapon_hidden.x_2006m = self.weapon_hidden.mateba
	self.weapon_offsets.weapons.x_2006m = self.weapon_offsets.weapons.mateba
	self.reload_timelines.x_2006m.start[1].rot = Rotation()
	self.reload_timelines.x_2006m.start[2].time = 0.1
	self.reload_timelines.x_2006m.start[2].sound = nil
	self.reload_timelines.x_2006m.start[2].rot = Rotation(0,0,170)
	self.reload_timelines.x_2006m.start[3].sound = "wp_mateba_empty_barrel"
	self.reload_timelines.x_2006m.finish[1].rot = Rotation(0,0,170)
	self.reload_timelines.x_2006m.finish[2].rot = Rotation()

	--Signature (pd2_dlc_joy)
	self.weapon_assist.weapons.shepheard = {
		grip = "idle_wpn",
		position = Vector3(-1,19,4)
	}
	self.reload_timelines.shepheard.start[2].pos = Vector3(0,0,-4)
	self.reload_timelines.shepheard.start[3].pos = Vector3(0,0,-20)
	self.reload_timelines.shepheard.finish[1].pos = Vector3(0,0,-10)
	self.reload_timelines.shepheard.finish[2].pos = Vector3(0,0,-4)
	self.reload_timelines.shepheard.finish[3].pos = Vector3(0,0,-4)
	self.reload_timelines.x_shepheard.start[1].sound = "wp_shepheard_clip_grab_throw"
	self.reload_timelines.x_shepheard.start[2].pos = Vector3(0,0,-4)
	self.reload_timelines.x_shepheard.start[3].pos = Vector3(0,0,-20)
	self.reload_timelines.x_shepheard.finish[1].sound = "wp_shepheard_clip_slide_in"
	self.reload_timelines.x_shepheard.finish[1].pos = Vector3(0,0,-10)
	self.reload_timelines.x_shepheard.finish[2].pos = Vector3(0,0,-4)
	self.reload_timelines.x_shepheard.finish[3].pos = Vector3(0,0,-4)
	self.reload_timelines.x_shepheard.finish[4].sound = "wp_shepheard_lever_release"
	
	--Gruber Kurz (pd2_dlc1)
	self.magazine_offsets.ppk = {
		position = Vector3(0, 0, 0)
	}
	self.magazine_offsets.x_ppk = self.magazine_offsets.ppk

	--Hailstorm Mk 5 (pd2_dlc_pxp2)
	self.magazine_offsets.hailstorm.position = Vector3(2, 1, 7)
	self.weapon_assist.weapons.hailstorm = {
		position = Vector3(0, 12, -3.8)
	}
	self.reload_timelines.hailstorm.start[1].sound = "wp_hailstorm_reload_mag_out"
	self.reload_timelines.hailstorm.start[1].effect = {
		object = "a_efx_heat",
		name = "effects/payday2/particles/weapons/heat/hailstorm_heat"
	}
	self.reload_timelines.hailstorm.start[2].rot = Rotation(0,10,0)
	self.reload_timelines.hailstorm.start[3].rot = Rotation(0,10,0)
	self.reload_timelines.hailstorm.start[4].rot = Rotation(1,10,-4)
	self.reload_timelines.hailstorm.start[5].sound = "wp_hailstorm_reload_mag_throw"
	self.reload_timelines.hailstorm.finish[1].rot = Rotation(0,10,0)
	self.reload_timelines.hailstorm.finish[1].sound = "wp_hailstorm_reload_mag_in"
	self.reload_timelines.hailstorm.finish[2].rot = Rotation(0,10,0)
	self.reload_timelines.hailstorm.finish[3].rot = Rotation(0,5,0)
	self.reload_timelines.hailstorm.finish[4].sound = "wp_hailstorm_reload_shoulder"

	--VD-12 (pd2_dlc_pxp2)
	self.weapon_offsets.weapons.sko12 = {
		position = Vector3(-0.5,1.8,1)
	}
	self.magazine_offsets.sko12 = {
		position = Vector3(12,-14,14)
	}
	self.weapon_offsets.weapons.x_sko12 = self.weapon_offsets.weapons.sko12
	self.magazine_offsets.x_sko12 = {
		position = Vector3(1,-10,1)
	}
	self.reload_timelines.sko12.start[1].sound = "wp_sko12_reload_mag_out"
	self.reload_timelines.sko12.start[2].time = 0.05
	self.reload_timelines.sko12.start[2].pos = Vector3(0,0,-1)
	self.reload_timelines.sko12.start[2].rot = nil
	self.reload_timelines.sko12.start[3].time = 0.08
	self.reload_timelines.sko12.start[3].pos = Vector3(0,0,-20)
	self.reload_timelines.sko12.start[3].rot = nil
	self.reload_timelines.sko12.finish[1].sound = "wp_sko12_reload_mag_in"
	self.reload_timelines.sko12.finish[2].pos = Vector3(0,0,-1)
	self.reload_timelines.sko12.finish[2].rot = nil
	self.reload_timelines.sko12.finish[3].sound = nil
	self.reload_timelines.x_sko12.start[1].sound = "wp_sko12_reload_mag_out"
	self.reload_timelines.x_sko12.start[2].rot = nil
	self.reload_timelines.x_sko12.finish[1].sound = "wp_sko12_reload_mag_in"
	self.reload_timelines.x_sko12.finish[1].rot = nil
	self.reload_timelines.x_sko12.finish[2].rot = nil
	self.reload_timelines.x_sko12.finish[3].rot = nil
	self.reload_timelines.x_sko12.finish[4].sound = nil
	
	--Bernetti Auto (pd2_dlc_afp)
	self.reload_timelines.beer.start[1].sound = "wp_beer_mag_out"
	self.reload_timelines.beer.finish[1].sound = "wp_beer_mag_in"
	self.reload_timelines.beer.finish[4].sound = "wp_beer_slide_forward"
	self.reload_timelines.x_beer.start[1].sound = "wp_beer_x_mag_out" --Akimbo weapons use their own _x sounds for some reason
	self.reload_timelines.x_beer.finish[1].sound = "wp_beer_x_mag_in"
	self.reload_timelines.x_beer.finish[4].sound = "wp_beer_x_slide_forward"

	--Czech 92 (pd2_dlc_afp)
	self.reload_timelines.czech.start[1].sound = "wp_czech_mag_out"
	self.reload_timelines.czech.finish[1].sound = "wp_czech_mag_in"
	self.reload_timelines.czech.finish[4].sound = "wp_czech_slide_forward"
	self.reload_timelines.x_czech.start[1].sound = "wp_czech_x_mag_out"
	self.reload_timelines.x_czech.finish[1].sound = "wp_czech_x_mag_in"
	self.reload_timelines.x_czech.finish[4].sound = "wp_czech_x_slide_forward"

	--Igor Automatik (pd2_dlc_afp)
	self.reload_timelines.stech.start[1].sound = "wp_stetch_mag_release_button"
	self.reload_timelines.stech.start[2].sound = "wp_stetch_mag_slide_out"
	self.reload_timelines.stech.finish[1].sound = "wp_stetch_mag_slide_in"
	self.reload_timelines.stech.finish[4].sound = "wp_stetch_slide_release"
	self.reload_timelines.x_stech.start[1].sound = "wp_stetch_x_mag_release_button"
	self.reload_timelines.x_stech.start[2].sound = "wp_stetch_x_mag_slide_out"
	self.reload_timelines.x_stech.finish[1].sound = "wp_stetch_x_mag_slide_in"
	self.reload_timelines.x_stech.finish[4].sound = "wp_stetch_x_slide_release"
	
	--M13 9mm (pd2_dlc_khp)
	self.weapon_offsets.weapons.legacy = {
		position = Vector3(-0.5, 2, 2.2)
	}
	self.weapon_offsets.weapons.x_legacy = self.weapon_offsets.weapons.legacy
	self.reload_timelines.legacy.start[1].sound = "wp_legacy_mag_throw"
	self.reload_timelines.legacy.finish[1].sound = "wp_legacy_mag_in"
	self.reload_timelines.legacy.finish[4].sound = "wp_legacy_slide_release"
	self.reload_timelines.x_legacy.start[1].sound = "wp_legacy_mag_throw"
	self.reload_timelines.x_legacy.finish[1].sound = "wp_legacy_mag_in"
	self.reload_timelines.x_legacy.finish[4].sound = "wp_legacy_slide_release"
	
	--Miyaka 10 Special (pd2_dlc_sawp)
	self.weapon_offsets.weapons.pm9 = {
		position = Vector3(0.2, 1, 2)
	}
	self.weapon_offsets.weapons.x_pm9 = self.weapon_offsets.weapons.pm9
	self.reload_timelines.pm9.start[1].sound = "wp_pm9_mag_slide_out"
	self.reload_timelines.pm9.finish[1].sound = "wp_pm9_mag_slide_in"
	self.reload_timelines.pm9.finish[4].sound = "wp_pm9_lever_release"
	self.reload_timelines.x_pm9.start[1].sound = "wp_pm9_x_mag_slide_out"
	self.reload_timelines.x_pm9.finish[1].sound = "wp_pm9_x_mag_slide_in"
	self.reload_timelines.x_pm9.finish[4].sound = "wp_pm9_x_lever_release"

	--Pronghorn (pd2_dlc_pxp1)
	self.weapon_offsets.weapons.scout = {
		position = Vector3(-1, -2, 3.8)
	}
	self.magazine_offsets.scout = {
		position = Vector3(1, 1, 5),
		rotation = Rotation(-10, 0, 0)
	}
	self.reload_timelines.scout.start[1].sound = "wp_steyr_scout_reload_empty_bolt_out"
	self.reload_timelines.scout.finish[1].sound = "wp_steyr_scout_reload_empty_mag_in"
	self.reload_timelines.scout.finish[4].sound = "wp_steyr_scout_reload_empty_bolt_in"
	
	--Káng Arms X1 (pd2_dlc_sawp)
	self.reload_timelines.qbu88.start[1].sound = "wp_qbu88_mag_out"
	self.reload_timelines.qbu88.finish[1].sound = "wp_qbu88_mag_in"
	self.reload_timelines.qbu88.finish[3].sound = "wp_qbu88_lever_release"
	
	--North Star (pd2_dlc_savi)
	self.weapon_hidden.victor = {
		magazine_extra = {
			"g_mag_2"
		}
	}
	self.magazine_offsets.victor.position = Vector3(1,-12,3)
	self.weapon_assist.weapons.victor.grip = nil
	self.reload_timelines.victor.start[1].sound = "wp_saintvictor_reload_empty_mag_out"
	self.reload_timelines.victor.start[2].visible = false
	self.reload_timelines.victor.finish[1].sound = "wp_saintvictor_reload_empty_mag_in"
	self.reload_timelines.victor.finish[1].visible = true
	self.reload_timelines.victor.finish[3].sound = "wp_saintvictor_reload_empty_bolt_release"
	
	--Akimbo Jackal (pd2_dlc_osa)
	self.reload_timelines.x_schakal.start[1].sound = "wp_schakal_x_mag_out"
	self.reload_timelines.x_schakal.finish[1].sound = "wp_schakal_x_mag_in"
	self.reload_timelines.x_schakal.finish[4].sound = "wp_schakal_x_bolt_slap"
	
	--Akimbo Tatonka (pd2_dlc_osa)
	self.reload_timelines.x_coal.start[1].sound = "wp_coal_x_mag_out_back"
	self.reload_timelines.x_coal.finish[1].sound = "wp_coal_x_mag_in_back"
	self.reload_timelines.x_coal.finish[4].sound = "wp_coal_x_release_lever"
	
	--Akimbo MP40 (pd2_dlc_osa)
	self.reload_timelines.x_erma.start[1].sound = "wp_erma_x_mag_out"
	self.reload_timelines.x_erma.finish[1].sound = "wp_erma_x_mag_in"
	self.reload_timelines.x_erma.finish[4].sound = "wp_erma_x_slide_release"

	--Raven (pd2_dlc_gage_shot)
	self.reload_timelines.ksg.reload_part_type = "lower_body"

	self.weapon_assist.weapons.hk21.points[2] = nil
	self.weapon_assist.weapons.rpk.points[2] = nil
	self.weapon_assist.weapons.mg42.points[2] = nil
	self.weapon_assist.weapons.m249 = {
		grip = "idle_wpn",
		position = Vector3(-2,30,2)
	}
	self.weapon_assist.weapons.par = {
		grip = "idle_wpn",
		position = Vector3(-2,34,2)
	}

	self.melee_offsets.weapons.aziz.hit_point = nil
	self.weapon_kick.exclude_list.system = true
end)