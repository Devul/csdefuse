
function fruit.TeamSelectMenu()
	print("Team Select Menu Called")
end

net.Receive("fruit_TeamSelectMenu", function(len)
	fruit.TeamSelectMenu()
end)