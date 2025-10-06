---@diagnostic disable: undefined-global

CoD.R6eHudAmmoTactical = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoTactical.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoTactical )
	self.id = "R6eHudAmmoTactical"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.TacticalImage = LUI.UIImage.new()
	self.TacticalImage:setLeftRight( false, true, -198, -154.5 )
	self.TacticalImage:setTopBottom( false, true, -97.3, -46.5 )
	self.TacticalImage:setImage( RegisterImage( "blacktransparent" ) )
	self.TacticalImage:setScale( 0.8 )
	self.TacticalImage:setAlpha( 0 )
	self:addElement( self.TacticalImage )

	self.TacticalPromptBG = LUI.UIImage.new()
	self.TacticalPromptBG:setLeftRight( false, true, -191.4, -155.4 )
	self.TacticalPromptBG:setTopBottom( false, true, -62.1, -26.1 )
	self.TacticalPromptBG:setImage( RegisterImage( "ui_icon_key_prompt_bg" ) )
	self.TacticalPromptBG:setScale( 0.65 )
	if Engine.LastInput_Gamepad() then
		self.TacticalPromptBG:setAlpha( 0 )
	else
		self.TacticalPromptBG:setAlpha( 1 )
	end
	self:addElement( self.TacticalPromptBG )

	self.TacticalPromptText = LUI.UIText.new()
	self.TacticalPromptText:setLeftRight( false, true, -271.5, -74.5 )
	self.TacticalPromptText:setTopBottom( false, true, -53.6, -33.1 )
	self.TacticalPromptText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.TacticalPromptText:setRGB( 0.5, 0.5, 0.5 )
	self.TacticalPromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.TacticalPromptText )

	self.TacticalPromptTimer = LUI.UITimer.newElementTimer( 0, false, function ( timerEvent )
		if Engine.LastInput_Gamepad() then
			self.TacticalPromptText:setScale( 0.8 )
			self.TacticalPromptText:setText( Engine.Localize( "[{+smoke}]" ) )
		else
			self.TacticalPromptText:setScale( 0.8 )
			self.TacticalPromptText:setText( Engine.Localize( "[{+smoke}]" ) )

			if string.match( Engine.GetKeyBindingLocalizedString( controller, "+smoke" ), "UNBOUND" ) then
				self.TacticalPromptText:setText( Engine.Localize( "" ) )
			end

			if string.match( Engine.GetKeyBindingLocalizedString( controller, "+smoke" ), "%s" ) then
				if string.len( Engine.GetKeyBindingLocalizedString( controller, "+smoke" ):match("^(.-)%s") ) > 1 then
					if string.len( Engine.GetKeyBindingLocalizedString( controller, "+smoke" ):reverse():match("^(.-)%s") ) > 1 then
						self.TacticalPromptText:setText( Engine.Localize( "" ) )
					else
						self.TacticalPromptText:setText( Engine.Localize( Engine.GetKeyBindingLocalizedString( controller, "+smoke" ):reverse():match("^(.-)%s") ) )
					end
				else
					self.TacticalPromptText:setText( Engine.Localize( Engine.GetKeyBindingLocalizedString( controller, "+smoke" ):match("^(.-)%s") ) )
				end
			end
		end
	end )
	self:addElement( self.TacticalPromptTimer )

	self.TacticalCountText = LUI.UIText.new()
	self.TacticalCountText:setLeftRight( false, true, -184.4, -164.9 )
	self.TacticalCountText:setTopBottom( false, true, -102.8, -90.3 )
	self.TacticalCountText:setText( Engine.Localize( "" ) )
	self.TacticalCountText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.TacticalCountText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.TacticalCountText:setRGB( 0.7, 0.7, 0.7 )
	self:addElement( self.TacticalCountText )

    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentSecondaryOffhand.secondaryOffhand" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		local image = "blacktransparent"
		if modelValue ~= nil then
            if modelValue == "hud_cymbal_monkey_bo3" then
                image = "ui_icon_aura_grenade"
            elseif modelValue == "hud_alices_doll" then   
                image = "ui_icon_aura_grenade"
            else
                image = modelValue    
            end
		end
		self.TacticalImage:setImage( RegisterImage( image ) )
	end )
    
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhandCount" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
        if modelValue ~= nil then
            self.TacticalCountText:setText( Engine.Localize( modelValue ) )
			if modelValue ~= 0 then
				self.TacticalImage:setAlpha( 1 )
			else
				self.TacticalImage:setAlpha( 0.6 )
			end
        end
	end )

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.TacticalImage:close()
		element.TacticalPromptBG:close()
		element.TacticalPromptText:close()
		element.TacticalPromptTimer:close()
		element.TacticalCountText:close()
	end )

    return self
end