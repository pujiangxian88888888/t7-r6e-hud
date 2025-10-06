---@diagnostic disable: undefined-global

EnableGlobals()
function SubscribeToVisibilityBit( f1_arg0, f1_arg1, f1_arg2, f1_arg3 )
	f1_arg2:subscribeToModel( Engine.GetModel( Engine.GetModelForController( f1_arg0 ), "UIVisibilityBit." .. Enum.UIVisibilityBit[f1_arg3] ), function ( model )
		f1_arg1:updateElementState( f1_arg2, {
			name = "model_validation",
			menu = f1_arg1,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit[f1_arg3]
		} )
	end )
end

function SubscribeToModelAndUpdateState( f3_arg0, f3_arg1, f3_arg2, f3_arg3 )
	f3_arg2:subscribeToModel( Engine.GetModel( Engine.GetModelForController( f3_arg0 ), f3_arg3 ), function ( model )
		f3_arg1:updateElementState( f3_arg2, {
			name = "model_validation",
			menu = f3_arg1,
			modelValue = Engine.GetModelValue( model ),
			modelName = f3_arg3
		} )
	end )
end

function SubscribeToGlobalModelAndUpdateState( f5_arg0, f5_arg1, f5_arg2, f5_arg3, f5_arg4 )
	f5_arg2:subscribeToGlobalModel( f5_arg0, f5_arg3, f5_arg4, function ( model )
		f5_arg1:updateElementState( f5_arg2, {
			name = "model_validation",
			menu = f5_arg1,
			modelValue = Engine.GetModelValue( model ),
			modelName = f5_arg4
		} )
	end )
end

function SubscribeToElementModelAndUpdateState( f7_arg0, f7_arg1, f7_arg2 )
	f7_arg1:subscribeToElementModel( f7_arg1, f7_arg2, function ( f8_arg0 )
		f7_arg0:updateElementState( f7_arg1, {
			name = "model_validation",
			menu = f7_arg0,
			modelValue = Engine.GetModelValue( f8_arg0 ),
			modelName = f7_arg2
		} )
	end )
end

function SubscribeToMultipleModels( f9_arg0, f9_arg1, f9_arg2 )
	for f9_local0 = 1, #f9_arg1, 1 do
		f9_arg0:subscribeToModel( f9_arg1[f9_local0], f9_arg2 )
	end
end

function SubscribeToMultipleModelsByName( f10_arg0, f10_arg1, f10_arg2, f10_arg3 )
	for f10_local0 = 1, #f10_arg2, 1 do
		f10_arg0:subscribeToModel( Engine.GetModel( Engine.GetModelForController( f10_arg1 ), f10_arg2[f10_local0] ), f10_arg3 )
	end
end

function SubscribeToScriptNotify( f11_arg0, f11_arg1, f11_arg2, f11_arg3 )
	f11_arg0:subscribeToGlobalModel( f11_arg1, "PerController", "scriptNotify", function ( model )
		if IsParamModelEqualToString( model, f11_arg2 ) then
			f11_arg3( CoD.GetScriptNotifyData( model ) )
		end
	end )
end

function SetupNextAnimation( f13_arg0, f13_arg1 )
	f13_arg0:registerEventHandler( "transition_complete_keyframe", function ( element, event )
		if event.interrupted then
			local f14_local0 = element:getParent()
			f14_local0.clipFinished( element, event )
		else
			f13_arg1( element )
		end
	end )
end

function PlayClipOnAnimationEnd( f15_arg0, f15_arg1, f15_arg2 )
	f15_arg0:registerEventHandler( "transition_complete_keyframe", function ( element, event )
		local f16_local0 = element:getParent()
		f16_local0.clipFinished( element, event )
		if not event.interrupted then
			PlayClip( element:getParent(), f15_arg2, f15_arg1 )
		end
	end )
end

