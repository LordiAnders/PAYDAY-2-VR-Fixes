# PAYDAY-2-VR-Fixes
Bunch of fixes for the mostly neglected VR version of PAYDAY 2, including fixing many weapons lacking animations and sounds when reloading, as well as fixing a few pesky crashes and other annoyances.

This is similar to the already existing '[Unofficial VR Patch](https://modworkshop.net/mod/27138)' by Zdann that was unfortunately discontinued.

This mod accomplishes the same fixes as Zdann's mod and shouldn't be used together or they might conflict.

## Changes
### Weapons
- Added proper reload timelines (animations and sounds) for all weapons that were missing them or had broken timelines.
- Improved reload timelines on some weapons that had little animation or to reduce clipping.
- Fixed many weapons lacking reload sounds.
- Adjusted many weapon offsets so they sit better in the hand.
- Fixed double-barrel shotguns having poor magazine insertion points when using manual reloading.
- Fixed several two-hand grip points that were poorly positioned or used the wrong hand animation.
- Fixed several magazines being held incorrectly.
- Fixed Airbow and SG Versteckt 51D not displaying held magazines properly.
- Fixed SG Versteckt 51D, Hailstorm Mk 5 and Basilisk 3V exclusive set not playing their intended effects when reloading.
- Fixed MA-17 Flamethrower playing recoil animations when it shouldn't.
- Fixed weapons in underbarrel modes sharing the same reload timeline as the standard fire mode.
- Fixed akimbo weapons playing empty magazine sounds/animations before they are completely empty.
- Fixed weapon skins not applying correctly to held/dropped magazines.
- Fixed a few magazines lacking bullet_object definitions despite existing in their models, so the bullets in the magazine update properly.
- Fixed held and dropped magazines not displaying the correct amount of bullets in them.
- Fixed the fire animation not playing on weapons on the final shot, when using manual reloading.
- Fixed gadget laser beams becoming offset when the gadget is located anywhere but the right side of the weapon.
- Fixed gadget laser beams lagging behind on akimbo weapons when moving.
- Removed hitpoint variable from the Tactical Flashlight melee weapon that made it difficult to hit enemies.
- Added a possible fix for weapons sometimes restoring negative ammo when performing partial reloads with manual reloading.
### Skills
- Fixed the Counterstrike skill not working with VR melee.
- Fixed the Stockholm Syndrome skill not working. Pressing teleport/sprint in custody now activates it.
### Interface
- Added grab functionality to the scroll bar when viewing the mod list of lobbies, it can now be scrolled by using the VR laser pointer.
- Fixed not being able to resize panels on the VR belt when editing the layout.
- Fixed the ammo counter on the VR belt slowly moving outside the reload panel over time.
- Fixed reload timer and belt not accounting for weapons in underbarrel modes.
- Fixed ability icons on teammates becoming stuck and not showing progress circles.
- Fixed the down counter clipping into the ammo counter on teammates.
- Fixed player names sometimes turning invisible on the tablet.
- Restored the intended font size for the ammo panel.
- Added a proper belt icon for the Adhesive Grenade, replacing the placeholder Snowball icon.
### Heists
- Fixed ladders on Big Bank, Counterfeit and Election Day day 2 (warehouse) having bad exit points, causing the player to clip through walls or fall to their death.
- The collision fade out effect from getting close to walls is temporarily disabled when using the turrets in Midland Ranch and Lost in Transit.
### Other
- Fixed involuntary weapon butt melee attacks when snap turning.
- Fixed random involuntary weapon butt melee attacks when switching weapons.
- Fixed the player not getting teleported correctly by the game when the 'Collision Teleport' setting is turned on. (Fixes Border Crossing tunnel teleport, out of bounds teleport and 'killer ziplines')
- Fixed a crash caused by hands sometimes being invalid in the 'hand in wall' check.
- Fixed a crash that can sometimes occur when a heist starts after the black intro screen.
- Added a check to prevent throwing too many grenades, when using the VR belt, which could trip the game's anticheat.
- Fixed the event decorations, that are enabled at certain times of the year, not being implemented properly for the VR main menu. These can be disabled in the mod options.
### Improvements
- Unlocked all weapons that were 'VR Locked' as they are now all usable and reload correctly.
- Removed annoying grip points on the LMGs that make them hard to two-hand properly. They now only have 1 grip point.
- Added a small weapon fire delay when masking up from placing the mask directly on the head, to prevent accidentally firing the weapon at the same time.
- Added a mod option to change the melee damage cooldown to something that better resembles melee cooldowns in desktop mode.
- Added a small grace period after performing a melee kill that prevents the infiltrator/sociopath melee bonus from being lost when hitting a corpse in the same swing.

## Underbarrel weapons
Overkill had apparently tried to get underbarrel weapons working in VR in Update 207.

You can toggle underbarrel modes by using the "fire mode" binding, but it can sometimes conflict with the regular fire mode. I'd recommend putting on a forced single/auto fire weapon mod to avoid this.

Additionally, underbarrel modes can only be toggled while you're not "aiming down sights" (weapon held at eye level and looking straight).

This mod implements reload timelines for underbarrel modes so they have proper reload animations and sounds, instead of sharing the same reload as the standard fire mode.

## Installation
Only needs [SuperBLT](https://superblt.znix.xyz/) and PAYDAY 2 VR.

Drop into BLT mods folder (PAYDAY 2/mods).
