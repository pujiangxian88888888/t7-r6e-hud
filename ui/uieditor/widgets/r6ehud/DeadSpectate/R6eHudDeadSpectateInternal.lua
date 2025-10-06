---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )
require( "ui.uieditor.widgets.r6ehud.DeadSpectate.R6eHudDeadSpectateWidgets" )

CoD.R6eHudDeadSpectateInternal = InheritFrom( LUI.UIElement )
CoD.R6eHudDeadSpectateInternal.new = function ( menu, controller )

	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudDeadSpectateInternal )
	self.id = "R6eHudDeadSpectateInternal"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 300 )
	self:setTopBottom( true, false, 0, 60 )
	self.anyChildUsesUpdateState = true

    local spectatingBar = CoD.R6eHudDeadSpectateWidgets.new( menu, controller )
	spectatingBar:setLeftRight( true, true, 0, 0 )
	spectatingBar:setTopBottom( true, false, -24.75, 0.75 )
	self:addElement( spectatingBar )
	self.spectatingBar = spectatingBar

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

    local playerName = LUI.UIText.new()
	playerName:setLeftRight( false, false, -100, 100 )
	playerName:setTopBottom( false, true, -162, -154 )
	playerName:setTTF( "fonts/TradaSans-Medium.ttf" )
	playerName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	playerName:subscribeToGlobalModel( controller, "DeadSpectate", "playerIndex", function ( model )
		local playerIndex = Engine.GetModelValue( model )
		if playerIndex then
			playerName:setText( GetClientNameAndClanTag( controller, playerIndex ) )
		end
	end )
	self:addElement( playerName )
	self.playerName = playerName

    self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				spectatingBar:completeAnimation()
				self.spectatingBar:setAlpha( 1 )
				self.clipFinished( spectatingBar, {} )

				SpectateText:completeAnimation()
				self.SpectateText:setAlpha( 1 )
				self.clipFinished( SpectateText, {} )

				DeadSpectateBG:completeAnimation()
				self.DeadSpectateBG:setAlpha( 1 )
				self.clipFinished( DeadSpectateBG, {} )


		
			end
		},
		ShowOnlySpectatingPrompt = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )

				playerName:completeAnimation()
				self.playerName:setLeftRight( false, false, -100, 100 )
				self.playerName:setTopBottom( true, false, 9.75, 34.75 )
				self.clipFinished( playerName, {} )

				spectatingBar:completeAnimation()
				self.spectatingBar:setAlpha( 1 )
				self.clipFinished( spectatingBar, {} )

				SpectateText:completeAnimation()
				self.SpectateText:setAlpha( 1 )
				self.clipFinished( SpectateText, {} )

				DeadSpectateBG:completeAnimation()
				self.DeadSpectateBG:setAlpha( 1 )
				self.clipFinished( DeadSpectateBG, {} )

			end
		},
		HideAllPrompts = {
			DefaultClip = function ()
				self:setupElementClipCounter( 5 )

				playerName:completeAnimation()
				self.playerName:setLeftRight( false, false, -100, 100 )
				self.playerName:setTopBottom( true, false, 9.75, 34.75 )
				self.clipFinished( playerName, {} )

				spectatingBar:completeAnimation()
				self.spectatingBar:setAlpha( 0 )
				self.clipFinished( spectatingBar, {} )

				spectatingBar:completeAnimation()
				self.spectatingBar:setAlpha( 1 )
				self.clipFinished( spectatingBar, {} )

				spectatingBar:completeAnimation()
				self.spectatingBar:setAlpha( 1 )
				self.clipFinished( spectatingBar, {} )

			end
		}
	}

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.spectatingBar:close()
		element.DeadSpectateBG:close()
		element.SpectateText:close()
        element.playerName:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end