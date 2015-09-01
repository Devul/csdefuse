fruit.config = fruit.config or {}

fruit.useCustomModels = true

fruit.config.models = {
	[1] = {"models/player/urban.mdl"},
	[2] = {"models/player/leet.mdl"},
	[3] = {"models/gman_high.mdl"},
}

fruit.config.customModels = {
	[1] = {"models/player/ctm_fbi_varianta.mdl"},
	[2] = {"models/player/tm_phoenix.mdl"},
	[3] = {"models/gman_high.mdl"},
}

fruit.config.weapons = {
	[1] = {
		["Pistols"] = {"weapon_csgo_usp", "weapon_csgo_p2000", "weapon_csgo_p250", "weapon_csgo_fn", "weapon_csgo_cz75", "weapon_csgo_deagle"},
		["Submachine Guns"] = {"weapon_csgo_mp9", "weapon_csgo_ump", "weapon_csgo_mp7", "weapon_csgo_bizon"},
		["Heavy Weapons"] = {"weapon_csgo_nova"},
		["Assault Rifles"] = {"weapon_csgo_m4a1_s", "weapon_csgo_m4a4", "weapon_csgo_famas", "weapon_csgo_aug", "weapon_csgo_awp", "weapon_csgo_scar", "weapon_csgo_ssg08"},
		["Gear"] = {"weapon_csgo_flashbang", "weapon_csgo_taser"},
	},
	[1] = {
		["Pistols"] = {"weapon_csgo_glock", "weapon_csgo_p250", "weapon_csgo_tec9", "weapon_csgo_cz75", "weapon_csgo_deagle"},
		["Submachine Guns"] = {"weapon_csgo_ump", "weapon_csgo_mp7", "weapon_csgo_bizon"},
		["Heavy Weapons"] = {"weapon_csgo_nova", "weapon_csgo_xm1014", "weapon_csgo_mag7"},
		["Assault Rifles"] = {"weapon_csgo_ak47", "weapon_csgo_galil", "weapon_csgo_sg553", "weapon_csgo_awp", "weapon_csgo_g3sg1", "weapon_csgo_ssg08"},
		["Gear"] = {"weapon_csgo_flashbang", "weapon_csgo_taser"},
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
	[1] = {"csgo_default_knife", "weapon_csgo_p2000"},
	[2] = {"csgo_default_t", "weapon_csgo_glock"}
}

print("Configuration loaded")