Hooks:PreHook(PlayerMovement,"set_ghost_position","VRFixes_set_ghost_position",function(self,pos,unit_position)
	self._m_pos = unit_position and unit_position or pos
end)