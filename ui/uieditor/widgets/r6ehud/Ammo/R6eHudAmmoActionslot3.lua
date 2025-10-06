---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot3Shotgun" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot3GrenadeLauncher" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )


CoD.R6eHudAmmoActionslot3 = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot3.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot3 )
	self.id = "R6eHudAmmoActionslot3"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.UnderBarrelGrenadeLauncherIcon = CoD.R6eHudAmmoActionslot3GrenadeLauncher.new( menu, controller )
	self.UnderBarrelGrenadeLauncherIcon:setLeftRight( true, true, 0, 0 )
	self.UnderBarrelGrenadeLauncherIcon:setTopBottom( true, true, 0, 0 )
	self.UnderBarrelGrenadeLauncherIcon:setAlpha( 0 )
	self:addElement( self.UnderBarrelGrenadeLauncherIcon )

	self.UnderBarrelShotgunIcon = CoD.R6eHudAmmoActionslot3Shotgun.new( menu, controller )
	self.UnderBarrelShotgunIcon:setLeftRight( true, true, 0, 0 )
	self.UnderBarrelShotgunIcon:setTopBottom( true, true, 0, 0 )
	self.UnderBarrelShotgunIcon:setAlpha( 0 )
	self:addElement( self.UnderBarrelShotgunIcon )

    self.Actionslot3PromptBG = LUI.UIImage.new()
	self.Actionslot3PromptBG:setLeftRight( false, true, -91.3, -55.3 )
	self.Actionslot3PromptBG:setTopBottom( false, true, -62.1, -26.1 )
	self.Actionslot3PromptBG:setImage( RegisterImage( "ui_icon_key_prompt_bg" ) )
	self.Actionslot3PromptBG:setScale( 0.66 )
	if Engine.LastInput_Gamepad() then
		self.Actionslot3PromptBG:setAlpha( 0 )
	else
		self.Actionslot3PromptBG:setAlpha( 1 )
	end
	self:addElement( self.Actionslot3PromptBG )

	self.Actionslot3PromptText = LUI.UIText.new()
	self.Actionslot3PromptText:setLeftRight( false, true, -169.4, 23.6 )
	self.Actionslot3PromptText:setTopBottom( false, true, -53.6, -33.1 )
	self.Actionslot3PromptText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.Actionslot3PromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Actionslot3PromptText:setText( "[{+actionslot 3}]" )
	self.Actionslot3PromptText:setScale( 0.8 )
	self.Actionslot3PromptText:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.Actionslot3PromptText )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.UnderBarrelGrenadeLauncherIcon:completeAnimation()
				self.UnderBarrelGrenadeLauncherIcon:setAlpha( 0 )
				self.clipFinished( self.UnderBarrelGrenadeLauncherIcon, {} )
				self.UnderBarrelShotgunIcon:completeAnimation()
				self.UnderBarrelShotgunIcon:setAlpha( 0 )
				self.clipFinished( self.UnderBarrelShotgunIcon, {} )
			end
		},
		UnderBarrelGrenadeLauncher = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.UnderBarrelGrenadeLauncherIcon:completeAnimation()
				self.UnderBarrelGrenadeLauncherIcon:setAlpha( 1 )
				self.clipFinished( self.UnderBarrelGrenadeLauncherIcon, {} )
				self.UnderBarrelShotgunIcon:completeAnimation()
				self.UnderBarrelShotgunIcon:setAlpha( 0 )
				self.clipFinished( self.UnderBarrelShotgunIcon, {} )
			end
		},
		UnderBarrelShotgun = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.UnderBarrelGrenadeLauncherIcon:completeAnimation()
				self.UnderBarrelGrenadeLauncherIcon:setAlpha( 0 )
				self.clipFinished( self.UnderBarrelGrenadeLauncherIcon, {} )
				self.UnderBarrelShotgunIcon:completeAnimation()
				self.UnderBarrelShotgunIcon:setAlpha( 1 )
				self.clipFinished( self.UnderBarrelShotgunIcon, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "UnderBarrelGrenadeLauncher",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadLeft_iw8", 1 ) or IsModelValueEqualTo( controller, "hudItems.showDpadLeft_iw8", 2 )
			end
		},
		{
			stateName = "UnderBarrelShotgun",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadLeft_iw8", 3 )
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.showDpadLeft_iw8" )

	LUI.OverrideFunction_CallOriginalFirst( self, "setState", function ( element, controller )
		local f7_local0 = element:getParent()
		f7_local0:dispatchEventToChildren( {
			name = "actionslot3_update",
			stateName = controller
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.UnderBarrelGrenadeLauncherIcon:close()
		element.UnderBarrelShotgunIcon:close()
        element.Actionslot3PromptBG:close()
		element.Actionslot3PromptText:close()
	end )
	return self
end

