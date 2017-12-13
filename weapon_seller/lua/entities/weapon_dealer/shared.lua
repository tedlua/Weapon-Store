	ENT.Base = "base_ai"
	ENT.Type = "ai"
	ENT.AutomaticFrameAdvance = true
	ENT.PrintName = "Weapon Dealer"
	ENT.Author = "ted.lua"
	ENT.Category = "ted.lua (Teddy)"
	ENT.Instructions = ""
	ENT.Spawnable = true
	ENT.AdminSpawnable = true

	function ENT:SetAutomaticFrameAdvance( npcAnimate ) -- This is called by the game to tell the entity if it should animate itself.
		self.AutomaticFrameAdvance = npcAnimate
	end
