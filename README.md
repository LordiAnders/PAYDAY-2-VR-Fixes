# PAYDAY-2-VR-Fixes
Bunch of fixes for the mostly neglected VR version of PAYDAY 2.

## Fixes
- Added proper reload timelines (animations and sounds) for all weapons that were missing them or had broken timelines.
- Improved reload timelines on some weapons that had little animation or to reduce clipping.
- Fixed many weapons lacking reload sounds.
- Adjusted many weapon offsets so they sit better in the hand.
- Fixed several two-hand grip points that were poorly positioned or used the wrong hand animation.
- Fixed several magazines being held incorrectly.
- Fixed Airbow and SG Versteckt 51D not displaying held magazines properly.
- Fixed SG Versteckt 51D, Hailstorm Mk 5 and Basilisk 3V exclusive set not playing their intended effects when reloading.
- Fixed MA-17 Flamethrower playing recoil animations when it shouldn't.
- Fixed reload timer and belt not accounting for weapons in underbarrel modes.
- Fixed akimbo weapons playing empty magazine sounds/animations before they are completely empty.
- Fixed weapon skins not applying correctly to held/dropped magazines.
- Removed hitpoint variable from the Tactical Flashlight melee that made it difficult to hit enemies.
- The game no longer automatically attempts to do a weapon butt melee attack when turning.
- Fixed the Counterstrike skill not working with VR melee.
- Fixed the Stockholm Syndrome skill not working. Pressing teleport/sprint in custody now activates it.
- Fixed a crash caused by hands sometimes being invalid in the 'hand in wall' check.
- (Possibly?) Fixed a crash that can sometimes occur when a heist starts related to 'playerhandstateweapon'.
## Improvements
- Unlocked all weapons that were 'VR Locked' as they are now all usable and reload correctly.
- Weapons with underbarrel modes now support reload timelines so they can be reloaded correctly.
- Held and dropped magazines that have bullets in them are now affected by your current ammo count.
- Removed annoying grip points on the LMGs that make them hard to two-hand properly, they now only have 1 grip point.

## Underbarrel weapons
Overkill had apparently tried to get underbarrel weapons working in VR.

As of U240.2 you can toggle underbarrel modes by using the "fire mode" binding, but it can sometimes conflict with the regular fire mode. I'd recommend putting on a forced single/auto fire weapon mod to avoid this.

Additionally, underbarrel modes can only be toggled while you're not "aiming down sights" (weapon held at eye level and looking straight).

## Installation
Drop into BLT mods folder (PAYDAY 2/mods).