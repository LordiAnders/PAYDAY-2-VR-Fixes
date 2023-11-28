--Fixes ammo counter text slowly creeping out of the reload panel over the course of a game
--Due to rounding errors when the panel is scaled when touched, it causes the ammo counter to permanently move slightly over time
local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	text:set_size(w, h)
	--text:set_position(math.round(text:x()), math.round(text:y()))
end

Hooks:OverrideFunction(HUDBeltInteractionReload,"_reload_animate",function(self, o, time, clip_start, clip_full)
	local ammo_text = self._ammo_text

	ammo_text:set_text(tostring(clip_start) .. "/" .. tostring(clip_full))
	make_fine_text(ammo_text)
	ammo_text:show()

	local inc = clip_full - clip_start

	over(time, function (p)
		ammo_text:set_text(tostring(math.floor(clip_start + inc * p)) .. "/" .. tostring(clip_full))
		make_fine_text(ammo_text)
		ammo_text:set_center_x(self._panel:w() / 2)
	end)
	ammo_text:set_text(tostring(clip_full) .. "/" .. tostring(clip_full))

	self._waiting_for_trigger = true
	local bg_val = 0

	while self._waiting_for_trigger do
		local dt = coroutine.yield()
		bg_val = bg_val + dt * 360
		local val = math.abs(math.sin(bg_val))

		self._bg:set_color(Color(val, val, val))
	end

	self._bg:set_color(Color.black)
end)