surface.CreateFont( "fruit_TeamSelectTitle", {
	font = "Stratum2-Medium", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 64,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "fruit_TeamSelectSubTitle", {
	font = "Stratum2-Medium", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 48,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:MakePopup()

	self:SetTitle("") 
	self:ShowCloseButton(true) -- Will be false when fully implemented
	self:InvalidateParent(true) -- Allow GetSize to be called on docked elements.
	self:SetDraggable(false)

	local matWidth, matHeight = 1920, 1080
	self.logo = self:Add("DImageButton")
	self.logo:SetPos( 0, 0 )
	self.logo:SetSize( self:GetWide(), self:GetTall() )
	self.logo:SetMaterial( Material("background.jpg") )

	self.header = self:Add("Panel")
	self.header:Dock(TOP)
	self.header:SetTall(self:GetTall() / 8)
	self.header.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, pnl:GetTall() - 2, w, 2, Color(0, 0, 0, 255))
	end

	self.title = self.header:Add("DLabel")
	self.title:Dock(BOTTOM)
	self.title:DockMargin(256, 0, 0, 0)

	self.title:SetText("CHOOSE TEAM")
	self.title:SetTextColor(color_white)
	self.title:SetFont("fruit_TeamSelectTitle")
	self.title:SetContentAlignment(1)
	self.title:SizeToContents()

	self.footer = self:Add("Panel")
	self.footer:Dock(BOTTOM)
	self.footer:SetTall(self:GetTall() / 8)
	self.footer.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, 2, Color(0, 0, 0, 255))
	end

	self.cancel = self.footer:Add("DButton")
	self.cancel:SetPos(256, 8)
	self.cancel:DockMargin(256, -64, 0, 0)

	self.cancel:SetText("Cancel")
	self.cancel:SetTextColor(color_white)
	self.cancel:SetFont("fruit_TeamSelectSubTitle")
	self.cancel:SizeToContents()

	self.cancel.Paint = function(pnl, w, h)
	end
	self.cancel.DoClick = function()
		self:Remove()
	end

	self.autoSelect = self.footer:Add("DButton")
	self.autoSelect:Dock(TOP)
	self.autoSelect:DockMargin(0, 8, 0, 0)

	self.autoSelect:SetText("Auto select")
	self.autoSelect:SetTextColor(color_white)
	self.autoSelect:SetFont("fruit_TeamSelectSubTitle")
	self.autoSelect:SetContentAlignment(5)
	self.autoSelect:SizeToContents()

	self.autoSelect.Paint = function(pnl, w, h)
	end
	self.autoSelect.DoClick = function()
		self:Remove()
	end

	surface.SetFont("fruit_TeamSelectSubTitle")
	local width, height = surface.GetTextSize("Spectate")

	self.spectate = self.footer:Add("DButton")
	self.spectate:SetPos(self:GetWide() - width - 256, 8)
	self.spectate:DockMargin(0, 8, 0, 0)

	self.spectate:SetText("Spectate")
	self.spectate:SetTextColor(color_white)
	self.spectate:SetFont("fruit_TeamSelectSubTitle")
	self.spectate:SetContentAlignment(9)
	self.spectate:SizeToContents()

	self.spectate.Paint = function(pnl, w, h)
	end
	self.spectate.DoClick = function()
		self:Remove()
	end
	self.filler = self:Add("DPanel")
	self.filler:Dock(FILL)
	self.filler:InvalidateParent(true)

	self.filler.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,255))
	end

	self.container = self.filler:Add("DPanel")
	self.container:Dock(FILL)
	self.container:DockMargin(256, 8, 256, 48)
	self.container:InvalidateParent(true)
	self.container.Paint = function(pnl, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
	end

	local ctWidth, ctHeight = surface.GetTextSize("Counter-Terrorists")
	self.leftHeader = self.container:Add("DLabel")
	self.leftHeader:SetPos(self.container:GetWide() / 4 - 8 - (ctWidth / 2), 4)

	self.leftHeader:SetText("Counter-Terrorists")
	self.leftHeader:SetTextColor(Color(0, 100, 200, 15))
	self.leftHeader:SetFont("fruit_TeamSelectSubTitle")
	self.leftHeader:SetContentAlignment(5)
	self.leftHeader:SizeToContents()

	self.leftContainer = self.container:Add("DButton")
	self.leftContainer:Dock(LEFT)
	self.leftContainer:SetText("")
	self.leftContainer:SetWide(self.container:GetWide() / 2 - 8)
	self.leftContainer:DockMargin(4, 56, 4, 4)

	local ctMaterial = Material("background_ct.jpg")
	self.leftContainer.Paint = function(pnl, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( ctMaterial	) -- If you use Material, cache it!
		surface.DrawTexturedRect( -512, -256, 1920, 1080 )

		draw.OutlinedBox(0, 0, w, h, 4, color_white)
	end

	self.leftContainer.DoClick = function()
		net.Start("fruit_SelectTeam")
			net.WriteInt(1, 4)
		net.SendToServer()

		self:Remove()
	end

	local tWidth, tWidth = surface.GetTextSize("Terrorists")
	self.rightHeader = self.container:Add("DLabel")
	self.rightHeader:SetPos(self.container:GetWide() * 0.75 - 10 - (tWidth), 4)

	self.rightHeader:SetText("Terrorists")
	self.rightHeader:SetTextColor(Color(255, 190, 0, 5))
	self.rightHeader:SetFont("fruit_TeamSelectSubTitle")
	self.rightHeader:SetContentAlignment(5)
	self.rightHeader:SizeToContents()

	local tMaterial = Material("background.jpg")
	self.rightContainer = self.container:Add("DButton")
	self.rightContainer:Dock(RIGHT)
	self.rightContainer:SetText("")
	self.rightContainer:SetWide(self.container:GetWide() / 2 - 8)
	self.rightContainer:DockMargin(4, 56, 4, 4)
	self.rightContainer.Paint = function(pnl, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( tMaterial	) -- If you use Material, cache it!
		surface.DrawTexturedRect( -800, -256, 1920, 1080 )

		draw.OutlinedBox(0, 0, w, h, 4, color_white)
	end


	self.rightContainer.DoClick = function()
		net.Start("fruit_SelectTeam")
			net.WriteInt(2, 4)
		net.SendToServer()

		self:Remove()
	end
end

function PANEL:Paint(pnl, w, h)
	Derma_DrawBackgroundBlur(self, 5)
end

function PANEL:Think()
	if self.leftContainer:IsHovered() then
		self.leftHeader:SetTextColor(Color(0, 100, 200, 255))
	else
		self.leftHeader:SetTextColor(Color(0, 100, 200, 15))
	end

	if self.rightContainer:IsHovered() then
		self.rightHeader:SetTextColor(Color(255, 190, 0, 255))
	else
		self.rightHeader:SetTextColor(Color(255, 190, 0, 5))
	end
end

derma.DefineControl( "fruit_TeamSelectMenu", "Team selection menu for CS: Defuse", PANEL, "DFrame" )

local teamSelectFrame
function fruit.TeamSelectMenu()
	teamSelectFrame = vgui.Create("fruit_TeamSelectMenu")
end
concommand.Add("fruit_TeamSelectMenu", fruit.TeamSelectMenu)

net.Receive("fruit_TeamSelectMenu", function(len)
	fruit.TeamSelectMenu()
end)

hook.Add("Think", "OpenTeamMenu", function(client, key)
	if LocalPlayer():IsTyping() then return end

	if input.IsKeyDown( KEY_M ) and not IsValid(teamSelectFrame) then
		fruit.TeamSelectMenu()
	end
end)