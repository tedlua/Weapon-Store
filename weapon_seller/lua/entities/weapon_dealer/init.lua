	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )
	include( 'shared.lua' )

	function ENT:Initialize()

		self:SetModel( "models/Humans/Group03/male_09.mdl" )
		self:SetHullType( HULL_HUMAN )
		self:SetUseType( SIMPLE_USE )
		self:SetHullSizeNormal( )
		self:SetSolid( SOLID_BBOX )
		self:SetMaxYawSpeed( 5000 )

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

	end

	function ENT:OnTakeDamage()
		return false
	end

	function ENT:AcceptInput( name, activator, caller )
		if activator:IsPlayer() then
			if( activator:GetPos():Distance(self:GetPos()) < 80 ) then
				if name == "Use" then OpenWeaponStore( activator ) end
			end
		end
	end
