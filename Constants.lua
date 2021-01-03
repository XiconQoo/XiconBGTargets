XiconPlateBuffs_CC = {
    --
    --druid
    --
    ["Maim"] = true,
    ["Cyclone"] = true,
    ["Bash"] = true,
    ["Hibernate"] = true,
    ["Entangling Roots"] = true,
    --
    --hunter
    --
    ["Concussive Shot"] = true,
    ["Scare Beast	"] = true,
    ["Freezing Trap"] = true,
    ["Wyvern Sting	"] = true,
    ["Wing Clip"] = true,
    ["Scatter Shot"] = true,
    ["Silencing Shot"] = true,
    --hunter pets
    ["Charge"] = true,
    ["Intimidation"] = true,
    --
    --mage
    --
    ["Chilled"] = true,
    ["Frostbite"] = true,
    ["Impact"] = true,
    ["Polymorph"] = true,
    ["Frost Nova"] = true,
    ["Counterspell"] = true,
    ["Dragon's Breath"] = true,
    --mage pet
    ["Freeze"] = true,
    --
    --paladin
    --
    ["Hammer of Justice"] = true,
    ["Repentance"] = true,
    ["Turn Evil"] = true,
    --
    --priest
    --
    ["Psychic Scream"] = true,
    ["Silence"] = true,
    ["Blackout"] = true,
    ["Mind Control"] = true,
    --
    --rogue
    --
    ["Gouge"] = true,
    ["Sap"] = true,
    ["Cheap Shot"] = true,
    ["Garrote - Silence"] = true,
    ["Kidney Shot"] = true,
    ["Blind"] = true,
    --
    --shaman
    --
    ["Frost Shock"] = true,
    --
    --warlock
    --
    ["Death Coil"] = true,
    ["Fear"] = true,
    ["Howling Terror"] = true,
    ["Shadowfury"] = true,
    ["Pyroclasm"] = true,
    --warlock pets
    ["Intercept Stun"] = true,
    ["Spell Lock"] = true,
    ["Seduction"] = true,
    --
    --warrior
    --
    ["Charge Stun"] = true,
    ["Intimidating Shout"] = true,
    ["Intercept Stun"] = true,
    ["Hamstring"] = true,
    ["Piercing Howl"] = true,
    --
    --racial + general
    ["Mace Stun Effect"] = true,
    ["Chastise"] = true,
    ["War Stomp"] = true,
}
function initTrackedCrowdControl()
    return {
        -- Cyclone
        [GetSpellInfo(33786)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
        },
        -- Hibernate
        [GetSpellInfo(18658)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            magic = true,
        },
        -- Entangling Roots
        [GetSpellInfo(26989)] = {
            track = "debuff",
            duration = 10,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
        },
        -- Feral Charge
        [GetSpellInfo(16979)] = {
            track = "debuff",
            duration = 4,
            priority = 30,
            root = true,
        },
        -- Bash
        [GetSpellInfo(8983)] = {
            track = "debuff",
            duration = 4,
            priority = 30,
        },
        -- Pounce
        [GetSpellInfo(9005)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
        },
        -- Maim
        [GetSpellInfo(22570)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            incapacite = true,
        },

        -- Innervate
        [GetSpellInfo(29166)] = {
            track = "buff",
            duration = 20,
            priority = 10,
        },


        -- Freezing Trap Effect
        [GetSpellInfo(14309)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            magic = true,
        },
        -- Wyvern Sting
        [GetSpellInfo(19386)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            poison = true,
            sleep = true,
        },
        -- Scatter Shot
        [GetSpellInfo(19503)] = {
            track = "debuff",
            duration = 4,
            priority = 40,
            onDamage = true,
        },
        -- Silencing Shot
        [GetSpellInfo(34490)] = {
            track = "debuff",
            duration = 3,
            priority = 15,
            magic = true,
        },
        -- Intimidation
        [GetSpellInfo(19577)] = {
            track = "debuff",
            duration = 2,
            priority = 40,
        },
        --[[
        -- The Beast Within
        [GetSpellInfo(34692)] = {
            track = "buff",
            duration = 18,
            priority = 20,
        },--]]


        -- Polymorph
        [GetSpellInfo(12826)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            magic = true,
        },
        -- Dragon's Breath
        [GetSpellInfo(31661)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
            onDamage = true,
            magic = true,
        },
        -- Frost Nova
        [GetSpellInfo(27088)] = {
            track = "debuff",
            duration = 8,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
        },
        -- Freeze (Water Elemental)
        [GetSpellInfo(33395)] = {
            track = "debuff",
            duration = 8,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
        },
        -- Counterspell - Silence
        [GetSpellInfo(18469)] = {
            track = "debuff",
            duration = 4,
            priority = 15,
            magic = true,
        },
        --[[
        -- Ice Block
        [GetSpellInfo(45438)] = {
            track = "buff",
            duration = 10,
            priority = 20,
        },
        --]]


        -- Hammer of Justice
        [GetSpellInfo(10308)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            magic = true,
        },
        -- Repentance
        [GetSpellInfo(20066)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
            onDamage = true,
            magic = true,
            incapacite = true,
        },
        --[[
        -- Blessing of Protection
        [GetSpellInfo(10278)] = {
            track = "buff",
            duration = 10,
            priority = 10,
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
        },
        -- Chastise
        [GetSpellInfo(44047)] = {
            track = "debuff",
            duration = 8,
            priority = 30,
            root = true,
        },
        -- Mind Control
        [GetSpellInfo(605)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            magic = true,
        },
        -- Silence
        [GetSpellInfo(15487)] = {
            track = "debuff",
            duration = 5,
            priority = 15,
            magic = true,
        },
        --[[
        -- Pain Suppression
        [GetSpellInfo(33206)] = {
            track = "buff",
            duration = 8,
            priority = 10,
        },
        --]]


        -- Sap
        [GetSpellInfo(6770)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            incapacite = true,
        },
        -- Blind
        [GetSpellInfo(2094)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
        },
        -- Cheap Shot
        [GetSpellInfo(1833)] = {
            track = "debuff",
            duration = 4,
            priority = 40,
        },
        -- Kidney Shot
        [GetSpellInfo(8643)] = {
            track = "debuff",
            duration = 6,
            priority = 40,
        },
        -- Gouge
        [GetSpellInfo(1776)] = {
            track = "debuff",
            duration = 4,
            priority = 40,
            onDamage = true,
            incapacite = true,
        },
        -- Kick - Silence
        [GetSpellInfo(18425)] = {
            track = "debuff",
            duration = 2,
            priority = 15,
        },
        -- Garrote - Silence
        [GetSpellInfo(1330)] = {
            track = "debuff",
            duration = 3,
            priority = 15,
        },
        --[[
        -- Cloak of Shadows
        [GetSpellInfo(31224)] = {
            track = "buff",
            duration = 5,
            priority = 20,
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
        },
        -- Death Coil
        [GetSpellInfo(27223)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
        },
        -- Shadowfury
        [GetSpellInfo(30283)] = {
            track = "debuff",
            duration = 2,
            priority = 40,
            magic = true,
        },
        -- Seduction (Succubus)
        [GetSpellInfo(6358)] = {
            track = "debuff",
            duration = 10,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
        },
        -- Howl of Terror
        [GetSpellInfo(5484)] = {
            track = "debuff",
            duration = 8,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
        },
        -- Spell Lock (Felhunter)
        [GetSpellInfo(24259)] = {
            track = "debuff",
            duration = 3,
            priority = 15,
            magic = true,
        },
        --[[
        -- Unstable Affliction
        [GetSpellInfo(31117)] = {
            track = "debuff",
            duration = 5,
            priority = 15,
            magic = true,
        },
        --]]


        -- Intimidating Shout
        [GetSpellInfo(5246)] = {
            track = "debuff",
            duration = 8,
            priority = 15,
            onDamage = true,
            fear = true,
        },
        -- Concussion Blow
        [GetSpellInfo(12809)] = {
            track = "debuff",
            duration = 5,
            priority = 40,
        },
        -- Intercept Stun
        [GetSpellInfo(25274)] = {
            track = "debuff",
            duration = 3,
            priority = 40,
        },

        --[[
        -- Spell Reflection
        [GetSpellInfo(23920)] = {
            track = "buff",
            duration = 5,
            priority = 10,
        },
        --]]


        -- War Stomp
        [GetSpellInfo(20549)] = {
            track = "debuff",
            duration = 2,
            priority = 40,
        },
        -- Arcane Torrent
        [GetSpellInfo(28730)] = {
            track = "debuff",
            duration = 2,
            priority = 15,
            magic = true,
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