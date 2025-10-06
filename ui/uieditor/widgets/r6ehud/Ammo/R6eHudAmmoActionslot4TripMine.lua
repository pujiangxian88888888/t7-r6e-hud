---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoActionslot4TripMine = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot4TripMine.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot4TripMine )
	self.id = "R6eHudAmmoActionslot4TripMine"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.TripMineIcon = LUI.UIImage.new()
	self.TripMineIcon:setLeftRight( false, true, -116 + 1.5, -94 - 1.5 )
	self.TripMineIcon:setTopBottom( false, true, -78.5, -58 - 3 )
	self.TripMineIcon:setImage( RegisterImage( "ui_icon_trip_mine" ) )
	self.TripMineIcon:setScale( 1.3 )
	self.TripMineIcon:setAlpha( 0.8 )
	self:addElement( self.TripMineIcon )

	self.TripMineAmmo = LUI.UIText.new()
	self.TripMineAmmo:setLeftRight( false, true, -202.7, -5.7 )
	self.TripMineAmmo:setTopBottom( false, true, -102.8, -90.3 )
	self.TripMineAmmo:setText( Engine.Localize( "" ) )
	self.TripMineAmmo:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.TripMineAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.TripMineAmmo:setRGB( 0.7, 0.7, 0.7 )
	self:addElement( self.TripMineAmmo )
    
	self.TripMineAmmo:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.TripMineAmmo:setText( modelValue )
		else
			self.TripMineAmmo:setText( "" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.TripMineIcon:completeAnimation()
				self.TripMineIcon:setAlpha( 1 )
				self.clipFinished( self.TripMineIcon, {} )
			end
		},
		NoTripMine = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.TripMineIcon:completeAnimation()
				self.TripMineIcon:setAlpha( 0.6 )
				self.clipFinished( self.TripMineIcon, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "NoTripMine",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.actionSlot3ammo", 0 )
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.actionSlot3ammo" )
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.TripMineIcon:close()
		element.TripMineAmmo:close()
	end )

	return self
end

