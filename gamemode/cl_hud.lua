
--[[---------------------------------------------------------------------------
Display notifications
- Credits to FPtje for DarkRP.notify functionality.
- SV: https://github.com/FPtje/DarkRP/blob/a54ed7c50a99a23d8d99305b1321590c2ead9eeb/gamemode/modules/base/sv_util.lua
- CL: https://github.com/FPtje/DarkRP/blob/a54ed7c50a99a23d8d99305b1321590c2ead9eeb/gamemode/modules/hud/cl_hud.lua#L366
---------------------------------------------------------------------------]]--
local function DisplayNotify(msg)
	local txt = msg:ReadString()
	notification.AddLegacy(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("buttons/lightswitch2.wav")

	-- Log to client console
	MsgC(Color(255, 20, 20, 255), "[NOTIFICATION] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

local gradient = Material("gui/gradient")

surface.CreateFont( "csgo_text", { font = "Stratum2 Medium", size = 40, antialias = true } )
surface.CreateFont( "csgo_punch", { font = "Stratum2 Medium", size = 32, antialias = true } )
surface.CreateFont( "csgo_inv", { font = "Stratum2 Medium", size = 28, antialias = true } )
surface.CreateFont( "kill_count", { font = "Stratum2 Medium", size = 18, antialias = true } )
surface.CreateFont("csgo_icons_small", { font = "csd", size = 64, weight = 400, amtialias = true } )

CreateConVar("fruit_hud_drawbars", 0, nil)

local cols = {
   frame_bg = Color( 0, 0, 0, 185 ),
   low_hp = Color( 255, 75, 75, 185 ),
   white = Color( 255, 255, 255, 255 ),
}

local hudPosY = 40

local function draw_CenterAlert()
   local rs = fruit.RoundState

   -- Round Over = rs 4
   -- Warmup = rs2
   -- wait = rs 1
    

   if rs == 0 then
      text = "WAITING FOR PLAYERS"
   elseif rs == 2 then
      text = "WARMING UP"
   elseif rs == 3 then
      text = "WAITING FOR PLAYERS"
   end

   if rs != 1 then

      surface.SetDrawColor( cols.frame_bg )
      surface.DrawRect( ScrW() /4, hudPosY, ScrW() /2, 42 )
      surface.SetMaterial( gradient )
      surface.DrawTexturedRect( ( ScrW() / 4 ) + ( ScrW() / 2 ), hudPosY, 100, 42 )
      surface.DrawTexturedRectRotated( (ScrW() / 4) - 50, hudPosY + 21, 100, 42, 180 )
      surface.DrawRect( ScrW() /4, hudPosY, ScrW() /2, 2 )
      surface.DrawRect( ScrW() /4, hudPosY + 40, ScrW() /2, 2 )
      surface.DrawTexturedRect( ( ScrW() / 4 ) + ( ScrW() / 2 ), hudPosY, 100, 2 )
      surface.DrawTexturedRect( ( ScrW() / 4 ) + ( ScrW() / 2 ), hudPosY + 40, 100, 2 )
      surface.DrawTexturedRectRotated( (ScrW() / 4) - 50, hudPosY + 1, 100, 2, 180 )
      surface.DrawTexturedRectRotated( (ScrW() / 4) - 50, hudPosY + 41, 100, 2, 180 )

      draw.SimpleText( text, "csgo_text", ScrW() /2, hudPosY + 21, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

   end

end

local PADDING, WIDTH, HALFWIDTH = 10, 16, 6
local BULLET_MATERIAL = Material("csgo_hud/bullet.png")
local LastBullet, SmoothingIn, smooth, Changedbullets, Flyingbullets = 5, false, 0, 0, {}
local function DrawBulletHud(bullets, x, y, red, scale)
    if scale then
       WIDTH = 16 * scale
       HALFWIDTH = 0.375 * WIDTH
    end
    if not bullets or bullets < 1 then return end
    if red then
        if LocalPlayer():GetRole() == ROLE_TRAITOR or LocalPlayer().IsGhost and LocalPlayer():IsGhost() then
        surface.SetDrawColor(255,255,255,255)
        else
        surface.SetDrawColor(255,75,75,255)
        end
    end
    
    if LastBullet != bullets then
        Changedbullets = math.min(bullets, 5 - (LastBullet - bullets))
        if bullets > LastBullet then 
            Changedbullets = 4 
        else
            if Flyingbullets[1] then
                for k, v in pairs(Flyingbullets) do
                    Flyingbullets[k] = v - 0.05
                end
                table.insert(Flyingbullets, 0.25)
            else
               Flyingbullets[1] = 0.25
            end
        end
        if not SmoothingIn then
           SmoothingIn = true
        end 
        LastBullet = bullets
    end
    bullets = math.min(bullets, 5)
    --if SmoothingIn then bullets = bullets - 1 end
 
    local xpos = x + 30 + PADDING + 1000
    surface.SetMaterial(BULLET_MATERIAL)
    
    
    if SmoothingIn then
        smooth = math.Approach(smooth, 1, 3 * FrameTime())
        
        for i = 1, Changedbullets do
            surface.DrawTexturedRect(xpos - (i + 1) * HALFWIDTH + (smooth * HALFWIDTH), y, WIDTH, WIDTH) 
        end
        
        if bullets == 5 then

            local role_text = LocalPlayer():GetRoleStringRaw()

            if LocalPlayer().IsGhost and LocalPlayer():IsGhost() then
            surface.SetDrawColor(specdmcol.r, specdmcol.g, specdmcol.b, smooth * 255)
            else
            surface.SetDrawColor(textcol[role_text].r, textcol[role_text].g, textcol[role_text].b, smooth * 255)
            end
  
            surface.DrawTexturedRect(xpos - 48 + (smooth * 18), y, WIDTH, WIDTH)

            if LocalPlayer().IsGhost and LocalPlayer():IsGhost() then
              surface.SetDrawColor(specdmcol)
            else
              surface.SetDrawColor(textcol[role_text])
            end

        end
        
        if smooth == 1 then
           smooth, SmoothingIn = 0, false
        end
    else
        for i = 1, bullets do
            surface.DrawTexturedRect(xpos - i * HALFWIDTH, y, WIDTH, WIDTH) 
        end
    end
    
    for k, v in pairs (Flyingbullets) do
        Flyingbullets[k] = v - FrameTime()
        if v < 0 then Flyingbullets[k] = nil continue end
        surface.DrawTexturedRectRotated(xpos + HALFWIDTH * k, y + HALFWIDTH + k * 3, WIDTH, WIDTH, k * -15) 
    end
    for i = 5, 1, -1 do
        if Flyingbullets[i] and Flyingbullets[i] < 0.25 - i * 0.05 then
            Flyingbullets[i + 1] = Flyingbullets[i]
            Flyingbullets[i] = nil
        end
    end
end

function csgo_bullet_hud()
if( !IsValid( LocalPlayer() ) or !IsValid( LocalPlayer():GetActiveWeapon() ) ) then return end

    local wep = LocalPlayer():GetActiveWeapon();
    local clip = wep:Clip1() or 0;
    local maxammo = LocalPlayer():GetActiveWeapon().Primary.ClipSize
    local red = clip <= math.ceil(maxammo / 7)

    local role_text = team.GetName(LocalPlayer():Team())

    if LocalPlayer().IsGhost and LocalPlayer():IsGhost() then
      surface.SetDrawColor(specdmcol)
    else
      surface.SetDrawColor(Color(255, 255, 255, 255))
    end

    DrawBulletHud( clip, ScrW() - 1085, ScrH() - 27, red, 1.0 )

end


valuemath = 0
local function draw_Bar( x, y, w, h, col, col_low, value, lowval )

   if value <= lowval then
      surface.SetDrawColor( cols.white )
   else
      surface.SetDrawColor( col )
   end

   surface.DrawLine( x, y, x + w, y )
   surface.DrawLine( x, y + h, x + w, y + h )
   surface.DrawLine( x, y, x, y + h )
   surface.DrawLine( x + w, y, x + w, y + h )

   valuemath = math.Approach( valuemath, value, 100*FrameTime() )

   boxwidth = (w - 3) * (valuemath/100)

   surface.DrawRect( x+2, y+2, boxwidth, h-3)
end

local function draw_Health()

   local pl = LocalPlayer()
   local hp = pl:Health()
   local sh = ScrH()
   local role_text = team.GetName(LocalPlayer():Team())

   local polygon = {

      { x = 0, y = sh - 8 },
      { x = 0, y = sh - 42 },
      { x = 12, y = sh - 42 },
      { x = 12, y = sh }

   }

   local polygon_ang = {

      { x = 0, y = sh - 8 },
      { x = 2, y = sh - 8 }, 
      { x = 12, y = sh - 2 },
      { x = 12, y = sh }

   }

   if hp <= 15 then
      surface.SetDrawColor( cols.low_hp )
   else
      surface.SetDrawColor( cols.frame_bg )
   end
   
   if pl:GetNWFloat("w_stamina") and pl:GetNWFloat("w_stamina") != 0 then
      frame_width = 318
   else
      frame_width = 188
   end

   xpos = 12
   edgepos = xpos + frame_width

   draw.NoTexture()
   surface.DrawPoly( polygon )
   surface.DrawRect( xpos, sh - 42, frame_width, 42) -- Big box

   surface.SetMaterial( gradient )
   surface.DrawTexturedRect( edgepos, sh - 42, 100, 42 ) -- BG Gradient
   
   if LocalPlayer().IsGhost and LocalPlayer():IsGhost() then
      surface.SetDrawColor(specdmcol)  
   elseif hp <= 15 then
      surface.SetDrawColor( cols.low_hp )
   else
      surface.SetDrawColor( Color(0, 0, 0, 150) )
   end

   surface.DrawRect( 0, sh - 40, 2, 32 ) -- Left Vertical
   surface.DrawRect( 0, sh - 42, edgepos, 2 ) -- Top Horizontal
   surface.DrawRect( xpos, sh - 2, frame_width, 2 ) -- Top Horizontal
   draw.NoTexture()
   surface.DrawPoly( polygon_ang )

   surface.SetMaterial( gradient )
   surface.DrawTexturedRect( edgepos, sh - 42, 100, 2 ) -- gradient frame upper
   surface.DrawTexturedRect( edgepos, sh - 2, 100, 2 ) -- gradient frame lower

   if hp <= 15 then
      surface.SetDrawColor( cols.white )
      num_col = cols.white
   else
      surface.SetDrawColor( Color(255, 255, 255, 255) )
      num_col = Color(255, 255, 255, 255) 
   end

   local health_tex = Material( "csgo_hud/health_symbol.png" )
   surface.SetMaterial( health_tex )
   surface.DrawTexturedRect( 14, sh - 27, 17, 17 )

   player_health = math.Clamp( hp, 0 , 100)

   draw.SimpleText( player_health, "csgo_text", 82, sh - 40, num_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )

	if GetConVar("fruit_hud_drawbars"):GetBool() then
		draw_Bar( 90, sh - 26, 110, 18, num_col, white, math.Clamp( hp, 0, 100 ), 15 )
	end
end

function fruit.DrawHUD()
	draw_CenterAlert()
	draw_Health()
	csgo_bullet_hud()

end
hook.Add("HUDPaint", "fruit.DrawHUD", fruit.DrawHUD)

-- Hide the standard HUD stuff
local hud = {"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}
function GM:HUDShouldDraw(name)
   for k, v in pairs(hud) do
      if name == v then return false end
   end

   return true
end

