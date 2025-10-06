---@diagnostic disable: undefined-global

CoD.R6eHudAmmoActionslot2Shield = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot2Shield.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot2Shield )
	self.id = "R6eHudAmmoActionslot2Shield"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    self.ShieldImage = LUI.UIImage.new()
	--self.ShieldImage:setLeftRight( false, true, -179, -125.5 )
	--self.ShieldImage:setTopBottom( false, true, -79, -25 )
	self.ShieldImage:setLeftRight( false, true, -119, -91 )
	self.ShieldImage:setTopBottom( false, true, -78.5, -55 )
	self.ShieldImage:setImage( RegisterImage( "blacktransparent" ) )
	self.ShieldImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) == 1 then
			self.ShieldImage:setImage( RegisterImage( "ui_icon_vest" ) )
			self.ShieldImage:setScale( 0.75 )
		else
			self.ShieldImage:setImage( RegisterImage( "blacktransparent" ) )
		end
	end )
	self:addElement( self.ShieldImage )

	self.ShieldMeter = LUI.UIImage.new()
	self.ShieldMeter:setLeftRight( false, true, -160, -116 )
	self.ShieldMeter:setTopBottom( false, true, -53, -49 )
	self.ShieldMeter:setImage( RegisterImage( "blacktransparent" ) )
	self.ShieldMeter:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self.ShieldMeter:setShaderVector( 1, 0, 0, 0, 0 )
	self.ShieldMeter:setShaderVector( 2, 1, 0, 0, 0 )
	self.ShieldMeter:setShaderVector( 3, 0, 0, 0, 0 )
	self.ShieldMeter:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) == 1 then
			self.ShieldMeter:setImage( RegisterImage( "ui_icon_vest_health_bar" ) )
			self.ShieldMeter:setZRot( 90 )
			self.ShieldMeter:setScale( 0.5 )
		else
			self.ShieldMeter:setImage( RegisterImage( "blacktransparent" ) )
		end
	end )
	self.ShieldMeter:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "ZMInventory.shield_health" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.ShieldMeter:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )

			self.ShieldMeter:setShaderVector( 0, AdjustStartEnd( 0, 1,
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 1 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 2 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 3 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 4 ) )
			)
		end
	end )
	self:addElement( self.ShieldMeter )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.ShieldImage:close()
		element.ShieldMeter:close()
	end )

	return self
end

