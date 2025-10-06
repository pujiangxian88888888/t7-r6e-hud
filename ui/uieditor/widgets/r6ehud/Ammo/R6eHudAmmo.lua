---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoActionslots" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoCounter" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoWeapon" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoLethal" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoTactical" )
require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoHeroWeapon" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmo = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmo.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmo )
	self.id = "R6eHudAmmo"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    self.WeaponName = CoD.R6eHudAmmoWeapon.new( menu, controller )
	self.WeaponName:setLeftRight( true, true, 0, 0 )
	self.WeaponName:setTopBottom( true, true, 0, 0 )
	self:addElement( self.WeaponName )

	self.AmmoCount = CoD.R6eHudAmmoCounter.new( menu, controller )
	self.AmmoCount:setLeftRight( true, true, 0, 0 )
	self.AmmoCount:setTopBottom( true, true, 0, 0 )
	self:addElement( self.AmmoCount )

	self.Lethals = CoD.R6eHudAmmoLethal.new( menu, controller )
	self.Lethals:setLeftRight( true, true, 0, 0 )
	self.Lethals:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Lethals )

	self.Tacticals = CoD.R6eHudAmmoTactical.new( menu, controller )
	self.Tacticals:setLeftRight( true, true, 0, 0 )
	self.Tacticals:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Tacticals )

	self.Actionslots = CoD.R6eHudAmmoActionslots.new( menu, controller )
	self.Actionslots:setLeftRight( true, true, 0, 0 )
	self.Actionslots:setTopBottom( true, true, 0, 0 )
	self:addElement( self.Actionslots )

	self.HeroWeapon = CoD.R6eHudAmmoHeroWeapon.new( menu, controller )
	self.HeroWeapon:setLeftRight( true, true, 0, 0 )
	self.HeroWeapon:setTopBottom( true, true, 0, 0 )
	self:addElement( self.HeroWeapon )

    self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 1 )
				self.clipFinished( self.WeaponName, {} )

				self.AmmoCount:completeAnimation()
				self.AmmoCount:setAlpha( 1 )
				self.clipFinished( self.AmmoCount, {} )

                self.Lethals:completeAnimation()
				self.Lethals:setAlpha( 1 )
				self.clipFinished( self.Lethals, {} )

                self.Tacticals:completeAnimation()
				self.Tacticals:setAlpha( 1 )
				self.clipFinished( self.Tacticals, {} )

                self.Actionslots:completeAnimation()
				self.Actionslots:setAlpha( 1 )
				self.clipFinished( self.Actionslots, {} )

				self.HeroWeapon:completeAnimation()
				self.HeroWeapon:setAlpha( 1 )
				self.clipFinished( self.HeroWeapon, {} )
			end
		},
		IsThrowingGrenade = {
			DefaultClip = function ()
                self:setupElementClipCounter( 2 )
				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 0 )
				self.clipFinished( self.WeaponName, {} )

				self.AmmoCount:completeAnimation()
				self.AmmoCount:setAlpha( 0 )
				self.clipFinished( self.AmmoCount, {} )

                self.Lethals:completeAnimation()
				self.Lethals:setAlpha( 0 )
				self.clipFinished( self.Lethals, {} )

                self.Tacticals:completeAnimation()
				self.Tacticals:setAlpha( 0 )
				self.clipFinished( self.Tacticals, {} )

                self.Actionslots:completeAnimation()
				self.Actionslots:setAlpha( 0 )
				self.clipFinished( self.Actionslots, {} )

				self.HeroWeapon:completeAnimation()
				self.HeroWeapon:setAlpha( 0 )
				self.clipFinished( self.HeroWeapon, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "IsThrowingGrenade",
			condition = function ( menu, element, event )
				if IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "cymbal_monkey_zm" ) or
                 IsModelValueEqualTo( controller, "currentWeapon.viewmodelWeaponName", "frag_grenade_zm" ) or
                 ModelValueStartsWith( controller, "currentWeapon.viewmodelWeaponName", "zombie_" ) then
                    return true
                else 
                    return false
                end
			end
		}
	} )


	SubscribeToModelAndUpdateState( controller, menu, self, "currentWeapon.viewmodelWeaponName" )

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.WeaponName:close()
		element.AmmoCount:close()
		element.Lethals:close()
		element.Tacticals:close()
		element.Actionslots:close()
		element.HeroWeapon:close()
	end )

    return self
end
