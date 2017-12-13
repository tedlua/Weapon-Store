    -------------------------------------------------------
    local PLUGIN = PLUGIN or {

    }

    PLUGIN.Developer = 'ted.lua'
    PLUGIN.Profile = 'http://steamcommunity.com/id/tedlua/'
    PLUGIN.Date = '12/10/17'
    -------------------------------------------------------

    if !DrawManager then DrawManager = {} end

    MsgC( Color( 255, 0, 0 ), '[Start Up]; Initing Store. Loading client-side functions!\n' )

    if !CLIENT then return end

    surface.CreateFont( "DrawManager.CloseButton.Generic", { font = "Terminal", size = 24, weight = 800 } )

    function DrawManager.CreateDFrame( w, h, title, draggable, closeButton, popup )
        local self = vgui.Create( "DFrame" )
        self:SetSize( w, h )
        self:SetTitle( title )
        self:SetDraggable( draggable or false )
        self:ShowCloseButton( closeButton or false )
        self:Center()
        if popup then self:MakePopup() end
        return self
    end

    function DrawManager.CreateDButton( parent, x, y, w, h, txt, font, hover, colorContent, func )
        if IsValid( parent ) and ispanel( parent ) then
            local self = vgui.Create( "DButton", parent )
            self:SetPos( x, y )
            self:SetSize( w, h )
            self:SetText( txt )
            self:SetFont( font )
            self:SetTextColor( colorContent.textColor )

            if hover then
                self.IsHovering = false
                self.OnCursorEntered = function()
                    self.IsHovering = true
                end
                self.OnCursorExited = function()
                    self.IsHovering = false
                end
            end
            self.Paint = function( btn, w, h )
                if !self.IsHovering then
                    DrawManager.DrawRect( 0, 0, w, h, colorContent.bg )
                else
                    DrawManager.DrawRect( 0, 0, w, h, colorContent.hoverColor )
                end
            end
            self.DoClick = func
            return self
        end
    end

    function DrawManager.DrawRect( x, y, w, h, col )
        surface.SetDrawColor( col )
        surface.DrawRect( x, y, w, h )
    end

    function DrawManager.DrawRoundedBox( rad, x, y, w, h, col )
        draw.RoundedBox( rad, x, y, w, h, col )
    end

    function DrawManager.DrawText( msg, fnt, x, y, c, align )
        draw.SimpleText( msg, fnt, x, y, c, align and align or TEXT_ALIGN_CENTER )
    end

    function DrawManager.DrawOutlinedRect( x, y, w, h, t, c )
       surface.SetDrawColor( c )
       for i = 0, t - 1 do
           surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
       end
    end

    function DrawManager.CreateCloseButton( parent, x, y, w, h, paint )
        if IsValid( parent ) and parent:IsVisible() then
            local close = vgui.Create( "DLabel", parent )
            close:SetPos( x, y )
            close:SetSize( w, h )
            close:SetMouseInputEnabled( true )
            close:SetText( "" )
            close:SetCursor( "hand" )
            close.DoClick = function()
                parent:SetVisible( false )
            end

            close.IsHovering = false

            close.OnCursorEntered = function()
                close.IsHovering = true
            end
            close.OnCursorExited = function()
                close.IsHovering = false
            end

            close.Paint = function( btn, w, h )
                if !close.IsHovering then
                    DrawManager.DrawRect( 0, 0, 40, 20, Color( 178, 34, 34 ) )
                else
                    DrawManager.DrawRect( 0, 0, 40, 20, Color( 230, 32, 25 ) )
                end
                DrawManager.DrawText( 'x', 'DrawManager.CloseButton.Generic', 20, -3, Color( 255, 255, 255 ) )
            end
            return close
        end
    end

    local blur = Material( "pp/blurscreen" )
    function DrawManager.BlurMenu( panel, layers, density, alpha )
        -- Its a scientifically proven fact that blur improves a script
        local x, y = panel:LocalToScreen(0, 0)

        surface.SetDrawColor( 255, 255, 255, alpha )
        surface.SetMaterial( blur )

        for i = 1, 3 do
            blur:SetFloat( "$blur", ( i / layers ) * density )
            blur:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
        end
    end
