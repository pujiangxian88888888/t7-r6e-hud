---@diagnostic disable: undefined-global

CoD.R6eHudReloadHint = InheritFrom( LUI.UIElement )
CoD.R6eHudReloadHint.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	self:setUseStencil( false )
	self:setClass( CoD.R6eHudReloadHint )
	self.id = "R6eHudReloadHint"
	self.soundSet = "default"
	self.anyChildUsesUpdateState = true

	self.ReloadHint = LUI.UIText.new()
	self.ReloadHint:setLeftRight( true, true, 0, 0 )
	self.ReloadHint:setTopBottom( true, false, 0, 22 )
	self.ReloadHint:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.ReloadHint:setText( "" )
	self.ReloadHint:setTTF( "fonts/TradaSans-Medium.ttf" )
	self:addElement( self.ReloadHint )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.ReloadHint:completeAnimation()
				self.ReloadHint:setAlpha( 0 )
				self.clipFinished( self.ReloadHint, {} )
			end
		},
		NoAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
			
				self.ReloadHint:completeAnimation()
                self.ReloadHint:setTopBottom( true, false, -92, -70 )
                self.ReloadHint:setRGB( 1, 0, 0 )
				self.ReloadHint:setAlpha( 1 )
				self.ReloadHint:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
				self.ReloadHint:setAlpha( 0 )
				SetupNextAnimation( self.ReloadHint, function ( f6_arg0 )
					f6_arg0:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
					f6_arg0:setAlpha( 1 )
					PlayClipOnAnimationEnd( f6_arg0, controller, "DefaultClip" )
				end )
			end
		},
		LowAmmo = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
		
				self.ReloadHint:completeAnimation()
                self.ReloadHint:setTopBottom( true, false, -92, -70 )
                self.ReloadHint:setRGB( 1, 0, 0 )
				self.ReloadHint:setAlpha( 1 )
				self.ReloadHint:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
				self.ReloadHint:setAlpha( 0 )
				SetupNextAnimation( self.ReloadHint, function ( f6_arg0 )
					f6_arg0:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )
					f6_arg0:setAlpha( 1 )
					PlayClipOnAnimationEnd( f6_arg0, controller, "DefaultClip" )
				end )
			end
		},
		Reload = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.ReloadHint:completeAnimation()
                self.ReloadHint:setTopBottom( true, false, 0, 18 )
				self.ReloadHint:setAlpha( 1 )
				self.ReloadHint:setRGB( 0.5, 0.5, 0.5 )
                self.clipFinished( self.ReloadHint, {} )
			end
		}
	}
	local f1_local1 = function ()
		local f9_local0 = IsModelValueTrue( controller, "hudItems.playerSpawned" )
		if f9_local0 then
			f9_local0 = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
			if f9_local0 then
				f9_local0 = Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE )
				if f9_local0 then
					if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ) then
						f9_local0 = not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE )
					else
						f9_local0 = false
					end
				end
			end
		end
		return f9_local0 and WeaponUsesAmmo( controller )
	end
	
	self:mergeStateConditions( {
		{
			stateName = "NoAmmo",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "CurrentWeapon.ammoStock", 0 ) and IsModelValueLessThanOrEqualTo( controller, "CurrentWeapon.ammoInDWClip", 0 ) and IsModelValueEqualTo( controller, "CurrentWeapon.ammoInClip", 0 ) and f1_local1()
			end
		},
		{
			--后备弹药为0，武器和双持武器弹匣弹药量低
            stateName = "LowAmmo",
			condition = function ( menu, element, event )
				local islowammoclip = IsLowAmmoClip( controller )
                local islowammodwclip = IsLowAmmoDWClip( controller )
                if islowammodwclip then
                    islowammodwclip = not ( IsModelValueEqualTo( controller, "CurrentWeapon.ammoInDWClip", -1 ) )
                end
                local isemptystock = IsModelValueEqualTo( controller, "CurrentWeapon.ammoStock", 0 )
                
                if isemptystock and ( islowammoclip or islowammodwclip ) and f1_local1() then
                    return true
                end
                return false
			end
		},
		{
			stateName = "Reload",
			condition = function ( menu, element, event )
				local islowammoclip = IsLowAmmoClip( controller )
                local islowammodwclip = IsLowAmmoDWClip( controller )
                if islowammodwclip then
                    islowammodwclip = not ( IsModelValueEqualTo( controller, "CurrentWeapon.ammoInDWClip", -1 ) )
                end
                local isemptystock = IsModelValueEqualTo( controller, "CurrentWeapon.ammoStock", 0 )
                
                if ( not isemptystock ) and ( islowammoclip or islowammodwclip ) and f1_local1() then
                    return true
                end
                return false
			end
		}
	} )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.weapon" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.equippedWeaponReference" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.ammoInClip" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.ammoInDWClip" )
	SubscribeToModelAndUpdateState( controller, menu, self, "CurrentWeapon.ammoStock" )
	SubscribeToModelAndUpdateState( controller, menu, self, "hudItems.playerSpawned" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_VISIBLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_WEAPON_HUD_VISIBLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_HUD_HARDCORE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_GAME_ENDED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_DEMO_CAMERA_MODE_MOVIECAM" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_DEMO_ALL_GAME_HUD_HIDDEN" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_KILLCAM" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_FLASH_BANGED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_UI_ACTIVE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IS_SCOPED" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_VEHICLE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_GUIDED_MISSILE" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_SCOREBOARD_OPEN" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_IN_REMOTE_KILLSTREAK_STATIC" )
	SubscribeToVisibilityBit( controller, menu, self, "BIT_EMP_ACTIVE" )

	LUI.OverrideFunction_CallOriginalFirst( self, "setState", function ( element, controller )
		if controller == "NoAmmo" then
			element.ReloadHint:setText( Engine.Localize( "UI_HINT_NO_AMMO" ) )
		elseif controller == "LowAmmo" then
			element.ReloadHint:setText( Engine.Localize( "UI_HINT_LOW_AMMO" ) )
		elseif controller == "Reload" then
			element.ReloadHint:setText( Engine.Localize( "UI_HINT_RELOAD" ) )
		end
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ReloadHint:close()
	end )
	return self
end


 
