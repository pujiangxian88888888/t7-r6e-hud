---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.r6ehud.Generic.R6eHudUtility" )


CoD.R6eHudNotifications = InheritFrom( LUI.UIElement )
CoD.R6eHudNotifications.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudNotifications )
	self.id = "R6eHudNotifications"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

    self.MaxAmmoNotification = LUI.UIText.new()
	self.MaxAmmoNotification:setLeftRight( false, false, -400, 400 )
	self.MaxAmmoNotification:setTopBottom( false, true, -282, -250 )
	self.MaxAmmoNotification:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.MaxAmmoNotification:setText( "" )
	self.MaxAmmoNotification:setTTF( "fonts/Erbaum_Bold.ttf" )
	self.MaxAmmoNotification:setAlpha( 0 )
	self:addElement( self.MaxAmmoNotification )
    
    self.TeammateNeedsReviveNotification = LUI.UIText.new()
	self.TeammateNeedsReviveNotification:setLeftRight( false, false, -190, 190 )
	self.TeammateNeedsReviveNotification:setTopBottom( false, true, -580, -540 )
	self.TeammateNeedsReviveNotification:setText( "" )
	self.TeammateNeedsReviveNotification:setTTF( "fonts/Erbaum_Bold.ttf" )
    --self.TeammateNeedsReviveNotification:setImage( RegisterImage( "blacktransparent" ) )
	self.TeammateNeedsReviveNotification:setAlpha( 0 )
	--self.TeammateNeedsReviveNotification:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe" ) )
	--[[
	setShaderVector第一个参数为0，不起效果，为1，裁切边缘出现虚化，为2，下半截也被裁切，为3，下半截被裁切的边缘虚化
	第二个参数为控制从右到左裁切幅度,还会影响图片不透明度
	]]--
    --self.TeammateNeedsReviveNotification:setShaderVector( 3, 0.5, 0, 0, 0 )
	--self.TeammateNeedsReviveNotification:setShaderVector( 0, 0, 0, 0, 0 )
	--self.TeammateNeedsReviveNotification:setShaderVector( 1, 0, 0, 0, 0 )
	--self.TeammateNeedsReviveNotification:setShaderVector( 2, 1, 0, 0, 0 )
	--self.TeammateNeedsReviveNotification:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.TeammateNeedsReviveNotification )

    SubscribeToScriptNotify( self, controller, "zombie_notification", function ()
		self.MaxAmmoNotification:setText( "MAX AMMO" )
		PlayClip( self, "FullAmmo", controller )
	end )

    SubscribeToScriptNotify( self, controller, "zombie_revive_notification", function (  )
		--self.TeammateNeedsReviveNotification:setImage( RegisterImage( "ui_icon_teammate_down_notify" ) )
		self.TeammateNeedsReviveNotification:setText( "teammate needs revive" )
		PlayClip( self, "TeammateNeedsRevive", controller )
	end )
	

    self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				self.MaxAmmoNotification:completeAnimation()
				self.MaxAmmoNotification:setTopBottom( false, true, -282, -250 )
				self.MaxAmmoNotification:setAlpha( 0 )
				self.clipFinished( self.MaxAmmoNotification, {} )

				self.TeammateNeedsReviveNotification:completeAnimation()
				self.TeammateNeedsReviveNotification:setAlpha( 0 )
				self.clipFinished( self.TeammateNeedsReviveNotification, {} )

			end,
			FullAmmo = function ()
				self:setupElementClipCounter( 3 )
				
				self.MaxAmmoNotification:completeAnimation()
				self.MaxAmmoNotification:setTopBottom( false, true, -282, -250 )
				self.MaxAmmoNotification:setAlpha( 0 )
				self.MaxAmmoNotification:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
				self.MaxAmmoNotification:setAlpha( 1 )
				SetupNextAnimation( self.MaxAmmoNotification, function ( f8_arg0 )
					f8_arg0:beginAnimation( "keyframe", 5000, false, false, CoD.TweenType.Linear )
					SetupNextAnimation( f8_arg0, function ( f9_arg0 )
						f9_arg0:beginAnimation( "keyframe", 1500, false, false, CoD.TweenType.Linear )
						f9_arg0:setTopBottom( false, true, -312, -280 )
						f9_arg0:setAlpha( 0 )
						f9_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end )
				end )
			end,
			TeammateNeedsRevive = function ()
				self:setupElementClipCounter( 3 )
				
				self.TeammateNeedsReviveNotification:completeAnimation()
				--self.TeammateNeedsReviveNotification:setTopBottom( false, true, -282, -250 )
				self.TeammateNeedsReviveNotification:setAlpha( 0 )
				self.TeammateNeedsReviveNotification:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
				self.TeammateNeedsReviveNotification:setAlpha( 1 )
				SetupNextAnimation( self.TeammateNeedsReviveNotification, function ( f8_arg0 )
					f8_arg0:beginAnimation( "keyframe", 5000, false, false, CoD.TweenType.Linear )
					SetupNextAnimation( f8_arg0, function ( f9_arg0 )
						f9_arg0:beginAnimation( "keyframe", 1500, false, false, CoD.TweenType.Linear )
						--f9_arg0:setTopBottom( false, true, -312, -280 )
						f9_arg0:setAlpha( 0 )
						f9_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end )
				end )
			end
			
		}
	}

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.MaxAmmoNotification:close()
        element.TeammateNeedsReviveNotification:close()
	end )

	return self

end