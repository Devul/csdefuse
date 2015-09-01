
--[[---------------------------------------------------------------------------
Display notifications
- Credits to FPtje for DarkRP.notify functionality.
- SV: https://github.com/FPtje/DarkRP/blob/a54ed7c50a99a23d8d99305b1321590c2ead9eeb/gamemode/modules/base/sv_util.lua
- CL: https://github.com/FPtje/DarkRP/blob/a54ed7c50a99a23d8d99305b1321590c2ead9eeb/gamemode/modules/hud/cl_hud.lua#L366
---------------------------------------------------------------------------]]--
function fruit.Notify(ply, msgtype, len, msg)
	umsg.Start("_Notify", ply)
		umsg.String(msg)
		umsg.Short(msgtype)
		umsg.Long(len)
	umsg.End()
end