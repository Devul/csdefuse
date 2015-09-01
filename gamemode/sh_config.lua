fruit.config = fruit.config or {}

fruit.config.models = {
	[1] = {"models/player/urban.mdl"},
	[2] = {"models/player/leet.mdl"}
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

fruit.defaultLoadout = {"weapon_crowbar", "weapon_pistol"}


print("Configuration loaded")