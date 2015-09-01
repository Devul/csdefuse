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
	print("[GAMEMODE] "..self.Name.." initialised.")
end

fruit.util.Include( "sh_config.lua" )
fruit.util.IncludeInDir( "libs" )
fruit.util.IncludeInDir( "plugins" )

--[[
	Team Setup
]]--

team.SetUp( 1, "Counter-Terrorists", Color( 0, 100, 200, 255 ))
team.SetUp( 2, "Terrorists", Color( 255, 191, 0, 255 ))