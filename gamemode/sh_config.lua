fruit.config = fruit.config or {}

fruit.useCustomModels = false

CreateConVar( "fruit_cs_maxMoney", "16000", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

fruit.config.currencyStr = "$"

fruit.config.RoundIntroTime = 5 -- 5 seconds.
fruit.config.RoundOutroTime = 5 -- 5 seconds.
fruit.config.RoundLength = 120 -- 120 seconds.

fruit.config.walkSpeed = 200
fruit.config.runSpeed = 150

-- Key = teamId
fruit.config.models = {
	[1] = {"models/player/urban.mdl"},
	[2] = {"models/player/leet.mdl"},
	[3] = {"models/gman_high.mdl"},
}

-- Key = teamId
fruit.config.customModels = {
	[1] = {"models/player/ctm_fbi_varianta.mdl"},
	[2] = {"models/player/tm_phoenix.mdl"},
	[3] = {"models/gman_high.mdl"},
}

fruit.config.defaultKnives = {
	"csgo_default_knife", "csgo_default_t"
}

fruit.config.knifeSkins = {
	-- Bayonets
	["Bayonet"] = "csgo_bayonet",
	["Bayonet - Crimson Web"] = "csgo_bayonet_crimsonwebs",
	["Bayonet - Fade"] = "csgo_bayonet_fade",
	["Bayonet - Night"] = "csgo_bayonet_night",
	-- Butterfly Knives
	["Butterfly Knife"] = "csgo_butterfly",
	["Butterfly Knife - Crimson Web"] = "csgo_butterfly_crimsonwebs",
	["Butterfly Knife - Fade"] = "csgo_butterfly_fade",
	["Butterfly Knife - Night"] = "csgo_butterfly_night",
	-- Falchion
	["Falchion"] = "csgo_falchion",
	["Falchion Knife - Crimson Web"] = "csgo_falchion_crimsonwebs",
	["Falchion Knife - Fade"] = "csgo_falchion_fade",
	["Falchion Knife - Night"] = "csgo_falchion_night",
	-- Flip Knife
	["Flip Knife"] = "csgo_flip",
	["Flip Knife - Crimson Web"] = "csgo_flip_crimsonwebs",
	["Flip Knife - Fade"] = "csgo_flip_fade",
	["Flip Knife - Night"] = "csgo_flip_night",
	-- Gut Knife
	["Gut Knife"] = "csgo_gut",
	["Gut Knife - Crimson Web"] = "csgo_gut_crimsonwebs",
	["Gut Knife - Fade"] = "csgo_gut_fade",
	["Gut Knife - Night"] = "csgo_gut_night",
	-- Huntsman Knife
	["Huntsman Knife"] = "csgo_huntsman",
	["Huntsman Knife - Crimson Web"] = "csgo_huntsman_crimsonwebs",
	["Huntsman Knife - Fade"] = "csgo_huntsman_fade",
	["Huntsman Knife - Night"] = "csgo_huntsman_night",
	-- Karambit
	["Karambit"] = "csgo_karambit",
	["Karambit - Crimson Web"] = "csgo_karambit_crimsonwebs",
	["Karambit - Fade"] = "csgo_karambit_fade",
	-- M9 Bayonet
	["M9 Bayonet"] = "csgo_m9",
	["M9 Bayonet - Crimson Web"] = "csgo_m9_crimsonwebs",
	["M9 Bayonet - Fade"] = "csgo_m9_fade",
	["M9 Bayonet - Night"] = "csgo_m9_night",
}

-- First Tier Key = teamId
-- Second Tier Key = Category String
fruit.config.weapons = {
	[1] = {
		["Pistols"] = {
			["weapon_csgo_usp"] = {price = 200}, 
			["weapon_csgo_p2000"] = {price = 200}, 
			["weapon_csgo_p250"] = {price = 300}, 
			["weapon_csgo_fn"] = {price = 500},
			["weapon_csgo_cz75"] = {price = 300}, 
			["weapon_csgo_deagle"] = {price = 700}
		},
		["Submachine Guns"] = {
			["weapon_csgo_mp9"] = {price = 1100}, 
			["weapon_csgo_ump"] = {price = 1200}, 
			["weapon_csgo_mp7"] =  {price = 1700}, 
			["weapon_csgo_bizon"] = {price = 1400}
		},
		["Heavy Weapons"] = {
			["weapon_csgo_nova"] = {price = 1200}
		},
		["Assault Rifles"] = {
			["weapon_csgo_m4a1_s"] = {price = 3200},
			["weapon_csgo_m4a4"] = {price = 3100},
			["weapon_csgo_famas"] = {price = 2250}, 
			["weapon_csgo_aug"] = {price = 3300},
			["weapon_csgo_awp"] = {price = 4750}, 
			["weapon_csgo_scar"] = {price = 5000},
			["weapon_csgo_ssg08"] = {price = 1700},
		},
		["Gear"] = {
			["weapon_csgo_flashbang"] = {price = 200},
			["weapon_csgo_taser"] = {price = 300},
		},
	},
	[2] = {
		["Pistols"] = {
			["weapon_csgo_glock"] = {price = 200}, 
			["weapon_csgo_p250"] = {price = 300}, 
			["weapon_csgo_tec9"] = {price = 500},
			["weapon_csgo_cz75"] = {price = 300}, 
			["weapon_csgo_deagle"] = {price = 700}
		},
		["Submachine Guns"] = {
			["weapon_csgo_mp9"] = {price = 1100}, 
			["weapon_csgo_ump"] = {price = 1200}, 
			["weapon_csgo_mp7"] =  {price = 1700}, 
			["weapon_csgo_bizon"] = {price = 1400}
		},
		["Heavy Weapons"] = {
			["weapon_csgo_nova"] = {price = 1200}
		},
		["Assault Rifles"] = {
			["weapon_csgo_ak47"] = {price = 2700},
			["weapon_csgo_galil"] = {price = 2000},
			["weapon_csgo_sg553"] = {price = 3300},
			["weapon_csgo_awp"] = {price = 4750}, 
			["weapon_csgo_g3sg1"] = {price = 5000},
			["weapon_csgo_ssg08"] = {price = 1700}
		},
		["Gear"] = {
			["weapon_csgo_flashbang"] = {price = 200},
			["weapon_csgo_taser"] = {price = 300},
		}
	}
}

fruit.roundStates = {}
local roundState
local function createRoundState(name)
	roundState = {}
	roundState.name = name

	return table.insert(fruit.roundStates, roundState)
end

ROUND_ACTIVE = createRoundState("Active")
ROUND_WARMINGUP = createRoundState("Warming Up")
ROUND_WAITINGFORPLAYERS = createRoundState("Waiting for Players")
ROUND_INTRO = createRoundState("Round Intro")
ROUND_OUTRO = createRoundState("Round Outro")

fruit.defaultLoadout = {}

fruit.teamBasedLoadout = {
	[1] = {"csgo_default_knife", "weapon_csgo_usp"},
	[2] = {"csgo_default_t", "weapon_csgo_glock"},
}

print("Configuration loaded")