---@diagnostic disable: undefined-global

--require( "ui_mp.t6.zombie.R6eHudPostLoad" )

require( "ui.uieditor.widgets.HUD.ZM_RoundWidget.ZmRndContainer" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidgetFactory.ZmAmmoContainerFactory" )
require( "ui.uieditor.widgets.HUD.ZM_Score.ZMScr" )
require( "ui.uieditor.widgets.DynamicContainerWidget" )
require( "ui.uieditor.widgets.Notifications.Notification" )
require( "ui.uieditor.widgets.HUD.ZM_CursorHint.ZMCursorHint" )
require( "ui.uieditor.widgets.HUD.CenterConsole.CenterConsole" )
require( "ui.uieditor.widgets.HUD.DeadSpectate.DeadSpectate" )
require( "ui.uieditor.widgets.MPHudWidgets.ScorePopup.MPScr" )
require( "ui.uieditor.widgets.HUD.ZM_PrematchCountdown.ZM_PrematchCountdown" )
require( "ui.uieditor.widgets.Scoreboard.CP.ScoreboardWidgetCP" )
require( "ui.uieditor.widgets.Chat.inGame.IngameChatClientContainer" )

require( "ui.uieditor.widgets.r6ehud.Score.R6eHudScoreContainer" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoContainer" )
require( "ui.uieditor.widgets.r6ehud.Perks.R6eHudPerksContainer" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudHintString" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudReloadHint" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudNotifications" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudReviveContainer" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudSelfPlayerDownContainer" )
require( "ui.uieditor.widgets.r6ehud.DeadSpectate.R6eHudDeadSpectateContainer" )

CoD.Zombie.CommonHudRequire()

local PreLoadFunc = function ( self, controller )
	CoD.Zombie.CommonPreLoadHud( self, controller )
end

local PostLoadFunc = function ( f24_arg0, f24_arg1 )
	local f24_local0 = DataSources.WorldSpaceIndicators.getModel( f24_arg1 )
	CoD.TacticalModeUtility.CreateShooterSpottedWidgets( f24_arg0, f24_arg1 )
	if f24_local0 then
		local f24_local1 = function ( f25_arg0 )
			local f25_local0 = f25_arg0:getFirstChild()
			while f25_local0 do
				if LUI.startswith( f25_local0.id, "bleedOutItem" ) then
					local f25_local1 = f25_local0:getModel( f24_arg1, "playerName" )
					if f25_local1 then
						Engine.SetModelValue( f25_local1, Engine.GetGamertagForClient( f24_arg1, f25_local0.bleedOutClient ) )
					end
				end
				f25_local0 = f25_local0:getNextSibling()
			end
		end
		
		local f24_local2 = 0
		local f24_local3 = true
		while f24_local3 do
			local f24_local4 = Engine.CreateModel( f24_local0, "bleedOutModel" .. f24_local2 )
			Engine.SetModelValue( Engine.CreateModel( f24_local4, "playerName" ), Engine.GetGamertagForClient( f24_arg1, f24_local2 ) )
			Engine.SetModelValue( Engine.CreateModel( f24_local4, "prompt" ), "ZMUI_REVIVE" )
			Engine.SetModelValue( Engine.CreateModel( f24_local4, "clockPercent" ), 0 )
			Engine.SetModelValue( Engine.CreateModel( f24_local4, "bleedOutPercent" ), 0 )
			Engine.SetModelValue( Engine.CreateModel( f24_local4, "stateFlags" ), 0 )
			Engine.SetModelValue( Engine.CreateModel( f24_local4, "arrowAngle" ), 0 )
			local f24_local5 = CoD.R6eHudReviveContainer.new( f24_arg0, f24_arg1 )
			f24_local5.bleedOutClient = f24_local2
			f24_local5.id = "bleedOutItem" .. f24_local2
			f24_local5:setLeftRight( true, false, 0, 0 )
			f24_local5:setTopBottom( true, false, 0, 0 )
			f24_local5:setModel( f24_local4 )
			f24_local3 = f24_local5:setupBleedOutWidget( f24_arg1, f24_local2 )
			f24_local5:processEvent( {
				name = "update_state",
				menu = f24_arg0
			} )
			f24_arg0.fullscreenContainer:addElement( f24_local5 )
			f24_arg0.fullscreenContainer:subscribeToModel( Engine.GetModel( Engine.GetModelForController( f24_arg1 ), "playerConnected" ), function ( model )
				f24_local1( f24_arg0.fullscreenContainer )
			end )
			f24_local2 = f24_local2 + 1
		end
	end
	f24_arg0.m_inputDisabled = true
	if LUI.DEV ~= nil then
		if LUI.DEVHideButtonPrompts then
			f24_arg0.CursorHint:setAlpha( 0 )
		end
		f24_arg0:registerEventHandler( "hide_button_prompts", function ( element, event )
			element.CursorHint:setAlpha( event.show and 1 or 0 )
		end )
	end
end

LUI.createMenu.T7Hud_zm_factory = function ( controller )
	local self = CoD.Menu.NewForUIEditor( "T7Hud_zm_factory" )

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self.soundSet = "HUD"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "T7Hud_zm_factory.buttonPrompts" )
	self.anyChildUsesUpdateState = true

	if CoD.R6eHudSelfPlayerDownContainer.new then
		CoD.player_health_bar_bleedout = Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.revivewidget" )
		Engine.SetModelValue( Engine.CreateModel( CoD.player_health_bar_bleedout, "playerName" ), "" )
		Engine.SetModelValue( Engine.CreateModel( CoD.player_health_bar_bleedout, "prompt" ), "" )
		Engine.SetModelValue( Engine.CreateModel( CoD.player_health_bar_bleedout, "clockPercent" ), 1 )
		Engine.SetModelValue( Engine.CreateModel( CoD.player_health_bar_bleedout, "bleedOutPercent" ), 1 )
		Engine.SetModelValue( Engine.CreateModel( CoD.player_health_bar_bleedout, "stateFlags" ), 0 )
		Engine.SetModelValue( Engine.CreateModel( CoD.player_health_bar_bleedout, "arrowAngle" ), 0 )

		self.SelfPlayerDownBleedBar = CoD.R6eHudSelfPlayerDownContainer.new( self, controller )
		self.SelfPlayerDownBleedBar:setLeftRight( true, true, 0, 0 )
		self.SelfPlayerDownBleedBar:setTopBottom( true, true, 0, 0 )
		self.SelfPlayerDownBleedBar:setModel( player_health_bar_bleedout )
		self:addElement( self.SelfPlayerDownBleedBar )
	end

	--[[ self.DummyFont1 = LUI.UIText.new()
	self.DummyFont1:setLeftRight( true, false, -1280, -1000 )
	self.DummyFont1:setTopBottom( true, false, -720, -700 )
	self.DummyFont1:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.DummyFont1:setText( "DummyFont" )
	self:addElement( self.DummyFont1 )

	self.DummyFont2 = LUI.UIText.new()
	self.DummyFont2:setLeftRight( true, false, -1280, -1000 )
	self.DummyFont2:setTopBottom( true, false, -720, -700 )
	self.DummyFont2:setTTF( "fonts/TradaSans-Medium.ttf" )
	self.DummyFont2:setText( "DummyFont" )
	self:addElement( self.DummyFont2 ) ]]

	self.ZMPerksContainerFactory = CoD.R6eHudPerksContainer.new( self, controller )
	self.ZMPerksContainerFactory:setLeftRight( true, true, 0, 0 )
	self.ZMPerksContainerFactory:setTopBottom( true, true, 0, 0 )
	self:addElement( self.ZMPerksContainerFactory )

	self.Rounds = CoD.ZmRndContainer.new( self, controller )
	self.Rounds:setLeftRight( true, false, 1098, 1322 )
	self.Rounds:setTopBottom( true, false, 18, 174 )
	self.Rounds:setScale( 0.8 )
	self:addElement( self.Rounds )
	
	self.Ammo = CoD.R6eHudAmmoContainer.new( self, controller )
	self.Ammo:setLeftRight( true, true, 0, 0 )
	self.Ammo:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Ammo )
	
	self.Score = CoD.R6eHudScoreContainer.new( self, controller )
	self.Score:setLeftRight( true, true, 0, 0 )
	self.Score:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Score )

	self.Reload = CoD.R6eHudReloadHint.new( self, controller )
	self.Reload:setLeftRight( true, true, 0, 0 )
	self.Reload:setTopBottom( true, false, 412, 435 )
	self:addElement( self.Reload )

	self.fullscreenContainer = CoD.DynamicContainerWidget.new( self, controller )
	self.fullscreenContainer:setLeftRight( false, false, -640, 640 )	
	self.fullscreenContainer:setTopBottom( false, false, -360, 360 )
	self:addElement( self.fullscreenContainer )
	
	self.ZmNotifications = CoD.R6eHudNotifications.new( self, controller )
	self.ZmNotifications:setLeftRight( true, true, 0, 0 )
	self.ZmNotifications:setTopBottom( true, true, 0, 0 )
	self:addElement( self.ZmNotifications )

	--[[
	self.Notifications = CoD.Notification.new( self, controller )
	self.Notifications:setLeftRight( true, true, 0, 0 )
	self.Notifications:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Notifications )]]

	--[[ self.ZmNotifBGBContainerFactory = CoD.ZmNotifBGB_ContainerFactory.new( self, controller )
	self.ZmNotifBGBContainerFactory:setLeftRight( false, false, -156, 156 )
	self.ZmNotifBGBContainerFactory:setTopBottom( true, false, -6, 247 )
	self.ZmNotifBGBContainerFactory:setScale( 0.75 )
	self.ZmNotifBGBContainerFactory:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function ( modelRef )
		if IsParamModelEqualToString( modelRef, "zombie_bgb_token_notification" ) then
			AddZombieBGBTokenNotification( self, self.ZmNotifBGBContainerFactory, controller, modelRef )
		elseif IsParamModelEqualToString( modelRef, "zombie_bgb_notification" ) then
			AddZombieBGBNotification( self, self.ZmNotifBGBContainerFactory, modelRef )
		elseif IsParamModelEqualToString( modelRef, "zombie_notification" ) then
			AddZombieNotification( self, self.ZmNotifBGBContainerFactory, modelRef )
		end
	end )
	self:addElement( self.ZmNotifBGBContainerFactory ) ]]
	
	self.CursorHint = CoD.ZMCursorHint.new( self, controller )
	self.CursorHint:setLeftRight( false, false, -250, 250 )
	self.CursorHint:setTopBottom( true, false, 522, 616 )
	self.CursorHint:mergeStateConditions( {
		{
			stateName = "Active_1x1",
			condition = function ( menu, element, event )
				if IsCursorHintActive( controller ) then
					if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
					or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
					or Engine.GetModelValue( Engine.GetModel( DataSources.HUDItems.getModel( controller ), "cursorHintIconRatio" ) ) ~= 1 then
						return false
					else
						return true
					end
				end
			end
		},
		{
			stateName = "Active_2x1",
			condition = function ( menu, element, event )
				if IsCursorHintActive( controller ) then
					if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
					or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
					or Engine.GetModelValue( Engine.GetModel( DataSources.HUDItems.getModel( controller ), "cursorHintIconRatio" ) ) ~= 2 then
						return false
					else
						return true
					end
				end
			end
		},
		{
			stateName = "Active_4x1",
			condition = function ( menu, element, event )
				if IsCursorHintActive( controller ) then
					if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
					or not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT )
					or Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
					or Engine.GetModelValue( Engine.GetModel( DataSources.HUDItems.getModel( controller ), "cursorHintIconRatio" ) ) ~= 4 then
						return false
					else
						return true
					end
				end
			end
		},
		{
			stateName = "Active_NoImage",
			condition = function ( menu, element, event )
				if IsCursorHintActive( controller ) then
					if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
					and Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) then
						return true
					else
						return false
					end
				end
			end
		}
	} )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showCursorHint" ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.showCursorHint"
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
		} )
	end )
	self.CursorHint:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.cursorHintIconRatio" ), function ( modelRef )
		self:updateElementState( self.CursorHint, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.cursorHintIconRatio"
		} )
	end )
	self:addElement( self.CursorHint )
	
	self.ConsoleCenter = CoD.CenterConsole.new( self, controller )
	self.ConsoleCenter:setLeftRight( false, false, -370, 370 )
	self.ConsoleCenter:setTopBottom( true, false, 68.5, 166.5 )
	self:addElement( self.ConsoleCenter )
	
	self.DeadSpectate = CoD.R6eHudDeadSpectateContainer.new( self, controller )
	self.DeadSpectate:setLeftRight( false, false, -150, 150 )
	self.DeadSpectate:setTopBottom( false, true, -180, -120 )
	self:addElement( self.DeadSpectate )
	
	self.MPScore = CoD.MPScr.new( self, controller )
	self.MPScore:setLeftRight( false, false, -50, 50 )
	self.MPScore:setTopBottom( true, false, 233.5, 258.5 )
	self.MPScore:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function ( modelRef )
		if IsParamModelEqualToString( modelRef, "score_event" ) and PropertyIsTrue( self, "menuLoaded" ) then
			PlayClipOnElement( self, {
				elementName = "MPScore",
				clipName = "NormalScore"
			}, controller )
			SetMPScoreText( self, self.MPScore, controller, modelRef )
		end
	end )
	self:addElement( self.MPScore )
	
	self.ZMPrematchCountdown0 = CoD.ZM_PrematchCountdown.new( self, controller )
	self.ZMPrematchCountdown0:setLeftRight( false, false, -640, 640 )
	self.ZMPrematchCountdown0:setTopBottom( false, false, -360, 360 )
	self:addElement( self.ZMPrematchCountdown0 )
	
	self.ScoreboardWidget = CoD.ScoreboardWidgetCP.new( self, controller )
	self.ScoreboardWidget:setLeftRight( false, false, -503, 503 )
	self.ScoreboardWidget:setTopBottom( true, false, 247, 773 )
	self:addElement( self.ScoreboardWidget )
	
	--[[ self.ZMBeastBar = CoD.ZM_BeastmodeTimeBarWidget.new( self, controller )
	self.ZMBeastBar:setLeftRight( false, false, -242.5, 321.5 )
	self.ZMBeastBar:setTopBottom( false, true, -174, -18 )
	self.ZMBeastBar:setScale( 0.7 )
	self:addElement( self.ZMBeastBar )
	
	self.RocketShieldBlueprintWidget = CoD.RocketShieldBlueprintWidget.new( self, controller )
	self.RocketShieldBlueprintWidget:setLeftRight( true, false, -36.5, 277.5 )
	self.RocketShieldBlueprintWidget:setTopBottom( true, false, 104, 233 )
	self.RocketShieldBlueprintWidget:setScale( 0.8 )
	self.RocketShieldBlueprintWidget:mergeStateConditions( {
		{
			stateName = "Scoreboard",
			condition = function ( menu, element, event )
				if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) then
					return AlwaysFalse()
				end
			end
		}
	} )
	self.RocketShieldBlueprintWidget:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmInventory.widget_shield_parts" ), function ( modelRef )
		self:updateElementState( self.RocketShieldBlueprintWidget, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "zmInventory.widget_shield_parts"
		} )
	end )
	self.RocketShieldBlueprintWidget:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( modelRef )
		self:updateElementState( self.RocketShieldBlueprintWidget, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	self:addElement( self.RocketShieldBlueprintWidget ) ]]
	
	self.IngameChatClientContainer = CoD.IngameChatClientContainer.new( self, controller )
	self.IngameChatClientContainer:setLeftRight( true, false, 0, 360 )
	self.IngameChatClientContainer:setTopBottom( true, false, -2.5, 717.5 )
	self:addElement( self.IngameChatClientContainer )
	
	self.IngameChatClientContainer0 = CoD.IngameChatClientContainer.new( self, controller )
	self.IngameChatClientContainer0:setLeftRight( true, false, 0, 360 )
	self.IngameChatClientContainer0:setTopBottom( true, false, -2.5, 717.5 )
	self:addElement( self.IngameChatClientContainer0 )

	self.Score.navigation = {
		up = self.ScoreboardWidget,
		right = self.ScoreboardWidget
	}
	
	self.ScoreboardWidget.navigation = {
		left = self.Score,
		down = self.Score
	}

	CoD.Menu.AddNavigationHandler( self, self, controller )

	self:registerEventHandler( "menu_loaded", function ( element, event )
		local retVal = nil
		
		SizeToSafeArea( element, controller )
		SetProperty( self, "menuLoaded", true )
		element:dispatchEventToChildren( event )

		if not retVal then
			retVal = element:dispatchEventToChildren( event )
		end

		return retVal
	end )

	self.Score.id = "Score"
	self.ScoreboardWidget.id = "ScoreboardWidget"

	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )

	self:processEvent( {
		name = "update_state",
		menu = self
	} )

	if not self:restoreState() then
		self.ScoreboardWidget:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.SelfPlayerDownBleedBar:close()
		--element.DummyFont1:close()
		--element.DummyFont2:close()
		element.ZMPerksContainerFactory:close()
		element.Rounds:close()
		element.Ammo:close()
		element.Score:close()
		element.Reload:close()
		element.fullscreenContainer:close()
		element.ZmNotifications:close()
		--element.Notifications:close()
		element.ZmNotifBGBContainerFactory:close()
		element.CursorHint:close()
		element.ConsoleCenter:close()
		element.DeadSpectate:close()
		element.MPScore:close()
		element.ZMPrematchCountdown0:close()
		element.ScoreboardWidget:close()
		--element.ZMBeastBar:close()
		--element.RocketShieldBlueprintWidget:close()
		element.IngameChatClientContainer:close()
		element.IngameChatClientContainer0:close()
	
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "T7Hud_zm_factory.buttonPrompts" ) )
	end )

	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end
