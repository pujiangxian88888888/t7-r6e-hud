---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudReviveWidget" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudReviveClampedArrow" )

CoD.R6eHudReviveContainer = InheritFrom( LUI.UIElement )
CoD.R6eHudReviveContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudReviveContainer )
	self.id = "R6eHudReviveContainer"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1 )
	self:setTopBottom( true, false, 0, 1 )
	self.anyChildUsesUpdateState = true
	
	self.R6eHudReviveWidget = CoD.R6eHudReviveWidget.new( menu, controller )
	self.R6eHudReviveWidget:setLeftRight( true, false, -109.5, 110.5 )
	self.R6eHudReviveWidget:setTopBottom( true, false, -110, 110 )
	self.R6eHudReviveWidget:setScale( 0.8 )
	self.R6eHudReviveWidget:linkToElementModel( self, nil, false, function ( model )
		self.R6eHudReviveWidget:setModel( model, controller )
	end )
	self:addElement( self.R6eHudReviveWidget )

	self.ClampedArrow = CoD.R6eHudReviveClampedArrow.new( menu, controller )
	self.ClampedArrow:setLeftRight( false, false, -118.37, 141.63 )
	self.ClampedArrow:setTopBottom( false, false, -32, 32 )
	self.ClampedArrow:linkToElementModel( self, "arrowAngle", true, function ( model )
		local arrowAngle = Engine.GetModelValue( model )
		if arrowAngle then
			self.ClampedArrow:setZRot( arrowAngle )
		end
	end )
	self:addElement( self.ClampedArrow )
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				self.ClampedArrow:completeAnimation()
				self.ClampedArrow:setAlpha( 0 )
				self.clipFinished( self.ClampedArrow, {} )
			end
		},
		Clamped = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				self.ClampedArrow:completeAnimation()
				self.ClampedArrow:setAlpha( 1 )
				self.clipFinished( self.ClampedArrow, {} )
			end
		},
		Visible_Reviving = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				self.ClampedArrow:completeAnimation()
				self.ClampedArrow:setAlpha( 0 )
				self.clipFinished( self.ClampedArrow, {} )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				self.ClampedArrow:completeAnimation()
				self.ClampedArrow:setAlpha( 0 )
				self.clipFinished( self.ClampedArrow, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Clamped",
			condition = function ( menu, element, event )
				return IsBleedOutVisible( element, controller ) and IsSelfModelValueEnumBitSet( element, controller, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_CLAMPED )
			end
		},
		{
			stateName = "Visible_Reviving",
			condition = function ( menu, element, event )
				return IsBleedOutVisible( element, controller ) and IsSelfModelValueEnumBitSet( element, controller, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_BEING_REVIVED )
			end
		},
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				return IsBleedOutVisible( element, controller )
			end
		}
	} )
	self:linkToElementModel( self, "bleedingOut", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "bleedingOut"
		} )
	end )
	self:linkToElementModel( self, "beingRevived", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "beingRevived"
		} )
	end )
	self:linkToElementModel( self, "stateFlags", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "stateFlags"
		} )
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.R6eHudReviveWidget:close()
		element.ClampedArrow:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end