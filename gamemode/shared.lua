DeriveGamemode( "base" )

fruit = fruit or GM

fruit.version = "010915"

fruit.Name = "CS: Defuse [v"..fruit.version.."]"
fruit.Author = "Devul"
fruit.Email = "devultj@gmail.com"
fruit.Website = "devul.me"

AddCSLuaFile( "sh_util.lua" )
include( "sh_util.lua" )

function fruit:Initialize()
	print( "[GAMEMODE] "..self.Name.." initialised." )
end

fruit.util.Include( "sh_config.lua" )
fruit.util.IncludeInDir( "libs" )
fruit.util.IncludeInDir( "plugins" )

--[[
	Team Setup
]]--

fruit.teams = {}

local teamId = 0
local function createTeam( name, info )
	local teamData = info

	teamId = teamId + 1
	teamData.name = name

	team.SetUp( teamId, teamData.name, (teamData.color or Color( 0, 255, 0 )) )

	return table.insert( fruit.teams, teamId )
end

TEAM_COUNTERTERRORISTS = createTeam("Counter-Terrorists", {
	color = Color( 0, 100, 200, 255 )
})

TEAM_TERRORISTS = createTeam("Terrorists", {
	color = Color( 255, 191, 0, 255 )
})

TEAM_SPECTATOR = createTeam("Spectators", {
	color = Color(  100, 100, 100, 255 )
})
