---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.ZMInventoryStalingrad.GameTimeGroup" )

local PreLoadFunc = function ( self, controller )
	Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.zone_name" )
	--Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.TimeWidgets_Minutes" )
	--Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.TimeWidgets_Seconds" )
end

CoD.R6eHudScoreTimeAndZoneWidgets = InheritFrom( LUI.UIElement )
CoD.R6eHudScoreTimeAndZoneWidgets.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudScoreTimeAndZoneWidgets )
	self.id = "R6eHudScoreTimeAndZoneWidgets"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

    self.ZoneText = LUI.UIText.new()
	self.ZoneText:setLeftRight( true, false, 67.3, 200 )
	self.ZoneText:setTopBottom( true, false, 60, 80 ) 
	self.ZoneText:setText( Engine.Localize( "" ) )
	self.ZoneText:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.ZoneText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self:addElement( self.ZoneText )

	self.GameTimeGroup = CoD.GameTimeGroup.new( menu, controller )
	self.GameTimeGroup:setLeftRight( true, false, 298, 340.5 )
	self.GameTimeGroup:setTopBottom( true, false, 33, 51 )
	self.GameTimeGroup:setScale( 0.5 )
	self.GameTimeGroup:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.GameTimeGroup.CurrentClockTime.FEButtonPanelShaderContainer:setScale( 0 )
	self.GameTimeGroup.CurrentClockTime.Backing:setScale( 0 )
	self.GameTimeGroup.CurrentClockTime.BackPanel:setScale( 0 )
	self.GameTimeGroup.CurrentClockTime.TimeElasped:setScale( 0 )
	self.GameTimeGroup.CurrentClockTime.GameTimer:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.GameTimeGroup.CurrentClockTime.HighlightFrame:setScale( 0 )
	self.GameTimeGroup.SurviveTime:setScale( 0 )
	self.GameTimeGroup.Last5RoundTime:setScale( 0 )
	self.GameTimeGroup.QuestTime:setScale( 0 )
	self:addElement( self.GameTimeGroup )
	
	--[[
	self.Timer = LUI.UIText.new()
	self.Timer:setLeftRight( true, false, 200, 300 )
	self.Timer:setTopBottom( true, false, 60, 80 ) 
	self.Timer:setText( Engine.Localize( "" ) )
	self.Timer:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.Timer:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( self.Timer )
	]]--


	self.DotLine = LUI.UIText.new()
	self.DotLine:setLeftRight( true, false, 277, 713 )
	self.DotLine:setTopBottom( true, false, 79.3, 91 )
	self.DotLine:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.DotLine:setText( "--------------------------------------------------" )
	self.DotLine:setScale( 2 )
	self:addElement( self.DotLine )

    self.ZoneText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.zone_name" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			if Engine.GetModelValue( modelRef ) == "none" then
				self.ZoneText:setText( "UNKNOWN" )
			else
				self.ZoneText:setText( Engine.Localize( Engine.GetModelValue( modelRef ) ) )
			end
		end
	end )

	--[[
	self.Timer:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.TimeWidgets_Minutes" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			Minutes = Engine.GetModelValue( modelRef )
		end
	end )

	self.Timer:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.TimeWidgets_Seconds" ), function ( modelRef )
		if Engine.GetModelValue( modelRef ) then
			Seconds = Engine.GetModelValue( modelRef )
		end

		if( Minutes ~= nil and seconds ~= nil ) then
			self.Timer:setText( Minutes .. ":" .. Seconds )
		end
	end )
	]]--

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ZoneText:close()
		element.GameTimeGroup:close()
		element.DotLine:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end