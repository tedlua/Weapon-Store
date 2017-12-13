    --[[
        Created by: ted.lua (http://steamcommunity.com/id/tedlua/)
    ]]

    if !CLIENT then return end

    surface.CreateFont( "Teddy.WeaponStore.Medium", { font = "Arial", size = 22, weight = 800 } )
    surface.CreateFont( "Teddy.WeaponStore.Small", { font = "Arial", size = 22, weight = 800 } )
    surface.CreateFont( "Teddy.WeaponStore.Title", { font = "Calibri", size = 30, weight = 800 } )

    local donatorName = 'Donators' -- Use this to rename the Donator section.

    local CreateButton = { -- These are your categories, buttons are made automatically.
        'Knives',
        'Weapons',
        'Vapes',
        donatorName,
        'Others' -- Do not remove this, if a category is not found this is used.
    }

    local Category = CreateButton[ 1 ]

    local function DrawOutline( offset, w, h )
        DrawManager.DrawRect( 0, 0, w, 30, Color( 28, 28, 28 ) )
        DrawManager.DrawRect( 0, 0, 30, 30, Color( 28, 28, 28 ) )
        DrawManager.DrawRect( 4, 33, 146, h - 37, Color( 28, 28, 28 ) )
        DrawManager.DrawRect( 152, 33, w - 155, 33, Color( 26, 26, 26 ) )
    end

    local function nameMatch( name, owns )
        for x = 1, #owns do
            if name == owns[ x ] then
                return true
            end
        end
        return false
    end

    --[[
        Creating a local instance of this function in case of conflic with my other addons
        Don't want to add an extra param for roundedBox.
    --]]

    local function CreateDButton( parent, x, y, w, h, txt, font, hover, colorContent, func )
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
                    DrawManager.DrawRoundedBox( 4, 0, 0, w, h, colorContent.bg )
                else
                    DrawManager.DrawRoundedBox( 4, 0, 0, w, h, colorContent.hoverColor )
                end
            end
            self.DoClick = func
            return self
        end
    end

    local function GetCurrentTable( origin, id, owns, config )
        if not IsValid( origin ) then return end
        origin:Clear()
        for y, x in pairs( id ) do
            if not table.HasValue( CreateButton, x.cat ) then x.cat = 'Others' end
            if x.donator then x.cat = donatorName end
            if x.cat ~= Category then continue end
            local text = 'This weapon is temporary.'
            if config then
                text = nameMatch( x.name, owns ) and 'You already own this item!' or 'Once bought, it lasts forever.'
            end
            local me = vgui.Create( 'DPanel', origin )
            me:SetSize( origin:GetWide(), 65 )
            me.Paint = function( o, w, h )
                DrawManager.DrawRect( 0, 0, w, h, y % 2 == 0 and Color( 24, 24, 24 ) or Color( 20, 20, 20 ) )
                DrawManager.DrawText( x.name, 'Teddy.WeaponStore.Small', 60, 8, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
                DrawManager.DrawText( gmod.GetGamemode().Name == 'DarkRP' and DarkRP.formatMoney( x.price ) or x.price, 'Teddy.WeaponStore.Small', 60, 35, Color( 46, 204, 113 ), TEXT_ALIGN_LEFT )
                DrawManager.DrawText( config and 'Permanent' or 'Temporary', 'Teddy.WeaponStore.Small', w / 2 + 50, 8, Color( 255, 255, 255 ) )
                DrawManager.DrawText( text, 'Teddy.WeaponStore.Small', w / 2 - 77, 35, Color( 80, 80, 80 ), TEXT_ALIGN_LEFT )
            end
            local icon =  vgui.Create( "DModelPanel" , me )
            icon:SetPos( 0, 7 )
            icon:SetSize( 65, 65 )
            icon:SetModel( x.model )

            function icon:LayoutEntity( Entity ) return end
            local num = !string.find( x.name, 'Karambit' ) and .49 or .17
            local min, max = icon.Entity:GetRenderBounds()
            icon:SetCamPos( min:Distance( max ) * Vector( num, num, num ) )
            icon:SetLookAt( (max + min) / 2 )

            local btn = CreateDButton( me, me:GetWide() - 125, 16, 105, 32, nameMatch( x.name, owns ) and 'Withdraw' or 'Purchase', 'Teddy.WeaponStore.Small', true, { bg = Color( 46, 204, 113 ), hoverColor = Color( 32, 232, 119 ), textColor = Color( 255, 255, 255 ) }, function( self )
                net.Start( 'TEDDY_STORE_ATTEMPT_BUY_WEAPON' )
                    net.WriteString( x.name )
                net.SendToServer()
                local text = 'Purchase'
                if config then
                    text = 'Withdraw'
                end
                self:SetText( text )
            end )
            origin:AddItem( me )
        end
    end

    local function CreateClickableLink( home, x, y, w, h, txt, color, func )
        local link = vgui.Create( "DLabel", home )
        link:SetPos( x, y )
        link:SetSize( w, h )
        link:SetText( txt )
        link:SetFont( "Teddy.WeaponStore.Small" )
        link:SetTextColor( color )
        link:SetMouseInputEnabled( true )
        link:SetCursor( "hand" )
        link.OnMousePressed = func
    end

    local function CreateStoreButton( where, origin, id, owns, donators, x, y, w, h, txt, font, var, config )
        local disabled, color = true, Color( 255, 255, 255 )
        local btn = vgui.Create( 'DButton', where )
        btn:SetPos( x, y )
        btn:SetSize( w, h )
        btn:SetFont( font )
        btn:SetText( txt )

        if not var then
            disabled = false
        elseif var then
            if donators[ LocalPlayer():GetUserGroup() ] then
                color, disabled = Color( 46, 204, 113 ), false
            else
                disabled, color = true, Color( 148, 0, 0 )
            end
        end

        btn:SetTextColor( color )
        btn:SetDisabled( disabled )
        btn.Paint = function()
            DrawManager.DrawRoundedBox( 4, 0, 0, w, h, Color( 22, 22, 22 ) )
        end
        btn.DoClick = function()
            Category = txt
            GetCurrentTable( origin, id, owns, config )
        end
    end

    net.Receive( 'TEDDY_STORE_INTERFACE', function()
        local Weapons = net.ReadTable()
        local Owns = net.ReadTable()
        local Donators = net.ReadTable()
        local Config = net.ReadBool()
        local me = DrawManager.CreateDFrame( 820, 540, '', false, false, true )
        me.Paint = function( o, w, h )
            DrawManager.DrawRect( 0, 0, w, h, Color( 36, 36, 36 ) )
            DrawOutline( 16, w, h )
            DrawManager.DrawText( 'Weapon Store', 'Teddy.WeaponStore.Title', w / 2, -1, Color( 52, 152, 219 ) )
            -- Grammar matters.
            DrawManager.DrawText( ( string.sub( Category, 1, #Category - 1 ) == 'Knive' and 'Knife' or string.sub( Category, 1, #Category - 1 ) ) .. ' Store', 'Teddy.WeaponStore.Title', w / 2, 34, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            DrawManager.DrawRect( 0, 66, 150, 3, Color( 36, 36, 36 ) )
        end
        local close = DrawManager.CreateCloseButton( me, me:GetWide() - 45, 5, 140, 70, true )

        local your = vgui.Create( 'DPanelList', me )
        your:SetSize( me:GetWide() - 156, me:GetTall() - 74 )
        your:SetPos( 153, 70 )
        your:SetSpacing( 2 )
        your:EnableVerticalScrollbar( true )
        your.Paint = function( o, w, h )
            DrawManager.DrawRect( 0, 0, w, h, Color( 26, 26, 26 ) )
        end

        local sbar = your.VBar

        function sbar:Paint( w, h )
            DrawManager.BlurMenu( sbar, 13, 20, 200 )
            draw.RoundedBox( 0, 0, 0, 4, h, Color( 6, 8, 3 ) )
        end
        function sbar.btnUp:Paint( w, h ) end
        function sbar.btnDown:Paint( w, h )  end

        function sbar.btnGrip:Paint( w, h )
            DrawManager.DrawRoundedBox( 0, 0, 0, 4, h, Color( 60, 60, 60, 170 ) )
        end

        for x = 1, #CreateButton do
            CreateStoreButton( me, your, Weapons, Owns, Donators, 7, 37 + 35 * x, 140, 30, CreateButton[ x ], 'Teddy.WeaponStore.Small', CreateButton[ x ] == donatorName, Config )
        end

        GetCurrentTable( your, Weapons, Owns, Config )

        CreateClickableLink( me, 40, 42, 75, 15, "Creator", Color( 52, 152, 219 ), function() gui.OpenURL( "http://steamcommunity.com/id/tedlua/" ) end )

    end )
