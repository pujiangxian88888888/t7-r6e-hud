---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoStock" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoClip" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoCounter = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoCounter.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoCounter )
	self.id = "R6eHudAmmoCounter"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.StockAmmo = CoD.R6eHudAmmoStock.new( menu, controller )
	self.StockAmmo:setLeftRight( true, true, 0, 0 )
	self.StockAmmo:setTopBottom( true, true, 0, 0 )
	self:addElement( self.StockAmmo )

	self.ClipAmmo = CoD.R6eHudAmmoClip.new( menu, controller )
	self.ClipAmmo:setLeftRight( true, true, 0, 0 )
	self.ClipAmmo:setTopBottom( true, true, 0, 0 )
	self:addElement( self.ClipAmmo )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.StockAmmo:completeAnimation()
				self.StockAmmo:setAlpha( 1 )
				self.clipFinished( self.StockAmmo, {} )
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 1 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.StockAmmo:completeAnimation()
				self.StockAmmo:setAlpha( 0 )
				self.clipFinished( self.StockAmmo, {} )
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 0 )
				self.ClipAmmo:setLeftRight( true, true, 0, 0 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		},
		ClipOnly = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.StockAmmo:completeAnimation()
				self.StockAmmo:setAlpha( 0 )
				self.clipFinished( self.StockAmmo, {} )
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 1 )
				self.ClipAmmo:setLeftRight( true, true, 0, 0 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return not WeaponUsesAmmo( controller )
			end
		},
		{
			stateName = "ClipOnly",
			condition = function ( menu, element, event )
				local f6_local0 = IsModelValueEqualTo( controller, "CurrentWeapon.equippedWeaponReference", "hero_annihilator_zm" )
				if not f6_local0 then
					f6_local0 = ModelValueStartsWithAny( controller, "CurrentWeapon.equippedWeaponReference", "elemental_bow", "skull_gun_", "dragon_gauntlet" )
				end
				return f6_local0
			end
		}
	} )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.weapon" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.equippedWeaponReference" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.StockAmmo:close()
		element.ClipAmmo:close()
	end )

	return self
end

