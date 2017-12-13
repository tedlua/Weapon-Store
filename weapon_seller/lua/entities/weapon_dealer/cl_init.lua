	include( "shared.lua" )

	surface.CreateFont( "DealerText",
	{
		font = "Colaborate-Regular", size = 60, weight = 700
	} )

	local v = Vector()

	function ENT:Draw()
	    self:DrawModel()
	    v.z = math.sin( CurTime() ) * 50
	    if LocalPlayer():GetPos():Distance( self:GetPos() ) < 1800 then
		  local ang = self:GetAngles()
		  ang:RotateAroundAxis(self:GetAngles():Right(), 90)
		  ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
		  cam.Start3D2D(self:GetPos() + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)

		  DrawManager.DrawRect( v.x - 250, ( v.z / 2 ) - 900, 500, 130, Color( 22, 22, 22 ) )
		  DrawManager.DrawOutlinedRect( v.x - 250, ( v.z / 2 ) - 900, 500, 130, 4, Color( 0, 0, 0 ) )

		  draw.SimpleText( "Weapon Store", "DealerText", 0, ( v.z / 2 ) - 835, Color( 46, 204, 113, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		  cam.End3D2D()
	    end
	end
