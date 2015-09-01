local playerData = playerData or {}

local meta = FindMetaTable("Player")

function meta:setMoney( amount )
	if not amount then amount = 0 end
	if amount < 1 or amount > GetConVar("fruit_cs_maxMoney"):GetInt() then return end

	playerData = playerData or {}
	playerData.money = amount
end

function meta:getMoney( amount )
	return playerData and playerData.money or false
end

net.Receive("setUpMoney", function(len)
	LocalPlayer():setMoney()
end)

net.Receive("sendMoneyChange", function(len)
	local amount = net.ReadInt(16)

	LocalPlayer():setMoney( amount )
end)