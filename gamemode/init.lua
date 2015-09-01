fruit = fruit or GM

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

AddCSLuaFile( "sh_config.lua" )
include( "sh_config.lua" )

fruit.Loadout = { "weapon_physcannon" }

CreateConVar( "fruit_DebugMode", 1, FCVAR_NOTIFY, "int (0 = false, 1 = true)" )
fruit.DebugMode = GetConVar( "fruit_DebugMode" )

fruit.isInitialized = false

fruit.inRound = false
fruit.inWarmup = false
fruit.inHalfTime = false
fruit.isFinished = false

SCORE_T = 0
SCORE_CT = 0

PLAYERS_T = {}
PLAYERS_CT = {}

util.AddNetworkString("fruit_TeamSelectMenu")
util.AddNetworkString("fruit_SelectTeam")
util.AddNetworkString("fruit_UpdateRoundState")
util.AddNetworkString("fruit_StartRound")
util.AddNetworkString("fruit_UpdateScore")

local meta = FindMetaTable("Player")

function fruit.PrintDebug( any )
	if tobool( fruit.DebugMode ) then 
		return print( any )
	end
end

function fruit:PlayerLoadout( client )
	for _, weapon in pairs( fruit.Loadout ) do
		client:Give( weapon )
	end
	
	fruit.PrintDebug( "[DEBUG] "..client:Name().." -> Loadout Assigned" )
end

function fruit:RestartRound()
	for k,v in pairs(ents.FindByClass("prop_ragdoll")) do
		v:Remove()
	end

	for k,v in pairs(player.GetAll()) do
		if v:Team() != TEAM_SPECTATOR then
			v:Spawn()
		end
	end

	PLAYERS_CT = {}
	PLAYERS_T = {}

	fruit:BeginRound()
end

function fruit:EndRound( winner )
	if winner == TEAM_COUNTERTERRORISTS then
		SCORE_CT = SCORE_CT + 1
		if SCORE_CT > 15 then
			print("Game won! Restarting")
		end

		net.Start("fruit_UpdateScore")
			net.WriteInt(SCORE_CT, 8)
			net.WriteInt(SCORE_T, 8)
			net.WriteInt(winner, 8)
		net.Broadcast()

	elseif winner == TEAM_TERRORISTS then
		SCORE_T = SCORE_T + 1
		if SCORE_T > 15 then
			print("Game won! Restarting")
		end

		net.Start("fruit_UpdateScore")
			net.WriteInt(SCORE_CT, 8)
			net.WriteInt(SCORE_T, 8)
			net.WriteInt(winner, 8)
		net.Broadcast()
	else
		-- Round draw
	end
end

function fruit:BeginRound()

	fruit.RoundState = ROUND_INTRO
	
	timer.Remove("IntroTimer")
	timer.Remove("RoundTimer")
	timer.Remove("OutroTimer")

	net.Start("fruit_StartRound")
	net.Broadcast()

	for _, v in pairs(player.GetAll()) do
		fruit:SetPlayerSpeed( v, 0.0001, 0.001 )
	end

	timer.Create("IntroTimer", fruit.config.RoundIntroTime or 5, 1, function()
			fruit.RoundState = ROUND_ACTIVE

			for _, v in pairs(player.GetAll()) do
				if v:Team() == TEAM_COUNTERTERRORISTS then
					PLAYERS_CT[v:UserID()] = true
				end
				if v:Team() == TEAM_TERRORISTS then
					PLAYERS_T[v:UserID()] = true
				end

				fruit:SetPlayerSpeed( v, fruit.config.walkSpeed, fruit.config.runSpeed )
			end
		timer.Create("RoundTimer", fruit.config.RoundLength or 120, 1, function()
				fruit.RoundState = ROUND_OUTRO
				fruit:EndRound( TEAM_TERRORISTS )
			timer.Create("OutroTimer", fruit.config.RoundOutroTime or 5, 1, function()
				fruit.RestartRound()
			end)
		end)
	end)
end

function fruit:PlayerInitialSpawn( client )
		fruit.PrintDebug( "[DEBUG] "..client:Name().." -> Connected" )
		client.hasChosenTeam = false

	if #player.GetAll() > 1 and fruit.RoundState == ROUND_WAITINGFORPLAYERS then
		fruit:BeginRound()
	end
end

function fruit:DoPlayerDeath( client, attacker, dmg )
	if client:Team() == TEAM_COUNTERTERRORISTS then
		PLAYERS_CT[client:UserID()] = nil
	end
	if client:Team() == TEAM_TERRORISTS then
		PLAYERS_T[client:UserID()] = nil
	end

	if table.Count(PLAYERS_CT) < 1 then
		fruit:EndRound(TEAM_TERRORISTS)
	elseif table.Count(PLAYERS_T) < 1 then
		fruit:EndRound(TEAM_COUNTERTERRORISTS)
	end
end

--[[
	Team Selection Stuff
]]--

function fruit.ForceTeamSelect( client )
	fruit.PrintDebug("[DEBUG] "..client:Name().." -> Selecting Team.")
	
	net.Start("fruit_TeamSelectMenu")
	net.Send( client )
end

function GM:PlayerSpawn( client )
	if fruit.RoundState == ROUND_ACTIVE and client.hasChosenTeam then
		print("Deny spawn")
	--return false
	end

	if client.NextTeamChange then
		client:SetTeam(client.NextTeamChange)
		client:Spawn()
	end

	if not client.hasChosenTeam or client:Team() == 0 then
		if client:IsBot() then
			local teamId = math.random(1,2)
				fruit.SelectTeam(client, teamId)
				client:SetTeam(teamId)
				client:Spawn()
		end

		client:SetTeam( TEAM_SPECTATOR ) 

		fruit.ForceTeamSelect( client )
	end

	if not client:Team() == TEAM_SPECTATOR then
		fruit:PlayerLoadout( client )
	end

	client:SetModel( table.Random( ( fruit.useCustomModels and fruit.config.customModels[ client:Team() ] or fruit.config.models[ client:Team() ] ) ) )
	client:SetupHands()

	if fruit.defaultLoadout then
		for _, weapon in pairs(fruit.defaultLoadout) do
			client:Give(weapon)
		end
		fruit.PrintDebug("[DEBUG] ".. client:Name() .." has received their Default loadout.")
	end

	if fruit.teamBasedLoadout[client:Team()] then
		for _, wep in pairs(fruit.teamBasedLoadout[client:Team()]) do
				print(wep)
			client:Give(wep)
		end
		fruit.PrintDebug("[DEBUG] ".. client:Name() .." has received their Team based loadout.")
	end

	local userId = client:UserID()
	if fruit.player[userId] and fruit.player[userId].knife then
		client:setKnife(fruit.player[userId].knife)
	end
end

local teamToSpawnEnt = {
	[0] = "info_player_terrorist", 
	[TEAM_COUNTERTERRORISTS] = "info_player_counterterrorist",
	[TEAM_TERRORISTS] = "info_player_terrorist",
	[TEAM_SPECTATOR] = "info_player_terrorist",
}

function GM:PlayerSelectSpawn( client )
	if client:Team() == TEAM_SPECTATOR then return end


	local spawns = ents.FindByClass( teamToSpawnEnt and teamToSpawnEnt[ client:Team() ] or "info_player_counterterrorist" )
	local random_entry = math.random( #spawns )

	return spawns[ random_entry ]

end

function fruit.SelectTeam(client, teamId)
	if not fruit.teams[teamId] then fruit.PrintDebug( "[DEBUG]"..client:Name().." -> Attempted Invalid Team Request" ) return end

	if client.lastChosenTeamTime and (client.lastChosenTeamTime + CurTime()) < CurTime() then
		fruit.Notify(client, 1, 4, "You cannot select a team right now.")

		return
	end

	client.hasChosenTeam = true
	client.lastChosenTeamTime = CurTime()

	if fruit.RoundState and fruit.RoundState == ROUND_ACTIVE then
		client.NextTeamChange = teamId
		fruit.Notify(client, 2, 4, "You will be switched to "..team.GetName(teamId).. " when you next spawn.")
	else
		client:SetTeam(teamId)
		client:Spawn()
	end

	if not fruit.RoundState == ROUND_ACTIVE then
		client:Spawn()
	end

end

net.Receive( "fruit_SelectTeam", function( len, client )
		local teamId = net.ReadInt(4)
		fruit.SelectTeam(client, teamId)
end)