---@diagnostic disable: undefined-global

require( "ui.uieditor.widgets.HUD.ZM_Perks.PerkListItemFactory" )

local perksImages = {
	additional_primary_weapon = "specialty_giant_three_guns_zombies",
	dead_shot = "specialty_giant_ads_zombies",
	dive_to_nuke = "specialty_divetonuke_zombies",
	doubletap2 = "specialty_giant_doubletap_zombies",
	juggernaut = "specialty_giant_juggernaut_zombies",
	marathon = "specialty_giant_marathon_zombies",
	quick_revive = "specialty_giant_quickrevive_zombies",
	sleight_of_hand = "specialty_giant_fastreload_zombies",
	tombstone = "specialty_tombstone_zombies",
	widows_wine = "specialty_giant_widows_wine_zombies",
	electric_cherry = "specialty_blue_electric_cherry_zombies",
	phdflopper = "specialty_phdflopper_zombies",
	dyingwish = "specialty_dyingwish_zombies",
	timeslip = "specialty_giant_timeslip_zombies",
	icu = "specialty_giant_icu_zombies",
	melee_macchiato = "specialty_melee_macchiato_zombies"
}

local GetPerkFromList = function ( perksList, perkCF )
	if perksList ~= nil then
		for index = 1, #perksList, 1 do
			if perksList[index].properties.key == perkCF then
				return index
			end
		end
	end

	return nil
end

local GetPerkFromStatus = function ( perksList, perkCF, perkStatusModel )
	if perksList ~= nil then
		for index = 1, #perksList, 1 do
			if perksList[index].properties.key == perkCF and perksList[index].models.status ~= perkStatusModel then
				return index
			end
		end
	end

	return -1
end

local PerksListUpdate = function ( element, controller )
	if not element.perksList then
		element.perksList = {}
	end	

	local tableUpdated = false

	for perkCF, perkImage in pairs( perksImages ) do
		local perkModelValue = Engine.GetModelValue( Engine.GetModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.perks" ), perkCF ) )

		if perkModelValue ~= nil and perkModelValue > 0 then
			if not GetPerkFromList( element.perksList, perkCF ) then
				table.insert( element.perksList, {
					models = {
						image = perkImage,
						status = perkModelValue,
						newPerk = false
					},
					properties = {
						key = perkCF
					}
				} )

				tableUpdated = true
			end

			if GetPerkFromStatus( element.perksList, perkCF, perkModelValue ) > 0 then
				element.perksList[GetPerkFromStatus( element.perksList, perkCF, perkModelValue )].models.status = perkModelValue

				Engine.SetModelValue( Engine.GetModel( Engine.GetModel( Engine.GetModelForController( controller ), "ZMPerksFactory" ), tostring( GetPerkFromStatus( element.perksList, perkCF, perkModelValue ) ) .. ".status" ), perkModelValue )
			end
		
		else
			if GetPerkFromList( element.perksList, perkCF ) then
				local perkIdx = GetPerkFromList( element.perksList, perkCF )          
                table.remove( element.perksList, perkIdx )
				tableUpdated = true
			end
		end
		
	end    

	if tableUpdated then
		for index = 1, #element.perksList, 1 do
			element.perksList[index].models.newPerk = ( index == #element.perksList )
		end

		return true
	else
		for index = 1, #element.perksList, 1 do
            Engine.SetModelValue( Engine.GetModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.perks" ), element.perksList[index].properties.key ), element.perksList[index].models.status )
		end
	
		return false
	end
end

DataSources.ZMPerksFactory = DataSourceHelpers.ListSetup( "ZMPerksFactory", function ( controller, element )
	PerksListUpdate( element, controller )
	return element.perksList
end, true )

local PreLoadFunc = function ( self, controller )
	for perkCF, perkImage in pairs( perksImages ) do
		self:subscribeToModel( Engine.CreateModel( Engine.CreateModel( Engine.GetModelForController( controller ), "hudItems.perks" ), perkCF ), function ( modelRef )
			if PerksListUpdate( self.PerkList, controller ) then
				self.PerkList:updateDataSource()
			end
		end, false )
	end
end

CoD.R6eHudPerksContainer = InheritFrom( LUI.UIElement )
CoD.R6eHudPerksContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.R6eHudPerksContainer )
	self.id = "R6eHudPerksContainer"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.PerkList = LUI.UIList.new( menu, controller, 3.5, 0, nil, false, false, 0, 0, false, false )
	self.PerkList:makeFocusable()
	self.PerkList:setLeftRight( true, false, 487.5 - 155, 521 )
	self.PerkList:setTopBottom( false, true, -58, -24.5 )
	self.PerkList:setWidgetType( CoD.PerkListItemFactory )
	self.PerkList:setHorizontalCount( 10 )
	self.PerkList:setScale( 0.75 )
	self:addElement( self.PerkList )

	self.PerkList:setDataSource( "ZMPerksFactory" )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.PerkList:completeAnimation()
				self.PerkList:setAlpha( 1 )
				self.clipFinished( self.PerkList, {} )
			end,
			Hidden = function ()
				self:setupElementClipCounter( 3 )

				local HiddenTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.PerkList:completeAnimation()
				self.PerkList:setAlpha( 1 )
				HiddenTransition( self.PerkList, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				self.PerkList:completeAnimation()
				self.PerkList:setAlpha( 0 )
				self.clipFinished( self.PerkList, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 3 )
				
				local DefaultStateTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 1 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.PerkList:completeAnimation()
				self.PerkList:setAlpha( 0 )
				DefaultStateTransition( self.PerkList, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				if not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED )
				and Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
				and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) then
					return false
				else
					return true
				end
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( modelRef )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
		} )
	end )

	self.PerkList.id = "PerkList"

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.PerkList:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
