---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot2" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot3" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslot4" )

CoD.R6eHudAmmoActionslots = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoActionslots.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoActionslots )
	self.id = "R6eHudAmmoActionslots"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    self.Actionslot2 = CoD.R6eHudAmmoActionslot2.new( menu, controller )
	self.Actionslot2:setLeftRight( true, true, 0, 0 )
	self.Actionslot2:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Actionslot2 )

	self.Actionslot3 = CoD.R6eHudAmmoActionslot3.new( menu, controller )
	self.Actionslot3:setLeftRight( true, true, 0, 0 )
	self.Actionslot3:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Actionslot3 )

	self.Actionslot4 = CoD.R6eHudAmmoActionslot4.new( menu, controller )
	self.Actionslot4:setLeftRight( true, true, 0, 0 )
	self.Actionslot4:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Actionslot4 )

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Actionslot2:close()
		element.Actionslot3:close()
		element.Actionslot4:close()
	end )
    
	return self

end