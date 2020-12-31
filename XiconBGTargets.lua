local ADDON_NAME = "XiconBGTargets"
local select, tonumber, tostring = select, tonumber, tostring
local XiconBGTargetsDB_local
local L = XiconBGTargetsLocals

--local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
--local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_REACTION_NEUTRAL = COMBATLOG_OBJECT_REACTION_NEUTRAL


local print = function(s)
    local str = s
    if s == nil then str = "" end
    DEFAULT_CHAT_FRAME:AddMessage("|cffa0f6aa[".. ADDON_NAME .."]|r: " .. str)
end

---------------------------------------------------------------------------------------------

-- FRAME SETUP

---------------------------------------------------------------------------------------------

XiconBGTargets = CreateFrame("Frame", ADDON_NAME, UIParent)
XiconBGTargets:EnableMouse(false)
XiconBGTargets:SetWidth(1)
XiconBGTargets:SetHeight(1)
XiconBGTargets:SetAlpha(0)

local factionGrp
local FlagIcon
local HealerIcon = {"Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\healers_icons", -1, 0}
local testMode

local function getIconCoords (x, y) -- MONK 2,0
    local b = 1/256;
    return {b * x * 64, b * (x * 64 + 64), b * y * 64, b * (y * 64 + 64)};
end

function XiconBGTargets:Test(value)
    testMode = value
    XiconDebuffLib_BG:addDebuff("Timber Worg", "0x000123", 29166, GetSpellInfo(29166)) -- innervate
    XiconDebuffLib_BG:addDebuff("Timber Worg", "0x000123", 22570, GetSpellInfo(22570)) -- maim
    XiconDebuffLib_BG:addDebuff("Timber Worg", "0x000123", 14309, GetSpellInfo(14309)) -- freezing trap
    XiconDebuffLib_BG:addDebuff("Timber Worg", "0x000123", 12826, GetSpellInfo(12826)) -- polymorph
end

local function createUnitFrames()
    -- draggable masterframe
    local EnemyUnits = CreateFrame("Frame", nil, UIParent)
    EnemyUnits:SetMovable(true)
    EnemyUnits:EnableMouse(true)
    EnemyUnits:RegisterForDrag("RightButton")
    EnemyUnits:SetScript("OnDragStart", EnemyUnits.StartMoving)
    EnemyUnits:SetScript("OnDragStop", EnemyUnits.StopMovingOrSizing)
    EnemyUnits:SetPoint("CENTER")
    EnemyUnits:SetWidth(80)
    EnemyUnits:SetHeight(15)
    EnemyUnits:SetScale(1)
    EnemyUnits:Hide()
    local title = EnemyUnits:CreateFontString(EnemyUnits, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOP", 0, -2)
    title:SetText("EnemyFrames")
    EnemyUnits.title = title

    local frames = {}
    -- unit frames
    factionGrp = UnitFactionGroup("player")
    if UnitFactionGroup("player") == "Alliance" then
        factionGrp = "Alliance"
        FlagIcon = "Interface\\Icons\\INV_BannerPVP_02"
    else
        factionGrp = "Horde"
        FlagIcon = "Interface\\Icons\\INV_BannerPVP_01"
    end


    for i=1, 15 do -- max 15 in BG
        local yoffset = (i - 1) * -26 - 18
        local xoffset = 0
        local unit = CreateFrame("Button", "XiconBGUnit" .. i, EnemyUnits, "SecureActionButtonTemplate")
        unit:SetPoint("TOPLEFT", EnemyUnits, "TOPLEFT", xoffset, yoffset)
        unit:SetHeight(25)
        unit:SetWidth(140)
        unit:SetBackdrop( {
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tile = false, tileSize = 32,
        })
        unit:SetBackdropColor(0,0,0,1)

        ---macro
        unit:SetAttribute("type", "macro") -- left click causes macro
        if i == 1 then
            unit:SetAttribute("macrotext", "/targetexact Timber Worg") --for testing
        end

        ---flag
        unit.flag = unit:CreateTexture(nil, "OVERLAY")
        unit.flag:SetTexture(FlagIcon)
        unit.flag:SetSize(24, 24)
        unit.flag:SetPoint("LEFT", unit, "RIGHT", 0, 0)
        unit.flag:Hide()

        ---healIcon
        unit.heal = unit:CreateTexture(nil, "OVERLAY")
        unit.heal:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\healers_icons")
        unit.heal:SetSize(24, 24)
        unit.heal:SetPoint("RIGHT", unit, "LEFT", 0, 0)
        unit.heal:SetTexCoord(unpack(getIconCoords(2,0)))
        unit.heal:Show()

        ---highlight
        function unit:Update()
            if self.hasAttention or self.highlight.hasMouseover then
                self.highlight:Show()
            else
                self.highlight:Hide()
            end
        end
        unit:SetScript("OnEnter", function(self)
            self.highlight.hasMouseover = true
            self:Update()
        end)
        unit:SetScript("OnLeave", function(self)
            self.highlight.hasMouseover = nil
            self:Update()
        end)

        unit:RegisterEvent("PLAYER_TARGET_CHANGED")
        local function eventHandler(self, event, ...)
            self.hasAttention = self.healthBar.nameText:GetText() == UnitName("target")
            self:Update()
        end
        unit:SetScript("OnEvent", eventHandler)

        unit.highlight = CreateFrame("Frame", nil, unit)
        unit.highlight:SetFrameLevel(5)
        unit.highlight:SetAllPoints(unit)
        unit.highlight:SetHeight(1)
        unit.highlight:SetWidth(1)

        unit.highlight.top = unit.highlight:CreateTexture(nil, "OVERLAY")
        unit.highlight.top:SetBlendMode("ADD")
        unit.highlight.top:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\highlight")
        unit.highlight.top:SetPoint("TOPLEFT", unit, 0, 0)
        unit.highlight.top:SetPoint("TOPRIGHT", unit, 0, 0)
        unit.highlight.top:SetHeight(30)
        unit.highlight.top:SetTexCoord(0.3125, 0.625, 0, 0.3125)

        unit.highlight.left = unit.highlight:CreateTexture(nil, "OVERLAY")
        unit.highlight.left:SetBlendMode("ADD")
        unit.highlight.left:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\highlight")
        unit.highlight.left:SetPoint("TOPLEFT", unit, 0, 0)
        unit.highlight.left:SetPoint("BOTTOMLEFT", unit, 0, 0)
        unit.highlight.left:SetWidth(30)
        unit.highlight.left:SetTexCoord(0, 0.3125, 0.3125, 0.625)

        unit.highlight.right = unit.highlight:CreateTexture(nil, "OVERLAY")
        unit.highlight.right:SetBlendMode("ADD")
        unit.highlight.right:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\highlight")
        unit.highlight.right:SetPoint("TOPRIGHT", unit, 0, 0)
        unit.highlight.right:SetPoint("BOTTOMRIGHT", unit, 0, 0)
        unit.highlight.right:SetWidth(30)
        unit.highlight.right:SetTexCoord(0.625, 0.93, 0.3125, 0.625)

        unit.highlight.bottom = unit.highlight:CreateTexture(nil, "OVERLAY")
        unit.highlight.bottom:SetBlendMode("ADD")
        unit.highlight.bottom:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\highlight")
        unit.highlight.bottom:SetPoint("BOTTOMLEFT", unit, 0, 0)
        unit.highlight.bottom:SetPoint("BOTTOMRIGHT", unit, 0, 0)
        unit.highlight.bottom:SetHeight(30)
        unit.highlight.bottom:SetTexCoord(0.3125, 0.625, 0.625, 0.93)
        unit.highlight:Hide()

        unit.highlight.top:SetHeight(10)
        unit.highlight.bottom:SetHeight(10)
        unit.highlight.left:SetWidth(10)
        unit.highlight.right:SetWidth(10)

        --- HP bar
        local healthBar = CreateFrame("StatusBar", nil, unit)
        healthBar:SetStatusBarTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\Minimalist")
        healthBar:SetMinMaxValues(0, 100)
        healthBar:SetValue(100)
        healthBar:SetHeight(23)
        healthBar:SetWidth(137)
        healthBar:SetStatusBarColor(0, 1, 0)
        healthBar:SetPoint("TOP", unit, "TOP", 0, -1)

        healthBar.bg = healthBar:CreateTexture(nil, "BACKGROUND")
        healthBar.bg:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\Minimalist")
        healthBar.bg:ClearAllPoints()
        healthBar.bg:SetAllPoints(healthBar)
        healthBar.bg:SetAlpha(.3)

        healthBar.nameText = healthBar:CreateFontString(nil, "LOW")
        healthBar.nameText:SetFont("Fonts\\FRIZQT__.TTF", 12)
        healthBar.nameText:Show()
        --healthBar.nameText:SetTextColor(Gladdy.db.healthBarFontColor.r, Gladdy.db.healthBarFontColor.g, Gladdy.db.healthBarFontColor.b, Gladdy.db.healthBarFontColor.a)
        healthBar.nameText:SetShadowOffset(1, -1)
        healthBar.nameText:SetShadowColor(0, 0, 0, 1)
        healthBar.nameText:SetJustifyH("CENTER")
        healthBar.nameText:SetPoint("LEFT", 5, 0)
        healthBar.nameText:SetText("Player")
        if i == 1 then
            healthBar.nameText:SetText("Timber Worg")
        end

        healthBar.healthText = healthBar:CreateFontString(nil, "LOW")
        healthBar.healthText:SetFont("Fonts\\FRIZQT__.TTF", 12)
        healthBar.healthText:Hide()
        --healthBar.healthText:SetTextColor(Gladdy.db.healthBarFontColor.r, Gladdy.db.healthBarFontColor.g, Gladdy.db.healthBarFontColor.b, Gladdy.db.healthBarFontColor.a)
        healthBar.healthText:SetShadowOffset(1, -1)
        healthBar.healthText:SetShadowColor(0, 0, 0, 1)
        healthBar.healthText:SetJustifyH("CENTER")
        healthBar.healthText:SetPoint("RIGHT", -5, 0)

        unit.healthBar = healthBar

        frames[i] = unit
        unit:Show()
    end
    EnemyUnits.unitFrames = frames
    XiconBGTargets.EnemyUnits = EnemyUnits
    XiconBGTargets.EnemyUnits:Show()
end

---------------------------------------------------------------------------------------------

-- EVENT HANDLERS

---------------------------------------------------------------------------------------------

local events = {} -- store event functions to be assigned to reputation frame

function events:ADDON_LOADED(...)
    if select(1, ...) == ADDON_NAME then
        XiconBGTargetsDB_local = XiconBGTargetsDB
        if not XiconBGTargetsDB_local then
            XiconBGTargetsDB_local = {}

        end
        print("Loaded")
        XiconDebuffLib_BG:Init(nil)
        createUnitFrames()
        XiconBGTargets:UnregisterEvent("ADDON_LOADED")
    end
end

function events:COMBAT_LOG_EVENT_UNFILTERED(...)
    local _, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType, stackCount = select(1, ...)
    local isEnemy = bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) == COMBATLOG_OBJECT_REACTION_NEUTRAL or bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE

end

function events:PLAYER_FOCUS_CHANGED()

end

function events:UPDATE_MOUSEOVER_UNIT()

end

local function parseFlagEvent(msg, faction)

    if( XiconBGTargets.activeBF == "Warsong Gulch" ) then
        -- Reverse the factions because Alliance found = Horde event
        -- Horde found = Alliance event
        if( string.match(msg, L["Alliance"]) ) then
            faction = "Horde"
        elseif( string.match(msg, L["Horde"]) ) then
            faction = "Alliance"
        end
    end

    local flagCarrier
    -- WSG, pick up
    if( string.match(msg, L["was picked up by (.+)!"]) ) then
        flagCarrier = string.match(msg, L["was picked up by (.+)!"])

    -- EoTS, pick up
    elseif( string.match(msg, L["(.+) has taken the flag!"]) ) then
        flagCarrier = string.match(msg, L["(.+) has taken the flag!"])

    -- WSG, returned
    elseif( string.match(msg, L["was returned to its base"]) ) then


    -- EOTS, returned
    elseif( string.match(msg, L["flag has been reset"]) ) then


    -- WSG/EoTS, captured
    elseif( string.match(msg, L["captured the"]) ) then


    -- EoTS/WSG, dropped
    elseif( string.match(msg, L["was dropped by (.+)!"]) or string.match(msg, L["The flag has been dropped"]) ) then

    end
end

function events:CHAT_MSG_BG_SYSTEM_ALLIANCE(msg)
    parseFlagEvent(msg, "Alliance")
end

function events:CHAT_MSG_BG_SYSTEM_HORDE(msg)
    parseFlagEvent(msg, "Horde")
end

local isInBattleground = false
function events:PLAYER_ENTERING_WORLD()
    local instance = select(2, IsInInstance())
    if (instance == "pvp") then
        isInBattleground = true
        --load addon
    else
        isInBattleground = false
        -- hide frames
        -- wipe all data
    end
    --self.lastInstance = instance
end

function events:PLAYER_LOGOUT(...)
    XiconBGTargetsDB = XiconBGTargetsDB_local
end


---------------------------------------------------------------------------------------------

-- REGISTER EVENTS

---------------------------------------------------------------------------------------------

XiconBGTargets:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
end);
for k, _ in pairs(events) do
    XiconBGTargets:RegisterEvent(k); -- Register all events for which handlers have been defined
end

---------------------------------------------------------------------------------------------

-- ON_UPDATE (periodically update nameplates)

---------------------------------------------------------------------------------------------
---
local updateInterval, lastUpdate = 0.1, 0
XiconBGTargets:SetScript("OnUpdate", function(_, elapsed)
    lastUpdate = lastUpdate + elapsed
    if lastUpdate > updateInterval then
        -- do stuff
        factionGrp = UnitFactionGroup("player")
        isInBattleground = true --select(2, IsInInstance()) == "pvp"
        if isInBattleground then
            local status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch
            for i=1, MAX_BATTLEFIELD_QUEUES do
                status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch = GetBattlefieldStatus(i);
                if (status == "active") then
                    XiconBGTargets.activeBF = mapName
                    break
                end
            end
            if status == "active" and mapName ~= "Alterac Valley" or testMode then
                XiconBGTargets.EnemyUnits:Show()
                local opposingFaction = {}
                local opposingFaction = {}
                local j = 1
                for i=1, GetNumBattlefieldScores() do
                    local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i);
                    if ( faction and name and class ) then
                        if ( factionGrp == "Alliance" and faction == 0 ) then
                            opposingFaction[j] = {name = name, class = class, killingBlows = killingBlows, honorableKills = honorableKills, deaths = deaths, honorGained = honorGained, rank = rank, damageDone = damageDone, healingDone = healingDone}
                            j = j + 1
                        elseif ( factionGrp == "Horde" and faction == 1 ) then
                            opposingFaction[j] = {i, name, class}
                            j = j + 1
                        end
                    end
                end
                if testMode then
                    opposingFaction[j] = {name = "Timber Worg", class = "Warrior", killingBlows = 0, honorableKills = 0, deaths = 0, honorGained = 0, rank = 0, damageDone = 1, healingDone = 0}
                end
                table.sort(opposingFaction, function(a,b) -- sort by class and name
                    local class = a.class:upper() < b.class:upper()
                    local classEqual = a.class:upper() == b.class:upper()
                    local name = a.name:upper() < b.name:upper()
                    if classEqual then
                        return name
                    end
                    return class
                end)
                if #opposingFaction < #XiconBGTargets.EnemyUnits.unitFrames then
                    for i=#opposingFaction + 1, #XiconBGTargets.EnemyUnits.unitFrames do
                        XiconBGTargets.EnemyUnits.unitFrames[i]:Hide()
                    end
                end

                for i=1, #opposingFaction do
                    local classcolor = RAID_CLASS_COLORS[string.upper(opposingFaction[i].class)]
                    if (tonumber(opposingFaction[i].healingDone) > tonumber(opposingFaction[i].damageDone)) then -- is healer
                        XiconBGTargets.EnemyUnits.unitFrames[i].heal:Show()
                    else
                        XiconBGTargets.EnemyUnits.unitFrames[i].heal:Hide()
                    end
                    XiconBGTargets.EnemyUnits.unitFrames[i].healthBar.nameText:SetText(opposingFaction[i].name)
                    XiconBGTargets.EnemyUnits.unitFrames[i].healthBar:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b)
                    XiconBGTargets.EnemyUnits.unitFrames[i]:SetAttribute("macrotext", "/targetexact " .. opposingFaction[i].name)
                    XiconBGTargets.EnemyUnits.unitFrames[i]:Show()
                    XiconDebuffLib_BG:assignDebuffs(opposingFaction[i].name, XiconBGTargets.EnemyUnits.unitFrames[i], false)
                end
            end
        else
            for i=1, #XiconBGTargets.EnemyUnits.unitFrames do
                XiconBGTargets.EnemyUnits.unitFrames[i]:Hide()
            end
            XiconBGTargets.EnemyUnits:Hide()
        end
        -- end do stuff
        lastUpdate = 0;
    end
end)
