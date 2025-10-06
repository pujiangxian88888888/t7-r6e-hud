---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudDeadSpectateWidgets = InheritFrom( LUI.UIElement )
CoD.R6eHudDeadSpectateWidgets.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudDeadSpectateWidgets )
	self.id = "R6eHudDeadSpectateWidgets"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 67 )
	self:setTopBottom( true, false, 0, 25 )
	self.anyChildUsesUpdateState = true

	local DeadSpectateBG = LUI.UIImage.new()
	DeadSpectateBG:setLeftRight( false, false, -196, 196 )
	DeadSpectateBG:setTopBottom( false, true, -208, -128 )
	DeadSpectateBG:setImage( RegisterImage( "ui_icon_dead_spectating_bg" ) )
	DeadSpectateBG:setScale( 0.66 )
	self:addElement( DeadSpectateBG )
	self.DeadSpectateBG = DeadSpectateBG

	local SpectateText = LUI.UIText.new()
	SpectateText:setLeftRight( false, false, -100, 100 )
	SpectateText:setTopBottom( false, true, -181.5, -172 )
	SpectateText:setTTF( "fonts/Erbaum_Bold.ttf" )
	SpectateText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	SpectateText:setText( Engine.Localize( "UI_HINT_SPECTATING" ) )
	self:addElement( SpectateText )
	self.SpectateText = SpectateText

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				DeadSpectateBG:completeAnimation()
				self.DeadSpectateBG:setAlpha( 0 )
				self.clipFinished( DeadSpectateBG, {} )

				SpectateText:completeAnimation()
				self.SpectateText:setAlpha( 0 )
				self.clipFinished( SpectateText, {} )

			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				DeadSpectateBG:completeAnimation()
				self.DeadSpectateBG:setAlpha( 1 )
				self.clipFinished( DeadSpectateBG, {} )

				SpectateText:completeAnimation()
				self.SpectateText:setAlpha( 1 )
				self.clipFinished( SpectateText, {} )

			end
		},
		VisibleLastPlayer = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				DeadSpectateBG:completeAnimation()
				self.DeadSpectateBG:setAlpha( 1 )
				self.clipFinished( DeadSpectateBG, {} )

				SpectateText:completeAnimation()
				self.SpectateText:setAlpha( 1 )
				self.clipFinished( SpectateText, {} )

			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "VisibleLastPlayer",
			condition = function ( menu, element, event )
				local f7_local0
				if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_FINAL_KILLCAM ) or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DRAW_SPECTATOR_MESSAGES ) or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM ) or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ) or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_TEAM_SPECTATOR ) then
					f7_local0 = IsGamepad( controller )
					if f7_local0 then
						f7_local0 = IsModelValueEqualToEitherValue( controller, "gameScore.alliesAlive", 0, 1 )
					end
				else
					f7_local0 = false
				end
				return f7_local0
			end
		},
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				local f8_local0
				if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_FINAL_KILLCAM ) or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DRAW_SPECTATOR_MESSAGES ) or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM ) or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ) or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_TEAM_SPECTATOR ) then
					f8_local0 = IsGamepad( controller )
				else
					f8_local0 = false
				end
				return f8_local0
			end
		}
	} )
	
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_FINAL_KILLCAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_FINAL_KILLCAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DRAW_SPECTATOR_MESSAGES ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DRAW_SPECTATOR_MESSAGES
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_TEAM_SPECTATOR ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_TEAM_SPECTATOR
		} )
	end )
	if self.m_eventHandlers.input_source_changed then
		local f1_local5 = self.m_eventHandlers.input_source_changed
		self:registerEventHandler( "input_source_changed", function ( element, event )
			event.menu = event.menu or menu
			element:updateState( event )
			return f1_local5( element, event )
		end )
	else
		self:registerEventHandler( "input_source_changed", LUI.UIElement.updateState )
	end
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "LastInput"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "gameScore.alliesAlive" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "gameScore.alliesAlive"
		} )
	end )
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.DeadSpectateBG:close()
		element.SpectateText:close()

	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

