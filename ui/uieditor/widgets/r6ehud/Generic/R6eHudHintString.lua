---@diagnostic disable: undefined-global

--[[

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudHintString = InheritFrom( LUI.UIElement )
CoD.R6eHudHintString.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudHintString )
	self.id = "R6eHudHintString"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.Hintstring = LUI.UIText.new()
	self.Hintstring:setLeftRight( true, true, 0, 0 )
	self.Hintstring:setTopBottom( false, false, -11, 11 )
	self.Hintstring:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Hintstring:setText( "" )
	self.Hintstring:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.Hintstring )

	self.Hintstring:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.cursorHintText" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			self.Hintstring:setText( Engine.Localize( modelValue ) )
		end
	end )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.Hintstring:completeAnimation()
				self.Hintstring:setAlpha( 0 )
				self.clipFinished( self.Hintstring, {} )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.Hintstring:completeAnimation()
				self.Hintstring:setAlpha( 1 )
				self.clipFinished( self.Hintstring, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				local f5_local0 = IsCursorHintActive( controller )
				if f5_local0 then
					if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE ) then
						f5_local0 = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
						if f5_local0 then
							if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ) then
								f5_local0 = not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
							else
								f5_local0 = false
							end
						else
							return f5_local0
						end
					end
					f5_local0 = false
				end
				return f5_local0
			end
		}
	} )
	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.showCursorHint" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_HARDCORE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_VISIBLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_GUIDED_MISSILE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_DEMO_PLAYING" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_FLASH_BANGED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_SELECTING_LOCATIONAL_KILLSTREAK" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_SPECTATING_CLIENT" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_UI_ACTIVE" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Hintstring:close()
	end )
    
	return self
end
--]]

CoD.ZmParadoxHintstring = InheritFrom( LUI.UIElement )
CoD.ZmParadoxHintstring.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.ZmParadoxHintstring )
	self.id = "ZmParadoxHintstring"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true
	self.HintstringShadow = LUI.UIText.new()
	self.HintstringShadow:setLeftRight( true, true, 1, 1 )
	self.HintstringShadow:setTopBottom( false, false, -10, 12 )
	self.HintstringShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.HintstringShadow:setText( "" )
	self.HintstringShadow:setRGB( 0, 0, 0 )
	self.HintstringShadow:setTTF( "fonts/helveticaneue.ttf" )
	self:addElement( self.HintstringShadow )
	self.Hintstring = LUI.UIText.new()
	self.Hintstring:setLeftRight( true, true, 0, 0 )
	self.Hintstring:setTopBottom( false, false, -11, 11 )
	self.Hintstring:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Hintstring:setText( "" )
	self.Hintstring:setTTF( "fonts/helveticaneue.ttf" )
	self:addElement( self.Hintstring )
	self.Hintstring:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.cursorHintText" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue ~= nil then
			local f2_local1 = Engine.Localize( modelValue )
			self.HintstringShadow:setText( f2_local1:gsub( "%^3", "" ) )
			self.Hintstring:setText( f2_local1 )
		end
	end )
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.HintstringShadow:completeAnimation()
				self.HintstringShadow:setAlpha( 0 )
				self.clipFinished( self.HintstringShadow, {} )
				self.Hintstring:completeAnimation()
				self.Hintstring:setAlpha( 0 )
				self.clipFinished( self.Hintstring, {} )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.HintstringShadow:completeAnimation()
				self.HintstringShadow:setAlpha( 0.6 )
				self.clipFinished( self.HintstringShadow, {} )
				self.Hintstring:completeAnimation()
				self.Hintstring:setAlpha( 1 )
				self.clipFinished( self.Hintstring, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				local f5_local0 = IsCursorHintActive( controller )
				if f5_local0 then
					if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE ) then
						f5_local0 = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
						if f5_local0 then
							if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ) then
								f5_local0 = not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
							else
								f5_local0 = false
							end
						else
							return f5_local0
						end
					end
					f5_local0 = false
				end
				return f5_local0
			end
		}
	} )
	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.showCursorHint" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_HARDCORE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_VISIBLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_GUIDED_MISSILE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_DEMO_PLAYING" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_FLASH_BANGED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_SELECTING_LOCATIONAL_KILLSTREAK" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_SPECTATING_CLIENT" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_UI_ACTIVE" )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.HintstringShadow:close()
		element.Hintstring:close()
	end )
	return self
end



