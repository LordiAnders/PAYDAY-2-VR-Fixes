--Adds missing event decorations to the VR main menu
--It seems inconsistent considering that effects were visible in the menu, but not units
if VRFixes_Mod.Settings.eventdecorations then
	Hooks:PostHook(MenuSceneManagerVR,"_set_up_templates","VRFixes_Show_Event_units",function(self)
		local templates = {
			"standard",
			"blackmarket",
			"blackmarket_mask",
			"infamy_preview",
			"blackmarket_item",
			"character_customization",
			"play_online",
			"options",
			--"lobby",
			"lobby_vr",
			"lobby1",
			"lobby2",
			"lobby3",
			"lobby4",
			"inventory",
			"blackmarket_crafting",
			"blackmarket_weapon_color",
			--"safe",
			"blackmarket_customize",
			"blackmarket_character",
			"blackmarket_customize_armour",
			"blackmarket_armor",
			"blackmarket_screenshot",
			"crime_spree_lobby",
			"crew_management",
			"blackmarket_item",
			"movie_theater"
		}

		for _, template in ipairs(templates) do
			self._scene_templates[template].show_event_units = true
		end
	end)
end

Hooks:PostHook(MenuSceneManager,"setup_event_units","VRFixes_Adjust_Menu_Event_Units",function(self)
	if VRFixes_Mod.Settings.eventdecorations then
		--The positions of the decorations need to be manually adjusted, since they weren't created with the VR menu scene in mind
		local presents_position = Vector3(-350,220,125)
		local xmas_position = Vector3(700,-20,45)
		local snow_position = Vector3(-55,-185,72)
		local decoration_adjusters = {
			[Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_diamonds"):key()] = presents_position,
			[Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_polkal"):key()] = presents_position,
			[Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_polkas"):key()] = presents_position,
			[Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_stars"):key()] = presents_position,
			[Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_stripes"):key()] = presents_position,
			[Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_zigzag"):key()] = presents_position,
			[Idstring("units/pd2_dlc2/props/com_props_christmas_tree/com_prop_christmas_tree"):key()] = xmas_position,
			[Idstring("units/pd2_dlc_cane/props/cne_prop_snow_pile_01/cne_prop_snow_pile_01"):key()] = snow_position
		}

		if self._event_units then
			for _,unit in ipairs(self._event_units) do
				local adjuster = decoration_adjusters[unit:name():key()]
				if adjuster then
					unit:set_position(unit:position() + adjuster)
				end
			end
		end
	else
		--Remove all the decorations, if the mod option is turned off. This also removes the particle effects that are normally present in vanilla (confetti)
		
		if self._event_effects then
			for _, effect in ipairs(self._event_effects) do
				--if World:effect_manager():alive(effect) then --This fails because the effect is not considered 'alive' until a few frames have passed. Killing the effect works fine without this check
					World:effect_manager():kill(effect)
				--end
			end
		end

		self._event_effects = {}
		
		self:remove_event_units() --Run the original function just for good measure
	end
end)