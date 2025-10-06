---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoActionslot4MortarStrike = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot4MortarStrike.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot4MortarStrike )
	self.id = "R6eHudAmmoActionslot4MortarStrike"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.MortarStrikeIcon = LUI.UIImage.new()
	self.MortarStrikeIcon:setLeftRight( false, true, -119, -91 )
	self.MortarStrikeIcon:setTopBottom( false, true, -85, -57 )
	self.MortarStrikeIcon:setImage( RegisterImage( "ui_icon_mortar_strike" ) )
	self.MortarStrikeIcon:setScale( 1.1 )
	self:addElement( self.MortarStrikeIcon )

	self.MortarStrikeAmmo = LUI.UIText.new()
	self.MortarStrikeAmmo:setLeftRight( false, true, -202.7, -5.7 )
	self.MortarStrikeAmmo:setTopBottom( false, true, -102.8, -90.3 )
	self.MortarStrikeAmmo:setText( "" )
	self.MortarStrikeAmmo:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.MortarStrikeAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.MortarStrikeAmmo:setRGB( 0.7, 0.7, 0.7 )
	self:addElement( self.MortarStrikeAmmo )
    
	self.MortarStrikeAmmo:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.MortarStrikeAmmo:setText( modelValue )
		else
			self.MortarStrikeAmmo:setText( "" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.MortarStrikeIcon:completeAnimation()
				self.MortarStrikeIcon:setAlpha( 1 )
				self.clipFinished( self.MortarStrikeIcon, {} )
			end
		},
		NoMortarStrike = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.MortarStrikeIcon:completeAnimation()
				self.MortarStrikeIcon:setAlpha( 0.6 )
				self.clipFinished( self.MortarStrikeIcon, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "NoMortarStrike",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 0 )
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.actionSlot3ammo" )
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.MortarStrikeIcon:close()
		element.MortarStrikeAmmo:close()
	end )

	return self
end

