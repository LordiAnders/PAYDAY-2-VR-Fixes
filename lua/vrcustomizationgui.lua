Hooks:OverrideFunction(VRBeltCustomization,"set_back_button_enabled",function(self,enabled)
	if self._back_button_enabled == enabled then
		return
	end

	tag_print("VRBeltCustomization:set_back_button_enabled", hand_id, enabled)

	--[[local player = managers.menu:player()

	if not enabled then
		player._hand_state_machine:enter_hand_state(hand_id, hand_id == player:primary_hand_index() and "customization" or "customization_empty")
	else
		player._hand_state_machine:enter_hand_state(hand_id, hand_id == player:primary_hand_index() and "laser" or "empty")
	end]] --Breaks belt resizing. It is already handled by backing out of the "INTERFACE" menu where it's safer

	if managers.menu:active_menu() then
		managers.menu:active_menu().input:focus(false)
		managers.menu:active_menu().input:focus(true)
	end

	self._back_button_enabled = enabled
end)