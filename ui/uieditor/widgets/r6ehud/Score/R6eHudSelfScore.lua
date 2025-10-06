---@diagnostic disable: undefined-global

local PreLoadFunc = function ( self, controller )
	Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.HealthBar" )
end

CoD.R6eHudSelfScore = InheritFrom( LUI.UIElement )
CoD.R6eHudSelfScore.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudSelfScore )
	self.id = "R6eHudSelfScore"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.PlayerIconBG = LUI.UIImage.new()
	self.PlayerIconBG:setLeftRight( true, false, 60, 116 )
	self.PlayerIconBG:setTopBottom( false, true, -91.3, -30 )
	self.PlayerIconBG:setImage( RegisterImage( "ui_icon_player_icon_bg" ) )
	self:addElement( self.PlayerIconBG )

	self.PortraitImage = LUI.UIImage.new()
	self.PortraitImage:setLeftRight( true, false, 60, 116 )
	self.PortraitImage:setTopBottom( false, true, -91.3, -30 )
	self.PortraitImage:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.PortraitImage )

	self.ScoreText = LUI.UIText.new()
	self.ScoreText:setLeftRight( true, false, 124, 265 )
	self.ScoreText:setTopBottom( false, true, -74, -38.7 )
	self.ScoreText:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.ScoreText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreText )

	self.HealthBarBG = LUI.UIImage.new()
	self.HealthBarBG:setLeftRight( true, false, 120.3, 293.7 )
	self.HealthBarBG:setTopBottom( false, true, -41.7, -27.7 )
	self.HealthBarBG:setImage( RegisterImage( "ui_icon_health_bar_bg" ) )
	self:addElement( self.HealthBarBG )

	self.HealthBar = LUI.UIImage.new( self, Instance )
	self.HealthBar:setLeftRight( true, false, 121.8, 290.2 )
	self.HealthBar:setTopBottom( false, true, -37.7, -30.7 )
	self.HealthBar:setImage( RegisterImage( "ui_icon_hud_selfhealthbar_jugg" ) )
	self.HealthBar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self.HealthBar:setShaderVector( 0, 0.5, 0, 0, 0 )
	self.HealthBar:setShaderVector( 1, 0, 0, 0, 0 )
	self.HealthBar:setShaderVector( 2, 1, 0, 0, 0 )
	self.HealthBar:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.HealthBar )

	self.HealthText = LUI.UIText.new()
	self.HealthText:setLeftRight( true, false, 297, 415 )
	self.HealthText:setTopBottom( false, true, -48, -23.7 )
	self.HealthText:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.HealthText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
    self:addElement( self.HealthText )
	
	self.ColorBlock = LUI.UIImage.new()
	self.ColorBlock:setLeftRight( true, false, 60, 66 )
	self.ColorBlock:setTopBottom( false, true, -91.3, -85.3 )
	self.ColorBlock:setImage( RegisterImage( "$white" ) )
	self:addElement( self.ColorBlock )

	self.SelfPlayerDownIcon = LUI.UIImage.new()
	self.SelfPlayerDownIcon:setLeftRight( true, false, 60, 116 )
	self.SelfPlayerDownIcon:setTopBottom( false, true, -91.3, -30 )
	self.SelfPlayerDownIcon:setImage( RegisterImage( "ui_icon_self_player_down" ) )
	self.SelfPlayerDownIcon:subscribeToModel( Engine.GetModel( CoD.player_health_bar_bleedout, "stateFlags" ), function ( model )
		local modelvalue = Engine.GetModelValue( model )
		if modelvalue ~= nil then
			if modelvalue == 0 then
				self.SelfPlayerDownIcon:setAlpha( 0 )
			else
				self.SelfPlayerDownIcon:setAlpha( 1 )
			end
		end
	end )
	self:addElement( self.SelfPlayerDownIcon )

	self.PortraitImage:linkToElementModel( self, "zombiePlayerIcon", true, function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.PortraitImage:setImage( RegisterImage( Engine.GetModelValue( modelRef ) ) )
			--[[
			if Engine.GetModelValue( modelRef ) == "uie_t7_zm_hud_score_char_sakuya" then
				self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_sakuya" ) )

			elseif Engine.GetModelValue( modelRef ) == "uie_t7_zm_hud_score_char_marisa" then
				self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_marisa" ) )

			elseif Engine.GetModelValue( modelRef ) == "uie_t7_zm_hud_score_char_youmu" then
				self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_youmu" ) )

			elseif Engine.GetModelValue( modelRef ) == "uie_t7_zm_hud_score_char_reimu" then
				self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_reimu" ) )

			elseif Engine.GetModelValue( modelRef ) == "uie_t7_zm_hud_score_char_isla" then
				self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_isla" ) )
			else
				self.PortraitImage:setImage( RegisterImage( "blacktransparent" ) )
			end
			]]--
		end
	end )

	self.ScoreText:linkToElementModel( self, "playerScore", true, function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			if tonumber( Engine.GetModelValue( modelRef ) ) <= 99999 then
				self.ScoreText:setText( Engine.Localize( Engine.GetModelValue( modelRef ) ) )
			else
				self.ScoreText:setText( 99999 ) 
			end
		end
	end )

	local lastsenthealth = 100
	local maxhealth = 200
    self.HealthBar:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.HealthBar" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
				local currenthealth = Engine.GetModelValue( modelRef )
				if lastsenthealth ~= currenthealth then
					local ratio = currenthealth / maxhealth
					--self.HealthBar:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
					if Engine.GetModelValue( modelRef ) <= 30 then
						self.HealthBar:setRGB( 1, 0, 0 )
					else
						self.HealthBar:setRGB( 1, 1, 1 )
					end
					self.HealthBar:setShaderVector( 0, ratio, 0, 0, 0 )
					end
				end	
				lastsenthealth = currenthealth
	
	end )

    self.HealthText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.HealthBar" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.HealthText:setText( Engine.Localize( Engine.GetModelValue( modelRef ) ) )
			if Engine.GetModelValue( modelRef ) <= 30 then	
				self.HealthText:setRGB( 1, 0, 0 )
			else
				self.HealthText:setRGB( 1, 1, 1 )
			end
		end
	end )

	self.ColorBlock:linkToElementModel( self, "clientNum", true, function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.ColorBlock:setRGB( ZombieClientScoreboardColor( Engine.GetModelValue( modelRef ) ) )
		end
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.PlayerIconBG:close()
		element.PortraitImage:close()
		element.ScoreText:close()
		element.HealthBarBG:close()
		element.HealthBar:close()
		element.HealthText:close()
		element.ColorBlock:close()
		element.SelfPlayerDownIcon:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
