local playerData = playerData or {}

function setMoney( amount )
	if not amount then amount = 0 end
	if amount < 1 or amount > GetConVar("fruit_cs_maxMoney"):GetInt() then return end

	playerData = playerData or {}
	playerData.money = amount
end

function getMoney( amount )
	return playerData and playerData.money or 0
end

net.Receive("setUpMoney", function(len)
	setMoney()
end)

net.Receive("sendMoneyChange", function(len)
	local amount = net.ReadInt(16)

	setMoney( amount )
end)


--[[-------------------------------------------------------------------------
	Turn cash into a nice string.
---------------------------------------------------------------------------]]
local function attachMoneyPrefix(str)
	local config = fruit.config
	return config.currencyStr and config.currencyStr .. str or str .. config.currencyStr
end

function fruit.formatMoney(n)
	if not n then return attachMoneyPrefix("0") end

	if n >= 1e14 then return attachMoneyPrefix(tostring(n)) end

	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1

	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
	end

	return attachMoneyPrefix(n)
end
