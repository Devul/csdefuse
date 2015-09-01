fruit.util = fruit.util or {}

function fruit.util.Include( dir, typ )
	if ( !dir ) then return end
	dir = dir:lower( )
	if ( SERVER and ( typ == "SERVER" or dir:find( "sv_" ) ) ) then 
		include( dir )
	elseif ( typ == "CLIENT" or dir:find( "cl_" ) ) then
		if ( SERVER ) then 
			AddCSLuaFile( dir )
		else 
			include( dir )
		end
	elseif ( typ == "SHARED" or dir:find( "sh_" ) ) then
		AddCSLuaFile( dir )
		include( dir )
	end
end

function fruit.util.IncludeInDir( dir )
	if not dir then return end
	local dir2 = "cs_defuse/gamemode/" .. dir .. "/*.lua"
	for k, v in pairs( file.Find( dir2, "LUA" ) ) do
		fruit.util.Include( dir .. "/" .. v )
	end
end