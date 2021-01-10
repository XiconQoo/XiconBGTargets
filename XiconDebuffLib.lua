local LIB_NAME = "XiconDebuffLib_BG"
local trackedUnitNames = {}
local framePool = {}
local trackedCC = initTrackedCrowdControl()
local XiconDebuffSV_local
local select, tonumber, ceil = select, tonumber, ceil

local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_REACTION_NEUTRAL = COMBATLOG_OBJECT_REACTION_NEUTRAL

local print = function(s)
    local str = s
    if s == nil then str = "" end
    DEFAULT_CHAT_FRAME:AddMessage("|cffa0f6aa[".. LIB_NAME .."]|r: " .. str)
end

---------------------------------------------------------------------------------------------

-- FRAME SETUP FOR REGISTER EVENTS

---------------------------------------------------------------------------------------------

XiconDebuffLib_BG = CreateFrame("Frame", "XiconDebuffsLib", UIParent)
XiconDebuffLib_BG:EnableMouse(false)
XiconDebuffLib_BG:SetWidth(1)
XiconDebuffLib_BG:SetHeight(1)
XiconDebuffLib_BG:SetAlpha(0)

---------------------------------------------------------------------------------------------

-- REGISTER MODULE

---------------------------------------------------------------------------------------------

function XiconDebuffLib_BG:Init(savedVariables)
    XiconDebuffSV_local = savedVariables
    if not XiconDebuffSV_local then
        XiconDebuffSV_local = {}
        XiconDebuffSV_local["iconSize"] = 25
        XiconDebuffSV_local["yOffset"] = 0
        XiconDebuffSV_local["xOffset"] = -2
        XiconDebuffSV_local["fontSize"] = 10
        XiconDebuffSV_local["font"] = "Fonts\\ARIALN.ttf"
        XiconDebuffSV_local["responsive"] = false
        XiconDebuffSV_local["sorting"] = 'descending'
        XiconDebuffSV_local["alpha"] = 0.9
    end
    print("initialized")
end

function XiconDebuffLib_BG:UpdateSavedVariables(savedVariables)
    XiconDebuffSV_local = savedVariables
end

function XiconDebuffLib_BG:GetTrackedUnitNames()
    return trackedUnitNames
end

---------------------------------------------------------------------------------------------

-- TABLE & MATH FUNCTIONS

---------------------------------------------------------------------------------------------

function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

local function formatTimer(num, numDecimalPlaces)
    return string.format("%." .. (numDecimalPlaces or 0) .. "f", num)
end

local function round(num, numDecimalPlaces)
    return tonumber(formatTimer(num, numDecimalPlaces))
end

local function splitName(str)
    local name = string.match(str , "(.+)0x.+")
    local guid = string.match(str , ".+(0x.+)")
    return {name, guid}
end

---------------------------------------------------------------------------------------------

-- TARGETING FUNCTIONS

---------------------------------------------------------------------------------------------

local function isValidTarget(unit)
    return UnitCanAttack("player", unit) == 1 and not UnitIsDeadOrGhost(unit)
end

local function getUnitTargetedByMe(unitGUID)
    if UnitGUID("target") == unitGUID then return "target" end
    if UnitGUID("focus") == unitGUID then return "focus" end
    if UnitGUID("mouseover") == unitGUID then return "mouseover" end
    return nil
end

---------------------------------------------------------------------------------------------

-- DEBUFF FUNCTIONS

---------------------------------------------------------------------------------------------

local function calcEndTime(timeLeft) return GetTime() + timeLeft end

local function removeDebuff(destName, destGUID, spellID)
    if trackedUnitNames[destName..destGUID] then
        for i = 1, #trackedUnitNames[destName..destGUID] do
            if trackedUnitNames[destName..destGUID][i] then
                if trackedUnitNames[destName..destGUID][i].spellID == spellID then
                    trackedUnitNames[destName..destGUID][i]:SetParent(nil)
                    trackedUnitNames[destName..destGUID][i]:SetAlpha(0)
                    trackedUnitNames[destName..destGUID][i]:SetScript("OnUpdate", nil)
                    --trackedUnitNames[destName..destGUID][i].cooldowncircle:SetCooldown(0,0)
                    framePool[#framePool + 1] = tremove(trackedUnitNames[destName..destGUID], i)
                    if #trackedUnitNames[destName..destGUID] == 0 then
                        trackedUnitNames[destName..destGUID] = nil
                    end
                end
            end
        end
                end
            end

function XiconDebuffLib_BG:addOrRefreshDebuff(destName, destGUID, spellID, timeLeft)
    destName = string.gsub(destName, "%s+", "")
    local spellName = GetSpellInfo(spellID)
    if not trackedUnitNames[destName..destGUID] then trackedUnitNames[destName..destGUID] = {} end
    local found
    for i = 1, #trackedUnitNames[destName..destGUID] do
        if trackedUnitNames[destName..destGUID][i] and trackedUnitNames[destName..destGUID][i].spellID == spellID then
            --trackedUnitNames[destName..destGUID][i].cooldowncircle:SetCooldown(GetTime(), timeLeft or trackedCC[spellName].duration)
            trackedUnitNames[destName..destGUID][i].endtime = calcEndTime(timeLeft or trackedCC[spellName].duration)
            found = true
            break
        end
    end
    if not found then
        XiconDebuffLib_BG:addDebuff(destName, destGUID, spellID, spellName, timeLeft)
    end
end

function XiconDebuffLib_BG:addDebuff(destName, destGUID, spellID, spellName, timeLeft)
    if trackedUnitNames[destName..destGUID] == nil then
        trackedUnitNames[destName..destGUID] = {}
    end
    local _, _, texture = GetSpellInfo(spellID)
    local duration = trackedCC[spellName].duration
    local icon
    if #framePool > 0 then
        icon = tremove(framePool, 1)
    else
        icon = CreateFrame("frame", nil, nil)
    icon.texture = icon:CreateTexture(nil, "BORDER")
        icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
    end

    icon:SetAlpha(XiconDebuffSV_local["alpha"])
    icon.texture:SetAllPoints(icon)
    icon.texture:SetTexture(texture)

    icon.cooldown:SetAlpha(XiconDebuffSV_local["alpha"])
    icon.cooldown:SetFont(XiconDebuffSV_local["font"], XiconDebuffSV_local["fontSize"], "OUTLINE")
    icon.cooldown:SetAllPoints(icon)

    --icon.cooldowncircle = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
    --icon.cooldowncircle.noCooldownCount = true -- disable OmniCC
    --icon.cooldowncircle:SetAllPoints()
    --icon.cooldowncircle:SetCooldown(GetTime(), timeLeft or duration)

    icon.endtime = calcEndTime(timeLeft or duration)
    icon.spellName = spellName
    icon.spellID = spellID
    icon.destGUID = destGUID
    icon.destName = destName

    local iconTimer = function(iconFrame, elapsed)

        local itimer = ceil(iconFrame.endtime - GetTime()) -- cooldown duration
        local milliTimer = round(iconFrame.endtime - GetTime(), 1)
        iconFrame.timeLeft = milliTimer
        if itimer >= 60 then
            iconFrame.cooldown:SetText(itimer)
            icon.cooldown:SetTextColor(0.7, 1, 0)
            if itimer < 60 and itimer >= 90 then
                iconFrame.cooldown:SetText("2m")
            else
                iconFrame.cooldown:SetText(ceil(itimer / 60) .. "m") -- X minutes
            end
        elseif itimer < 60 and itimer >= 11 then
            --if it's less than 60s
            iconFrame.cooldown:SetText(itimer)
            icon.cooldown:SetTextColor(0.7, 1, 0)
        elseif itimer <= 10 and itimer >= 5 then
            iconFrame.cooldown:SetTextColor(1, 0.7, 0)
            iconFrame.cooldown:SetText(itimer)
        elseif itimer <= 4 and itimer >= 3 then
            iconFrame.cooldown:SetTextColor(1, 0, 0)
            iconFrame.cooldown:SetText(itimer)
        elseif milliTimer <= 3 and milliTimer > 0 then
            iconFrame.cooldown:SetTextColor(1, 0, 0)
            iconFrame.cooldown:SetText(formatTimer(milliTimer, 1))
        elseif milliTimer <= 0 and milliTimer > -0.05 then -- 50ms ping max wait for SPELL_AURA_REMOVED event
            iconFrame.cooldown:SetText("")
        else -- fallback in case SPELL_AURA_REMOVED is not fired
            removeDebuff(iconFrame.destName, iconFrame.destGUID, iconFrame.spellID)
        end
    end

    if trackedUnitNames[destName..destGUID] == nil then trackedUnitNames[destName..destGUID] = {} end
    tinsert(trackedUnitNames[destName..destGUID], icon)
    icon:SetScript("OnUpdate", iconTimer)
    --sorting
    if XiconDebuffSV_local["sorting"] == "none" then
        return
    end
    if XiconDebuffSV_local["sorting"] == "ascending" then
        table.sort(trackedUnitNames[destName..destGUID], function(iconA,iconB) return iconA.endtime < iconB.endtime end)
    elseif XiconDebuffSV_local["sorting"] == "descending" then
        table.sort(trackedUnitNames[destName..destGUID], function(iconA,iconB) return iconA.endtime > iconB.endtime end)
    end
end


local function addIcons(dstName, namePlate)
    local num = #trackedUnitNames[dstName]
    local size, fontSize, width
    if not width then
        width = namePlate:GetWidth()
    end
    if XiconDebuffSV_local["responsive"] and num * XiconDebuffSV_local["iconSize"] + (num * 2 - 2) > width then
        size = (width - (num * 2 - 2)) / num
        if XiconDebuffSV_local["fontSize"] < size/2 then
            fontSize = XiconDebuffSV_local["fontSize"]
        else
            fontSize = size / 2
        end
    else
        fontSize = XiconDebuffSV_local["fontSize"]
        size = XiconDebuffSV_local["iconSize"]
    end
    for i = 1, #trackedUnitNames[dstName] do
        trackedUnitNames[dstName][i]:ClearAllPoints()
        trackedUnitNames[dstName][i]:SetWidth(size)
        trackedUnitNames[dstName][i]:SetHeight(size)
        trackedUnitNames[dstName][i]:SetAlpha(XiconDebuffSV_local["alpha"])
        trackedUnitNames[dstName][i].cooldown:SetAlpha(XiconDebuffSV_local["alpha"])
        trackedUnitNames[dstName][i].cooldown:SetFont(XiconDebuffSV_local["font"], fontSize, "OUTLINE")
        if i == 1 then
            trackedUnitNames[dstName][i]:SetPoint("RIGHT", namePlate, "LEFT", XiconDebuffSV_local["xOffset"], XiconDebuffSV_local["yOffset"])
        else
            trackedUnitNames[dstName][i]:SetPoint("RIGHT", trackedUnitNames[dstName][i - 1], - size - 2, 0)
        end
    end
end

local function hideIcons(namePlate, dstName)
    if namePlate then -- OnHide or just remove icons
        namePlate.xiconPlateActive = nil
        if not dstName and namePlate.XiconGUID then -- OnHide
            namePlate.XiconGUID = nil
        end
        local kids = { namePlate:GetChildren() };
        for _, child in ipairs(kids) do
            if child.destGUID then
                for i = 1, #trackedUnitNames[child.destName .. child.destGUID] do
                    trackedUnitNames[child.destName .. child.destGUID][i]:SetParent(nil)
                    trackedUnitNames[child.destName .. child.destGUID][i]:SetSize(0.01)
                    trackedUnitNames[child.destName .. child.destGUID][i]:Show()
                    trackedUnitNames[child.destName .. child.destGUID][i]:ClearAllPoints()
                    trackedUnitNames[child.destName .. child.destGUID][i]:SetAlpha(0.01)
                    trackedUnitNames[child.destName .. child.destGUID][i]:SetPoint("CENTER", nil)
                end
                break
            end
        end
    elseif not namePlate and dstName then -- UNIT_DIED
    if trackedUnitNames[dstName] then
            local i = #trackedUnitNames[dstName]
            while i > 0 do
            trackedUnitNames[dstName][i]:SetParent(nil)
                trackedUnitNames[dstName][i]:SetAlpha(0)
                trackedUnitNames[dstName][i]:SetScript("OnUpdate", nil)
                framePool[#framePool + 1] = tremove(trackedUnitNames[dstName], i)
                if #trackedUnitNames[dstName] == 0 then
                    trackedUnitNames[dstName] = nil
                end
                i = i - 1
            end
        end
    end
end

local function updateDebuffsOnUnit(unit)
    if isValidTarget(unit) then
        local unitName = string.gsub(UnitName(unit), "%s+", "")
        local unitGUID = UnitGUID(unit)
            for i = 1, 40 do
            local spellName,rank,icon,count,dtype,duration,timeLeft,isMine = UnitDebuff(unit, i)
            if not spellName then break end
            if trackedCC[spellName] and timeLeft then
                    --update buff durations
                XiconDebuffLib_BG:addOrRefreshDebuff(unitName, unitGUID, trackedCC[spellName].id, timeLeft, true)
                if timeLeft > 0.5 then
                    XiconDebuffLib_BG:SendMessage(string.format("GAIN:%s,%s,%s,%s,%s,%s,%s", trackedCC[spellName].id, spellName, unitName, unitGUID, duration, timeLeft, "enemy"))
                end
            end
        end
    end
end

local function updateDebuffsOnUnitGUID(unitGUID)
    local unit = getUnitTargetedByMe(unitGUID)
    if unit then
        updateDebuffsOnUnit(unit)
    end
end

local function updateDebuffsOnNameplate(name, namePlate, force)
    if trackedUnitNames[name] then
        for j = 1, #trackedUnitNames[name] do
            trackedUnitNames[name][j]:SetParent(namePlate)
            trackedUnitNames[name][j]:Show()
            trackedUnitNames[name][j]:SetFrameStrata(force and "LOW" or "BACKGROUND")
        end
        addIcons(name, namePlate)
        if not namePlate:GetScript("OnHide") then
            namePlate:SetScript("OnHide", hideIcons)
            namePlate.xiconPlateHooked = true
        elseif not namePlate.xiconPlateHooked then
            namePlate:HookScript("OnHide", hideIcons)
            namePlate.xiconPlateHooked = true
        end
        namePlate.xiconPlateActive = true
    end
end

function XiconDebuffLib_BG:assignDebuffs(dstName, namePlate, force)
    dstName = string.gsub(dstName, "%s+", "")
    local name
    if force and namePlate.XiconGUID then -- we know the nameplates guid here
        name = dstName .. namePlate.XiconGUID() -- record to look for
        if trackedUnitNames[name] == nil then -- force wipe debuffs if no record, else record will show on this nameplate
            hideIcons(namePlate, dstName)
            end
    else
        -- find unit with unknown guid, same name and hidden active debuffs in trackedUnitNames
        for k,v in pairs(trackedUnitNames) do
            local splitStr = splitName(k)
            if namePlate.XiconGUID and v[1].destGUID == namePlate.XiconGUID() then -- we definitely know this nameplate (hovered / targeted before... OnHide will clear namePlate.XiconGUID
                name = k
                break
            elseif not namePlate.XiconGUID and splitStr[1] == dstName and #v > 0 and v[1]:GetParent() == nil and v[1].destName == dstName then
                -- wild guess in pve, accurate in pvp
                name = k
                break
            elseif splitStr[1] == dstName and #v > 0 and namePlate.xiconPlateActive and v[1]:GetParent() == namePlate then
                -- still wild guess but active, we update here nonetheless, accurate in pvp
                name = k
    end
    end
        end
    if name then
        -- nameplate with either force or guess was found
        updateDebuffsOnNameplate(name, namePlate, force)
    end
end

function XiconDebuffLib_BG:updateNameplate(unit, plate, unitName)
    local guid = UnitGUID(unit)
    local plateGUID = plate.XiconGUID
    if guid and not plateGUID then
        plate.XiconGUID = function() return guid end
    elseif guid and plateGUID and guid ~= plateGUID() then
        plate.XiconGUID = function() return guid end
    end
    updateDebuffsOnUnit(unit)
    XiconDebuffLib_BG:assignDebuffs(unitName, plate, true)
end

function XiconDebuffLib_BG:SendMessage(msg)
    SendAddonMessage("XICON2", msg, "RAID")
end

---------------------------------------------------------------------------------------------

-- EVENT HANDLERS

---------------------------------------------------------------------------------------------

local events = {}

function events:COMBAT_LOG_EVENT_UNFILTERED(...)
    local _, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType, stackCount = select(1, ...)
    local dstIsEnemy = bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) == COMBATLOG_OBJECT_REACTION_NEUTRAL or bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
    local srcIsEnemy = bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) == COMBATLOG_OBJECT_REACTION_NEUTRAL or bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
    local name
    if dstIsEnemy and trackedCC[spellName] then
        if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_CAST_SUCCESS" then
            name = string.gsub(dstName, "%s+", "")
            XiconDebuffLib_BG:addOrRefreshDebuff(dstName, dstGUID, spellID)
            updateDebuffsOnUnitGUID(dstGUID)
        end
    end
    if (srcIsEnemy or dstIsEnemy) and trackedCC[spellName] then
        if (eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_DISPEL") then
            name = string.gsub(dstName, "%s+", "")
            removeDebuff(name, dstGUID, spellID)
            XiconDebuffLib_BG:SendMessage(string.format("REMOVE:%s,%s,%s,%s,%s,%s,%s", trackedCC[spellName].id, spellName, name, dstGUID, "nil", "nil", "enemy"))
        end
    end
    if srcIsEnemy and eventType == "UNIT_DIED" then
        name = string.gsub(dstName, "%s+", "")
        if trackedUnitNames[name..dstGUID] then
            hideIcons(nil, name..dstGUID)
            trackedUnitNames[name..dstGUID] = nil
            XiconDebuffLib_BG:SendMessage(string.format("DIED:%s,%s,%s,%s,%s,%s,%s", trackedCC[spellName].id, spellName, name, dstGUID, "nil", "nil", "enemy"))
        end
    end
end

function events:PLAYER_FOCUS_CHANGED()
    updateDebuffsOnUnit("focus")
end

function events:PLAYER_TARGET_CHANGED()
    updateDebuffsOnUnit("target")
end

function events:UPDATE_MOUSEOVER_UNIT()
    updateDebuffsOnUnit("mouseover")
end

function events:UNIT_AURA(unitId)
    updateDebuffsOnUnit(unitId)
end

-- Catch syncs
function events:CHAT_MSG_ADDON(prefix, msg, type, author)
    if( (prefix == "PCCT2" or prefix == "XICON1" or prefix == "XICON2") and author ~= UnitName("player")  ) then
        local dataType, data = string.match(msg, "([^:]+)%:(.+)")
        local spellID, spellName, destName, destGUID, duration, timeLeft, playerType = string.split(",", data)
        if( dataType == "GAIN" ) then
            XiconDebuffLib_BG:addOrRefreshDebuff(destName, destGUID, spellID, timeLeft)
        elseif( dataType == "REMOVE" ) then
            removeDebuff(destName, destGUID, spellID)
        elseif dataType == "DIED"  then
            if trackedUnitNames[destName..destGUID] then
                hideIcons(nil, destName..destGUID)
                trackedUnitNames[destName..destGUID] = nil
            end
        end
    end
end

function events:PLAYER_ENTERING_WORLD(...) -- TODO add option to enable/disable in open world/instance/etc
    trackedUnitNames = {} -- wipe all data
    framePool = {}
end

---------------------------------------------------------------------------------------------

-- REGISTER EVENTS

---------------------------------------------------------------------------------------------

XiconDebuffLib_BG:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
end);
for k, _ in pairs(events) do
    XiconDebuffLib_BG:RegisterEvent(k); -- Register all events for which handlers have been defined
end