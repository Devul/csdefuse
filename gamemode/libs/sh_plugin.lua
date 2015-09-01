fruit.plugin = fruit.plugin or { Lists = { } }

function fruit.plugin.LoadAll( dir )
	local _, folders = file.Find( dir .. "/gamemode/plugins/*", "LUA" )

	for k, v in pairs( folders ) do
		PLUGIN = fruit.plugin.Get( v ) or { }
		
		if not PLUGIN.name then PLUGIN.name = "Empty" end
		
		local Pdir = dir .. "/gamemode/plugins/" .. v
		
		if ( file.Exists( Pdir .. "/sh_plugin.lua", "LUA" ) ) then
			fruit.util.Include( Pdir .. "/sh_plugin.lua" )
			
			for k1, v1 in pairs( file.Find( Pdir .. "/derma/*.lua", "LUA" ) ) do
				fruit.util.Include( Pdir .. "/derma/" .. v1 )
			end
			
			for k1, v1 in pairs( file.Find( Pdir .. "/libs/*.lua", "LUA" ) ) do
				fruit.util.Include( Pdir .. "/libs/" .. v1 )
			end
			
			fruit.plugin.Lists[ v ] = PLUGIN
			MsgC(Color(0,200,0), "[fruit-Plugin] "..PLUGIN.name.." loaded.\n")
		end
		
		PLUGIN = nil
	end
end

function fruit.plugin.Get( id )
	return fruit.plugin.Lists[ id ]
end

function fruit.plugin.GetAll( )
	return fruit.plugin.Lists
end

fruit.plugin.LoadAll( fruit.FolderName )