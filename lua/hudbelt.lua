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

--Implements a secondary counter on the deployable belt item, that tracks how many secondary uses the deployable has remaining (shaped charges)
--This requires the set_deployable_equipment_amount_from_string PreHook in hudteammatevr.lua
function HUDBelt:set_amount_secondary(id, amount)
	local interaction = self._interactions[id]

	if not interaction then
		Application:error("[HUDBelt:set_amount_secondary] invalid ID", id)

		return
	end

	interaction:set_amount_secondary(amount)
end

function HUDBeltInteraction:set_amount_secondary(amount)
	if not self._secondary_amount_text then
		self._secondary_amount_text = self._panel:text({
			valign = "bottom",
			halign = "left",
			font = tweak_data.hud.medium_font_noshadow,
			font_size = tweak_data.hud.default_font_size
		})
	end
	
	if not amount then
		self._show_secondary_amount = false

		self._secondary_amount_text:set_visible(false)

		return
	end

	self._show_secondary_amount = true

	self._secondary_amount_text:set_text(tostring(amount))
	make_fine_text(self._secondary_amount_text)
	self._secondary_amount_text:set_right(18)
	self._secondary_amount_text:set_bottom(self._panel:h() - 6)
	self._secondary_amount_text:set_color((amount > 0 and Color.white or Color.red):with_alpha(self._alpha + self._alpha_diff))
end

Hooks:PostHook(HUDBeltInteraction,"set_state","VRFixes_HUDBeltInteraction_set_state_secondary",function(self,state)
	if self._secondary_amount_text then
		self._secondary_amount_text:set_visible(self._show_secondary_amount and state ~= "inactive")
	end
end)

Hooks:PostHook(HUDBeltInteraction,"set_alpha","VRFixes_HUDBeltInteraction_set_alpha_secondary",function(self,alpha)
	if self._secondary_amount_text then
		self._secondary_amount_text:set_color(self._secondary_amount_text:color():with_alpha(alpha + self._alpha_diff))
	end
end)