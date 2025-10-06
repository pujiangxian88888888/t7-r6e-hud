---@diagnostic disable: undefined-global

CoD.R6eHudAmmoWeapon = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoWeapon.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoWeapon )
	self.id = "R6eHudAmmoWeapon"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.WeaponName = LUI.UIText.new()
	self.WeaponName:setLeftRight( false, true, -789, -227.3 )
	self.WeaponName:setTopBottom( false, true, -44, -29.3 )
	self.WeaponName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.WeaponName:setText( "" )
	self.WeaponName:setAlpha( 0 )
	self.WeaponName:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.WeaponName )

	self.AATText = LUI.UIText.new()
	self.AATText:setLeftRight( true, true, 0, -32 )
	self.AATText:setTopBottom( false, true, -19, 0 )
	self.AATText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.AATText:setText( "" )
	self.AATText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.AATText )

	self.WeaponName:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentWeapon.weaponName" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.WeaponName:setText( Engine.Localize( modelValue ) )
		end
	end )
	self.AATText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentWeapon.aat" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.AATText:setText( string.upper( Engine.Localize( modelValue ) ) )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )
				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 1 )
				self.clipFinished( self.WeaponName, {} )
	
				self.AATText:completeAnimation()
				self.AATText:setAlpha( 1 )
				self.clipFinished( self.AATText, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.WeaponName:close()
		element.AATText:close()
	end )

	return self
end

