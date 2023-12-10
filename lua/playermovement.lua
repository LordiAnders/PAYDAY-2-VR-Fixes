--Fixes the Collision Teleport setting causing actual teleports to fail (Border Crossing, out of bounds, ziplines, etc)
Hooks:PreHook(PlayerMovement,"warp_to","VRFixes_warp_to",function(self,pos)
	mvector3.set(self._m_pos,pos)
end)