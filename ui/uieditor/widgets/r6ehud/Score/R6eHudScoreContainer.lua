---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Score.R6eHudScoreTimeAndZoneWidgets" )
require( "ui.uieditor.widgets.r6ehud.Score.R6eHudSelfScore" )
require( "ui.uieditor.widgets.r6ehud.Score.R6eHudTeammateScore" )
require( "ui.uieditor.widgets.HUD.ZM_Score.ZMScr_PlusPointsContainer" )

DataSources.ZMPlayerList = {
	getModel = function ( controller )
		return Engine.CreateModel( Engine.GetModelForController( controller ), "PlayerList" )
	end
}

CoD.R6eHudScoreContainer = InheritFrom( LUI.UIElement )
CoD.R6eHudScoreContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudScoreContainer )
	self.id = "R6eHudScoreContainer"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

    self.TimeAndZoneWidgets = CoD.R6eHudScoreTimeAndZoneWidgets.new( menu, controller )
    self.TimeAndZoneWidgets:setLeftRight( true, true, 0, 0 )
	self.TimeAndZoneWidgets:setTopBottom( true, true, 0, 0 )
    self:addElement( self.TimeAndZoneWidgets )
	
	self.ListingUser = LUI.UIList.new( menu, controller, 2, 0, nil, false, false, 0, 0, false, false )
	self.ListingUser:makeFocusable()
	self.ListingUser:setLeftRight( true, true, 0, 0 )
	self.ListingUser:setTopBottom( true, true, 0, 0 )
	self.ListingUser:setWidgetType( CoD.R6eHudSelfScore )
	self.ListingUser:setDataSource( "PlayerListZM" )
	self.ListingUser:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				if not IsSelfModelValueEqualTo( element, controller, "playerScoreShown", 0 ) then
					return true
				else
					return false
				end
			end
		}
	} )
	self.ListingUser:linkToElementModel( self.ListingUser, "playerScoreShown", true, function ( modelRef )
		menu:updateElementState( self.ListingUser, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "playerScoreShown"
		} )
	end )
	self:addElement( self.ListingUser )
	
	self.Listing2 = CoD.R6eHudTeammateScore.new( menu, controller )
	self.Listing2:setLeftRight( true, true, 0, 0 )
	self.Listing2:setTopBottom( true, true, 0, 0 )
	self.Listing2:subscribeToGlobalModel( controller, "ZMPlayerList", "1", function ( modelRef )
		self.Listing2:setModel( modelRef, controller )
	end )
	self:addElement( self.Listing2 )
	
	self.Listing3 = CoD.R6eHudTeammateScore.new( menu, controller )
	self.Listing3:setLeftRight( true, true, 0, 0 )
	self.Listing3:setTopBottom( true, true, 0, -54 )
	self.Listing3:subscribeToGlobalModel( controller, "ZMPlayerList", "2", function ( modelRef )
		self.Listing3:setModel( modelRef, controller )
	end )
	self:addElement( self.Listing3 )
	
	self.Listing4 = CoD.R6eHudTeammateScore.new( menu, controller )
	self.Listing4:setLeftRight( true, true, 0, 0 )
	self.Listing4:setTopBottom( true, true, 0, -108 )
	self.Listing4:subscribeToGlobalModel( controller, "ZMPlayerList", "3", function ( modelRef )
		self.Listing4:setModel( modelRef, controller )
	end )
	self:addElement( self.Listing4 )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

                self.TimeAndZoneWidgets:completeAnimation()
				self.TimeAndZoneWidgets:setAlpha( 0 )
				self.clipFinished( self.TimeAndZoneWidgets, {} )

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 0 )
				self.clipFinished( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 0 )
				self.clipFinished( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 0 )
				self.clipFinished( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 0 )
				self.clipFinished( self.Listing4, {} )

			end,
			HudStart = function ()
				self:setupElementClipCounter( 4 )

				local HudStartTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 1 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

                self.TimeAndZoneWidgets:completeAnimation()
				self.TimeAndZoneWidgets:setAlpha( 0 )
				HudStartTransition( self.TimeAndZoneWidgets, {} )

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 0 )
				HudStartTransition( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 0 )
				HudStartTransition( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 0 )
				HudStartTransition( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 0 )
				HudStartTransition( self.Listing4, {} )

			end
		},
		HudStart = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

                self.TimeAndZoneWidgets:completeAnimation()
				self.TimeAndZoneWidgets:setAlpha( 1 )
				self.clipFinished( self.TimeAndZoneWidgets, {} )

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 1 )
				self.clipFinished( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 1 )
				self.clipFinished( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 1 )
				self.clipFinished( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 1 )
				self.clipFinished( self.Listing4, {} )
				
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 4 )
				
				local DefaultStateTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

                self.TimeAndZoneWidgets:completeAnimation()
				self.TimeAndZoneWidgets:setAlpha( 1 )
				DefaultStateTransition( self.TimeAndZoneWidgets, {} )

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 1 )
				DefaultStateTransition( self.ListingUser, {} )
				
				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 1 )
				DefaultStateTransition( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 1 )
				DefaultStateTransition( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 1 )
				DefaultStateTransition( self.Listing4, {} )

			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "HudStart",
			condition = function ( menu, element, event )
				if IsModelValueTrue( controller, "hudItems.playerSpawned" ) then
					if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					and Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE ) then
						return true
					else
						return false
					end
				end
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.playerSpawned" ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.playerSpawned"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
		} )
	end )

	self.ListingUser.id = "ListingUser"

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.TimeAndZoneWidgets:close()
		element.ListingUser:close()
		element.Listing2:close()
		element.Listing3:close()
		element.Listing4:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
