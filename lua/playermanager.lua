--[[
	(hudbelt.lua & hudteammatevr.lua)
	Required for the secondary counter on deployables to work properly, for deployables with secondary functions
	
	remove_equipment has a check to see if the equipment that is being removed is currently "selected" on the HUD, before updating the HUD
	
	In VR, the current equipment only gets "switched" when the player interacts with the "non-selected" deployable on the belt, meaning
	if trip mines isn't considered the "current equipment" by the game, the function won't send a HUD update.
	This means the secondary counter can only update if the player has recently placed a trip mine, or chose trip mines as their primary deployable
]]
local function get_as_digested(amount)
	local list = {}

	for i = 1, #amount do
		table.insert(list, Application:digest_value(amount[i], false))
	end

	return list
end

local function make_double_hud_string(a, b)
	return string.format("%01d|%01d", a, b)
end

local function set_hud_item_amount(index, amount)
	if #amount > 1 then
		managers.hud:set_item_amount_from_string(index, make_double_hud_string(amount[1], amount[2]), amount)
	else
		managers.hud:set_item_amount(index, amount[1])
	end
end

Hooks:PostHook(PlayerManager,"remove_equipment","VRFixes_Equipment_secondary_hook",function(self,equipment_id,slot)
	if _G.IS_VR then
		local current_equipment = self:selected_equipment()
		local equipment, index = self:equipment_data_by_name(equipment_id)

		local cur_equipment = (current_equipment and current_equipment.equipment == equipment.equipment)

		if cur_equipment or not cur_equipment and (slot or 1) > 1 then
			set_hud_item_amount(index, get_as_digested(equipment.amount))
		end
	end
end)