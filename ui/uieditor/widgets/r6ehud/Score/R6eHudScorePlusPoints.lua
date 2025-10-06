---@diagnostic disable: undefined-global

CoD.R6eHudScorePlusPoints = InheritFrom( LUI.UIElement )
CoD.R6eHudScorePlusPoints.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudScorePlusPoints )
	self.id = "R6eHudScorePlusPoints"
	self.soundSet = "HUD"
	self.anyChildUsesUpdateState = true

	self.Label2 = LUI.UIText.new()
	self.Label2:setLeftRight( false, true, -99, 1 )
	self.Label2:setTopBottom( false, true, -27, 1 )
	self.Label2:setRGB( 0, 0, 0 )
	self.Label2:setText( "" )
	self.Label2:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.Label2 )

	self.Label1 = LUI.UIText.new()
	self.Label1:setLeftRight( false, true, -100, 0 )
	self.Label1:setTopBottom( false, true, -28, 0 )
	self.Label1:setText( "" )
	self.Label1:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.Label1 )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.Label2:completeAnimation()
				self.Label2:setAlpha( 0.6 )
				self.Label2:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				SetupNextAnimation( self.Label2, function ( f3_arg0 )
					f3_arg0:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
					f3_arg0:setAlpha( 0 )
					f3_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
				end )
				self.Label1:completeAnimation()
				self.Label1:setRGB( 0.9, 0.9, 0 )
				self.Label1:setAlpha( 1 )
				self.Label1:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				SetupNextAnimation( self.Label1, function ( f4_arg0 )
					f4_arg0:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
					f4_arg0:setAlpha( 0 )
					f4_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
				end )
			end,
			NegativeScore = function ()
				self:setupElementClipCounter( 2 )
				self.Label2:completeAnimation()
				self.Label2:setAlpha( 0.6 )
				self.Label2:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				SetupNextAnimation( self.Label2, function ( f6_arg0 )
					f6_arg0:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
					f6_arg0:setAlpha( 0 )
					f6_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
				end )
				self.Label1:completeAnimation()
				self.Label1:setRGB( 0.47, 0, 0 )
				self.Label1:setAlpha( 1 )
				self.Label1:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
				SetupNextAnimation( self.Label1, function ( f7_arg0 )
					f7_arg0:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
					f7_arg0:setAlpha( 0 )
					f7_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
				end )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Label1:close()
		element.Label2:close()
	end )

	return self
end

