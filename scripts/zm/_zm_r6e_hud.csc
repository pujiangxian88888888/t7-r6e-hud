#using scripts\codescripts\struct;

#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;

#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\ai_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\vehicle_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_laststand.gsh;
#insert scripts\shared\duplicaterender.gsh;

//REGISTER_SYSTEM_EX( "zm_r6e_hud", &__init__, undefined, undefined )

function autoexec __init_sytem__()
{
    system::register( "zm_r6e_hud", &__init__, &__main__, undefined );
    callback::on_spawned( &addplayers );
	util::register_system( "laststand", &result );
	util::register_system( "laststand_bleedout_bar", &bleedout_bar_result );
}

function __init__()
{
    LuiLoad( "ui.uieditor.menus.R6eHud_zm" );
    LuiLoad( "ui.uieditor.widgets.r6ehud.Powerups.R6eHudPowerupsContainer" );
 
    //clientfield::register( "clientuimodel", "R6e.Health", VERSION_SHIP, GetMinBitCountForNum( 200 ), "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", "hudItems.showDpadLeft_iw8", VERSION_SHIP, GetMinBitCountForNum( 3 ), "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", "hudItems.dpadLeftAmmo", VERSION_SHIP, GetMinBitCountForNum( 66 ), "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	/*
	for( i = 0; i < GetDvarInt( "com_maxclients" ); i++ )
	{		
        clientfield::register( "world", "bleedout_bar" + i, VERSION_SHIP, GetMinBitCountForNum( 45 ), "int", &update_bleedout_timer, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	}
	*/

	//clientfield::register( "clientuimodel", "hudItems.player_laststand_bleedout_bar", VERSION_SHIP, GetMinBitCountForNum( 45 ), "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//thread lua_print();
	
}

function __main__()
{
	//callback::on_localclient_connect( &local_player_connected );
	callback::on_localplayer_spawned( &local_player_spawned );
}

// function lua_print()
// {
	
// 	while(1)
// 	{
// 		if(GetDvarString("test") != "")
// 		{
// 			SubtitlePrint(0, 2000, "test: " + GetDvarString("test") );
// 			setdvar("test","");
// 		}
// 		wait 1;
// 	}
// }

/*
function local_player_connected( localclientnum )
{
	self thread timer_hud( localclientnum );
}
*/

function local_player_spawned( localclientnum )
{
	self thread health_bar_hud( localclientnum );
}

function addplayers( localClientNum )
{
	self notify( "addplayers" );
	self endon( "addplayers" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );

	for(;;)
	{
		if( !isdefined( level.activeplayers ) )
		{
			level.activeplayers = [];
		}
		else
		{
			level.activeplayers[ self GetEntityNumber() ] = self;
		}
		waitrealtime( 2 );
	}
	
}

/*

function update_bleedout_timer( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	playerNum = Int( GetSubStr( fieldName, 12 ) );
	
	level notify( "update_bleedout_timer" + playerNum );
	level endon( "update_bleedout_timer" + playerNum );
	model = GetUIModel( GetUIModelForController( localClientNum ), "WorldSpaceIndicators.bleedOutModel" + playerNum + ".bleedOutPercent" );
	
	if( isdefined( model ) )
	{
		if( newVal >= 45 )
		{
			SetUIModelValue( model, 1 );
		}
		else
		{
			thread animation_update( model , newVal + 1 , playerNum );
		}
	}
}

function animation_update( model, newval , playerNum )
{
	level notify( "bleedout_bar" + playerNum );
	level endon( "bleedout_bar" + playerNum );
	
	startTime = GetRealTime();
	timeSinceLastUpdate = 0;    
    
    oldValue = newval - 1;
    
	while( timeSinceLastUpdate <= 1 )
	{
		timeSinceLastUpdate = ( ( GetRealTime() - startTime ) / 1000 );
		lerpValue = ( LerpFloat( newval , oldValue , timeSinceLastUpdate ) / 45 );
		SetUIModelValue( model, lerpValue );
        WAIT_CLIENT_FRAME;
	}
}
*/

function result( localclientnum, message )
{
	if( self != GetLocalPlayer( localclientnum ) && ( !isdefined( message ) || message == "" ) )
	{
		return;
	}
	//SubtitlePrint( 0 , 2000 , message );
	if(IsSubStr( message, "hp") )
	{
		revive_info = StrTok( message, "," );
		revive_stats = revive_info[1];
		player_num = int(revive_info[2]);

		revive_model = GetUIModel( GetUIModelForController( localclientnum ), "hudItems.revivewidget" );
		revive_stage = GetUIModel( revive_model, "stateFlags" );
		//revive_num = GetUIModel( GetUIModelForController( localclientnum ), "revivenum" );
		reive_icon_clock = GetUIModel( GetUIModelForController( localClientNum ), "WorldSpaceIndicators.bleedOutModel" + player_num + ".clockPercent" );

		if( revive_stats == "player_down" )
    	{
        	SetUIModelValue( revive_stage, 2 );
			//SetUIModelValue( revive_num, 2 );
    	}
		else if( revive_stats == "player_solo_perk_revive" || revive_stats == "player_is_being_revived" || revive_stats == "player_using_self_revive" )
		{
			SetUIModelValue( revive_stage, 1 );
		}
    	else
    	{
        	SetUIModelValue( revive_stage, 0 );
			//SetUIModelValue( revive_num, int( revive_stats ) );
    	}
    	if(revive_stats == "player_is_being_revived" )
    	{
        	self thread reviveing_animation_update( localClientNum,reive_icon_clock );
    	}
    	if(revive_stats == "player_solo_perk_revive" )
    	{
        	self thread solorevive_animation_update( localClientNum,reive_icon_clock );
    	}
	}
}

function reviveing_animation_update( localClientNum, model )
{
	self notify( "reviving_animation_update" );
    self endon( "reviving_animation_update" );

	startTime = GetRealTime();
	timeSinceLastUpdate = 0;

    SetUIModelValue( model, 0 );

    oldValue = 0;
    newValue = 3;

    while( timeSinceLastUpdate <= 3 )
    {
		timeSinceLastUpdate = ( ( GetRealTime() - startTime ) / 1000 );
		lerpValue = (LerpFloat( oldValue, newValue, (timeSinceLastUpdate / 3) ) / 3);
        SetUIModelValue( model, lerpValue );
        WAIT_CLIENT_FRAME
    }

}

function solorevive_animation_update( localClientNum, model )
{
    self notify("reviving_animation_update");
    self endon("reviving_animation_update");

	startTime = GetRealTime();
	timeSinceLastUpdate = 0;

    SetUIModelValue( model, 0 );

    oldValue = 0;
    newValue = 1;

    while( timeSinceLastUpdate <= 10000 )
    {
		timeSinceLastUpdate = GetRealTime() - startTime;
		lerpValue = LerpFloat( oldValue, newValue, timeSinceLastUpdate / 10000 );
        SetUIModelValue( model, lerpValue );
        WAIT_CLIENT_FRAME
    }
}

function bleedout_bar_result( localclientnum, message )
{
	if( self != GetLocalPlayer( localclientnum ) && ( !isdefined( message ) || message == "" ) )
	{
		return;
	}

	if(IsSubStr( message,"lt" ) )
	{
		bleedout_info = StrTok(message, ",");
		bleedout_stats = bleedout_info[1];
		bleedout_model = GetUIModel( GetUIModelForController( localclientnum ), "hudItems.revivewidget" );
		bleedout_stage = GetUIModel( bleedout_model, "bleedOutPercent" );

		SetUIModelValue( bleedout_stage, bleedout_stats );
	}
}

function health_bar_hud( localclientnum )
{
	self notify( "health_bar_hud" );
	self endon( "health_bar_hud" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );

	//health_bar_model = GetUIModel( GetUIModelForController( localclientnum ), "hudItems.HealthBar" );
	controllerModel = GetUIModelForController( localclientnum );
    health_bar_model = CreateUIModel( controllerModel, "hudItems.HealthBar" );

	for(;;)
	{
		WAIT_CLIENT_FRAME
		health_ratio = RenderHealthOverlayHealth( localclientnum );
		if( self HasPerk( localclientnum, "specialty_armorvest" ) )
		{
			health = health_ratio * 200;
		}
		else
		{
			health = health_ratio * 100;
		}
		//SubtitlePrint( localclientnum, 2000, health );
		if( IS_EQUAL( GetUIModelValue( health_bar_model ), health ) )
		{
			continue;
		}
        SetUIModelValue( health_bar_model, health );
	}
}

/*
function timer_hud( localclientnum )
{
	self notify( "timer_hud" );
	self endon( "timer_hud" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	
	
	time = SpawnStruct();
	time.minute = 0;
	time.second = 0;
	//controllerModel = GetUIModelForController( localclientnum );
	timer_minute_model = CreateUIModel( GetUIModelForController( localclientnum ), "hudItems.TimeWidgets_Minutes" );
	timer_second_model = CreateUIModel( GetUIModelForController( localclientnum ), "hudItems.TimeWidgets_Seconds" );
	
	for(;;)
	{
		SubtitlePrint(0, 2000, "1111111" );
		total_time = GetTime();
		
		total_second = total_time / 1000;
		remain_second = total_second % 60;
		remain_minute = total_second / 60;
		time.minute = remain_minute;
		time.second = remain_second;
		
		
		SetUIModelValue( timer_minute_model, total_time );
		//SetUIModelValue( timer_second_model, time.second );
		SubtitlePrint(0, 2000, total_time );
		wait 1;
	}
}
*/