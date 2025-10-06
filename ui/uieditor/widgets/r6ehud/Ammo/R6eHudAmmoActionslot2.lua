---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot2Shield" )

CoD.R6eHudAmmoActionslot2 = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslot2.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslot2 )
	self.id = "R6eHudAmmoActionslot2"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.ShieldIcon = CoD.R6eHudAmmoActionslot2Shield.new( menu, controller )
	self.ShieldIcon:setLeftRight( true, true, 0, 0 )
	self.ShieldIcon:setTopBottom( true, true, 0, 0 )
	self.ShieldIcon:setAlpha( 1 )
	self:addElement( self.ShieldIcon )

	self.ShieldImage = LUI.UIImage.new()
	--self.ShieldImage:setLeftRight( false, true, -179, -125.5 )
	--self.ShieldImage:setTopBottom( false, true, -79, -25 )
	self.ShieldImage:setLeftRight( false, true, -155.5, -121 )
	self.ShieldImage:setTopBottom( false, true, -96.5, -45 )
	self.ShieldImage:setImage( RegisterImage( "blacktransparent" ) )
	self.ShieldImage:setAlpha( 0.8 )
	self.ShieldImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) == 1 then
			self.ShieldImage:setImage( RegisterImage( "ui_icon_riot_shield" ) )
			self.ShieldImage:setScale( 0.5 )
		else
			self.ShieldImage:setImage( RegisterImage( "blacktransparent" ) )
		end
	end )
	self:addElement( self.ShieldImage )

	self.ShieldMeter = LUI.UIImage.new()
	self.ShieldMeter:setLeftRight( false, true, -150, -106 )
	self.ShieldMeter:setTopBottom( false, true, -73, -69 )
	self.ShieldMeter:setImage( RegisterImage( "blacktransparent" ) )
	self.ShieldMeter:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self.ShieldMeter:setShaderVector( 1, 0, 0, 0, 0 )
	self.ShieldMeter:setShaderVector( 2, 1, 0, 0, 0 )
	self.ShieldMeter:setShaderVector( 3, 0, 0, 0, 0 )
	self.ShieldMeter:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) == 1 then
			self.ShieldMeter:setImage( RegisterImage( "ui_icon_vest_health_bar" ) )
			self.ShieldMeter:setZRot( 90 )
			self.ShieldMeter:setScale( 0.5 )
		else
			self.ShieldMeter:setImage( RegisterImage( "blacktransparent" ) )
		end
	end )
	self.ShieldMeter:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "ZMInventory.shield_health" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.ShieldMeter:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )

			self.ShieldMeter:setShaderVector( 0, AdjustStartEnd( 0, 1,
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 1 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 2 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 3 ),
				CoD.GetVectorComponentFromString( Engine.GetModelValue( modelRef ), 4 ) )
			)
		end
	end )
	self:addElement( self.ShieldMeter )

	self.Actionslot2PromptBG = LUI.UIImage.new()
	self.Actionslot2PromptBG:setLeftRight( false, true, -152.7, -116.7 )
	self.Actionslot2PromptBG:setTopBottom( false, true, -62.1, -26.1 )
	self.Actionslot2PromptBG:setImage( RegisterImage( "ui_icon_key_prompt_bg" ) )
	self.Actionslot2PromptBG:setScale( 0.66 )
	if Engine.LastInput_Gamepad() then
		self.Actionslot2PromptBG:setAlpha( 0 )
	else
		self.Actionslot2PromptBG:setAlpha( 1 )
	end
	self:addElement( self.Actionslot2PromptBG )

	self.Actionslot2PromptText = LUI.UIText.new()
	self.Actionslot2PromptText:setLeftRight( false, true, -233.2, -36.2  )
	self.Actionslot2PromptText:setTopBottom( false, true, -53.6, -33.1 )
	self.Actionslot2PromptText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.Actionslot2PromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.Actionslot2PromptText:setText( "[{+actionslot 2}]"  )
	self.Actionslot2PromptText:setScale( 0.8 )
	self.Actionslot2PromptText:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.Actionslot2PromptText )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.ShieldIcon:completeAnimation()
				self.ShieldIcon:setAlpha( 0 )
				self.clipFinished( self.ShieldIcon, {} )
			end
		},
		Shield = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.ShieldIcon:completeAnimation()
				self.ShieldIcon:setAlpha( 1 )
				self.clipFinished( self.ShieldIcon, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Shield",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadDown", 1 )
			end
		}
	} )
	
	LUI.OverrideFunction_CallOriginalFirst( self, "setState", function ( element, controller )
		local f9_local0 = element:getParent()
		f9_local0:dispatchEventToChildren( {
			name = "actionslot2_update",
			stateName = controller
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ShieldIcon:close()
		element.ShieldImage:close()
		element.ShieldMeter:close()
		element.Actionslot2PromptBG:close()
		element.Actionslot2PromptText:close()
	end )

	return self
end

