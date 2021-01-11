function initTrackedCrowdControl()
    return {
        -- Cyclone
        [GetSpellInfo(33786)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            id = 33786,
        },
        -- Hibernate
        [GetSpellInfo(18658)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            magic = true,
            id = 18658,
        },
        -- Entangling Roots
        [GetSpellInfo(26989)] = {
            track = "debuff",
            duration = 10,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
            id = 26989,
        },
        -- Feral Charge
        [GetSpellInfo(16979)] = {
            track = "debuff",
            duration = 4,
            priority = 30,
            root = true,
            id = 16979,
        },
        -- Bash
        [GetSpellInfo(8983)] = {
            track = "debuff",
            duration = 4,
            priority = 30,
            id = 8983,
        },
        -- Pounce
        [GetSpellInfo(9005)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
            id = 9005,
        },
        -- Maim
        [GetSpellInfo(22570)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            incapacite = true,
            id = 22570,
        },

        --[[
        -- Innervate
        [GetSpellInfo(29166)] = {
            track = "buff",
            duration = 20,
            priority = 10,
            id = 29166,
        },--]]


        -- Freezing Trap Effect
        [GetSpellInfo(14309)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            magic = true,
            id = 14309,
        },
        -- Wyvern Sting
        [GetSpellInfo(19386)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            poison = true,
            sleep = true,
            id = 19386,
        },
        -- Scatter Shot
        [GetSpellInfo(19503)] = {
            track = "debuff",
            duration = 4,
            priority = 40,
            onDamage = true,
            id = 19503,
        },
        -- Silencing Shot
        [GetSpellInfo(34490)] = {
            track = "debuff",
            duration = 3,
            priority = 15,
            magic = true,
            id = 34490,
        },
        -- Intimidation
        [GetSpellInfo(19577)] = {
            track = "debuff",
            duration = 2,
            priority = 40,
            id = 19577,
        },
        --[[
        -- The Beast Within
        [GetSpellInfo(34692)] = {
            track = "buff",
            duration = 18,
            priority = 20,
            id = 34692,
        },--]]


        -- Polymorph
        [GetSpellInfo(12826)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            magic = true,
            id = 12826,
        },
        -- Dragon's Breath
        [GetSpellInfo(31661)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
            onDamage = true,
            magic = true,
            id = 31661,
        },
        -- Frost Nova
        [GetSpellInfo(27088)] = {
            track = "debuff",
            duration = 8,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
            id = 27088,
        },
        -- Freeze (Water Elemental)
        [GetSpellInfo(33395)] = {
            track = "debuff",
            duration = 8,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
            id = 33395,
        },
        -- Counterspell - Silence
        [GetSpellInfo(18469)] = {
            track = "debuff",
            duration = 4,
            priority = 15,
            magic = true,
            id = 18469,
        },

        -- Ice Block
        [GetSpellInfo(45438)] = {
            track = "buff",
            duration = 10,
            priority = 20,
            id = 45438,
        },


        -- Hammer of Justice
        [GetSpellInfo(10308)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            magic = true,
            id = 10308,
        },
        -- Repentance
        [GetSpellInfo(20066)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            onDamage = true,
            magic = true,
            incapacite = true,
            id = 20066,
        },
        --[[
        -- Blessing of Protection
        [GetSpellInfo(10278)] = {
            track = "buff",
            duration = 10,
            priority = 10,
            id = 10278,
        },
        -- Blessing of Freedom
        [GetSpellInfo(1044)] = {
            track = "buff",
            duration = 14,
            priority = 10,
        },
        -- Divine Shield
        [GetSpellInfo(642)] = {
            track = "buff",
            duration = 12,
            priority = 20,
            id = 642,
        },
        --]]

        -- Psychic Scream
        [GetSpellInfo(8122)] = {
            track = "debuff",
            duration = 8,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            id = 8122,
        },
        -- Chastise
        [GetSpellInfo(44047)] = {
            track = "debuff",
            duration = 8,
            priority = 30,
            root = true,
            id = 44047,
        },
        -- Mind Control
        [GetSpellInfo(605)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            magic = true,
            id = 605,
        },
        -- Silence
        [GetSpellInfo(15487)] = {
            track = "debuff",
            duration = 5,
            priority = 15,
            magic = true,
            id = 15487,
        },
        --[[
        --Feiry Fire
        [GetSpellInfo(26993)] = {
            track = "debuff",
            duration = 40,
            priority = 15,
            magic = true,
            id = 26993,
        },
        -- Pain Suppression
        [GetSpellInfo(33206)] = {
            track = "buff",
            duration = 8,
            priority = 10,
            id = 33206,
        },
        --]]


        -- Sap
        [GetSpellInfo(6770)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            incapacite = true,
            id = 6770,
        },
        -- Blind
        [GetSpellInfo(2094)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            id = 2094,
        },
        -- Cheap Shot
        [GetSpellInfo(1833)] = {
            track = "debuff",
            duration = 4,
            priority = 40,
            id = 1833,
        },
        -- Kidney Shot
        [GetSpellInfo(8643)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            id = 8643,
        },
        -- Gouge
        [GetSpellInfo(1776)] = {
            track = "debuff",
            duration = 4,
            priority = 40,
            onDamage = true,
            incapacite = true,
            id = 1776,
        },
        -- Kick - Silence
        [GetSpellInfo(18425)] = {
            track = "debuff",
            duration = 2,
            priority = 15,
            id = 18425,
        },
        -- Garrote - Silence
        [GetSpellInfo(1330)] = {
            track = "debuff",
            duration = 3,
            priority = 15,
            id = 1330,
        },
        --[[
        -- Cloak of Shadows
        [GetSpellInfo(31224)] = {
            track = "buff",
            duration = 5,
            priority = 20,
            id = 31224,
        },
        --]]


        -- Fear
        [GetSpellInfo(5782)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            id = 5782,
        },
        -- Death Coil
        [GetSpellInfo(27223)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
            id = 27223,
        },
        -- Shadowfury
        [GetSpellInfo(30283)] = {
            track = "debuff",
            duration = 2,
            priority = 40,
            magic = true,
            id = 30283,
        },
        -- Seduction (Succubus)
        [GetSpellInfo(6358)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            id = 6358,
        },
        -- Howl of Terror
        [GetSpellInfo(5484)] = {
            track = "debuff",
            duration = 8,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            id = 5484,
        },
        -- Spell Lock (Felhunter)
        [GetSpellInfo(24259)] = {
            track = "debuff",
            duration = 3,
            priority = 15,
            magic = true,
            id = 24259,
        },
        --[[
        -- Unstable Affliction
        [GetSpellInfo(31117)] = {
            track = "debuff",
            duration = 5,
            priority = 15,
            magic = true,
            id = 31117,
        },
        --]]


        -- Intimidating Shout
        [GetSpellInfo(5246)] = {
            track = "debuff",
            duration = 8,
            priority = 15,
            onDamage = true,
            fear = true,
            id = 5246,
        },
        -- Concussion Blow
        [GetSpellInfo(12809)] = {
            track = "debuff",
            duration = 5,
            priority = 40,
            id = 12809,
        },
        -- Intercept Stun
        [GetSpellInfo(25274)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
            id = 25274,
        },

        --[[
        -- Spell Reflection
        [GetSpellInfo(23920)] = {
            track = "buff",
            duration = 5,
            priority = 10,
            id = 23920,
        },
        --]]


        -- War Stomp
        [GetSpellInfo(20549)] = {
            track = "debuff",
            duration = 2,
            priority = 40,
            id = 20549,
        },
        -- Arcane Torrent
        [GetSpellInfo(28730)] = {
            track = "debuff",
            duration = 2,
            priority = 15,
            magic = true,
            id = 28730,
        },
    }
end

XiconPlateBuffs_Totems = {
    ["Disease Cleansing Totem"] = "spell_nature_diseasecleansingtotem",
    ["Earth Elemental Totem"] = "spell_nature_earthelemental_totem",
    ["Earthbind Totem"] = "spell_nature_strengthofearthtotem02",
    ["Fire Elemental Totem"] = "spell_fire_elemental_totem",
    ["Fire Nova Totem"] = "spell_fire_sealoffire",
    ["Fire Resistance Totem"] = "spell_fireresistancetotem_01",
    ["Flametongue Totem"] = "spell_nature_guardianward",
    ["Frost Resistance Totem"] = "spell_frostresistancetotem_01",
    ["Grace of Air Totem"] = "spell_nature_invisibilitytotem",
    ["Grounding Totem"] = "spell_nature_groundingtotem",
    ["Healing Stream Totem"] = "Inv_spear_04",
    ["Magma Totem"] = "spell_fire_selfdestruct",
    ["Mana Spring Totem"] = "spell_nature_manaregentotem",
    ["Mana Tide Totem"] = "spell_frost_summonwaterelemental",
    ["Nature Resistance Totem"] = "spell_nature_natureresistancetotem",
    ["Poison Cleansing Totem"] = "spell_nature_poisoncleansingtotem",
    ["Searing Totem"] = "spell_fire_searingtotem",
    ["Sentry Totem"] = "spell_nature_removecurse",
    ["Stoneclaw Totem"] = "spell_nature_stoneclawtotem",
    ["Stoneskin Totem"] = "spell_nature_stoneskintotem",
    ["Strength of Earth Totem"] = "spell_nature_earthbindtotem",
    ["Totem of Wrath"] = "spell_fire_totemofwrath",
    ["Tremor Totem"] = "spell_nature_tremortotem",
    ["Windfury Totem"] = "spell_nature_windfury",
    ["Windwall Totem"] = "spell_nature_earthbind",
    ["Wrath of Air Totem"] = "spell_nature_slowingtotem",
}