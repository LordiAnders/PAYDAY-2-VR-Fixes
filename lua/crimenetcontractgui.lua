--Implements scroll bar grabbing functionality for the mods list when viewing lobbies in crime.net

if RequiredScript == "lib/managers/menu/menucomponentmanager" then

--MenuComponentManager doesn't send any mouse_released events to the ContractGui, so we need to add it
Hooks:PreHook(MenuComponentManager,"mouse_released","VRFixes_Mods_Scrollbar_Released",function(self,o,x,y)
	if self._crimenet_contract_gui and self._crimenet_contract_gui:release_scroll_bar() then
		return true
	end
end)

elseif RequiredScript == "lib/managers/menu/crimenetcontractgui" then

--Hijack presses so scroll bar takes priority, otherwise the game will try to inspect mods since it ignores the scroll bar
local old_cnet_mousepressed = CrimeNetContractGui.mouse_pressed
function CrimeNetContractGui:mouse_pressed(o,button,x,y,...)
	if not (self._mods_tab and self._mods_tab:is_active() and alive(self._mods_scroll) and button == Idstring("0") and self._mods_scroll:mouse_pressed(button,x,y)) then
		return old_cnet_mousepressed(self,o,button,x,y,...)
	end
end

Hooks:PostHook(CrimeNetContractGui,"mouse_moved","VRFixes_Mods_Scrollbar_Moved",function(self,o,x,y)
	if alive(self._mods_scroll) then
		self._mods_scroll:mouse_moved(o,x,y)
	end
end)

--New function since ContractGui lacks any release events
function CrimeNetContractGui:release_scroll_bar()
	if alive(self._mods_scroll) then
		self._mods_scroll:release_scroll_bar()
	end
end

end