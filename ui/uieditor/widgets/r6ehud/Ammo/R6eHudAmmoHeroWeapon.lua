---@diagnostic disable: undefined-global

CoD.R6eHudAmmoHeroWeapon = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoHeroWeapon.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoHeroWeapon )
	self.id = "R6eHudAmmoHeroWeapon"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    self.HeroWeaponIconBG = LUI.UIImage.new()
    self.HeroWeaponIconBG:setLeftRight( false, true, -111.3, -72.7 )
	self.HeroWeaponIconBG:setTopBottom( false, true, -196.7, -158 )
	self.HeroWeaponIconBG:setImage( RegisterImage( "ui_icon_hero_weapon_bg" ) )
	self.HeroWeaponIconBG:setAlpha( 0.8 )
	self:addElement( self.HeroWeaponIconBG )

    self.HeroWeaponIcon = LUI.UIImage.new()
    self.HeroWeaponIcon:setLeftRight( false, true, -102, -32 )
	self.HeroWeaponIcon:setTopBottom( false, true, -215.5, -145.5 )
	self.HeroWeaponIcon:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.HeroWeaponIcon )

	self.HeroWeaponPromptBG = LUI.UIImage.new()
	self.HeroWeaponPromptBG:setLeftRight( false, true, -109.4, -73.4 )
	self.HeroWeaponPromptBG:setTopBottom( false, true, -157, -121 )
	self.HeroWeaponPromptBG:setImage( RegisterImage( "ui_icon_key_prompt_bg" ) )
	self.HeroWeaponPromptBG:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.HeroWeaponPromptBG:setScale( 0.66 )
	if Engine.LastInput_Gamepad() then
		self.HeroWeaponPromptBG:setAlpha( 0 )
	else
		self.HeroWeaponPromptBG:setAlpha( 1 )
	end
	self:addElement( self.HeroWeaponPromptBG )

	self.HeroWeaponPromptText = LUI.UIText.new()
	self.HeroWeaponPromptText:setLeftRight( false, true, -165, -18 )
	self.HeroWeaponPromptText:setTopBottom( false, true, -147.5, -130 )
	self.HeroWeaponPromptText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.HeroWeaponPromptText:setRGB( 0.5, 0.5, 0.5 )
	self.HeroWeaponPromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.HeroWeaponPromptText )

	self.HeroWeaponPromptTimer = LUI.UITimer.newElementTimer( 0, false, function ( timerEvent )
		if Engine.LastInput_Gamepad() then
			self.HeroWeaponPromptText:setScale( 0.8 )
			self.HeroWeaponPromptText:setText( Engine.Localize( "[{+smoke}] + [{+frag}]" ) )
		else
			self.HeroWeaponPromptText:setScale( 0.8 )
			self.HeroWeaponPromptText:setText( Engine.Localize( "[{+weaphero}]" ) )

			if string.match( Engine.GetKeyBindingLocalizedString( controller, "+weaphero" ), "UNBOUND" ) then
				self.HeroWeaponPromptText:setText( Engine.Localize( "" ) )
			end

			if string.match( Engine.GetKeyBindingLocalizedString( controller, "+weaphero" ), "%s" ) then
				if string.len( Engine.GetKeyBindingLocalizedString( controller, "+weaphero" ):match("^(.-)%s") ) > 1 then
					if string.len( Engine.GetKeyBindingLocalizedString( controller, "+weaphero" ):reverse():match("^(.-)%s") ) > 1 then
						self.HeroWeaponPromptText:setText( Engine.Localize( "" ) )
					else
						self.HeroWeaponPromptText:setText( Engine.Localize( Engine.GetKeyBindingLocalizedString( controller, "+weaphero" ):reverse():match("^(.-)%s") ) )
					end
				else
					self.HeroWeaponPromptText:setText( Engine.Localize( Engine.GetKeyBindingLocalizedString( controller, "+weaphero" ):match("^(.-)%s") ) )
				end
			end
		end
	end )
	self:addElement( self.HeroWeaponPromptTimer )

	self.HeroWeaponEnergy = LUI.UIImage.new()
	self.HeroWeaponEnergy:setLeftRight( false, true, -111.3, -72.7 )
	self.HeroWeaponEnergy:setTopBottom( false, true, -196.7, -158 )
	self.HeroWeaponEnergy:setImage( RegisterImage( "ui_icon_hero_weapon_progress" ) )
	self.HeroWeaponEnergy:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_clock_normal" ) )
	self.HeroWeaponEnergy:setShaderVector( 0, 1, 0, 0, 0 )
	self.HeroWeaponEnergy:setShaderVector( 1, 0.5, 0, 0, 0 )
	self.HeroWeaponEnergy:setShaderVector( 2, 0.5, 0, 0, 0 )
	self.HeroWeaponEnergy:setShaderVector( 3, 0, 0, 0, 0 )
	self.HeroWeaponEnergy:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.HeroWeaponEnergy:setShaderVector( 0, AdjustStartEnd( 0, 1,
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 1 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 2 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 3 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 4 ) )
			)
		end
	end )
	self:addElement( self.HeroWeaponEnergy )

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.HeroWeaponIconBG:close()
        element.HeroWeaponIcon:close()
        element.HeroWeaponPromptBG:close()
        element.HeroWeaponPromptText:close()
        element.HeroWeaponEnergy:close()
    end )

	return self
end
