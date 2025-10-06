---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )

CoD.R6eHudAmmoClipDW = InheritFrom( LUI.UIElement )
CoD.R6eHudAmmoClipDW.new = function ( menu, controller )
    local self = LUI.UIElement.new()

    self:setUseStencil( false )
	self:setClass( CoD.R6eHudAmmoClipDW )
	self.id = "R6eHudAmmoClipDW"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

    --[[ self.ClipAmmoBG = LUI.UIText.new()
    self.ClipAmmoBG:setLeftRight( false, true, -475, -383 )
	self.ClipAmmoBG:setTopBottom( false, true, -70, -35 )
    self.ClipAmmoBG:setText( "" )
    self.ClipAmmoBG:setTTF( "fonts/Erbaum_Bold.ttf" )
    self.ClipAmmoBG:setRGB( 0, 0, 0 )
	self.ClipAmmoBG:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
    self:addElement( self.ClipAmmoBG ) ]]

    self.ClipAmmo = LUI.UIText.new()
    self.ClipAmmo:setLeftRight( false, true, -475, -383 )
	self.ClipAmmo:setTopBottom( false, true, -87.7, -41.7 )
    self.ClipAmmo:setText( "" )
    self.ClipAmmo:setTTF( "fonts/Erbaum_Bold.ttf" )
    self.ClipAmmo:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
    self:addElement( self.ClipAmmo )

    SubscribeToMultipleModelsByName( self, controller, {
		"CurrentWeapon.weapon",
		"CurrentWeapon.ammoInDWClip"
	}, function ( f2_arg0 )
		local modelValue = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentWeapon.ammoInDWClip" ) )
		if modelValue ~= nil and modelValue ~= -1 then
			self.ClipAmmo:setText( modelValue )
		end
	end )

    self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
		
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 1 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 0 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		},
		LowAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 1 )
				self.ClipAmmo:setRGB( 1, 1, 1 )
				self.ClipAmmo:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
				self.ClipAmmo:setRGB( 0.95, 0.31, 0.31 )
				SetupNextAnimation( self.ClipAmmo, function ( f6_arg0 )
					f6_arg0:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
					f6_arg0:setRGB( 1, 1, 1 )
					PlayClipOnAnimationEnd( f6_arg0, controller, "DefaultClip" )
				end )
			end
		},
		NoAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				self.ClipAmmo:completeAnimation()
				self.ClipAmmo:setAlpha( 1 )
				self.ClipAmmo:setRGB( 0.95, 0.31, 0.31 )
				self.clipFinished( self.ClipAmmo, {} )
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "CurrentWeapon.ammoInDWClip", -1 )
			end
		},
		{
			stateName = "LowAmmo",
			condition = function ( menu, element, event )
				return IsLowAmmoDWClip( controller )
			end
		},
		{
            stateName = "NoAmmo",
            condition = function ( menu, element, event )
                return IsModelValueEqualTo( controller, "CurrentWeapon.ammoInDWClip", 0 )
            end
        }
	} )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.weapon" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.ammoInDWClip" )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ClipAmmo:close()
	end )

    return self
end