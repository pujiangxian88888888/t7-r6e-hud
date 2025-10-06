---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoActionslot3GrenadeLauncher = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot3GrenadeLauncher.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot3GrenadeLauncher )
	self.id = "R6eHudAmmoActionslot3GrenadeLauncher"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.UnderBarrelGrenadeLauncherIcon = LUI.UIImage.new()
    self.UnderBarrelGrenadeLauncherIcon:setLeftRight( false, true, -100 + 10, -72 + 10 )
	self.UnderBarrelGrenadeLauncherIcon:setTopBottom( false, true, -85, -57 )
	self.UnderBarrelGrenadeLauncherIcon:setImage( RegisterImage( "ui_icon_m203" ) )
	self.UnderBarrelGrenadeLauncherIcon:setScale( 1.2 )
	self:addElement( self.UnderBarrelGrenadeLauncherIcon )

	self.UnderBarrelGrenadeLauncherAmmo = LUI.UIText.new()
	self.UnderBarrelGrenadeLauncherAmmo:setLeftRight( false, true, -169.4, 23.6 )
	self.UnderBarrelGrenadeLauncherAmmo:setTopBottom( false, true, -102.8, -90.3 )
	self.UnderBarrelGrenadeLauncherAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.UnderBarrelGrenadeLauncherAmmo:setText( "" )
	self.UnderBarrelGrenadeLauncherAmmo:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.UnderBarrelGrenadeLauncherAmmo:setRGB( 0.7, 0.7, 0.7 )
	self:addElement( self.UnderBarrelGrenadeLauncherAmmo )

	self.UnderBarrelGrenadeLauncherAmmo:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.dpadLeftAmmo" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.UnderBarrelGrenadeLauncherAmmo:setText( modelValue )
		else
			self.UnderBarrelGrenadeLauncherAmmo:setText( "" )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.UnderBarrelGrenadeLauncherAmmo:completeAnimation()
				self.UnderBarrelGrenadeLauncherAmmo:setAlpha( 1 )
				self.clipFinished( self.UnderBarrelGrenadeLauncherAmmo, {} )
			end
		},
		NoUnderBarrelGrenadeLauncherAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.UnderBarrelGrenadeLauncherAmmo:completeAnimation()
				self.UnderBarrelGrenadeLauncherAmmo:setAlpha( 0.6 )
				self.clipFinished( self.UnderBarrelGrenadeLauncherAmmo, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "NoUnderBarrelGrenadeLauncherAmmo",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.dpadLeftAmmo", 0 )
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.dpadLeftAmmo" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.UnderBarrelGrenadeLauncherIcon:close()
		element.UnderBarrelGrenadeLauncherAmmo:close()
	end )
    
	return self
end

