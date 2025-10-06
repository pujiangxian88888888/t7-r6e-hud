 ---@diagnostic disable: undefined-global
 
 local PreLoadFunc = function( self, controller )
	Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.revivewidget_timer" )
	Engine.CreateModel( Engine.GetModelForController( controller ), "WorldSpaceIndicators.bleedOutModel" .. Engine.GetClientNum( controller ) .. ".clockPercent" )
	--Engine.CreateModel( Engine.GetModelForController( controller ), "self_revive_progress" )
 end
 
CoD.R6eHudSelfPlayerDownWidget = InheritFrom( LUI.UIElement )
CoD.R6eHudSelfPlayerDownWidget.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudSelfPlayerDownWidget )
	self.id = "R6eHudSelfPlayerDownWidget"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 220 )
	self:setTopBottom( true, false, 0, 220 )
	self.anyChildUsesUpdateState = true

	self.ReviveBarBG = LUI.UIImage.new()
	self.ReviveBarBG:setLeftRight( false, false, -109, 109 )
	self.ReviveBarBG:setTopBottom( false, true, -216.7, -210 )
	self.ReviveBarBG:setImage( RegisterImage( "$white" ) )
	self.ReviveBarBG:setRGB( 0, 0, 0 )
	self.ReviveBarBG:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 1 then
				self.ReviveBarBG:setAlpha( 1 )
			else
				self.ReviveBarBG:setAlpha( 0 )
			end
		end
	end )
	self:addElement( self.ReviveBarBG )

	self.ReviveBar = LUI.UIImage.new()
	self.ReviveBar:setLeftRight( false, false, -109, 109 )
	self.ReviveBar:setTopBottom( false, true, -216.7, -210 )
	self.ReviveBar:setImage( RegisterImage( "$white" ) )
	self.ReviveBar:setRGB( 0.98, 0.88, 0.2 )
	self.ReviveBar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self.ReviveBar:setShaderVector( 0, 0.5, 0, 0, 0 )
	self.ReviveBar:setShaderVector( 1, 0, 0, 0, 0 )
	self.ReviveBar:setShaderVector( 2, 1, 0, 0, 0 )
	self.ReviveBar:setShaderVector( 3, 0, 0, 0, 0 )
	self.ReviveBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "WorldSpaceIndicators.bleedOutModel" .. Engine.GetClientNum( controller ) .. ".clockPercent" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			self.ReviveBar:setShaderVector( 0, modelvalue, 0, 0, 0 )
		end
	end )
	self.ReviveBar:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 1 then
				self.ReviveBar:setAlpha( 1 )
			else
				self.ReviveBar:setAlpha( 0 )
			end
		end
	end )
	self:addElement( self.ReviveBar )

	-- self.SelfReviveBar = LUI.UIImage.new()
	-- self.SelfReviveBar:setLeftRight( false, false, -109, 109 )
	-- self.SelfReviveBar:setTopBottom( false, true, -216.7, -210 )
	-- self.SelfReviveBar:setImage( RegisterImage( "$white" ) )
	-- self.SelfReviveBar:setRGB( 0.98, 0.88, 0.2 )
	-- self.SelfReviveBar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	-- self.SelfReviveBar:setShaderVector( 0, 0.5, 0, 0, 0 )
	-- self.SelfReviveBar:setShaderVector( 1, 0, 0, 0, 0 )
	-- self.SelfReviveBar:setShaderVector( 2, 1, 0, 0, 0 )
	-- self.SelfReviveBar:setShaderVector( 3, 0, 0, 0, 0 )
	-- self.SelfReviveBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.self_revive_progress_bar" ), function ( model )
	-- 	local modelvalue = Engine.GetModelValue( model )
	-- 	if modelvalue ~= nil then
	-- 		self.SelfReviveBar:beginAnimation( "keyframe", 50, false, false, CoD.TweenType.Linear )
	-- 		self.SelfReviveBar:setShaderVector( 0, modelvalue, 0, 0, 0 )
	-- 	end
	-- end )
	-- self.SelfReviveBar:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
	-- 	local modelvalue = Engine.GetModelValue( model )
	-- 	if modelvalue ~= nil then
	-- 		if modelvalue == 1 then
	-- 			self.SelfReviveBar:setAlpha( 1 )
	-- 		else
	-- 			self.SelfReviveBar:setAlpha( 0 )
	-- 		end
	-- 	end
	-- end )
	-- self:addElement( self.SelfReviveBar )

	self.ReviveBarIcon = LUI.UIImage.new()
	self.ReviveBarIcon:setLeftRight( false, false, -132.6, -112 )
	self.ReviveBarIcon:setTopBottom( false, true, -145.7 - 78 , -125 - 78 )
	self.ReviveBarIcon:setImage( RegisterImage( "ui_icon_being_revived" ) )
	--self.ReviveBarIcon:setScale( 2 )
	self.ReviveBarIcon:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 1 then
				self.ReviveBarIcon:setAlpha( 1 )
			else
				self.ReviveBarIcon:setAlpha( 0 )
			end
		end
	end )
	self:addElement( self.ReviveBarIcon )

	self.ReviveText = LUI.UIText.new()
	self.ReviveText:setLeftRight( false, false, -109, 109 )
	self.ReviveText:setTopBottom( false, true, -205, -185 )
	self.ReviveText:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.ReviveText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.ReviveText:setText( Engine.Localize( "UI_HINT_BEING_REVIVED" ) )
	self.ReviveText:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 1 then
				self.ReviveText:setAlpha( 1 )
			else
				self.ReviveText:setAlpha( 0 )
			end
		end
	end )
	self:addElement( self.ReviveText )

	self.BleedOutBarBG = LUI.UIImage.new()
	self.BleedOutBarBG:setLeftRight( false, false, -109, 109 )
	self.BleedOutBarBG:setTopBottom( false, true, -138.7, -132 )
	self.BleedOutBarBG:setImage( RegisterImage( "$white" ) )
	self.BleedOutBarBG:setRGB( 0, 0, 0 )
	self.BleedOutBarBG:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 0 then
				self.BleedOutBarBG:setAlpha( 0 )
			else
				self.BleedOutBarBG:setAlpha( 1 )
			end
		end
	end )
	self:addElement( self.BleedOutBarBG )

	self.BleedOutBar = LUI.UIImage.new()
	self.BleedOutBar:setLeftRight( false, false, -109, 109 )
	self.BleedOutBar:setTopBottom( false, true, -138.7, -132 )
	self.BleedOutBar:setImage( RegisterImage( "$white" ) )
	self.BleedOutBar:setRGB( 1, 0, 0 )
	self.BleedOutBar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self.BleedOutBar:setShaderVector( 0, 0.5, 0, 0, 0 )
	self.BleedOutBar:setShaderVector( 1, 0, 0, 0, 0 )
	self.BleedOutBar:setShaderVector( 2, 1, 0, 0, 0 )
	self.BleedOutBar:setShaderVector( 3, 0, 0, 0, 0 )
	self.BleedOutBar:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 0 then
				self.BleedOutBar:setAlpha( 0 )
			else
				self.BleedOutBar:setAlpha( 1 )
			end
		end
	end )
	self.BleedOutBar:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "bleedOutPercent" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			self.BleedOutBar:setShaderVector( 0, modelvalue, 0, 0, 0 )
		end
	end )
	self:addElement( self.BleedOutBar )

	self.BleedOutBarIcon = LUI.UIImage.new()
	self.BleedOutBarIcon:setLeftRight( false, false, -132.6, -112 )
	self.BleedOutBarIcon:setTopBottom( false, true, -145.7, -125 )
	self.BleedOutBarIcon:setImage( RegisterImage( "ui_icon_selfplayer_down_bleedout_bar_icon" ) )
	self.BleedOutBarIcon:setScale( 2 )
	self.BleedOutBarIcon:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 0 then
				self.BleedOutBarIcon:setAlpha( 0 )
			else
				self.BleedOutBarIcon:setAlpha( 1 )
			end
		end
	end )
	self:addElement( self.BleedOutBarIcon )

	
	--[[
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )

				self.BleedOutBarBG:completeAnimation()
				self.BleedOutBarBG:setAlpha( 0 )
				self.clipFinished( self.BleedOutBarBG, {} )

				self.BleedOutBar:completeAnimation()
				self.BleedOutBar:setAlpha( 1 )
				self.clipFinished( self.BleedOutBar, {} )

				self.BleedOutBarIcon:completeAnimation()
				self.BleedOutBarIcon:setAlpha( 0 )
				self.clipFinished( self.BleedOutBarIcon, {} )

			end
		},
		BleedingOut = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )

				self.BleedOutBarBG:completeAnimation()
				self.BleedOutBarBG:setAlpha( 1 )
				self.clipFinished( self.BleedOutBarBG, {} )

				self.BleedOutBar:completeAnimation()
				self.BleedOutBar:setAlpha( 1 )
				self.clipFinished( self.BleedOutBar, {} )

				self.BleedOutBarIcon:completeAnimation()
				self.BleedOutBarIcon:setAlpha( 1 )
				self.clipFinished( self.BleedOutBarIcon, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "BleedingOut",
			condition = function ( menu, element, event )
				return IsSelfModelValueEnumBitSet( element, controller, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_BLEEDING_OUT )
			end
		}
	} )
	]]--

	self:linkToElementModel( self, "stateFlags", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "stateFlags"
		} )
	end )
	self:linkToElementModel( self, "bleedOutPercent", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "bleedOutPercent"
		} )
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ReviveBarBG:close()
		element.ReviveBar:close()
		--element.SelfReviveBar:close()
		element.ReviveBarIcon:close()
		element.ReviveBarText:close()
		element.BleedOutBarBG:close()
		element.BleedOutBar:close()
		element.BleedOutBarIcon:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

