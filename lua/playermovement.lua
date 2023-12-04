Hooks:PreHook(PlayerMovement,"warp_to","VRFixes_warp_to",function(self,pos)
	mvector3.set(self._m_pos,pos)
end)