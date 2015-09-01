GRust = GRust or GM

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

GRust.Loadout = { "weapon_physcannon" }

CreateConVar( "GRust_DebugMode", 1, FCVAR_NOTIFY, "int boolean (0 = false, 1 = true)" )
GRust.DebugMode = GetConVar( "GRust_DebugMode" )

function GRust.PrintDebug( any )
	if tobool( GRust.DebugMode ) then 
		return print( any )
	end
end

function GRust:PlayerLoadout( client )
	for _, weapon in pairs( GRust.Loadout ) do
		client:Give( weapon )
	end
	
	GRust.PrintDebug( "[DEBUG] "..client:Name().." -> Loadout Assigned" )
end

function GRust:PlayerInitialSpawn( client )
		GRust.PrintDebug( "[DEBUG] "..client:Name().." -> Connected" )
end