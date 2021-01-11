# XiconBGTargets TBC Addon

### [v1.3-Beta Download Here](https://github.com/XiconQoo/XiconBGTargets/releases/download/v1.3-Beta/XiconBGTargets_v1.3-Beta.zip)

### [Dependant on Compatibility Addon](https://github.com/raethkcj/Compatibility)

This addon shows all available enemy units within a BG (except AV).
You can move the frame by right clicking on the text above the frames.

## Screenshot

![Screenshot](../readme-media/sample.jpg)

### Changes

v1.3-Beta
- localized classnames
- dependency Compatibility addon added
- DebuffModule updated

v1.2-Beta
- SoHighPlates revert to nameplate.oldname:GetText() (more reliant)
- add framePool array to reuse icon frames (less memory usage)
- improve hideIcons (icon's OnUpdate on elapsed timer will recycle itself to framePool)
- shown icons will be reused and timer will be updated (no new icons for active spells)
- add synchronization between players (also syncs data from CCTracker)
- handle spells from synchronization by spellID to overcome localization
- cooldown text color updated properly
- SPELL_AURA_REMOVED handled separately (sometimes destFlag and srcFlag are different)

v1.1-Beta
- show flag carrier icon WSG EYE

v1.0-Beta

- show targets and make them clickable to target said unit
- highlight current target (or mouseover)
- show healer icon on enemies (estimate, not 100% accurate... looks for dmg < heal)
- show CC applied left to enemy frame

### TODO

- config menu
- estimate unit in range
- show alive or death
- localization french