---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot4MortarStrike" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot4TripMine" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoActionslot4 = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot4.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot4 )
	self.id = "R6eHudAmmoActionslot4"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.TripMineIcon = CoD.R6eHudAmmoActionslot4TripMine.new( menu, controller )
	self.TripMineIcon:setLeftRight( true, true, 0, 0 )
	self.TripMineIcon:setTopBottom( true, true, 0, 0 )
	self.TripMineIcon:setAlpha( 0 )
	self:addElement( self.TripMineIcon )

	self.MortarStrikeIcon = CoD.R6eHudAmmoActionslot4MortarStrike.new( menu, controller )
	self.MortarStrikeIcon:setLeftRight( true, true, 0, 0 )
	self.MortarStrikeIcon:setTopBottom( true, true, 0, 0 )
	self.MortarStrikeIcon:setAlpha( 0 )
	self:addElement( self.MortarStrikeIcon )

	self.Actionslot4PromptBG = LUI.UIImage.new()
	self.Actionslot4PromptBG:setLeftRight( false, true, -122, -86 )
	self.Actionslot4PromptBG:setTopBottom( false, true, -62.1, -26.1 )
	self.Actionslot4PromptBG:setImage( RegisterImage( "ui_icon_key_prompt_bg" ) )
	self.Actionslot4PromptBG:setScale( 0.66 )
	if Engine.LastInput_Gamepad() then
		self.Actionslot4PromptBG:setAlpha( 0 )
	else
		self.Actionslot4PromptBG:setAlpha( 1 )
	end
	self:addElement( self.Actionslot4PromptBG )

	self.Actionslot4PromptText = LUI.UIText.new()
	self.Actionslot4PromptText:setLeftRight( false, true, -202.7, -5.7 )
	self.Actionslot4PromptText:setTopBottom( false, true, -53.6, -33.1 )
	self.Actionslot4PromptText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.Actionslot4PromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Actionslot4PromptText:setText( "[{+actionslot 4}]" )
	self.Actionslot4PromptText:setScale( 0.8 )
	self.Actionslot4PromptText:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.Actionslot4PromptText )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.TripMineIcon:completeAnimation()
				self.TripMineIcon:setAlpha( 0 )
				self.clipFinished( self.TripMineIcon, {} )
				self.MortarStrikeIcon:completeAnimation()
				self.MortarStrikeIcon:setAlpha( 0 )
				self.clipFinished( self.MortarStrikeIcon, {} )
			end
		},
		TripMine = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.TripMineIcon:completeAnimation()
				self.TripMineIcon:setAlpha( 1 )
				self.clipFinished( self.TripMineIcon, {} )
				self.MortarStrikeIcon:completeAnimation()
				self.MortarStrikeIcon:setAlpha( 0 )
				self.clipFinished( self.MortarStrikeIcon, {} )
			end
		},
		MortarStrike = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.TripMineIcon:completeAnimation()
				self.TripMineIcon:setAlpha( 0 )
				self.clipFinished( self.TripMineIcon, {} )
				self.MortarStrikeIcon:completeAnimation()
				self.MortarStrikeIcon:setAlpha( 1 )
				self.clipFinished( self.MortarStrikeIcon, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "TripMine",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadRight", 1 )
			end
		},
		{
			stateName = "MortarStrike",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadRight_MortarStrike", 1 )
			end
		}
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.showDpadRight" )
    SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.showDpadRight_MortarStrike" )

	LUI.OverrideFunction_CallOriginalFirst( self, "setState", function ( element, controller )
		local f7_local0 = element:getParent()
		f7_local0:dispatchEventToChildren( {
			name = "actionslot4_update",
			stateName = controller
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.TripMineIcon:close()
		element.MortarStrikeIcon:close()
        element.Actionslot4PromptBG:close()
		element.Actionslot4PromptText:close()
	end )
    
	return self
end

