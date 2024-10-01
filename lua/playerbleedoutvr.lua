--The bleedout and fatal player states aren't scripted correctly to unequip melee and deployables on both hands,
--allowing the player to do things like perform melee attacks when downed, even when fully incapacitated

if not VRFixes_Mod.Settings.bleedoutmeleefix then return end

local function unequipMeleeDeployables(self,enabled,fatal)
	if not enabled then
		local disallowedstates = {
			["melee"] = true,
			["deployable"] = true
		}
		for i=1,2 do
			local primary_hand = self._weapon_hand_id or PlayerHand.hand_id(managers.vr:get_setting("default_weapon_hand") or "right")
		
			local currenthandstate = self._unit:hand():current_hand_state(i):name()
			local disallowed_hand = disallowedstates[currenthandstate]
			
			if disallowed_hand then
				if fatal then
					self._unit:hand():_set_hand_state(i,"idle")
					if primary_hand == i then
						self._weapon_hand_id = self._weapon_hand_id or primary_hand
					end
				else
					self._unit:hand():_change_hand_to_default(i)
				end
			end
		end
	end
end

if RequiredScript == "lib/units/beings/player/states/vr/playerbleedoutvr" then
	Hooks:PostHook(PlayerBleedOutVR,"set_belt_and_hands_enabled","VRFixes_BleedOut_set_hand_states",unequipMeleeDeployables)
elseif RequiredScript == "lib/units/beings/player/states/vr/playerfatalvr" then
	Hooks:PostHook(PlayerFatalVR,"set_belt_and_hands_enabled","VRFixes_Fatal_set_hand_states",function(self,enabled)
		unequipMeleeDeployables(self,enabled,true)
	end)
end