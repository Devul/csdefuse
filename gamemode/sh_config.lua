fruit.config = fruit.config or {}

fruit.useCustomModels = false

CreateConVar( "fruit_cs_maxMoney", "16000", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

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
	roundState.name = Name

	table.insert(fruit.roundStates, roundState)
end

ROUND_ACTIVE = createRoundState("Active")
ROUND_WARMINGUP = createRoundState("Warming Up")
ROUND_WAITINGFORPLAYERS = createRoundState("Waiting for Players")

fruit.defaultLoadout = {}

fruit.teamBasedLoadout = {
	[1] = {"csgo_default_knife", "weapon_csgo_usp"},
	[2] = {"csgo_default_t", "weapon_csgo_glock"},
}

print("Configuration loaded")