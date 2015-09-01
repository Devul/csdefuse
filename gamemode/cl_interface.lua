surface.CreateFont( "fruit_TeamSelectTitle", {
	font = "Stratum2-Medium", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 42,
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

	local matWidth, matHeight = 538, 138
	print(self:GetWide(), matWidth)
	self.logo = self:Add("DImageButton")
	self.logo:SetPos( self:GetWide() / 2 - (matWidth /2), 0 )
	self.logo:SetSize( matWidth, matHeight )
	self.logo:SetMaterial( Material("logo_fixedwidth.png") )

	self.title = self:Add("DLabel")
	self.title:Dock(TOP)
	self.title:DockMargin(0, 118, 0, 0)

	self.title:SetText("Team Select")
	self.title:SetTextColor(color_white)
	self.title:SetFont("fruit_TeamSelectTitle")
	self.title:SetContentAlignment(5)
	self.title:SizeToContents()
end

function PANEL:Paint(pnl, w, h)
	Derma_DrawBackgroundBlur(self, 5)
end

derma.DefineControl( "fruit_TeamSelectMenu", "Team selection menu for CS: Defuse", PANEL, "DFrame" )

function fruit.TeamSelectMenu()
	local teamSelectFrame = vgui.Create("fruit_TeamSelectMenu")
end
concommand.Add("fruit_TeamSelectMenu", fruit.TeamSelectMenu)

net.Receive("fruit_TeamSelectMenu", function(len)
	fruit.TeamSelectMenu()
end)