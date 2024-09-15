--Newsfeedgui uses a quirk with setting rotation to 360, allowing the announcement text to render outside of the panel it belongs to, making the text actually slide in and out of the screen
--Unfortunately, while this looks fine in desktop, it causes the text to clip outside of the main menu screen when in VR

--This has the possibility of cutting off the text if it is too long, but I don't think anyone is going to be too bothered over that
if _G.IS_VR then
Hooks:PostHook(NewsFeedGui,"_create_gui","VRFixes_Announcement_Clipping_fix",function(self)
	self._title_panel:child("title"):set_rotation(0)
end)
end