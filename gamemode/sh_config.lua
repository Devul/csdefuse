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
	[1] = {"csgo_default_knife"},
	[2] = {"csgo_default_t"}
}

print("Configuration loaded")