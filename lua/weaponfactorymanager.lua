--Used for overriding the hardcoded "magazine" part getter in spawn_magazine_unit() so a different part can be returned other than the hardcoded "magazine"

local old_partstypeperkfunction = WeaponFactoryManager.get_parts_from_weapon_by_type_or_perk

function WeaponFactoryManager:get_parts_from_weapon_by_type_or_perk(type_or_perk,...)
	if vrtweaksfixes_customparttype and type_or_perk == "magazine" then
		type_or_perk = vrtweaksfixes_customparttype
	end

	return old_partstypeperkfunction(self,type_or_perk,...)
end