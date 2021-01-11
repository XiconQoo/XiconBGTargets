local ADDON_NAME = "XiconBGTargets"
local select, tonumber, tostring = select, tonumber, tostring
local XiconBGTargetsDB_local
local L = XiconBGTargetsLocals


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
local testMode
local isInBattleground = false
local XiconDebuffLib_BG
local localizedClassNames = {}
localizedClassNames["male"] = {}
localizedClassNames["female"] = {}

local function getIconCoords (x, y) -- MONK 2,0
    local b = 1/256;
    return {b * x * 64, b * (x * 64 + 64), b * y * 64, b * (y * 64 + 64)};
end

function XiconBGTargets:Test(value) -- /run XiconBGTargets:Test(true)
    testMode = value
    isInBattleground = value
    if value then
        XiconDebuffLib_BG:addOrRefreshDebuff("Noxilia", "0x000123", 22570, 18) -- maim
        XiconDebuffLib_BG:addOrRefreshDebuff("Noxilia", "0x000123", 14309, 12) -- freezing trap
        XiconDebuffLib_BG:addOrRefreshDebuff("Noxilia", "0x000123", 12826, 5) -- polymorph
        XiconDebuffLib_BG:addOrRefreshDebuff("Noxmo", "0x000123", 22570, 18) -- maim
        XiconDebuffLib_BG:addOrRefreshDebuff("Noxmo", "0x000123", 14309, 12) -- freezing trap
        XiconDebuffLib_BG:addOrRefreshDebuff("Noxmo", "0x000123", 12826, 5) -- polymorph
        XiconDebuffLib_BG:addOrRefreshDebuff("Teebee", "0x000123", 19503, 20) -- scatter shot
        XiconDebuffLib_BG:addOrRefreshDebuff("Teebee", "0x000123", 22570, 15) -- maim
        XiconDebuffLib_BG:addOrRefreshDebuff("Teebee", "0x000123", 14309, 12) -- freezing trap
        XiconDebuffLib_BG:addOrRefreshDebuff("Teebee", "0x000123", 12826, 5) -- polymorph
        XiconDebuffLib_BG:addOrRefreshDebuff("Knall", "0x000123", 33786) -- cyclone
        XiconDebuffLib_BG:addOrRefreshDebuff("Knall", "0x000123", 8983) -- bash
        XiconDebuffLib_BG:addOrRefreshDebuff("Timber Worg", "0x000123", 19386) -- wyvern sting
    end
end

local function createUnitFrames()
    -- draggable masterframe
    local EnemyUnits = CreateFrame("Frame", nil, UIParent)
    EnemyUnits:SetMovable(true)
    EnemyUnits:EnableMouse(true)
    EnemyUnits:RegisterForDrag("RightButton")
    EnemyUnits:SetScript("OnDragStart", EnemyUnits.StartMoving)
    EnemyUnits:SetScript("OnDragStop", EnemyUnits.StopMovingOrSizing)
    EnemyUnits:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    EnemyUnits:SetWidth(140)
    EnemyUnits:SetHeight(15)
    EnemyUnits:SetScale(1)
    EnemyUnits:Hide()
    EnemyUnits.title = EnemyUnits:CreateFontString(EnemyUnits, "OVERLAY", "GameFontNormalSmall")
    EnemyUnits.title:SetPoint("TOP", 0, 8)
    EnemyUnits.title:SetText("XiconBGTarget\n(right click to move)")

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

        ---healIcon
        unit.heal = unit:CreateTexture(nil, "OVERLAY")
        unit.heal:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\gfx\\healers_icons")
        unit.heal:SetSize(23, 23)
        unit.heal:SetPoint("RIGHT", unit, "LEFT", -2, 0)
        unit.heal:SetTexCoord(unpack(getIconCoords(2,0)))
        unit.heal:Show()

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
        if not XiconBGTargetsDB_local["point"] or XiconBGTargetsDB_local["point"] ~= "RIGHT" then XiconBGTargetsDB_local["point"] = "RIGHT" end
        if not XiconBGTargetsDB_local["relativePoint"] or XiconBGTargetsDB_local["relativePoint"] ~= "LEFT" then XiconBGTargetsDB_local["relativePoint"] = "LEFT" end
        if not XiconBGTargetsDB_local["xOffset"] or XiconBGTargetsDB_local["xOffset"] ~= -2 then XiconBGTargetsDB_local["xOffset"] = -2 end
        if not XiconBGTargetsDB_local["yOffset"] or XiconBGTargetsDB_local["yOffset"] ~= 0 then XiconBGTargetsDB_local["yOffset"] = 0 end
        if not XiconBGTargetsDB_local["iconSize"] or XiconBGTargetsDB_local["iconSize"] ~= 25 then XiconBGTargetsDB_local["iconSize"] = 25 end
        if not XiconBGTargetsDB_local["fontSize"] or XiconBGTargetsDB_local["fontSize"] ~= 10 then XiconBGTargetsDB_local["fontSize"] = 10 end
        if not XiconBGTargetsDB_local["font"] or XiconBGTargetsDB_local["font"] ~= "Fonts\\ARIALN.ttf" then XiconBGTargetsDB_local["font"] = "Fonts\\ARIALN.ttf" end
        if XiconBGTargetsDB_local["responsive"] == nil or XiconBGTargetsDB_local["responsive"] then XiconBGTargetsDB_local["responsive"] = false end
        if not XiconBGTargetsDB_local["sorting"] or XiconBGTargetsDB_local["sorting"] ~= 'descending' then XiconBGTargetsDB_local["sorting"] = 'descending' end
        if not XiconBGTargetsDB_local["alpha"] or XiconBGTargetsDB_local["alpha"] ~= 0.9 then XiconBGTargetsDB_local["alpha"] = 0.9 end

        XiconDebuffLib_BG = GetXiconBGDebuffModule()
        print("Loaded")
        XiconDebuffLib_BG:Init(XiconBGTargetsDB_local)
        createUnitFrames()

        -- get localized classnames from Compatibility
        FillLocalizedClassList(localizedClassNames["male"], false)
        FillLocalizedClassList(localizedClassNames["female"], true)
        for k,v in pairs(localizedClassNames["male"]) do
            localizedClassNames[v] = k
        end
        for k,v in pairs(localizedClassNames["female"]) do
            localizedClassNames[v] = k
        end
        XiconBGTargets:UnregisterEvent("ADDON_LOADED")
    end
end

local flagCarrier
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
    -- WSG, pick up
    if( string.match(msg, L["was picked up by (.+)!"]) ) then
        if faction ~= factionGrp then
            flagCarrier = string.match(msg, L["was picked up by (.+)!"])
        end
    -- EoTS, pick up
    elseif( string.match(msg, L["(.+) has taken the flag!"]) ) then
        if faction ~= factionGrp then
            flagCarrier = string.match(msg, L["(.+) has taken the flag!"])
        end
    -- WSG, returned
    elseif( string.match(msg, L["was returned to its base"]) ) then
        if faction ~= factionGrp then
            flagCarrier = nil
        end
    -- EOTS, returned
    elseif( string.match(msg, L["flag has been reset"]) ) then
        if faction ~= factionGrp then
            flagCarrier = nil
        end
    -- WSG/EoTS, captured
    elseif( string.match(msg, L["captured the"]) ) then
        if faction ~= factionGrp then
            flagCarrier = nil
        end
    -- EoTS/WSG, dropped
    elseif( string.match(msg, L["was dropped by (.+)!"]) or string.match(msg, L["The flag has been dropped"]) ) then
        if faction ~= factionGrp then
            flagCarrier = nil
        end
    end
end

function events:CHAT_MSG_BG_SYSTEM_ALLIANCE(msg)
    parseFlagEvent(msg, "Alliance")
end

function events:CHAT_MSG_BG_SYSTEM_HORDE(msg)
    parseFlagEvent(msg, "Horde")
end


function events:PLAYER_ENTERING_WORLD()
    local instance = select(2, IsInInstance())
    factionGrp = UnitFactionGroup("player")
    if (instance == "pvp") then
        isInBattleground = true
        XiconBGTargets.EnemyUnits:Show()
        --load addon
    else
        isInBattleground = false
        -- hide frames
        XiconBGTargets.EnemyUnits:Hide()
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

local updateInterval, lastUpdate = 0.1, 0
XiconBGTargets:SetScript("OnUpdate", function(_, elapsed)
    lastUpdate = lastUpdate + elapsed
    if lastUpdate > updateInterval then
        -- do stuff
        --isInBattleground = true --select(2, IsInInstance()) == "pvp"
        if isInBattleground then
            local status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch
            for i=1, MAX_BATTLEFIELD_QUEUES do
                status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch = GetBattlefieldStatus(i);
                if (status == "active") then
                    XiconBGTargets.activeBF = mapName
                    break
                end
            end
            if (status == "active" and mapName ~= "Alterac Valley") or testMode then
                XiconBGTargets.EnemyUnits:Show()
                local opposingFaction = {}
                local j = 1
                for i=1, GetNumBattlefieldScores() do
                    local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i);
                    if ( faction and name and class ) then
                        if ( factionGrp == "Alliance" and faction == 0 ) then
                            opposingFaction[j] = {name = name, class = localizedClassNames[class], killingBlows = killingBlows, honorableKills = honorableKills, deaths = deaths, honorGained = honorGained, rank = rank, damageDone = damageDone, healingDone = healingDone}
                            j = j + 1
                        elseif ( factionGrp == "Horde" and faction == 1 ) then
                            opposingFaction[j] = {name = name, class = localizedClassNames[class], killingBlows = killingBlows, honorableKills = honorableKills, deaths = deaths, honorGained = honorGained, rank = rank, damageDone = damageDone, healingDone = healingDone}
                            j = j + 1
                        end
                    end
                end
                if testMode then
                    opposingFaction[1] = {name = "Noxilia", class = "Druid", killingBlows = 0, honorableKills = 0, deaths = 0, honorGained = 0, rank = 0, damageDone = 1, healingDone = 0}
                    opposingFaction[2] = {name = "Noxmo", class = "Priest", killingBlows = 0, honorableKills = 0, deaths = 0, honorGained = 0, rank = 0, damageDone = 0, healingDone = 1}
                    opposingFaction[3] = {name = "Teebee", class = "Rogue", killingBlows = 0, honorableKills = 0, deaths = 0, honorGained = 0, rank = 0, damageDone = 1, healingDone = 0}
                    opposingFaction[4] = {name = "Knall", class = "Warlock", killingBlows = 0, honorableKills = 0, deaths = 0, honorGained = 0, rank = 0, damageDone = 1, healingDone = 0}
                    opposingFaction[5] = {name = "Timber Worg", class = "Mage", killingBlows = 0, honorableKills = 0, deaths = 0, honorGained = 0, rank = 0, damageDone = 1, healingDone = 0}
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
                    if flagCarrier and flagCarrier == opposingFaction[i].name then
                        XiconBGTargets.EnemyUnits.unitFrames[i].flag:Show()
                    else
                        XiconBGTargets.EnemyUnits.unitFrames[i].flag:Hide()
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
