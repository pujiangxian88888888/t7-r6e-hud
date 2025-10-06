---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Score.R6eHudScorePlusPoints" )

CoD.R6eHudScorePlusPointsContainer = InheritFrom( LUI.UIElement )
CoD.R6eHudScorePlusPointsContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudScorePlusPointsContainer )
	self.id = "R6eHudScorePlusPointsContainer"
	self.soundSet = "HUD"
	self.anyChildUsesUpdateState = true

	self.ZMScrPlusPoints = CoD.R6eHudScorePlusPoints.new( menu, controller )
	self.ZMScrPlusPoints:setLeftRight( true, true, 0, 0 )
	self.ZMScrPlusPoints:setTopBottom( true, true, 0, 0 )
	self:addElement( self.ZMScrPlusPoints )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 1 )
				self.ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
				self.ZMScrPlusPoints:setLeftRight( true, true, 0, -30 - math.random( 0, 60 ) )
				self.ZMScrPlusPoints:setTopBottom( true, true, 0, -22.5 + math.random( 0, 45 ) )
				self.ZMScrPlusPoints:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ZMScrPlusPoints:close()
	end )
    
	return self
end

