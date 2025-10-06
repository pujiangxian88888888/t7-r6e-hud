---@diagnostic disable: undefined-global

CoD.R6eHudReviveClampedArrow = InheritFrom( LUI.UIElement )
CoD.R6eHudReviveClampedArrow.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudReviveClampedArrow )
	self.id = "R6eHudReviveClampedArrow"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 260 )
	self:setTopBottom( true, false, 0, 64 )
	
	self.arrow = LUI.UIImage.new()
	self.arrow:setLeftRight( false, true, -64, 0 )
	self.arrow:setTopBottom( true, true, 0, 0 )
	self.arrow:setZRot( 90 )
	self.arrow:setImage( RegisterImage( "ui_icon_revive_arrow" ) )
	self:addElement( self.arrow )
	
	--Engine.SetDvar( "lua_test", 11111 )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

