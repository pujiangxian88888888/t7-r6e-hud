---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudTeammateScore = InheritFrom( LUI.UIElement )
CoD.R6eHudTeammateScore.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudTeammateScore )
	self.id = "R6eHudTeammateScore"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.PlayerIconBG = LUI.UIImage.new()
	self.PlayerIconBG:setLeftRight( true, false, 60, 102.7 )
	self.PlayerIconBG:setTopBottom( false, true, -150.6, -109.3 )
	self.PlayerIconBG:setImage( RegisterImage( "ui_icon_player_icon_bg" ) )
	self:addElement( self.PlayerIconBG )

	self.PortraitImage = LUI.UIImage.new()
	self.PortraitImage:setLeftRight( true, false, 60, 102.7 )
	self.PortraitImage:setTopBottom( false, true, -150.6, -109.3 )
	self.PortraitImage:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.PortraitImage )

	self.TeammateDownBG = LUI.UIImage.new()
	self.TeammateDownBG:setLeftRight( true, false, 60, 102.7 )
	self.TeammateDownBG:setTopBottom( false, true, -150.6, -109.3 )
	self.TeammateDownBG:setImage( RegisterImage( "$white" ) )
	self.TeammateDownBG:setRGB( 0.4, 0.4, 0.4 )
	self.TeammateDownBG:setAlpha( 0 )
	self:addElement( self.TeammateDownBG )

	self.ScoreText = LUI.UIText.new()
	self.ScoreText:setLeftRight( true, false, 244, 344 )
	self.ScoreText:setTopBottom( false, true, -122.6, -107.6 )
	self.ScoreText:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.ScoreText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ScoreText )

	self.HealthBarBG = LUI.UIImage.new()
	self.HealthBarBG:setLeftRight( true, false, 109.3, 241.3 )
	self.HealthBarBG:setTopBottom( false, true, -117.1, -110.6 )
	self.HealthBarBG:setImage( RegisterImage( "$white" ) )
	self.HealthBarBG:setRGB( 0.4, 0.4, 0.4 )
	self:addElement( self.HealthBarBG )

	self.HealthBar = LUI.UIImage.new( self, Instance )
	self.HealthBar:setLeftRight( true, false, 109.3, 241.3 )
	self.HealthBar:setTopBottom( false, true, -117.1, -110.6 )
	self.HealthBar:setImage( RegisterImage( "$white" ) )
	self.HealthBar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	self.HealthBar:setShaderVector( 0, 0.5, 0, 0, 0 )
	self.HealthBar:setShaderVector( 1, 0, 0, 0, 0 )
	self.HealthBar:setShaderVector( 2, 1, 0, 0, 0 )
	self.HealthBar:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.HealthBar )
	self.HealthBar:setModel( Engine.GetModel( Engine.GetGlobalModel(), "scoreboard.team1" ) ) 

	self.TeammateDownIcon = LUI.UIImage.new()
	self.TeammateDownIcon:setLeftRight( true, false, 223, 243.3 )
	self.TeammateDownIcon:setTopBottom( false, true, -139.8, -119.1 )
	self.TeammateDownIcon:setImage( RegisterImage( "ui_icon_selfplayer_down_bleedout_bar_icon" ) )
	self.TeammateDownIcon:setScale( 1.5 )
	self.TeammateDownIcon:setAlpha( 0 )
	self:addElement( self.TeammateDownIcon )

	self.TeammateDeadIcon = LUI.UIImage.new()
	self.TeammateDeadIcon:setLeftRight( true, false, 220, 241 )
	self.TeammateDeadIcon:setTopBottom( false, true, -140.1, -119.1 )
	self.TeammateDeadIcon:setImage( RegisterImage( "ui_icon_teammate_dead_icon" ) )
	self.TeammateDeadIcon:setAlpha( 0 )
	self:addElement( self.TeammateDeadIcon )

	self.ColorBlock = LUI.UIImage.new()
	self.ColorBlock:setLeftRight( true, false, 60, 66 )
	self.ColorBlock:setTopBottom( false, true, -150.6, -144.6 )
	self.ColorBlock:setImage( RegisterImage( "$white" ) )
	self:addElement( self.ColorBlock )

    self.PortraitImage:linkToElementModel( self, "zombiePlayerIcon", true, function ( modelRef )
			if Engine.GetModelValue( modelRef ) then
				self.PortraitImage:setImage( RegisterImage( Engine.GetModelValue( modelRef ) ) )
				-- if Engine.GetModelValue( modelRef ) == "ui_icon_hero_portrait_draft_sakuya" then
				-- 	self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_sakuya_teammate" ) )
	
				-- elseif Engine.GetModelValue( modelRef ) == "ui_icon_hero_portrait_draft_marisa" then
				-- 	self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_marisa_teammate" ) )
	
				-- elseif Engine.GetModelValue( modelRef ) == "ui_icon_hero_portrait_draft_youmu" then
				-- 	self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_youmu_teammate" ) )
	
				-- elseif Engine.GetModelValue( modelRef ) == "ui_icon_hero_portrait_draft_reimu" then
				-- 	self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_reimu_teammate" ) )

				-- elseif Engine.GetModelValue( modelRef ) == "ui_icon_hero_portrait_draft_isla" then
				-- 	self.PortraitImage:setImage( RegisterImage( "ui_icon_hero_portrait_draft_isla_teammate" ) )

				-- else
				-- 	self.PortraitImage:setImage( RegisterImage( "blacktransparent" ) )
				-- end
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

	for i = 0 , Engine.DvarInt(nil , "com_maxclients") - 1 , 1 do
		self.HealthBar:linkToElementModel( self.HealthBar, tostring( i ) .. ".clientNumScoreInfoUpdated", true, function( model ) 
			local clientNumScoreInfoUpdated = Engine.GetModelValue( model )
			if clientNumScoreInfoUpdated then
				local clientNum = Engine.GetModelValue( self:getModel( controller, "clientNum" ) )
				local clientNum2 = Engine.GetModelValue( self.HealthBar:getModel( controller, tostring( i ) .. ".clientNum" ) )
				Maxhealth = tonumber( GetScoreboardPlayerScoreColumn( controller, 8, clientNumScoreInfoUpdated ) )
				if Maxhealth and clientNum and clientNum2 and tostring( clientNum ) == tostring( clientNum2 )  then
					local health = tonumber( GetScoreboardPlayerScoreColumn( controller, 7, clientNumScoreInfoUpdated ) )
					if Maxhealth == 0 then  
						self.HealthBar:setAlpha( 0 )
					elseif Maxhealth == 1000 then --Player Dead
						self.HealthBar:setAlpha( 0 )
						self.HealthBarBG:setAlpha( 0 )
						self.TeammateDownIcon:setAlpha( 0 )
						self.TeammateDeadIcon:setAlpha( 1 )
						self.TeammateDownBG:setAlpha( 0 )
						self.PortraitImage:setRGB( 0.4, 0.4, 0.4 )
					else
						self.TeammateDeadIcon:setAlpha( 0 )
						self.HealthBarBG:setAlpha( 1 )
						self.HealthBar:setAlpha( 1 )
						self.PortraitImage:setRGB( 1, 1, 1 )
						--self.HealthBar:completeAnimation()
						if Maxhealth == 45 then --Player Down,45 is bleedout time,see _zm_r6e_hud.gsc				
							--self.HealthBar:setImage( RegisterImage( "ui_icon_teammate_bleedout_bar" ) ) 
							self.HealthBar:setRGB( 1, 0, 0 )
							self.TeammateDownBG:setAlpha( 1 )
							self.TeammateDownIcon:setAlpha( 1 )
						else
							--self.HealthBar:setImage( RegisterImage( "ui_icon_teammate_healthbar" ) )
							self.HealthBar:setRGB( 1, 1, 1 )
							self.TeammateDownBG:setAlpha( 0 )
							self.TeammateDownIcon:setAlpha( 0 )
						end
						--self.HealthBar:beginAnimation( "keyframe", 200, false, false, CoD.TweenType.Linear )
						self.HealthBar:setShaderVector( 0, health / Maxhealth, 0, 0, 0 )
					end
				end
			end
		end )
	end

	self.PlayerName = LUI.UIText.new()
	self.PlayerName:setLeftRight( true, false, 109.3, 300 )
	self.PlayerName:setTopBottom( false, true, -134.6, -122.6 )
	self.PlayerName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.PlayerName:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.PlayerName )

	self.ColorBlock:linkToElementModel( self, "clientNum", true, function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			self.ColorBlock:setRGB( ZombieClientScoreboardColor( Engine.GetModelValue( modelRef ) ) )
		end
	end )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				self.PlayerIconBG:completeAnimation()
				self.PlayerIconBG:setAlpha( 0 )
				self.clipFinished( self.PlayerIconBG, {} )

				self.PortraitImage:completeAnimation()
				self.PortraitImage:setAlpha( 0 )
				self.clipFinished( self.PortraitImage, {} )

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha( 0 )
				self.clipFinished( self.ScoreText, {} )

				self.ColorBlock:completeAnimation()
				self.ColorBlock:setAlpha( 0 )
				self.clipFinished( self.ColorBlock, {} )

				self.HealthBar:completeAnimation()
				self.HealthBar:setAlpha( 0 )
				self.clipFinished( self.HealthBar, {} )

				self.HealthBarBG:completeAnimation()
				self.HealthBarBG:setAlpha( 0 )
				self.clipFinished( self.HealthBarBG, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 0 )
				self.clipFinished( self.PlayerName, {} )

			end
			
		},
		Visible_Alive = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
                
				self.PlayerIconBG:completeAnimation()
				self.PlayerIconBG:setAlpha( 1 )
				self.clipFinished( self.PlayerIconBG, {} )

				self.PortraitImage:completeAnimation()
				self.PortraitImage:setAlpha( 1 )
				self.clipFinished( self.PortraitImage, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 1 )
				self.clipFinished( self.PlayerName, {} )

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha( 1 )
				self.clipFinished( self.ScoreText, {} )

				self.ColorBlock:completeAnimation()
				self.ColorBlock:setAlpha( 1 )
				self.clipFinished( self.ColorBlock, {} )

				self.HealthBar:completeAnimation()
				self.HealthBar:setAlpha( 1 )
				self.clipFinished( self.HealthBar, {} )

				self.HealthBarBG:completeAnimation()
				self.HealthBarBG:setAlpha( 1 )
				self.clipFinished( self.HealthBarBG, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 1 )
				self.clipFinished( self.PlayerName, {} )

				self.TeammateDownIcon:completeAnimation()
				self.TeammateDownIcon:setAlpha( 0 )
				self.clipFinished( self.TeammateDownIcon, {} )

				self.TeammateDeadIcon:completeAnimation()
				self.TeammateDeadIcon:setAlpha( 0 )
				self.clipFinished( self.TeammateDeadIcon, {} )

				self.TeammateDownBG:completeAnimation()
				self.TeammateDownBG:setAlpha( 0 )
				self.clipFinished( self.TeammateDownBG, {} )

			end	
		},
		Visible_Down = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
                
				self.PlayerIconBG:completeAnimation()
				self.PlayerIconBG:setAlpha( 1 )
				self.clipFinished( self.PlayerIconBG, {} )

				self.PortraitImage:completeAnimation()
				self.PortraitImage:setAlpha( 1 )
				self.clipFinished( self.PortraitImage, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 1 )
				self.clipFinished( self.PlayerName, {} )

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha( 1 )
				self.clipFinished( self.ScoreText, {} )

				self.ColorBlock:completeAnimation()
				self.ColorBlock:setAlpha( 1 )
				self.clipFinished( self.ColorBlock, {} )

				self.HealthBar:completeAnimation()
				self.HealthBar:setAlpha( 1 )
				self.clipFinished( self.HealthBar, {} )

				self.HealthBarBG:completeAnimation()
				self.HealthBarBG:setAlpha( 1 )
				self.clipFinished( self.HealthBarBG, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 1 )
				self.PlayerName:beginAnimation( "keyframe", 1, false, false, CoD.TweenType.Linear )
				self.PlayerName:setAlpha( 0 ) 
				SetupNextAnimation( self.PlayerName, function ( f6_arg0 )
					f6_arg0:beginAnimation( "keyframe", 1000, false, false, CoD.TweenType.Linear )
					SetupNextAnimation( f6_arg0, function( next )
						next:beginAnimation( "keyframe", 1, false, false, CoD.TweenType.Linear )
						next:setAlpha( 1 )
						PlayClipOnAnimationEnd( next, controller, "DefaultClip" )
					end
				)
				end )

				self.TeammateDownIcon:completeAnimation()
				self.TeammateDownIcon:setAlpha( 1 )
				self.clipFinished( self.TeammateDownIcon, {} )

				self.TeammateDeadIcon:completeAnimation()
				self.TeammateDeadIcon:setAlpha( 0 )
				self.clipFinished( self.TeammateDeadIcon, {} )

				self.TeammateDownBG:completeAnimation()
				self.TeammateDownBG:setAlpha( 1 )
				self.clipFinished( self.TeammateDownBG, {} )

			end	
		},
		Visible_Dead = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
                
				self.PlayerIconBG:completeAnimation()
				self.PlayerIconBG:setAlpha( 1 )
				self.clipFinished( self.PlayerIconBG, {} )

				self.PortraitImage:completeAnimation()
				self.PortraitImage:setAlpha( 1 )
				self.clipFinished( self.PortraitImage, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 1 )
				self.clipFinished( self.PlayerName, {} )

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha( 1 )
				self.clipFinished( self.ScoreText, {} )

				self.ColorBlock:completeAnimation()
				self.ColorBlock:setAlpha( 1 )
				self.clipFinished( self.ColorBlock, {} )

				self.HealthBar:completeAnimation()
				self.HealthBar:setAlpha( 1 )
				self.clipFinished( self.HealthBar, {} )

				self.HealthBarBG:completeAnimation()
				self.HealthBarBG:setAlpha( 1 )
				self.clipFinished( self.HealthBarBG, {} )

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha( 1 )
				self.clipFinished( self.PlayerName, {} )

				self.TeammateDownIcon:completeAnimation()
				self.TeammateDownIcon:setAlpha( 0 )
				self.clipFinished( self.TeammateDownIcon, {} )

				self.TeammateDeadIcon:completeAnimation()
				self.TeammateDeadIcon:setAlpha( 1 )
				self.clipFinished( self.TeammateDeadIcon, {} )

				self.TeammateDownBG:completeAnimation()
				self.TeammateDownBG:setAlpha( 0 )
				self.clipFinished( self.TeammateDownBG, {} )

			end	
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "Visible_Alive",
			condition = function ( menu, element, event )
				return ( not IsSelfModelValueEqualTo( element, controller, "playerScoreShown", 0 ) ) and ( Maxhealth ~= 45 ) and ( Maxhealth ~= 1000 )
			end
		},
		{
			stateName = "Visible_Down",
			condition = function ( menu, element, event )
				return ( not IsSelfModelValueEqualTo( element, controller, "playerScoreShown", 0 ) ) and ( Maxhealth == 45 )
			end
		},
		{
			stateName = "Visible_Death",
			condition = function ( menu, element, event )
				return ( not IsSelfModelValueEqualTo( element, controller, "playerScoreShown", 0 ) ) and ( Maxhealth == 1000 )
			end
		}

	} )

	self.PlayerName:linkToElementModel( self, "clientNum", true, function ( model )
		if Engine.GetModelValue( model ) then
			PlayerNameText = GetClientNameAndClanTag( controller, Engine.GetModelValue( model ) )
			self.PlayerName:setText( PlayerNameText )
		end
	end )

	self:linkToElementModel( self, "playerScoreShown", true, function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "playerScoreShown"
		} )
	end )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.PlayerIconBG:close()
		element.PortraitImage:close()
		element.TeammateDownBG:close()
		element.ScoreText:close()
		element.HealthBar:close()
		element.HealthBarBG:close()
		element.TeammateDownIcon:close()
		element.TeammateDeadIcon:close()
		element.ColorBlock:close()
		element.PlayerName:close()
		element.TeammateDownText:close()

	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
