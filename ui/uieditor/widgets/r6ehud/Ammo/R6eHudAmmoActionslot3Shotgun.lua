---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoActionslot3Shotgun = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot3Shotgun.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot3Shotgun )
	self.id = "R6eHudAmmoActionslot3Shotgun"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.UnderBarrelShotgunIcon = LUI.UIImage.new()
    self.UnderBarrelShotgunIcon:setLeftRight( false, true, -100 + 10, -72 + 10 )
	self.UnderBarrelShotgunIcon:setTopBottom( false, true, -85, -57 )
	self.UnderBarrelShotgunIcon:setImage( RegisterImage( "ui_icon_master_key" ) )
	self.UnderBarrelShotgunIcon:setScale( 1.2 )
	self:addElement( self.UnderBarrelShotgunIcon )

	self.UnderBarrelShotgunAmmo = LUI.UIText.new()
	self.UnderBarrelShotgunAmmo:setLeftRight( false, true, -169.4, 23.6 )
	self.UnderBarrelShotgunAmmo:setTopBottom( false, true, -102.8, -90.3 )
	self.UnderBarrelShotgunAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.UnderBarrelShotgunAmmo:setText( "" )
	self.UnderBarrelShotgunAmmo:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.UnderBarrelShotgunAmmo:setRGB( 0.7, 0.7, 0.7 )
	self:addElement( self.UnderBarrelShotgunAmmo )

	self.UnderBarrelShotgunAmmo:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.dpadLeftAmmo" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.UnderBarrelShotgunAmmo:setText( modelValue )
		else
			self.UnderBarrelShotgunAmmo:setText( "" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.UnderBarrelShotgunAmmo:completeAnimation()
				self.UnderBarrelShotgunAmmo:setAlpha( 1 )
				self.clipFinished( self.UnderBarrelShotgunAmmo, {} )
			end
		},
		NoUnderBarrelShotgunAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.UnderBarrelShotgunAmmo:completeAnimation()
				self.UnderBarrelShotgunAmmo:setAlpha( 0.6 )
				self.clipFinished( self.UnderBarrelShotgunAmmo, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "NoUnderBarrelShotgunAmmo",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.dpadLeftAmmo", 0 )
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.dpadLeftAmmo" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.UnderBarrelShotgunIcon:close()
		element.UnderBarrelShotgunAmmo:close()
	end )
    
	return self
end

