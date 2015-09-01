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

function fruit:PlayerInitialSpawn( client )
		fruit.PrintDebug( "[DEBUG] "..client:Name().." -> Connected" )
		client.hasChosenTeam = false
end

--[[
	Team Selection Stuff
]]--

function fruit.ForceTeamSelect( client )
	fruit.PrintDebug("[DEBUG] "..client:Name().." -> Selecting Team.")
	
	net.Start("fruit_TeamSelectMenu")
	net.Send( client )
end

function fruit:PlayerSpawn( client )
	if not client.hasChosenTeam or client:Team() == 0 then
		client:SetTeam( TEAM_SPECTATOR ) 
		fruit:PlayerSpawnAsSpectator( client )

		fruit.ForceTeamSelect( client )
	end
end

net.Receive( "fruit_SelectTeam", function( len, client )
	local teamId = net.ReadInt(4)

	if not fruit.teams[teamId] then fruit.PrintDebug( "[DEBUG]"..client:Name().." -> Attempted Invalid Team Request" ) return end

	if client.lastChosenTeamTime() + CurTime() < CurTime() then
		fruit.Notify(client, 1, 4, "You cannot select a team right now.")

		return
	end

	client:SetTeam(teamId)
	client.hasChosenTeam = true
	client.lastChosenTeamTime = CurTime()

end)