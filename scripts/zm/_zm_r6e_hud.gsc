#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#precache( "lui_menu_data", "hudItems.zone_name" );

REGISTER_SYSTEM_EX( "zm_r6e_hud", &__init__, &__main__, undefined )

function __init__()
{
	clientfield::register( "clientuimodel", "hudItems.showDpadLeft_iw8", VERSION_SHIP, 2, "int" );
	clientfield::register( "clientuimodel", "hudItems.dpadLeftAmmo", VERSION_SHIP, GetMinBitCountForNum( 66 ), "int" );

	SetScoreboardColumns( "kills" , "score" , "downs", "revives", "headshots", "plants" , "stabs" , "captures", "returns" );
	util::registerclientsys( "laststand" );
	util::registerclientsys( "laststand_bleedout_bar" );
}

function __main__()
{
    callback::on_spawned( &on_player_spawned );
	callback::on_connect( &on_player_connected );
	//thread test_bot();
}

// function test_bot()
// {
// 	level flag::wait_till( "all_players_connected" );
// 	bot1 = AddTestClient();
// 	bot2 = AddTestClient();
// 	bot3 = AddTestClient();
// }

function on_player_spawned()
{
	self thread zone_name_monitor();
	//self thread underbarreal_monitor();
	self thread selfplayer_down_monitor();
	self thread bleedout_bar_monitor();
	
}

function on_player_connected()
{
	self thread teammate_health_bar_hud();
}

function zone_name_monitor()
{
    self endon( "bled_out" );
    self endon( "disconnect" );
    self endon( "spawned_player" );

	self waittill( "weapon_change_complete" ); 

	while( true )
	{
		if( isdefined( self ) )
		{
			if( isdefined( GetEnt( self zm_utility::get_current_zone(), "targetname" ).script_string ) )
			{
				if( !IS_EQUAL( self GetControllerUIModelValue( "hudItems.zone_name" ), GetEnt( self zm_utility::get_current_zone(), "targetname" ).script_string ) )
					self SetControllerUIModelValue( "hudItems.zone_name", GetEnt( self zm_utility::get_current_zone(), "targetname" ).script_string );
			}
			else
			{
				if( !IS_EQUAL( self GetControllerUIModelValue( "hudItems.zone_name" ), "none" ) )
					self SetControllerUIModelValue( "hudItems.zone_name", "none" );
			}
		}
		WAIT_SERVER_FRAME
	}
}

////////////
//	NOTE  //
//The following function is a custom one that defined for my own level. 
//It may not be applicable to you,You can modify it for your demand.
//////
// function underbarreal_monitor()
// {
// 	self endon( "bled_out" );
// 	self endon( "disconnect" );
// 	self endon( "spawned_player" );

// 	for(;;)
// 	{
// 		self util::waittill_any( "weapon_fired", "weapon_give" );
// 		alt_weapon_count = 0;
// 		foreach( weapon in self GetWeaponsListPrimaries() )
// 		{
// 			if( isdefined( weapon.altweapon ) )
// 			{
// 				alt_weapon_count++;
// 			}
// 		}
// 		switch( alt_weapon_count )
// 		{
// 			case 1:
// 			{
// 				if( self HasWeapon( GetWeapon( "ar_tango21_shotty" ) ) )
// 				{
// 					self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 1 );
// 					self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", self GetAmmoCount( GetWeapon( "ar_tango21_shotty" ) ) );
// 				}
// 				else if( self HasWeapon( GetWeapon( "ar_m16a4_launcher" ) ) )
// 				{
// 					self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 2 );
// 					self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", self GetAmmoCount( GetWeapon( "ar_m16a4_launcher" ) ) );
// 				}
// 				else if( self HasWeapon( GetWeapon( "ar_scharlie_launcher" ) ) )
// 				{
// 					self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 2 );
// 					self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", self GetAmmoCount( GetWeapon( "ar_scharlie_launcher" ) ) );
// 				}
// 				break;
// 			}
// 			case 2:
// 			{
// 				if( IsSubStr( self GetCurrentWeapon().name, "tango21" ) )
// 				{
// 					self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 1 );
// 					self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", self GetAmmoCount( GetWeapon( "ar_tango21_shotty" ) ) );
// 				}
// 				else if( IsSubStr( self GetCurrentWeapon().name, "m16a4" ) )
// 				{
// 					self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 2 );
// 					self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", self GetAmmoCount( GetWeapon( "ar_m16a4_launcher" ) ) );
// 				}
// 				else if( IsSubStr( self GetCurrentWeapon().name, "scharlie" ) )
// 				{
// 					self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 2 );
// 					self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", self GetAmmoCount( GetWeapon( "ar_scharlie_launcher" ) ) );
// 				}
// 				break;
// 			}
// 			default:
// 			{
// 				self clientfield::set_player_uimodel( "hudItems.showDpadLeft_iw8", 0 );
// 				self clientfield::set_player_uimodel( "hudItems.dpadLeftAmmo", 0 );
// 				break;
// 			}
// 		}
// 	} 
// }

function selfplayer_down_monitor()
{
	self endon( "bled_out" );
	self endon( "disconnect" );
	self endon( "spawned_player" );

	player_num = self GetEntityNumber();
	while( true )
	{
		if( self laststand::player_is_in_laststand() && zm_utility::is_player_valid( self, false, true ) )
		{
			if( isdefined( self.bleedout_time ) )
			{	
				//self clientfield::set_player_uimodel( "hudItems.player_laststand_bleedout_bar", self.bleedout_time );
				
				if(IS_TRUE( self.revivetrigger.beingRevived ) ) 
				{
					self.captures = int( self.bleedout_time );
					self health_bar_client_sys(  "hp,player_is_being_revived," + player_num );
				}
				else
				{
					if(level flag::get( "wait_and_revive" )) // using solo revive
					{
						self.captures = int( self.bleedout_time );
						self health_bar_client_sys(  "hp,player_solo_perk_revive," + player_num );
					}
					
					else if( IS_TRUE( self.self_revive_trigger.beingRevivedBySelf ) ) 
					{
						self health_bar_client_sys(  "hp,player_using_self_revive," + player_num );
					}
					
					else
					{
						self.captures = int( self.bleedout_time );
						self health_bar_client_sys(  "hp,player_down," + player_num );
					}
				}
			}
			else
			{
				self health_bar_client_sys(  "hp,player_down," + player_num );
				self.captures = int( self.bleedout_time );
			}
		}
		else
		{
			self health_bar_client_sys(  "hp,player_alive," + player_num );
		}
		WAIT_SERVER_FRAME
	}
}

function health_bar_client_sys( stats )
{
	if(self.health_bar_prev_stats != stats)
	{
		self util::setClientSysState( "laststand", stats , self );
		self.health_bar_prev_stats = stats;
	}
}


function bleedout_bar_monitor()
{
	self endon( "bled_out" );
	self endon( "disconnect" );
	self endon( "spawned_player" );

	for(;;)
	{
		if( laststand::player_is_in_laststand() && zm_utility::is_player_valid( self, false, true ) )
		{
			self bleedout_bar_client_sys( "lt," + self.bleedout_time / 45 );
		}
		WAIT_SERVER_FRAME
	}
}


function bleedout_bar_client_sys( stats )
{
	if( self.bleedout_bar_prev_stats != stats )
	{
		self util::setClientSysState( "laststand_bleedout_bar", stats, self );
		self.bleedout_bar_prev_stats = stats;
	}
}

function teammate_health_bar_hud()
{
	self endon( "disconnect" );

	level flag::wait_till( "start_zombie_round_logic" );
	while( Length( self GetVelocity() ) <= 1 ) 
	{
		WAIT_SERVER_FRAME
	}
	bleedout_time_total = GetDvarfloat( "player_lastStandBleedoutTime" ); // Without BGB coagulant
	for(;;)
	{
		if ( self laststand::player_is_in_laststand() || isdefined( self.revivetrigger ) )
		{
			self.captures = int( self.bleedout_time );
			self.returns = int( bleedout_time_total ); // Player Down,The scoreboard column "capture" is self.bleedout_time
		}					 
		else if( self.sessionstate == "spectator" ) //Player Dead
		{
			self.captures = 1000;
			self.returns = 1000; 
		}
		else
		{
			self.captures = self.health;
			self.returns = 200; //Player alive,the scoreboard column "capture" is player current health
		}
		WAIT_SERVER_FRAME
	}
}
