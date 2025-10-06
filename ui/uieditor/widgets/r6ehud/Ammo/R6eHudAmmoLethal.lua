---@diagnostic disable: undefined-global

CoD.R6eHudAmmoLethal = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoLethal.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoLethal )
	self.id = "R6eHudAmmoLethal"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    --对所有的装备：玩家未持有不显示图标，玩家持有但当前数量为0设置alpha为0.6
	self.LethalImage = LUI.UIImage.new()
	self.LethalImage:setLeftRight( false, true, -243, -168 )
	--左右：两个参数同时下降，对象往左移动
	self.LethalImage:setTopBottom( false, true, -111.3, -30.5 ) 
	--上下：两个参数同时下降，对象往上移动
	self.LethalImage:setImage( RegisterImage( "blacktransparent" ) )
	self.LethalImage:setScale( 0.38 )
	self.LethalImage:setAlpha( 0 )
	self:addElement( self.LethalImage )

	self.LethalPromptBG = LUI.UIImage.new()
	self.LethalPromptBG:setLeftRight( false, true, -222.7, -186.7 )
	self.LethalPromptBG:setTopBottom( false, true, -62.1, -26.1 )
	self.LethalPromptBG:setImage( RegisterImage( "ui_icon_key_prompt_bg" ) )
	self.LethalPromptBG:setScale( 0.65 )
	if Engine.LastInput_Gamepad() then
		self.LethalPromptBG:setAlpha( 0 )
	else
		self.LethalPromptBG:setAlpha( 1 )
	end
	self:addElement( self.LethalPromptBG )

	self.LethalPromptText = LUI.UIText.new()
	self.LethalPromptText:setLeftRight( false, true, -303.3, -106.3 )
	self.LethalPromptText:setTopBottom( false, true, -53.6, -33.1 )
	self.LethalPromptText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.LethalPromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.LethalPromptText:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.LethalPromptText )

	self.LethalPromptTimer = LUI.UITimer.newElementTimer( 0, false, function ( timerEvent )
		if Engine.LastInput_Gamepad() then
			self.LethalPromptText:setScale( 0.8 )
			self.LethalPromptText:setText( Engine.Localize( "[{+frag}]" ) )
		else
			self.LethalPromptText:setScale( 0.8 )
			self.LethalPromptText:setText( Engine.Localize( "[{+frag}]" ) )

			if string.match( Engine.GetKeyBindingLocalizedString( controller, "+frag" ), "UNBOUND" ) then
				self.LethalPromptText:setText( Engine.Localize( "" ) )
			end

			if string.match( Engine.GetKeyBindingLocalizedString( controller, "+frag" ), "%s" ) then
				if string.len( Engine.GetKeyBindingLocalizedString( controller, "+frag" ):match("^(.-)%s") ) > 1 then
					if string.len( Engine.GetKeyBindingLocalizedString( controller, "+frag" ):reverse():match("^(.-)%s") ) > 1 then
						self.LethalPromptText:setText( Engine.Localize( "" ) ) --如果玩家在此处绑定了两个键或者是鼠标中键，导致返回字符串太长(例如G or Middle Mouse)，就直接不显示文本
					else
						self.LethalPromptText:setText( Engine.Localize( Engine.GetKeyBindingLocalizedString( controller, "+frag" ):reverse():match("^(.-)%s") ) )
					end
				else
					self.LethalPromptText:setText( Engine.Localize( Engine.GetKeyBindingLocalizedString( controller, "+frag" ):match("^(.-)%s") ) )
				end
			end
		end
	end )
	self:addElement( self.LethalPromptTimer )

	self.LethalCountText = LUI.UIText.new()
	self.LethalCountText:setLeftRight( false, true, -215.4, -195.9 )
	self.LethalCountText:setTopBottom( false, true, -102.8, -90.3 )
	self.LethalCountText:setText( Engine.Localize( "0" ) )
	self.LethalCountText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.LethalCountText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.LethalCountText:setRGB( 0.7, 0.7, 0.7 )
	self:addElement( self.LethalCountText )

    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentPrimaryOffhand.primaryOffhand" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		local image = "blacktransparent"
		if modelValue ~= nil then
            if modelValue == "uie_t7_zm_hud_inv_icnlthl" then
                image = "ui_icon_frag_grenade"
            elseif modelValue == "uie_t7_zm_hud_inv_widowswine" then   
                image = "ui_icon_glue_grenade"
            else
                image = modelValue    
            end
		end
		self.LethalImage:setImage( RegisterImage( image ) )
	end )
    
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentPrimaryOffhand.primaryOffhandCount" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
        if modelValue ~= nil then
            self.LethalCountText:setText( Engine.Localize( modelValue ) )
			if modelValue ~= 0 then
				self.LethalImage:setAlpha( 1 )
			else
				self.LethalImage:setAlpha( 0.6 )
			end
        end
	end )

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.LethalImage:close()
		element.LethalPromptBG:close()
		element.LethalPromptText:close()
		element.LethalPromptTimer:close()
		element.LethalCountText:close()
	end )

    return self
end