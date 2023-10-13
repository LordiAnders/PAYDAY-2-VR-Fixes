--Attempts to get the magazine unit from the original function and modifies the bullet objects on it, as well as reapplying cosmetic data, since it appears to be broken in vanilla
--Also adjusts its objects' visibility if reload_part_type_hidden is set in reload timeline, used for underbarrels to display the correct grenade when held

local old_magazine_unit_function = NewRaycastWeaponBase.spawn_magazine_unit

local material_textures = {
	pattern = "diffuse_layer0_texture",
	sticker = "diffuse_layer3_texture",
	pattern_gradient = "diffuse_layer2_texture",
	base_gradient = "diffuse_layer1_texture"
}
local material_variables = {
	cubemap_pattern_control = "cubemap_pattern_control",
	pattern_pos = "pattern_pos",
	uv_scale = "uv_scale",
	uv_offset_rot = "uv_offset_rot",
	pattern_tweak = "pattern_tweak"
}

function NewRaycastWeaponBase:spawn_magazine_unit(pos, rot, hide_bullets)
	local mag_unit = old_magazine_unit_function(self,pos,rot,hide_bullets) --Get the mag_unit using the original function, then we just modify the unit
	
	if not mag_unit then return end

	local mag_data = nil
	local mag_list = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("magazine", self._factory_id, self._blueprint)
	local mag_id = mag_list and mag_list[1]

	if not mag_id then
		return mag_unit
	end

	mag_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mag_id, self._factory_id, self._blueprint)

	if not mag_data then
		return mag_unit
	end

	if self.vrfixesammoreloadcount then
		local tweak = self:weapon_tweak_data()
		if (tweak and tweak.categories and tweak.categories[1]) == "akimbo" then
			self.vrfixesammoreloadcount = self.vrfixesammoreloadcount / 2 --This doesn't produce a 100% accurate result, but it's good enough
		end

		if mag_data.bullet_objects then
			local prefix = mag_data.bullet_objects.prefix
			
			local ammo_offset = 0
			
			local reload_addon = tweak_data.vr.reload_timelines[self.name_id].reload_part_addon
			if reload_addon then
				if type(reload_addon) == "table" then
					ammo_offset = reload_addon[mag_data.type] and reload_addon[mag_data.type].ammo_offset or 0
				end
			end

			for i = 1, mag_data.bullet_objects.amount do
				local target_object = mag_unit:get_object(Idstring(prefix .. ((mag_data.bullet_objects.offset or 0) + i)))

				if target_object then
					target_object:set_visibility(i <= (self.vrfixesammoreloadcount - ammo_offset))
				end
			end
		end
	end
	
	--Applies cosmetic data, copied from huskplayermovement
	
	local material_config_ids = self:_material_config_name(mag_id, mag_data, self._cosmetics_data and true)

	if mag_unit:material_config() ~= material_config_ids and DB:has(Idstring("material_config"), material_config_ids) then
		mag_unit:set_material_config(material_config_ids, true)
	end
	
	local materials = {}
	local unit_materials = mag_unit:get_objects_by_type(Idstring("material")) or {}

	for _, m in ipairs(unit_materials) do
		if m:variable_exists(Idstring("wear_tear_value")) then
			table.insert(materials, m)
		end
	end

	local textures = {}
	local base_variable, base_texture, mat_variable, mat_texture, type_variable, type_texture, p_type, custom_variable, texture_key = nil
	local cosmetics_data = self._cosmetics_data
	local cosmetics_quality = self._cosmetics_quality
	local wear_tear_value = cosmetics_quality and tweak_data.economy.qualities[cosmetics_quality] and tweak_data.economy.qualities[cosmetics_quality].wear_tear_value or 1

	for _, material in pairs(materials) do
		material:set_variable(Idstring("wear_tear_value"), wear_tear_value)

		p_type = managers.weapon_factory:get_type_from_part_id(mag_id)

		for key, variable in pairs(material_variables) do
			mat_variable = cosmetics_data.parts and cosmetics_data.parts[mag_id] and cosmetics_data.parts[mag_id][material:name():key()] and cosmetics_data.parts[mag_id][material:name():key()][key]
			type_variable = cosmetics_data.types and cosmetics_data.types[p_type] and cosmetics_data.types[p_type][key]
			base_variable = cosmetics_data[key]

			if mat_variable or type_variable or base_variable then
				material:set_variable(Idstring(variable), mat_variable or type_variable or base_variable)
			end
		end

		for key, material_texture in pairs(material_textures) do
			mat_texture = cosmetics_data.parts and cosmetics_data.parts[mag_id] and cosmetics_data.parts[mag_id][material:name():key()] and cosmetics_data.parts[mag_id][material:name():key()][key]
			type_texture = cosmetics_data.types and cosmetics_data.types[p_type] and cosmetics_data.types[p_type][key]
			base_texture = cosmetics_data[key]
			local texture_name = mat_texture or type_texture or base_texture

			if texture_name then
				if type_name(texture_name) ~= "Idstring" then
					texture_name = Idstring(texture_name)
				end

				Application:set_material_texture(material, Idstring(material_texture), texture_name, Idstring("normal"))
			end
		end
	end
	
	if tweak_data.vr.reload_timelines[self.name_id].reload_part_override_hidden then
		for _, object_name in ipairs(tweak_data.vr.reload_timelines[self.name_id].reload_part_override_hidden) do
			local object = mag_unit:get_object(Idstring(object_name))

			if alive(object) then
				object:set_visibility(visible)
			end
		end
	end

	return mag_unit
end