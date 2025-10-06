---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmo" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoContainer = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoContainer )
	self.id = "R6eHudAmmoContainer"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    self.AmmoWidgets = CoD.R6eHudAmmo.new( menu, controller )
	self.AmmoWidgets:setLeftRight( true, true, 0, 0 )
	self.AmmoWidgets:setTopBottom( true, true, 0, 0 )
	self:addElement( self.AmmoWidgets )
    
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )
				self.AmmoWidgets:completeAnimation()
				self.AmmoWidgets:setAlpha( 0 )
				self.clipFinished( self.AmmoWidgets, {} )
			end,
			Visible = function ()
				self:setupElementClipCounter( 1 )
				self.AmmoWidgets:completeAnimation()
				self.AmmoWidgets:setAlpha( 0 )
				self.AmmoWidgets:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
				self.AmmoWidgets:setAlpha( 1 )
				self.AmmoWidgets:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )
				self.AmmoWidgets:completeAnimation()
				self.AmmoWidgets:setAlpha( 1 )
				self.clipFinished( self.AmmoWidgets, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 1 )
				self.AmmoWidgets:completeAnimation()
				self.AmmoWidgets:setAlpha( 1 )
				self.AmmoWidgets:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
				self.AmmoWidgets:setAlpha( 0 )
				self.AmmoWidgets:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				local f6_local0 = IsModelValueTrue( controller, "hudItems.playerSpawned" )
				if f6_local0 then
					f6_local0 = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					if f6_local0 then
						f6_local0 = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE )
						if f6_local0 then
							if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ) then
								f6_local0 = not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE )
							else
								f6_local0 = false
							end
						end
					end
				end
				return f6_local0
			end
		}
	} )
	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.playerSpawned" )

	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_VISIBLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_WEAPON_HUD_VISIBLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_HARDCORE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_GAME_ENDED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_DEMO_CAMERA_MODE_MOVIECAM" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_DEMO_ALL_GAME_HUD_HIDDEN" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_KILLCAM" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_FLASH_BANGED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_UI_ACTIVE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_SCOPED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_VEHICLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_GUIDED_MISSILE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_SCOREBOARD_OPEN" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_REMOTE_KILLSTREAK_STATIC" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_EMP_ACTIVE" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.AmmoWidgets:close()
	end )
	return self


end
