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

function fruit.ForceTeamSelect( client )
	fruit.PrintDebug("[DEBUG] "..client:Name().." is selecting a Team.")
	
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