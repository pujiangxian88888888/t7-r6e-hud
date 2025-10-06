---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.HUD.ZM_Revive.ZM_ReviveBleedoutRedEyeGlow" )
require( "ui.uieditor.widgets.HUD.core_AmmoWidget.AmmoWidget_AbilityGlow" )

CoD.R6eHudReviveWidget = InheritFrom( LUI.UIElement )
CoD.R6eHudReviveWidget.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudReviveWidget )
	self.id = "R6eHudReviveWidget"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 220 )
	self:setTopBottom( true, false, 0, 220 )
	self.anyChildUsesUpdateState = true

	local GlowOrangeOver = LUI.UIImage.new()
	GlowOrangeOver:setLeftRight( false, false, -80, 80 )
	GlowOrangeOver:setTopBottom( false, false, -126.5, 126.5 )
	GlowOrangeOver:setRGB( 1, 0, 0 )
	GlowOrangeOver:setAlpha( 0.4 )
	GlowOrangeOver:setZRot( 90 )
	GlowOrangeOver:setImage( RegisterImage( "uie_t7_core_hud_mapwidget_panelglow" ) )
	GlowOrangeOver:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( GlowOrangeOver )
	self.GlowOrangeOver = GlowOrangeOver
	
	local glow = LUI.UIImage.new()
	glow:setLeftRight( false, false, -70, 70 )
	glow:setTopBottom( false, false, -70, 70 )
	glow:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( glow )
	self.glow = glow
	
	local RingGlow = LUI.UIImage.new()
	RingGlow:setLeftRight( false, false, -70, 70 )
	RingGlow:setTopBottom( false, false, -70, 70 )
	RingGlow:setRGB( 1, 0, 0 )
	RingGlow:setAlpha( 0 )
	RingGlow:setImage( RegisterImage( "uie_t7_zm_hud_revive_ringglow" ) )
	self:addElement( RingGlow )
	self.RingGlow = RingGlow

	local RingTopBG = LUI.UIImage.new()
	RingTopBG:setLeftRight( false, false, -70, 70 )
	RingTopBG:setTopBottom( false, false, -70, 70 )
	RingTopBG:setRGB( 0.15, 0.15, 0.15 )
	RingTopBG:setAlpha( 0.3 )
	RingTopBG:setImage( RegisterImage( "uie_t7_zm_hud_revive_ringtop" ) )
	self:addElement( RingTopBG )
	self.RingTopBG = RingTopBG
	
	local RingTopBleedOut = LUI.UIImage.new()
	RingTopBleedOut:setLeftRight( false, false, -70, 70 )
	RingTopBleedOut:setTopBottom( false, false, -70, 70 )
	RingTopBleedOut:setRGB( 1, 0, 0 )
	RingTopBleedOut:setImage( RegisterImage( "uie_t7_zm_hud_revive_ringtop" ) )
	RingTopBleedOut:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_clock_add" ) )
	RingTopBleedOut:setShaderVector( 1, 0.5, 0, 0, 0 )
	RingTopBleedOut:setShaderVector( 2, 0.5, 0, 0, 0 )
	RingTopBleedOut:setShaderVector( 3, 0.05, 0, 0, 0 )
	RingTopBleedOut:linkToElementModel( self, "bleedOutPercent", true, function ( model )
		local bleedOutPercent = Engine.GetModelValue( model )
		if bleedOutPercent then
			RingTopBleedOut:setShaderVector( 0, CoD.GetVectorComponentFromString( bleedOutPercent, 1 ), 
												CoD.GetVectorComponentFromString( bleedOutPercent, 2 ), 
												CoD.GetVectorComponentFromString( bleedOutPercent, 3 ), 
												CoD.GetVectorComponentFromString( bleedOutPercent, 4 ) )
		end
	end )
	self:addElement( RingTopBleedOut )
	self.RingTopBleedOut = RingTopBleedOut

	local ReviveProgressBarBG = LUI.UIImage.new()
	ReviveProgressBarBG:setLeftRight( false, false, -150, 150 )
	ReviveProgressBarBG:setTopBottom( false, true, -28, -20 )
	ReviveProgressBarBG:setImage( RegisterImage( "$white" ) )
	ReviveProgressBarBG:setRGB( 0.35, 0.35, 0.35 )
	ReviveProgressBarBG:setAlpha( 0 )
	self:addElement( ReviveProgressBarBG )
	self.ReviveProgressBarBG = ReviveProgressBarBG
	
	local ReviveProgressBar = LUI.UIImage.new()
	ReviveProgressBar:setLeftRight( false, false, -150, 150 )
	ReviveProgressBar:setTopBottom( false, true, -28, -20 )
	ReviveProgressBar:setAlpha( 0 )
	ReviveProgressBar:setImage( RegisterImage( "$white" ) )
	ReviveProgressBar:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	ReviveProgressBar:setShaderVector( 0, 0.5, 0, 0, 0 )
	ReviveProgressBar:setShaderVector( 1, 0, 0, 0, 0 )
	ReviveProgressBar:setShaderVector( 2, 1, 0, 0, 0 )
	ReviveProgressBar:setShaderVector( 3, 1, 0, 0, 0 )
	ReviveProgressBar:linkToElementModel( self, "clockPercent", true, function ( model )
		local clockPercent = Engine.GetModelValue( model )
		if clockPercent then
			ReviveProgressBar:setShaderVector( 0, clockPercent, 0, 0, 0 )
		end
	end )
	self:addElement( ReviveProgressBar )
	self.ReviveProgressBar = ReviveProgressBar

	local skull = LUI.UIImage.new()
	skull:setLeftRight( false, false, -70, 70 )
	skull:setTopBottom( false, false, -70, 70 )
	skull:setImage( RegisterImage( "ui_icon_zm_hud_revive_skull" ) )
	skull:setScale( 0.75 )
	self:addElement( skull )
	self.skull = skull
	
	local AbilitySwirl = LUI.UIImage.new()
	AbilitySwirl:setLeftRight( false, false, -67.86, 69 )
	AbilitySwirl:setTopBottom( false, false, -69, 67.86 )
	AbilitySwirl:setRGB( 1,0, 0 )
	AbilitySwirl:setAlpha( 0 )
	AbilitySwirl:setScale( 1.3 )
	AbilitySwirl:setImage( RegisterImage( "uie_t7_core_hud_ammowidget_abilityswirl" ) )
	AbilitySwirl:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	self:addElement( AbilitySwirl )
	self.AbilitySwirl = AbilitySwirl
	
	local Glow0 = CoD.AmmoWidget_AbilityGlow.new( menu, controller )
	Glow0:setLeftRight( true, true, 4, -4 )
	Glow0:setTopBottom( true, true, 4, -4 )
	Glow0:setRGB( 1, 0, 0 )
	Glow0:setAlpha( 0 )
	Glow0:setZoom( 13.47 )
	Glow0:setScale( 0.7 )
	self:addElement( Glow0 )
	self.Glow0 = Glow0
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 9 )

				GlowOrangeOver:completeAnimation()
				self.GlowOrangeOver:setAlpha( 0 )
				self.clipFinished( GlowOrangeOver, {} )

				glow:completeAnimation()
				self.glow:setAlpha( 0 )
				self.clipFinished( glow, {} )

				RingGlow:completeAnimation()
				self.RingGlow:setAlpha( 0 )
				self.clipFinished( RingGlow, {} )

				RingTopBG:completeAnimation()
				self.RingTopBG:setAlpha( 0 )
				self.clipFinished( RingTopBG, {} )

				RingTopBleedOut:completeAnimation()
				self.RingTopBleedOut:setAlpha( 0 )
				self.clipFinished( RingTopBleedOut, {} )

				ReviveProgressBarBG:completeAnimation()
				self.ReviveProgressBarBG:setAlpha( 0 )
				self.clipFinished( ReviveProgressBarBG, {} )
		
				ReviveProgressBar:completeAnimation()				
				self.ReviveProgressBar:setAlpha( 0 )
				self.clipFinished( ReviveProgressBar, {} )
	
				skull:completeAnimation()
				self.skull:setAlpha( 0 )
				self.clipFinished( skull, {} )
		
				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.clipFinished( Glow0, {} )
			end
		},
		Reviving = {
			DefaultClip = function ()
				self:setupElementClipCounter( 11 )
				
				GlowOrangeOver:completeAnimation()
				self.GlowOrangeOver:setAlpha( 0 )
				self.clipFinished( GlowOrangeOver, {} )

				glow:completeAnimation()
				self.glow:setAlpha( 0 )
				self.clipFinished( glow, {} )

				RingGlow:completeAnimation()
				self.RingGlow:setAlpha( 0 )
				self.clipFinished( RingGlow, {} )

				RingTopBG:completeAnimation()
				self.RingTopBG:setAlpha( 0 )
				self.clipFinished( RingTopBG, {} )

				RingTopBleedOut:completeAnimation()
				self.RingTopBleedOut:setAlpha( 0 )
				self.clipFinished( RingTopBleedOut, {} )

	
				ReviveProgressBarBG:completeAnimation()
				ReviveProgressBarBG:setTopBottom( false, true, -28, -20 )
				self.ReviveProgressBarBG:setAlpha( 0.35 )
				self.clipFinished( ReviveProgressBarBG, {} )
				
				
				ReviveProgressBar:completeAnimation()
				ReviveProgressBar:setTopBottom( false, true, -28, -20 )
				self.ReviveProgressBar:setAlpha( 1 )
				self.clipFinished( ReviveProgressBar, {} )
		
				skull:completeAnimation()
				self.skull:setAlpha( 0 )
				self.clipFinished( skull, {} )

				AbilitySwirl:completeAnimation()
				self.AbilitySwirl:setAlpha( 0 )
				self.clipFinished( AbilitySwirl, {} )

				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				self.clipFinished( Glow0, {} )
			end
		},
		BleedingOut = {
			DefaultClip = function ()
				self:setupElementClipCounter( 11 )
				
				local GlowOrangeOverFrame2 = function ( GlowOrangeOver, event )
					local GlowOrangeOverFrame3 = function ( GlowOrangeOver, event )
						if not event.interrupted then
							GlowOrangeOver:beginAnimation( "keyframe", 899, false, false, CoD.TweenType.Linear )
						end
						GlowOrangeOver:setAlpha( 0.4 )
						if event.interrupted then
							self.clipFinished( GlowOrangeOver, event )
						else
							GlowOrangeOver:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						GlowOrangeOverFrame3( GlowOrangeOver, event )
						return 
					else
						GlowOrangeOver:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
						GlowOrangeOver:setAlpha( 0.6 )
						GlowOrangeOver:registerEventHandler( "transition_complete_keyframe", GlowOrangeOverFrame3 )
					end
				end
				
				GlowOrangeOver:completeAnimation()
				self.GlowOrangeOver:setAlpha( 0.4 )
				GlowOrangeOverFrame2( GlowOrangeOver, {} )

				glow:completeAnimation()
				self.glow:setAlpha( 1 )
				self.clipFinished( glow, {} )
				
				RingGlow:completeAnimation()
				self.RingGlow:setAlpha( 1 )
				self.RingGlow:setScale( 1 )
				self.RingGlow:beginAnimation( "keyframe", 800, false, false, CoD.TweenType.Linear )
				self.RingGlow:setAlpha( 0 )
				self.RingGlow:setScale( 3 )
				SetupNextAnimation( self.RingGlow, function ( f6_arg0 )
					f6_arg0:beginAnimation( "keyframe", 1, false, false, CoD.TweenType.Linear )
					f6_arg0:setAlpha( 1 )
					f6_arg0:setScale( 1 )
					PlayClipOnAnimationEnd( f6_arg0, controller, "DefaultClip" )
				end )

				RingTopBG:completeAnimation()
				self.RingTopBG:setAlpha( 1 )
				self.clipFinished( RingTopBG, {} )

				RingTopBleedOut:completeAnimation()
				self.RingTopBleedOut:setAlpha( 1 )
				self.clipFinished( RingTopBleedOut, {} )

				ReviveProgressBarBG:completeAnimation()
				self.ReviveProgressBarBG:setAlpha( 0 )
				self.clipFinished( ReviveProgressBarBG, {} )
				
				ReviveProgressBar:completeAnimation()
				self.ReviveProgressBar:setAlpha( 0 )
				self.clipFinished( ReviveProgressBar, {} )
			
				skull:completeAnimation()
				self.skull:setAlpha( 1 )
				self.clipFinished( skull, {} )
				
				AbilitySwirl:completeAnimation()
				self.AbilitySwirl:setLeftRight( false, false, -67.86, 69 )
				self.AbilitySwirl:setTopBottom( false, false, -69, 67.86 )
				self.AbilitySwirl:setAlpha( 0 )
				self.clipFinished( AbilitySwirl, {} )
				
				
				local Glow0Frame2 = function ( Glow0, event )
					local Glow0Frame3 = function ( Glow0, event )
						if not event.interrupted then
							Glow0:beginAnimation( "keyframe", 899, false, false, CoD.TweenType.Linear )
						end
						Glow0:setAlpha( 0 )
						if event.interrupted then
							self.clipFinished( Glow0, event )
						else
							Glow0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
						end
					end
					
					if event.interrupted then
						Glow0Frame3( Glow0, event )
						return 
					else
						Glow0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Linear )
						Glow0:setAlpha( 0.3 )
						Glow0:registerEventHandler( "transition_complete_keyframe", Glow0Frame3 )
					end
				end
				
				Glow0:completeAnimation()
				self.Glow0:setAlpha( 0 )
				Glow0Frame2( Glow0, {} )
				self.nextClip = "DefaultClip"
			end
		}
	}
	self:mergeStateConditions( {
		{
			stateName = "Reviving",
			condition = function ( menu, element, event )
				return IsSelfModelValueEnumBitSet( element, controller, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_BEING_REVIVED )
			end
		},
		{
			stateName = "BleedingOut",
			condition = function ( menu, element, event )
				return IsSelfModelValueEnumBitSet( element, controller, "stateFlags", Enum.BleedOutStateFlags.BLEEDOUT_STATE_FLAG_BLEEDING_OUT )
			end
		}
	} )
	self:linkToElementModel( self, "stateFlags", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "stateFlags"
		} )
	end )
	self:linkToElementModel( self, "bleedOutPercent", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "bleedOutPercent"
		} )
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Glow0:close()
		element.RingTopBleedOut:close()
		element.RingTopRevive:close()
		element.ReviveProgressBarBG:close()
		element.ReviveProgressBar:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end