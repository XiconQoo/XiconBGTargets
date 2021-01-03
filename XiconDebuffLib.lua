local LIB_NAME = "XiconDebuffLib_BG"
local trackedUnitNames = {}
local trackedCC = initTrackedCrowdControl()
local XiconDebuffSV_local
local select, tonumber, tostring, ceil = select, tonumber, tostring, ceil

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

-- REGISTER LIB

---------------------------------------------------------------------------------------------

function XiconDebuffLib_BG:Init(savedVariables)
    XiconDebuffSV_local = savedVariables
    if not XiconDebuffSV_local then
        XiconDebuffSV_local = {}
        XiconDebuffSV_local["iconSize"] = 25
        XiconDebuffSV_local["yOffset"] = 0
        XiconDebuffSV_local["xOffset"] = -2
        XiconDebuffSV_local["fontSize"] = 10
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

local function split(str, separator)
    local fields = {}

    local sep = separator or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c) fields[#fields + 1] = c end)

    return fields
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

local function removeDebuff(destName, destGUID, spellName)
    if trackedUnitNames[destName..destGUID] ~= nil then
        for i = 1, #trackedUnitNames[destName..destGUID] do
            if trackedUnitNames[destName..destGUID][i] then
                if trackedUnitNames[destName..destGUID][i].name == spellName then
                    if trackedUnitNames[destName..destGUID][i]:IsVisible() then
                        local parent = trackedUnitNames[destName..destGUID][i]:GetParent()
                        if parent and parent.xiconPlate then
                            parent.xiconPlate = 0
                        end
                    end
                    trackedUnitNames[destName..destGUID][i]:SetParent(nil)
                    trackedUnitNames[destName..destGUID][i]:Hide()
                    --trackedUnitNames[destName..destGUID][i]:SetScript("OnUpdate", nil)
                    tremove(trackedUnitNames[destName..destGUID], i)
                    --count = count - 1
                end
            end
        end
    end
end

function XiconDebuffLib_BG:addDebuff(destName, destGUID, spellID, spellName)
    if trackedUnitNames[destName..destGUID] == nil then
        trackedUnitNames[destName..destGUID] = {}
    end
    local _, _, texture = GetSpellInfo(spellID)
    local duration = trackedCC[spellName].duration
    local icon = CreateFrame("frame", nil, nil)
    icon:SetAlpha(XiconDebuffSV_local["alpha"])
    icon.texture = icon:CreateTexture(nil, "BORDER")
    icon.texture:SetAllPoints(icon)
    icon.texture:SetTexture(texture)
    icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
    icon.cooldown:SetAlpha(XiconDebuffSV_local["alpha"])
    icon.cooldown:SetFont("Fonts\\ARIALN.ttf", XiconDebuffSV_local["fontSize"], "OUTLINE")

    icon.cooldown:SetTextColor(0.7, 1, 0)
    icon.cooldown:SetAllPoints(icon)
    icon.duration = duration
    icon.endtime = calcEndTime(duration)
    icon.name = spellName
    icon.destGUID = destGUID

    local iconTimer = function(iconFrame)
        --if not Icicledb.fontSize then Icicledb.fontSize = ceil(Icicledb.iconsizer - Icicledb.iconsizer  / 2) end
        local itimer = ceil(iconFrame.endtime - GetTime()) -- cooldown duration
        local milliTimer = round(iconFrame.endtime - GetTime(), 1)
        iconFrame.timeLeft = milliTimer
        if itimer >= 60 then
            iconFrame.cooldown:SetText(itimer)
            if itimer < 60 and itimer >= 90 then
                iconFrame.cooldown:SetText("2m")
            else
                iconFrame.cooldown:SetText(ceil(itimer / 60) .. "m") -- X minutes
            end
        elseif itimer < 60 and itimer >= 11 then
            --if it's less than 60s
            iconFrame.cooldown:SetText(itimer)
        elseif itimer <= 10 and itimer >= 5 then
            iconFrame.cooldown:SetTextColor(1, 0.7, 0)
            iconFrame.cooldown:SetText(itimer)
        elseif itimer <= 4 and itimer >= 3 then
            iconFrame.cooldown:SetTextColor(1, 0, 0)
            iconFrame.cooldown:SetText(itimer)
        elseif milliTimer <= 3 and milliTimer > 0 then
            iconFrame.cooldown:SetTextColor(1, 0, 0)
            iconFrame.cooldown:SetText(formatTimer(milliTimer, 1))
        else -- fallback in case SPELL_AURA_REMOVED is not fired
            removeDebuff(destName, destGUID, spellName)
            iconFrame:Hide()
            iconFrame:SetParent(nil)
            iconFrame:SetScript("OnUpdate", nil)
        end
    end

    removeDebuff(destName, destGUID, spellName)
    tinsert(trackedUnitNames[destName..destGUID], icon)
    icon:SetScript("OnUpdate", function()
        iconTimer(icon)
    end)
    --sorting
    if XiconDebuffSV_local["sorting"] == "none" then
        return
    end
    if XiconDebuffSV_local["sorting"] == "ascending" then
        table.sort(trackedUnitNames[destName..destGUID], function(timeleftA,timeleftB) return timeleftA.endtime < timeleftB.endtime end)
    elseif XiconDebuffSV_local["sorting"] == "descending" then
        table.sort(trackedUnitNames[destName..destGUID], function(timeleftA,timeleftB) return timeleftA.endtime > timeleftB.endtime end)
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
        trackedUnitNames[dstName][i].cooldown:SetFont("Fonts\\ARIALN.ttf", fontSize, "OUTLINE")
        if i == 1 then
            trackedUnitNames[dstName][i]:SetPoint("RIGHT", namePlate, "LEFT", XiconDebuffSV_local["xOffset"], XiconDebuffSV_local["yOffset"])
        else
            trackedUnitNames[dstName][i]:SetPoint("RIGHT", trackedUnitNames[dstName][i - 1], - size - 2, 0)
        end
    end
end

local function hideIcons(dstName, namePlate)
    namePlate.xiconPlate = 0
    if trackedUnitNames[dstName] then
        for i = 1, #trackedUnitNames[dstName] do
            trackedUnitNames[dstName][i]:SetParent(nil)
            trackedUnitNames[dstName][i]:Hide()
        end
    end
end

local function updateIconsOnUnit(unit)
    if isValidTarget(unit) then
        local destName = string.gsub(UnitName(unit), "%s+", "") .. UnitGUID(unit)
        if trackedUnitNames[destName] ~= nil then
            for i = 1, 40 do
                local debuffName,rank,icon,count,dtype,duration,timeLeft,isMine = UnitDebuff(unit, i)
                if not debuffName then break end
                if trackedCC[debuffName] and timeLeft ~= nil then
                    --update buff durations
                    for j = 1, #trackedUnitNames[destName] do
                        if trackedUnitNames[destName][j] and trackedUnitNames[destName][j].name == debuffName then
                            trackedUnitNames[destName][j].endtime = calcEndTime(timeLeft)
                            --break
                        end
                    end
                end
            end
        end
    end
end

local function updateIconsOnUnitGUID(unitGUID)
    local unit = getUnitTargetedByMe(unitGUID)
    if unit then
        updateIconsOnUnit(unit)
    end
end

function XiconDebuffLib_BG:assignDebuffs(dstName, namePlate, force)
    local name
    if force and namePlate.xiconGUID then
        name = dstName .. namePlate.xiconGUID
        if trackedUnitNames[name] == nil and namePlate.xiconBGHooked then
            local kids = { namePlate:GetChildren() };
            for _, child in ipairs(kids) do
                if child.destGUID then
                    hideIcons(dstName .. child.destGUID, namePlate) -- destGUID
                    return
                end
            end
        end
    else -- find unit with unkown guid, same name and hidden active debuffs in trackedUnitNames
        for k,v in pairs(trackedUnitNames) do
            local splitStr = split(k, "0x")
            if splitStr[1] == dstName and #v > 0 and v[1]:GetParent() == nil then
                name = k
                break
            elseif splitStr[1] == dstName and #v > 0 and namePlate.xiconBGHooked then
                --update plate to rearrange icons
                name = k
            end
            --[[if string.match(k, dstName) and #v > 0 and v[1]:GetParent() == nil then
                name = k
                break
            end--]]
        end
    end
    if name == nil then
        return
    else
        dstName = name
    end
    if trackedUnitNames[dstName] then
        namePlate.xiconPlate = #trackedUnitNames[dstName]
        for j = 1, #trackedUnitNames[dstName] do
            trackedUnitNames[dstName][j]:SetParent(namePlate)
            trackedUnitNames[dstName][j]:Show()
        end
        addIcons(dstName, namePlate)
        if not namePlate:GetScript("OnHide") then
            --print("namePlate:SetScript(\"OnHide\")")
            namePlate:SetScript("OnHide", function()
                hideIcons(dstName, namePlate)
            end)
            namePlate.xiconBGHooked = true
        elseif not namePlate.xiconBGHooked then
            --print("namePlate:HookScript(\"OnHide\")")
            namePlate:HookScript("OnHide", function()
                hideIcons(dstName, namePlate)
            end)
            namePlate.xiconBGHooked = true
        end
    end
end

function XiconDebuffLib_BG:updateNameplate(unit, plate, unitName)
    local guid = UnitGUID(unit)
    if not plate.xiconGUID then
        plate.xiconGUID = guid
    elseif plate.xiconGUID ~= guid then
        plate.xiconGUID = guid
    end
    updateIconsOnUnit(unit)
    XiconDebuffLib_BG:assignDebuffs(unitName, plate, true)
end

---------------------------------------------------------------------------------------------

-- EVENT HANDLERS

---------------------------------------------------------------------------------------------

local events = {}

function events:COMBAT_LOG_EVENT_UNFILTERED(...)
    local _, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType, stackCount = select(1, ...)
    local isEnemy = bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) == COMBATLOG_OBJECT_REACTION_NEUTRAL or bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
    if isEnemy and trackedCC[spellName] then
        local name = string.gsub(dstName, "%s+", "")
        if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") then
            --print(eventType .. " - " .. spellName .. " - addDebuff")
            XiconDebuffLib_BG:addDebuff(name, dstGUID, spellID, spellName)
            updateIconsOnUnitGUID(dstGUID)
        elseif (eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_DISPEL") then
            --print(eventType .. " - " .. spellName .. " - " .. dstName .. " - removeDebuff")
            removeDebuff(name, dstGUID, spellName)
        elseif eventType == "UNIT_DIED" then
            trackedUnitNames[dstName..dstGUID] = nil
        end
    end
end

function events:PLAYER_FOCUS_CHANGED()
    updateIconsOnUnit("focus")
end

function events:PLAYER_TARGET_CHANGED()
    updateIconsOnUnit("target")
end

function events:UPDATE_MOUSEOVER_UNIT()
    updateIconsOnUnit("mouseover")
end

function events:PLAYER_ENTERING_WORLD(...) -- TODO add option to enable/disable in open world/instance/etc
    trackedUnitNames = {} -- wipe all data
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