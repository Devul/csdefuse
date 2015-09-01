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
end

function fruit:PlayerSpawn( ply )
	if ply:Team() == 0 then
		ply:SetTeam( TEAM_SPECTATOR ) 
		fruit:PlayerSpawnAsSpectator( ply )
	end
end