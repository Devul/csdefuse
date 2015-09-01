
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
   local timeLeft = fruit.RoundState == ROUND_INTRO and timer.TimeLeft("IntroTimer") or fruit.RoundState == ROUND_OUTRO and timer.TimeLeft("OutroTimer") or timer.TimeLeft("RoundTimer")

   -- Round Over = rs 4
   -- Warmup = rs2
   -- wait = rs 1
    

  if rs == ROUND_INTRO then
      text = "ROUND STARTING"
  elseif rs == ROUND_WARMINGUP then
      text = "WARMING UP"
  elseif rs == ROUND_WAITINGFORPLAYERS then
      text = "WAITING FOR PLAYERS"
  elseif rs == ROUND_ACTIVE then
      text = "ROUND ACTIVE"
  elseif rs == ROUND_OUTRO then
      text = "ROUND ENDED"
   end

   if rs != 0 then

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
      draw.SimpleText( string.ToMinutesSeconds( timeLeft ), "csgo_text", ScrW() /2, hudPosY - 21, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

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
     
    surface.SetDrawColor(255,255,255,255)
    
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

            local role_text = team.GetName(LocalPlayer():Team())

            surface.SetDrawColor(255, 255, 255, smooth * 255)
            surface.DrawTexturedRect(xpos - 48 + (smooth * 18), y, WIDTH, WIDTH)
            surface.SetDrawColor(255, 255, 255, 255)

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
	local maxammo = LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()) or 0
    local red = clip <= math.ceil(maxammo / 7)

    local role_text = team.GetName(LocalPlayer():Team())

    surface.SetDrawColor(Color(255, 255, 255, 255))

    DrawBulletHud( clip, ScrW() - 1085, ScrH() - 27, red, 1.0 )
end

local csgo_classes = {}

local function draw_WeaponSection() -- Section not selection XD

   local pl = LocalPlayer()
   local hp = pl:Health()
   local sw = ScrW()
   local sh = ScrH()
   local role_text = team.GetName(pl:Team())

   local polygon = {

      { x = sw - 12, y = sh },
      { x = sw - 12, y = sh - 42 },
      { x = sw , y = sh - 42 },
      { x = sw , y = sh - 8 }
   
   }

   local polygon_ang = {

      { x = sw - 12, y = sh },
      { x = sw - 12, y = sh - 2 },
      { x = sw - 2, y = sh - 8 },
      { x = sw, y = sh - 8 }

   }

   -- Background
   surface.SetDrawColor( cols.frame_bg )
   draw.NoTexture()
   surface.DrawPoly( polygon )

   surface.DrawRect( sw - 200, sh - 42, 188, 42 )
   surface.SetMaterial( gradient )

   surface.DrawTexturedRectRotated( sw - 250, sh - 21, 100, 42, 180 )

   surface.SetDrawColor( Color(0,0,0,100) )
   draw.NoTexture()
   surface.DrawPoly( polygon_ang ) -- Frame Angle

   surface.DrawRect( sw - 200, sh - 2, 188, 2 ) -- Bottom Line
   surface.DrawRect( sw - 2, sh - 40, 2, 32 ) -- Right line
   surface.DrawRect( sw - 200, sh - 42, 200, 2 ) -- Top line

   surface.SetMaterial( gradient )
   surface.DrawTexturedRectRotated( sw - 250, sh - 41, 100, 2, 180 ) -- top gradient
   surface.DrawTexturedRectRotated( sw - 250, sh - 1, 100, 2, 180 ) -- bottom gradient

    curcol = Color(255, 255, 255, 255)   

   if pl:GetActiveWeapon() then

    local wep = LocalPlayer():GetActiveWeapon();
    if not wep then return end

    local ammo_clip = wep.Clip1 and wep:Clip1() or 0;
	local ammo_max = LocalPlayer():GetAmmoCount(wep.GetPrimaryAmmoType and wep:GetPrimaryAmmoType() or 0) or 0

      if ammo_clip != -1 then

         draw.SimpleText( ammo_clip, "csgo_text", sw - 150, sh-38, curcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
         draw.SimpleText( "/  "..ammo_max, "csgo_inv", sw - 140, sh-30, curcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
         csgo_bullet_hud()

      else

         local classname = pl:GetActiveWeapon():GetClass()

         if csgo_classes[classname] then
            local classmat = Material(csgo_classes[classname])
            surface.SetDrawColor(curcol)
            surface.SetMaterial(classmat)
            surface.DrawTexturedRect(sw - 150, sh - 50 , 128, 128)
           -- print(" THERE SHOULD BE A ICON MATERIAL HERE")
         end
      end      

   end

  local kills = pl:GetNWInt("Tkills")
  local killicon = Material("csgo_hud/killicon.png")
  
  surface.SetDrawColor(Color(255,255,255,255))
  surface.SetMaterial(killicon)

  local xpos = ScrW()
  local ypos = ScrH() - 38
  
  if kills == 1 then
    surface.DrawTexturedRect(xpos-240, ypos, 32, 32)
  elseif kills == 2 then
    surface.DrawTexturedRect(xpos-240, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-260, ypos, 32, 32)
    elseif kills == 3 then
    surface.DrawTexturedRect(xpos-240, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-260, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-280, ypos, 32, 32)
    elseif kills == 4 then
    surface.DrawTexturedRect(xpos-240, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-260, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-280, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-300, ypos, 32, 32)
    elseif kills == 5 then
    surface.DrawTexturedRect(xpos-240, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-260, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-280, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-300, ypos, 32, 32)
    surface.DrawTexturedRect(xpos-320, ypos, 32, 32)
    elseif kills > 5 then
    surface.DrawTexturedRect(xpos-240, ypos, 32, 32)
    draw.SimpleText("x"..kills, "kill_count", xpos-220, ypos + 8, Color(255,255,255,255), TEXT_ALIGN_LEFT )

  end


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
   
  if hp <= 15 then
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

local function draw_Money()

   local pl = LocalPlayer()
   local hp = pl:Health()
   local sh = ScrH() * 0.2
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
   
  if hp <= 15 then
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

   local health_tex = Material( "csgo_hud/shoppingcart.png", "smooth mips" )
   surface.SetMaterial( health_tex )
   surface.DrawTexturedRect( 14, sh - 30, 20, 20 )

   money = fruit.formatMoney(getMoney())

   draw.SimpleText( money, "csgo_text", 42, sh - 40, num_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT )

  if GetConVar("fruit_hud_drawbars"):GetBool() then
    draw_Bar( 90, sh - 26, 110, 18, num_col, white, math.Clamp( hp, 0, 100 ), 15 )
  end
end

function fruit.DrawHUD()
	draw_CenterAlert()
	draw_Health()
	draw_WeaponSection()
  draw_Money()

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

net.Receive("fruit_StartRound", function(len)

  timer.Remove("IntroTimer")
  timer.Remove("RoundTimer")
  timer.Remove("OutroTimer")
  timer.Remove("TickRoundTimer")
  timer.Remove("TickOutroFiveTimes")

  fruit.RoundState = ROUND_INTRO
  timer.Create("IntroTimer", fruit.config.RoundIntroTime or 5, 1, function()
      fruit.RoundState = ROUND_ACTIVE

      surface.PlaySound("music/valve_csgo_01/startround_0"..math.random(1, 2)..".mp3")
      timer.Create("TickRoundTimer", (fruit.config.RoundLength or 120) - 5, 1, function() timer.Create("TickOutroFiveTimes", 1, 5, function() surface.PlaySound("buttons/button14.wav") end) end)

    timer.Create("RoundTimer", fruit.config.RoundLength or 120, 1, function()
        fruit.RoundState = ROUND_OUTRO
      timer.Create("OutroTimer", fruit.config.RoundOutroTime or 5, 1, function()
        --do nout
      end)
    end)
  end)

end)

net.Receive("fruit_UpdateScore", function(len)
  local ScoreCT = net.ReadInt(8)
  local ScoreT = net.ReadInt(8)

  local winner = net.ReadInt(8)

  if winner == TEAM_TERRORISTS then
    surface.PlaySound("radio/terwin.wav")
  elseif winner == TEAM_COUNTERTERRORISTS then
    surface.PlaySound("radio/ctwin.wav")
  else
    surface.PlaySound("radio/rounddraw.wav")
  end

  timer.Remove("IntroTimer")
  timer.Remove("RoundTimer")

  timer.Create("OutroTimer", fruit.config.RoundOutroTime or 5, 1, function()
  end)

  SCORE_CT = ScoreCT
  SCORE_T = ScoreT

  LocalPlayer():ChatPrint("Score is now "..SCORE_CT..":"..SCORE_T)
end)