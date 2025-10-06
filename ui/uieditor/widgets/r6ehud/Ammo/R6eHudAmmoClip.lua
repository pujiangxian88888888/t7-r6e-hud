---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Ammo.R6eHudAmmoClipDW" )
require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoClip = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoClip.new = function ( menu, controller )
    local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoClip )
	self.id = "R6eHudAmmoClip"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.ClipAmmo = LUI.UIText.new()
	self.ClipAmmo:setLeftRight( false, true, -415, -257.3 )
	self.ClipAmmo:setTopBottom( false, true, -87.7, -41.7 )
	self.ClipAmmo:setText( "" )
	self.ClipAmmo:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.ClipAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( self.ClipAmmo )

	self.ClipDWAmmo = CoD.R6eHudAmmoClipDW.new( menu, controller )
	self.ClipDWAmmo:setLeftRight( true, true, 0, 0 )
	self.ClipDWAmmo:setTopBottom( true, true, 0, 0 )
	self:addElement( self.ClipDWAmmo )

    SubscribeToMultipleModelsByName( self, controller, {
		"CurrentWeapon.weapon",
		"CurrentWeapon.ammoInClip"
	}, function ( f2_arg0 )
		local modelValue = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentWeapon.ammoInClip" ) )
		if modelValue ~= nil then
			self.ClipAmmo:setText( modelValue )
			self.ClipDWAmmo:setLeftRight( true, true, 0, -4.25 - self.ClipAmmo:getTextWidth() )
		end
	end )
    --在R6异种里面，弹匣弹药低数字会在红色白色闪动，弹匣没有弹药会固定为红色
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setRGB( 1, 1, 1 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		},
		LowAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
				self.ClipAmmo:setRGB( 1, 0, 0 )
				SetupNextAnimation( self.ClipAmmo, function ( f5_arg0 )
					f5_arg0:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
					f5_arg0:setRGB( 1, 1, 1 )
					PlayClipOnAnimationEnd( f5_arg0, controller, "DefaultClip" )
				end )
			end
		},
        NoAmmo = {
            DefaultClip = function ()
                self:setupElementClipCounter( 3 )
                self.ClipAmmo:completeAnimation()
                self.ClipAmmo:setRGB( 1, 0, 0 )
                self.clipFinished( self.ClipAmmo, {} )
            end
        }
	}
	self:mergeStateConditions( {
		{
			stateName = "LowAmmo",
			condition = function ( menu, element, event )
				return IsLowAmmoClip( controller )
			end
		},
        {
            stateName = "NoAmmo",
            condition = function ( menu, element, event )
                return IsModelValueEqualTo( controller, "CurrentWeapon.ammoInClip", 0 )
            end
        }
	} )

	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.weapon" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.ammoInClip" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ClipAmmo:close()
		element.ClipDWAmmo:close()
	end )

	return self
end