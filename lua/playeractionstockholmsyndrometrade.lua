--Fix Stockholm Syndrome skill not working with VR controls

function StockholmSyndromeTradeAction:update(t, dt)
	local auto_activate = managers.groupai:state():num_alive_criminals() <= 0
	local allowed, feedback_idx = StockholmSyndromeTradeAction.is_allowed()

	if allowed and not self._last_can_use then
		managers.hint:show_hint("stockholm_syndrome_hint")
	end

	local button_pressed = self._controller:get_input_pressed("jump")
	
	if _G.IS_VR then
		button_pressed = self._controller:get_input_pressed("warp")
	end

	if not self._request_hostage_trade and (button_pressed and not managers.hud:chat_focus() or auto_activate) then
		local pm = managers.player

		if Network:is_server() then
			if allowed then
				pm:init_auto_respawn_callback(self._pos, self._peer_id, false)
				pm:change_stockholm_syndrome_count(-1)

				self._quit = true
			elseif feedback_idx > 0 and not auto_activate then
				self.on_failure(feedback_idx)
			end
		elseif managers.network:session() then
			managers.network:session():send_to_host("request_stockholm_syndrome", self._pos, self._peer_id, auto_activate)

			self._request_hostage_trade = true
		end
	end

	local current_state = game_state_machine:current_state_name()

	if self._previous_state == "ingame_waiting_for_respawn" and current_state ~= self._previous_state then
		self._quit = true
	end

	self._previous_state = current_state
	self._last_can_use = allowed

	return self._quit
end