---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoStock = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoStock.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoStock )
	self.id = "R6eHudAmmoStock"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.StockAmmo = LUI.UIText.new()
	self.StockAmmo:setLeftRight( false, true, -250.7, -126.3 )
	self.StockAmmo:setTopBottom( false, true, -66.7, -49.7 )
	self.StockAmmo:setText( "" )
	self.StockAmmo:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.StockAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.StockAmmo )

	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentWeapon.ammoStock" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.StockAmmo:setText( modelValue )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.StockAmmo:completeAnimation()
				self.StockAmmo:setRGB( 1, 1, 1 )
				self.clipFinished( self.StockAmmo, {} )
			end
		},
		LowReserve = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.StockAmmo:completeAnimation()
				self.StockAmmo:setRGB( 1, 0, 0 )
				self.clipFinished( self.StockAmmo, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "LowReserve",
			condition = function ( menu, element, event )
                --local maxStockAmmo = 
				local f5_local0 = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentWeapon.clipMaxAmmo" ) )
				if f5_local0 ~= nil then
					return IsModelValueLessThanOrEqualTo( controller, "CurrentWeapon.ammoStock", f5_local0 )
				else
					return AlwaysFalse()
				end
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.weapon" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.ammoStock" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.StockAmmo:close()
	end )

	return self
end
