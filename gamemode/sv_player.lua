local meta = FindMetaTable("Player")

fruit = fruit or {}
fruit.player = {}

util.AddNetworkString("setUpMoney")
util.AddNetworkString("sendMoneyChange")

function fruit.SetUpMoney( client )
	local userId = client:UserID()

	fruit.player[userId] = {}
	fruit.player[userId].money = 0

	net.Start("setUpMoney")
	net.Send( client )
end
hook.Add("PlayerInitialSpawn", "fruit.SetUpMoney", fruit.SetUpMoney)
concommand.Add("fruit_setUpMoney", fruit.SetUpMoney)

function meta:getMoney()
	local userId = self:UserID()

	return fruit and fruit.player[userId] and fruit.player[userId].money or false
end

function meta:setMoney( amount )
	local userId = self:UserID()

	if not fruit.player[userId] then
		fruit.SetUpMoney( self )
	end

	local clientMoney = self:getMoney()
	local maxMoney = GetConVar("fruit_cs_maxMoney"):GetInt() or 16000

	if amount + clientMoney > 16000 then
		amount = 16000
	end

	if amount < 0 then
		amount = 0
	end

	fruit.player[userId].money = amount

	net.Start("sendMoneyChange")
		net.WriteInt(amount, 16)
	net.Send( self )
end

function GM:DoPlayerDeath( client, attacker, dmg )
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetPos(client:GetPos())
	ragdoll:SetAngles(Angle(0,client:GetAngles().Yaw,0))
	local model = client:GetModel()
	if string.lower(model) == "models/player/corpse1.mdl" then
		model = "models/Humans/corpse1.mdl"
	end
	ragdoll:SetModel(model)
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	ragdoll:SetVelocity(client:GetVelocity())
	ragdoll.OwnerINT = client:EntIndex()
	ragdoll.PhysgunPickup = false
	ragdoll.CanTool = false
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	return (listener:Team() == talker:Team())
end