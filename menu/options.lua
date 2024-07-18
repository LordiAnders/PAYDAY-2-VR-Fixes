if not VRFixes_Mod then
	VRFixes_Mod = {}
	VRFixes_Mod.ModPath = ModPath
	VRFixes_Mod.LocPath = VRFixes_Mod.ModPath.."menu/loc.txt"
	VRFixes_Mod.SavePath = SavePath.."vrfixes.txt"
	VRFixes_Mod.Settings = {
		meleecooldown = false
	}
	function VRFixes_Mod:LoadSettings()
		VRFixes_Mod.Settings = io.file_is_readable(VRFixes_Mod.SavePath) and io.load_as_json(VRFixes_Mod.SavePath) or VRFixes_Mod.Settings
	end
	
	function VRFixes_Mod:SaveSettings()
		io.save_as_json(VRFixes_Mod.Settings,VRFixes_Mod.SavePath)
	end
end

Hooks:AddHook("BLTOnBuildOptions","VRFixes_Options_Build",function()
	MenuCallbackHandler.VRFixes_Mod_Options_toggle = function(self,item)
		VRFixes_Mod.Settings[item:name()] = Utils:ToggleItemToBoolean(item)
	end
	MenuCallbackHandler.VRFixes_Mod_Options_save = function()
		VRFixes_Mod:SaveSettings()
	end
	
	MenuHelper:LoadFromJsonFile(VRFixes_Mod.ModPath.."menu/menu.txt",VRFixes_Mod,VRFixes_Mod.Settings)
end)

Hooks:AddHook("LocalizationManagerPostInit","VRFixes_Options_Loc",function(self)
	self:load_localization_file(VRFixes_Mod.LocPath)
end)

VRFixes_Mod:LoadSettings()