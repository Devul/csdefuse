fruit = fruit or GM

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

fruit.Loadout = { "weapon_physcannon" }

CreateConVar( "fruit_DebugMode", 1, FCVAR_NOTIFY, "int (0 = false, 1 = true)" )
fruit.DebugMode = GetConVar( "fruit_DebugMode" )

fruit.isInitialized = false

fruit.inRound = false
fruit.inWarmup = false
fruit.inHalfTime = false
fruit.isFinished = false

util.AddNetworkString("fruit_TeamSelectMenu")
util.AddNetworkString("fruit_SelectTeam")
 
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

function fruit.BeginRound()
	fruit.RoundState = ROUND_ACTIVE
end

function fruit:PlayerInitialSpawn( client )
		fruit.PrintDebug( "[DEBUG] "..client:Name().." -> Connected" )
		client.hasChosenTeam = false

	if #player.GetAll() > 1 and fruit.RoundState == 0 then
		fruit.BeginRound()
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

local models = {
	[TEAM_COUNTERTERRORISTS] = {"models/player/urban.mdl"},
	[TEAM_TERRORISTS] = {"models/player/leet.mdl"},
	[TEAM_SPECTATOR] = {"models/gman_high.mdl"},
}

function GM:PlayerSpawn( client )
	print("PLayer Is Spawn")
	print(client.NextTeamChange)

	if client.NextTeamChange then
		client:SetTeam(client.NextTeamChange)
		client:Spawn()
	end

	if not client.hasChosenTeam or client:Team() == 0 then
		client:SetTeam( TEAM_SPECTATOR ) 
	--	fruit:PlayerSpawnAsSpectator( client )

		fruit.ForceTeamSelect( client )
	end

	if not client:Team() == TEAM_SPECTATOR then
		fruit:PlayerLoadout( client )
	end

	client:SetModel( table.Random( models[ client:Team() ] ) )

	if fruit.defaultLoadout then
		for _, weapon in pairs(fruit.defaultLoadout) do
			client:Give(weapon)
		end
		fruit.PrintDebug("[DEBUG] ".. client:Name() .." has received their loadout.")
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

	local spawns = ents.FindByClass( teamToSpawnEnt[ client:Team() ] )
	local random_entry = math.random( #spawns )

	return spawns[ random_entry ]

end

net.Receive( "fruit_SelectTeam", function( len, client )
	local teamId = net.ReadInt(4)

	if not fruit.teams[teamId] then fruit.PrintDebug( "[DEBUG]"..client:Name().." -> Attempted Invalid Team Request" ) return end

	if client.lastChosenTeamTime and (client.lastChosenTeamTime + CurTime()) < CurTime() then
		fruit.Notify(client, 1, 4, "You cannot select a team right now.")

		return
	end

	client.hasChosenTeam = true
	client.lastChosenTeamTime = CurTime()

	if fruit.RoundState == ROUND_ACTIVE then
		client.NextTeamChange = teamId
		fruit.Notify(client, 2, 4, "You will be switched to "..team.GetName(teamId).. " when you next spawn.")
	else
		client:SetTeam(teamId)
		client:Spawn()
	end

	if not fruit.RoundState == ROUND_ACTIVE then
		client:Spawn()
	end
end)